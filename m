Return-Path: <linux-kernel-owner+w=401wt.eu-S1764977AbYD2QOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764977AbYD2QOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYD2QN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:13:57 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:36330 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754656AbYD2QN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:13:56 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 1/2] pci/irq: restore mask_bits in msi shutdown -v3
Date: Tue, 29 Apr 2008 09:13:17 -0700
User-Agent: KMail/1.9.9
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       "Greg KH" <greg@kroah.com>, "Jeff Garzik" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
References: <200804222148.17530.yhlu.kernel@gmail.com> <200804251448.21966.jbarnes@virtuousgeek.org> <86802c440804251508w3607dc44yccc720899d94364b@mail.gmail.com>
In-Reply-To: <86802c440804251508w3607dc44yccc720899d94364b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290913.17662.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 25, 2008 3:08 pm Yinghai Lu wrote:
> On Fri, Apr 25, 2008 at 2:48 PM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> > On Wednesday, April 23, 2008 2:56 pm Yinghai Lu wrote:
> >  > Yinghai found after using 2.6.25-rc3 later to kexec RHEL 5.1,
> >  > NIC can not be used.
> >  >
> >  > bisected to
> >
> >  Hi Yinghai, I've been thinking about these patches a bit...  They seem
> > like an important bug fix (making sure kexec'd kernels work), but I'm a
> > bit worried that the kexec'd kernel can't handle potentially broken
> > MSI/INTx setups. Shouldn't the kexec'd kernel be a bit more robust?  I
> > guess in this case you're kexec'ing an old kernel, so there's not much we
> > can do, but it still makes me a little uneasy.
>
> Yes, it is important, and should be in 2.6.25 stable too.
>
> the maskbits always 0x00 (enabled) from BIOS post..., so we should restore
> that.
>
> >  I guess for this particular set it doesn't matter much, since we should
> > be restoring things in pci_msi*_shutdown and pci_shutdown_device either
> > way. Can you clean up the changelog a bit and maybe make it more concise?
> >  E.g. we probably don't need the whole commit message for the bisect, and
> > we want to be clearer about what the failure mode is w/o the changes...
>
> without it, the second kernel can not use the devices, if second
> kernel could use MSI but doesn't touch mask_bit.
>
> ---
> [PATCH 1/2] pci/irq: restore mask_bits in msi shutdown -v3
>
> Yinghai found after using 2.6.25-rc3 later to kexec RHEL 5.1,
> NIC can not be used.
>
> bisected to
>
> | commit 89d694b9dbe769ca1004e01db0ca43964806a611
> | Author: Thomas Gleixner <tglx@linutronix.de>
> | Date:   Mon Feb 18 18:25:17 2008 +0100
> |
> |   genirq: do not leave interupts enabled on free_irq
> |
> |   The default_disable() function was changed in commit:
> |
> |    76d2160147f43f982dfe881404cfde9fd0a9da21
> |    genirq: do not mask interrupts by default
>
> for MSI, default_shutdown will call mask_bit for msi device.  so all mask
> bits will left disabled after free_irq.  then if kexec next kernel that
> only can use msi_enable bit.  all device's MSI can not be used.
>
> So lets to restore the mask bit to it's pci reset defined value (enabled)
> when we disable the kernels use of msi.
>
> extend msi_set_mask_bit to msi_set_mask_bits to take mask, so we can fully
> restore that to 0x00 instead of 0xfe.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Applied both (fixed up the changelog a little though), thanks.

Jesse
