Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbYBKTWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbYBKTWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbYBKTWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:22:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:11252 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbYBKTWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TlU2NkBr7W/WO+c4XU1Zdp8nhMNsY7Xbu5zFI4pHHEFGZ55WKbEPAtcS524zT2K8I6UESDM5dUF4a2k+LkL8HiQA5TNiob27D5qFXokhqDOv/407f4ji6DDMsObgCljG0NnP+9rJrDFRu0uTv4EeEb7VXR7p3jFD4Y/xS2f1+Q8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Prevent IDE boot ops on NUMA system in mainline
Date: Mon, 11 Feb 2008 20:26:26 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: torvalds@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080211003520.GA32082@basil.nowhere.org>
In-Reply-To: <20080211003520.GA32082@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802112026.27677.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008, Andi Kleen wrote:
> 
> Without this patch a Opteron test system here oopses at boot with currentg git. 
> 
> Calling to_pci_dev() on a NULL pointer gives a negative value so the following NULL 
> pointer check never triggers and then an illegal address is referenced. Check the 
> unadjusted original device pointer for NULL instead.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Thanks Andi!

This may explain+resolve ide_generic OOPS-es reported by Pavel/Kamalesh/Nish.

[ I also see that Linus has already merged the patch and you've followed
  up on pcibus_to_node() issue so there is nothing left for me to do...

  I really love when things turn out like this... ;) ]

> Index: linux/include/linux/ide.h
> ===================================================================
> --- linux.orig/include/linux/ide.h
> +++ linux/include/linux/ide.h
> @@ -1294,7 +1294,7 @@ static inline void ide_dump_identify(u8 
>  static inline int hwif_to_node(ide_hwif_t *hwif)
>  {
>  	struct pci_dev *dev = to_pci_dev(hwif->dev);
> -	return dev ? pcibus_to_node(dev->bus) : -1;
> +	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
>  }
>  
>  static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
