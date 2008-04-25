Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbYDYWJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbYDYWJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbYDYWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:08:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:30195 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbYDYWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ejOMWhNKzD3wbQG0z2a5HMSZ4HT4y4YO6M5dRtmqfTQrkXf+qDWrvTwhA3Op7Rm6ITzW4hQlTgB5eyHXFgVUR7Ev2AWLG//e6bPcm02GGzqBh/m2j6BLpe4q/I5cXZI3iSGf4Z0ITwynzOc22f4Ke5maxqVmbNdfr7YwstL5aPo=
Message-ID: <86802c440804251508w3607dc44yccc720899d94364b@mail.gmail.com>
Date: Fri, 25 Apr 2008 15:08:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] pci/irq: restore mask_bits in msi shutdown -v3
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       "Greg KH" <greg@kroah.com>, "Jeff Garzik" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
In-Reply-To: <200804251448.21966.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <200804231456.30786.yhlu.kernel@gmail.com>
	 <200804251448.21966.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 2:48 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wednesday, April 23, 2008 2:56 pm Yinghai Lu wrote:
>  > Yinghai found after using 2.6.25-rc3 later to kexec RHEL 5.1,
>  > NIC can not be used.
>  >
>  > bisected to
>
>  Hi Yinghai, I've been thinking about these patches a bit...  They seem like an
>  important bug fix (making sure kexec'd kernels work), but I'm a bit worried
>  that the kexec'd kernel can't handle potentially broken MSI/INTx setups.
>  Shouldn't the kexec'd kernel be a bit more robust?  I guess in this case
>  you're kexec'ing an old kernel, so there's not much we can do, but it still
>  makes me a little uneasy.

Yes, it is important, and should be in 2.6.25 stable too.

the maskbits always 0x00 (enabled) from BIOS post..., so we should restore that.

>
>  I guess for this particular set it doesn't matter much, since we should be
>  restoring things in pci_msi*_shutdown and pci_shutdown_device either way.
>  Can you clean up the changelog a bit and maybe make it more concise?  E.g. we
>  probably don't need the whole commit message for the bisect, and we want to
>  be clearer about what the failure mode is w/o the changes...

without it, the second kernel can not use the devices, if second
kernel could use MSI but doesn't touch mask_bit.

---
[PATCH 1/2] pci/irq: restore mask_bits in msi shutdown -v3

Yinghai found after using 2.6.25-rc3 later to kexec RHEL 5.1,
NIC can not be used.

bisected to

| commit 89d694b9dbe769ca1004e01db0ca43964806a611
| Author: Thomas Gleixner <tglx@linutronix.de>
| Date:   Mon Feb 18 18:25:17 2008 +0100
|
|   genirq: do not leave interupts enabled on free_irq
|
|   The default_disable() function was changed in commit:
|
|    76d2160147f43f982dfe881404cfde9fd0a9da21
|    genirq: do not mask interrupts by default
|

for MSI, default_shutdown will call mask_bit for msi device.  so all mask bits
will left disabled after free_irq.  then if kexec next kernel that only can
use msi_enable bit.  all device's MSI can not be used.

So lets to restore the mask bit to it's pci reset defined value (enabled) when
we disable the kernels use of msi.

extend msi_set_mask_bit to msi_set_mask_bits to take mask, so we can fully
restore that to 0x00 instead of 0xfe.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---

YH
