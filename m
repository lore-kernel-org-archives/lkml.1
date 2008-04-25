Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYDYAkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYDYAkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYDYAkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:40:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:24090 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYDYAkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pRvIizTzCr0qH9CfcbM39SAOX5W8eI669pVr3lZUuH+xf7qpvCyqsuqPUn0bJy/2S5hI+PvYLEbXFHDGHtnJkioxFWxtlbJHuevmdatPF4d987voFktBVWvhNYKVSUNHUiaI6LGXKnqoJqcrgjLiqpPPJ9QkrslXEm8n4SyBKFM=
Message-ID: <86802c440804241740s53ae6587s909d307cf145d629@mail.gmail.com>
Date: Thu, 24 Apr 2008 17:40:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] pci/irq: restore mask_bits in msi shutdown -v3
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       "Greg KH" <greg@kroah.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
In-Reply-To: <200804231456.30786.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <200804231456.30786.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 2:56 PM, Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  Yinghai found after using 2.6.25-rc3 later to kexec RHEL 5.1,
>  NIC can not be used.
>
>  bisected to
>
>  | commit 89d694b9dbe769ca1004e01db0ca43964806a611
>  | Author: Thomas Gleixner <tglx@linutronix.de>
>  | Date:   Mon Feb 18 18:25:17 2008 +0100
>  |
>  |   genirq: do not leave interupts enabled on free_irq
>  |
>  |   The default_disable() function was changed in commit:
>  |
>  |    76d2160147f43f982dfe881404cfde9fd0a9da21
>  |    genirq: do not mask interrupts by default
>  |
>  |   It removed the mask function in favour of the default delayed
>  |   interrupt disabling. Unfortunately this also broke the shutdown in
>  |   free_irq() when the last handler is removed from the interrupt for
>  |   those architectures which rely on the default implementations. Now we
>  |   can end up with a enabled interrupt line after the last handler was
>  |   removed, which can result in spurious interrupts.
>  |
>  |   Fix this by adding a default_shutdown function, which is only
>  |   installed, when the irqchip implementation does provide neither a
>  |   shutdown nor a disable function.
>  |
>  |   [@stable: affected versions: .21 - .24 ]
>
>  for MSI, default_shutdown will call mask_bit for msi device.  so all mask bits
>  will left disabled after free_irq.  then if kexec next kernel that only can
>  use msi_enable bit.  all device's MSI can not be used.
>
>  want to try to restore MSI mask bits that is saved before using msi in first
>  kernel.
>
>  Eric said:
>  This is over complicated and for hardware that erroneously triggers
>  a msi irq after free_irq may have potential problems.
>
>  So lets do the much simpler, much safer, and more general method of
>  restoring the mask bit to it's pci reset defined value (enabled) when
>  we disable the kernels use of msi.
>
>  it will work, because pci_diable_msi is called after free_irq is called.
>
>  v3: extend msi_set_mask_bit to msi_set_mask_bits to take mask, so we can fully
>  restore that to 0x00 instead of 0xfe.
>
>  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

andrew,

this one should replace

[PATCH] x86_64: restore mask_bits in msi shutdown

in -mm

YH
