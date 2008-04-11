Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYDKGOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYDKGOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYDKGOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:14:02 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:20285 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYDKGOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=vcml1fvxghWtKgx/hjXIOhJVc9wFixIwX9lEB0lPllOzmv3a/DOuM4HA3Kbme0TPWH4OcuEufcNjZI+wYBYbMlz6/XVhQGluoZ93y8YkAyxtQ+8hkbeFsOvnBxFOBEL5MIlrwl350mnH3v1N+p7LqVXuCvNc4rMHWsWr43fRdAw=
Message-ID: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
Date: Thu, 10 Apr 2008 23:13:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeff Garzik" <jeff@garzik.org>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

last week found:
after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
forcedeth doesn't work anymore.

I stared at forcedeth.c two days. and revert every patches about that
doesn't help.

and figure out 2.6.25-rc2 works.

with git-bisect found

commit 89d694b9dbe769ca1004e01db0ca43964806a611
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Feb 18 18:25:17 2008 +0100

    genirq: do not leave interupts enabled on free_irq

    The default_disable() function was changed in commit:

     76d2160147f43f982dfe881404cfde9fd0a9da21
     genirq: do not mask interrupts by default

    It removed the mask function in favour of the default delayed
    interrupt disabling. Unfortunately this also broke the shutdown in
    free_irq() when the last handler is removed from the interrupt for
    those architectures which rely on the default implementations. Now we
    can end up with a enabled interrupt line after the last handler was
    removed, which can result in spurious interrupts.

    Fix this by adding a default_shutdown function, which is only
    installed, when the irqchip implementation does provide neither a
    shutdown nor a disable function.

    [@stable: affected versions: .21 - .24 ]

    Pointed-out-by: Michael Hennerich <Michael.Hennerich@analog.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Cc: stable@kernel.org
    Tested-by: Michael Hennerich <Michael.Hennerich@analog.com>

caused the regression.

it affected all my servers that are using Nvidia MCP55.

maybe we need to revert that patch.

YH
