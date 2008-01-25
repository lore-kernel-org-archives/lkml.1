Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYAYDgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYAYDgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYAYDgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:36:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:6870 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYAYDgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rl7i1rhszXmP1uN21rvxgeXC4Z7XOcWtfTNN+NZeH2i783BsGZude/B0cpZyiGOgqctWv9I9aaGnFKp9Nv5Aat6KxCxv7fwlNU8QvYvMqKuBdS8WJFlpyLqH9tX1EGFn1O7bOwpIolgx1RH70JMT7netSin2a0nNJbm1jVnnPVE=
Message-ID: <4799591B.5090905@gmail.com>
Date: Fri, 25 Jan 2008 12:35:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Shane Huang <Shane.Huang@amd.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] PCI: modify SB700 SATA MSI quirk
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF8F0@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E501BF8F0@sshaexmb1.amd.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shane Huang wrote:
> I did some modification to this patch and send it again, Please check
> it.
> The quirk to 0x4395 has been removed because 0x4395 only belongs to
> SB800.
> 
>> SB700 SATA MSI bug will be fixed in SB700 revision A21 at 
>> hardware level,
>> but the SB700 revision older than A21 will also be found in 
>> the market.
>> This patch modify the original quirk commit
>> bc38b411fe696fad32b261f492cb4afbf1835256 instead of withdrawing it.

You need to merge the above two messages into one patch description.

>> Signed-off-by: Shane Huang <shane.huang@amd.com>

After S-O-B, you can put --- and between it and the patch body, you can
say things which you wanna mention but don't think should be included in
commit message.

> +static void __devinit quirk_msi_intx_disable_ati_bug(struct pci_dev
> *dev)
> +{
> +	struct pci_dev *p;
> +	u8 rev = 0;
> +
> +	/* SB700 MSI issue will be fixed at HW level from revision A21,
> +	 * we need check PCI REVISION ID of SMBus controller to get
> SB700
> +	 * revision.
> +	 */
> +	p = pci_get_device(PCI_VENDOR_ID_ATI,
> PCI_DEVICE_ID_ATI_SBX00_SMBUS,
> +			   NULL);
> +	if (p) {
> +		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);

Please drop unnecessary braces and you can you p->revision.

> +	}
> +	if ((rev < 0x3B) && (rev >= 0x30)) {
> +		dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
> +	}

Hmm... So, if there's no SMBUS device the quirk applies.  Is this
intended?  If that can't happen, just do if (!p) return;

Also, pci_get_device() requires matching pci_dev_put().

> +}
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>  			PCI_DEVICE_ID_TIGON3_5780,
>  			quirk_msi_intx_disable_bug);
> @@ -1729,17 +1747,15 @@
>  			quirk_msi_intx_disable_bug);
>  
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4390,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4391,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4392,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4393,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4394,
> -			quirk_msi_intx_disable_bug);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4395,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);

You tested this, right?

-- 
tejun
