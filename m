Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbYDQKQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbYDQKQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYDQKPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:15:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60308 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbYDQKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:15:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: yhlu.kernel@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <200804111626.11232.yhlu.kernel@gmail.com> (Yinghai Lu's message
	of "Fri, 11 Apr 2008 16:26:11 -0700")
References: <200804111626.11232.yhlu.kernel@gmail.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Thu, 17 Apr 2008 03:15:44 -0700
Message-ID: <m1y77cu6r3.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_64: restore mask_bits in msi shutdown
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm.  Trying this again with what should be yh's proper address.


Yinghai Lu <yhlu.kernel.send@gmail.com> writes:

> I can not kexec RHEL 5.1 from 2.6.25-rc3 later
>
> caused by:
> commit 89d694b9dbe769ca1004e01db0ca43964806a611
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Feb 18 18:25:17 2008 +0100
>
>     genirq: do not leave interupts enabled on free_irq
>
>     The default_disable() function was changed in commit:
>
>      76d2160147f43f982dfe881404cfde9fd0a9da21
>      genirq: do not mask interrupts by default
>
>     It removed the mask function in favour of the default delayed
>     interrupt disabling. Unfortunately this also broke the shutdown in
>     free_irq() when the last handler is removed from the interrupt for
>     those architectures which rely on the default implementations. Now we
>     can end up with a enabled interrupt line after the last handler was
>     removed, which can result in spurious interrupts.
>
>     Fix this by adding a default_shutdown function, which is only
>     installed, when the irqchip implementation does provide neither a
>     shutdown nor a disable function.
>
>     [@stable: affected versions: .21 - .24 ]
>
>
>
> for MSI, default_shutdown will call mask_bit for msi device. so all mask bits
> will
> left disabled after free_irq.
> then if kexec next kernel that only can use msi_enable bit.
> all device's MSI can not be used.
>
> So try to restore MSI mask bits that is saved before using msi in first kernel.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Ouch!  In the case of MSI-X this is horrible.  Reenabling an interrupt
line when we are not using it.  That is likely to cause even stranger
things than kexec to fail.

What happens when someone next comes to use that msi interrupt is
a reasonable question.

The PCI standard describes the state the bits in the msi capability
are supposed to be in after reset, and if a driver is going to
assume some state that is the only reasonable state for a driver to
expect the hardware to be in.  So we don't need to perform a
save/restore cycle.

Could you look at having pci_disable_msi reset the mask bit
to it's default state after we have called msi_set_enable(dev, 0)?
Once the msi capability is disabled the mask bit has no affect.

You should be able to ignoring pci_disable_msix for now.

Thanks, 
Eric

