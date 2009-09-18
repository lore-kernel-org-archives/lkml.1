Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZIROmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZIROmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZIROmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:42:32 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27681 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZIROmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:42:31 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R1453M98dN936eMa4a4kzz1202hzzz32i203h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQ68UN-04-06J-02
X-M-MSG: 
Date: Fri, 18 Sep 2009 16:42:26 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Keith Mannthey <kmannth@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [Patch] AMD64_EDAC: Fix amd64_map_to_dcs_mask
Message-ID: <20090918144226.GD25309@aftab>
References: <1253239781.7263.113.camel@keith-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1253239781.7263.113.camel@keith-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Sep 2009 14:42:21.0346 (UTC) FILETIME=[3A8E9020:01CA386E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 07:09:41PM -0700, Keith Mannthey wrote:
> I tested 2.6.31 and the mainline amd64_edac driver.  Once errors were
> getting reported I noticed that a good amount of valid looking system
> addressed were not being correctly decoded to the csrow level.  I was
> only able to correctly decode errors on channel 0 of a given csrow.
> Errors on channel 1 were unable to be mapped. 
> 
> After some digging I realized that the there was an issue with handling
> of Dram Chip Select Masks.  Specifically that amd64_map_to_dcs_mask was
> returning incorrect values on my Rev F based system.  See AMD #32559,
> 4.5.4, starting on pg 90 for a Rev F explanation of the correct mapping
> of DRAM CS Base and DRAM CS Mask regs.  This lead to the code below.  I
> can provide further explanation if needed. 
> 
> 
> I have tested this code on Rev F based system with ecc debug dimms and
> fully expect it to work on earlier and later cpus.  I am now able to
> correctly decode and map errors to csrows rows on this system. 
> 
> 
> Submitted-by:  Keith Mannthey<kmannth@us.ibm.com>
> ---

This whole DSC[BM] handling is rather long-winded and overengineered. It
is on my to-be-rewritten-and-simplified list.

> 
> diff -urN linux-2.6.31/drivers/edac/amd64_edac.c linux-2.6.31-fixed/drivers/edac/amd64_edac.c
> --- linux-2.6.31/drivers/edac/amd64_edac.c	2009-09-09 15:13:59.000000000 -0700
> +++ linux-2.6.31-fixed/drivers/edac/amd64_edac.c	2009-09-17 22:32:09.000000000 -0700
> @@ -1,6 +1,8 @@
> -#include "amd64_edac.h"
> +#include <linux/log2.h>
>  #include <asm/k8.h>
>  
> +#include "amd64_edac.h"
> +
>  static struct edac_pci_ctl_info *amd64_ctl_pci;
>  
>  static int report_gart_errors;
> @@ -132,7 +134,7 @@
>  /* Map from a CSROW entry to the mask entry that operates on it */
>  static inline u32 amd64_map_to_dcs_mask(struct amd64_pvt *pvt, int csrow)
>  {
> -	return csrow >> (pvt->num_dcsm >> 3);
> +	return csrow >> (8 >> (ilog2(pvt->num_dcsm)+1));

Almost. You have 8 DCSMs on RevE, 4 on RevF and F10h and 2 on F11h and
this way you get wrong DCSM offsets for F11h. A dirty fix would be:

if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_E) {
	return csrow;
else
	return csrow >> 1;

The problem is, the csrow thing still goes over 0..7 which is obviously
wrong on F11h but I'll fix that later. Care to redo your patch according
to these and the comments from my previous mail and resend?

By the way, your patches made me look harder at that code region and
I've found some more problems with it which I've fixed. Would you like
to test the whole bunch of fixes on your setup?

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

