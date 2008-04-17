Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbYDQKGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbYDQKGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935249AbYDQJvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:51:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:27496 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbYDQJvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M9WLfGyCqod09AJnBHtOoadshbf3dF3Jkj4+VLz260KdpZ/BuUaae/6SAahjSG7aN8DIVZS8tA7+kkjsJemWj6g5cnoF6CpqyckUyFqdinTd+CE1XprjuQN66uJ6vxRI6dWXf28bLUY7ZNh1a0zQyQVTFT65YbLXpb0t010d8Ic=
Message-ID: <86802c440804170251y33e46234ta4e4846136ee845f@mail.gmail.com>
Date: Thu, 17 Apr 2008 02:51:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86_64: restore mask_bits in msi shutdown
Cc: hlu.kernel@gmail.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Jeff Garzik" <jeff@garzik.org>,
       "Ayaz Abdulla" <aabdulla@nvidia.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1bq48vnxn.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804111626.11232.yhlu.kernel@gmail.com>
	 <m1bq48vnxn.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 2:19 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Yinghai Lu <yhlu.kernel.send@gmail.com> writes:
>
>  > I can not kexec RHEL 5.1 from 2.6.25-rc3 later
>  >
>  > caused by:
>  > commit 89d694b9dbe769ca1004e01db0ca43964806a611
>  > Author: Thomas Gleixner <tglx@linutronix.de>
>  > Date:   Mon Feb 18 18:25:17 2008 +0100
>  >
>  >     genirq: do not leave interupts enabled on free_irq
>  >
>  >     The default_disable() function was changed in commit:
>  >
>  >      76d2160147f43f982dfe881404cfde9fd0a9da21
>  >      genirq: do not mask interrupts by default
>  >
>  >     It removed the mask function in favour of the default delayed
>  >     interrupt disabling. Unfortunately this also broke the shutdown in
>  >     free_irq() when the last handler is removed from the interrupt for
>  >     those architectures which rely on the default implementations. Now we
>  >     can end up with a enabled interrupt line after the last handler was
>  >     removed, which can result in spurious interrupts.
>  >
>  >     Fix this by adding a default_shutdown function, which is only
>  >     installed, when the irqchip implementation does provide neither a
>  >     shutdown nor a disable function.
>  >
>  >     [@stable: affected versions: .21 - .24 ]
>  >
>  >
>  >
>  > for MSI, default_shutdown will call mask_bit for msi device. so all mask bits
>  > will
>  > left disabled after free_irq.
>  > then if kexec next kernel that only can use msi_enable bit.
>  > all device's MSI can not be used.
>  >
>  > So try to restore MSI mask bits that is saved before using msi in first kernel.
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
>  Ouch!  In the case of MSI-X this is horrible.  Reenabling an interrupt
>  line when we are not using it.  That is likely to cause even stranger
>  things than kexec to fail.
>
>  What happens when someone next comes to use that msi interrupt is
>  a reasonable question.
>
>  The PCI standard describes the state the bits in the msi capability
>  are supposed to be in after reset, and if a driver is going to
>  assume some state that is the only reasonable state for a driver to
>  expect the hardware to be in.  So we don't need to perform a
>  save/restore cycle.
>
>  Could you look at having pci_disable_msi reset the mask bit
>  to it's default state after we have called msi_set_enable(dev, 0)?
>  Once the msi capability is disabled the mask bit has no affect.

but the next kernel (RHEL 5.1) only can enable msi, and it doesn't
touch mask_bits (that is leaved as 0xff by first 2.6.25-rc2 later)
so device (nvidia mcp55 nic) doesn't work. --- if i manually used
setpci to set 0x60 to 0xfe or 0x00. it will work. also if i booted
kernel (RHEL 5.1), that 0x60
is always 0x00, even nic works with MSI.

YH
