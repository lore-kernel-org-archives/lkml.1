Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0CKHcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:32:00 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:48919 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0CKHb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:31:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eF0rbPSJhuRr/8Wvlhp98Hi2X9bippcDcIj5nLcOj2i8o8EQ7Hcc86iY82AUU3FizH
         RLKWCVMsbxgWNrpIanOAKXP+rJmWxCCOn4cy8k/H5HT5vs0BM2yZC68PmxTl5kCr0WUa
         5RpB6loq622I3WD1efvLDamEA0ZSD/cTbdyfY=
MIME-Version: 1.0
In-Reply-To: <1268258994.2183.14.camel@carter>
References: <1268258994.2183.14.camel@carter>
Date: Thu, 11 Mar 2010 08:31:57 +0100
Message-ID: <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       zhenyuw@linux.intel.com, ben@decadent.org.uk, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 11:09 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> Hi,
>
> The commit 5877960869333e42ebeb733e8d9d5630ff96d350 (included since 2.6.32.4) crashes (locks up) the 82915G/GV/910GL Controller when intel-agp.c tries to access nonexistent GTT entries at:
>
> -               for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
> +               for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {
>
> Rationale: I915 (gma900) has 128 MB of video memory (maximum), as per intel.com ( http://www.intel.com/support/graphics/intel915g/sb/CS-012579.htm ) and lscpi:
>
> 00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics Controller (rev 04) (prog-if 00 [VGA controller])
>        Subsystem: Intel Corporation Device 4147
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 11
>        Region 0: Memory at ff480000 (32-bit, non-prefetchable) [size=512K]
>        Region 1: I/O ports at ec00 [size=8]
>        Region 2: Memory at d8000000 (32-bit, prefetchable) [size=128M]
>        Region 3: Memory at ff440000 (32-bit, non-prefetchable) [size=256K]
>        Capabilities: <access denied>
>
>
> AFAIK, that implies that its gtt_total_size (in pages) should be 32K (as num_entries showed before the commit) instead of 64K.
>
> Note: The IS_I915 macro includes 945; however, only GMA900 (I915) had 128 MB as the maximum AFAIK. Therefore, I divided the IS_I915 macro. I do not know about the "E7221" (please check).
>
> How to reproduce: Access kernel.org in iceweasel (Debian Lenny) and the X server will crash. Sometimes, the kernel freezes.
>
> Please review. The fix should be applied to stable series, as well as 2.6.33 and 2.6.34-rc1.
>
> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> ---
> --- linux-2.6.32.stable/drivers/char/agp/intel-agp.c.old        2010-03-10 15:32:36.000000000 +0100
> +++ linux-2.6.32.stable/drivers/char/agp/intel-agp.c    2010-03-10 22:38:23.000000000 +0100
> @@ -65,11 +65,11 @@
>  #define PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB    0x006a
>  #define PCI_DEVICE_ID_INTEL_IGDNG_M_IG     0x0046
>
> -/* cover 915 and 945 variants */
>  #define IS_I915 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB || \
>                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB || \
> -                agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB || \
> -                agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
> +                agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB)
> +
> +#define IS_I945 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
>                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || \
>                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB)
>
> @@ -724,14 +724,14 @@ static void intel_i830_init_gtt_entries(
>                        break;
>                case I915_GMCH_GMS_STOLEN_48M:
>                        /* Check it's really I915G */
> -                       if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
> +                       if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
>                                gtt_entries = MB(48) - KB(size);
>                        else
>                                gtt_entries = 0;
>                        break;
>                case I915_GMCH_GMS_STOLEN_64M:
>                        /* Check it's really I915G */
> -                       if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
> +                       if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
>                                gtt_entries = MB(64) - KB(size);
>                        else
>                                gtt_entries = 0;
> @@ -1305,6 +1305,8 @@ static int intel_i915_create_gatt_table(
>
>        if (IS_G33)
>            gtt_map_size = 1024 * 1024; /* 1M on G33 */
> +       else if (IS_I915)
> +           gtt_map_size = 128 * 1024; /* 128K on I915 */
>        intel_private.gtt = ioremap(temp2, gtt_map_size);
>        if (!intel_private.gtt)
>                return -ENOMEM;
>
>
>

Cc'ing the original committers.
