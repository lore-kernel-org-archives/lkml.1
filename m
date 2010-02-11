Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0BKOc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:32:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:36060 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753559Ab0BKOcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:32:25 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+ZA0sxzaGZewfA9NvxewBa3Dxo/Sxd3XO+WgudbD
	7154sPOpKsHaxK
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Tejun Heo <tj@kernel.org>
Subject: Re: patch idr-fix-a-critical-misallocation-bug.patch added to 2.6.32-stable tree
Date: Thu, 11 Feb 2010 15:32:11 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-sidux-686; KDE/4.3.4; i686; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
References: <12651725962428@site> <201002041641.21063.s.L-H@gmx.de> <4B73C50B.5040303@kernel.org>
In-Reply-To: <4B73C50B.5040303@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002111532.14218.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 11 February 2010, Tejun Heo wrote:
> Hello,
> 
> Can you please test the following patch on top of the current
> mainline?
> 
> Thanks.

This works fine for me on 2.6.33-rc7-git5 plus your patch:

KMS enabled:
ii  xserver-xorg-video-intel 2:2.9.1-2          X.Org X server -- Intel i8xx, i9xx display driver
- 00:02.0 VGA compatible controller [0300]: Intel Corporation 82945G/GZ Integrated Graphics Controller [8086:2772] (rev 02)
  00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GME Express Integrated Graphics Controller [8086:27ae] (rev 03)

KMS enabled:
ii  xserver-xorg-video-radeon 1:6.12.4-3         X.Org X server -- ATI Radeon display driver
- 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV630 [Radeon HD 2600 Series] [1002:9589]
  01:00.1 Audio device [0403]: ATI Technologies Inc RV630/M76 audio device [Radeon HD 2600 Series] [1002:aa08]
- 05:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)] [1002:5b60]
  05:00.1 Display controller [0380]: ATI Technologies Inc RV370 [Radeon X300SE] [1002:5b70]
- 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] [1002:4e50]
- 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV280 [Radeon 9200 PRO] [1002:5960] (rev 01)
  01:00.1 Display controller [0380]: ATI Technologies Inc RV280 [Radeon 9200 PRO] (Secondary) [1002:5940] (rev 01)

no KMS available (Debian unstable has no matching xserver-xorg-video-nouveau
yet):
ii  xserver-xorg-video-nv 1:2.1.15-1         X.Org X server -- NV display driver
- 01:00.0 VGA compatible controller [0300]: nVidia Corporation NV11 [GeForce2 MX/MX 400] [10de:0110] (rev a1)

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Thank you a lot
	Stefan Lippers-Hollmann

-- 
> diff --git a/lib/idr.c b/lib/idr.c
> index 1cac726..0dc7822 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -156,10 +156,12 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
>  			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
>  
>  			/* if already at the top layer, we need to grow */
> -			if (!(p = pa[l])) {
> +			if (id >= 1 << (idp->layers * IDR_BITS)) {
>  				*starting_id = id;
>  				return IDR_NEED_TO_GROW;
>  			}
> +			p = pa[l];
> +			BUG_ON(!p);
>  
>  			/* If we need to go up one layer, continue the
>  			 * loop; otherwise, restart from the top.
