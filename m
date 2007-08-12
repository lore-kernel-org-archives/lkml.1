Return-Path: <linux-kernel-owner+w=401wt.eu-S935085AbXHLNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085AbXHLNMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760497AbXHLNML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:12:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60673 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756490AbXHLNMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:12:09 -0400
Date: Sun, 12 Aug 2007 14:19:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: WU Fengguang <wfg@mail.ustc.edu.cn>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812141905.4ee423b9@the-village.bc.nu>
In-Reply-To: <386921666.18788@ustc.edu.cn>
References: <46BEF5C0.3080902@linux.vnet.ibm.com>
	<20070812120902.GA9972@mail.ustc.edu.cn>
	<386921666.18788@ustc.edu.cn>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Great! So the problem might have existed for some time, but we never
> > saw it due to default over commit values? Were you using these values
> > for over commit even before?
> 
> No I changed it several weeks ago to stop my desktop from freezing.
> So yes, the bug may have been there for a while.

The bug is the new exec with lots of arguments code. It tries to insert a
vm struct without having a valid current->mm. That isn't permitted and
never had been (which is also why it broke the sparc mmu code etc).

You'll need to change the kernel security interface a little to make this
fly - I think the following should do it.

	- make __vm_enough_memory take a struct mm pointer and use it
	- make security_ops pass the extra current->mm
	- add a vm_enough_memory_mm security op
	- use security_vm_enough_memory_mm(mm, ...) in __insert_vm_struct

I'll knock up a quick patch and see what is needed (someone else can do
the selinux changes)
