Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0CJXRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:17:04 -0500
Received: from wdscspam2.wdc.com ([129.253.170.131]:27545 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0CJXRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:17:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
Date: Wed, 10 Mar 2010 15:16:59 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com>
In-Reply-To: <87sk88w4xk.fsf_-_@devron.myhome.or.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
Thread-Index: AcrAaZHktooh/N1eTV2XjDRpOdm9RAAPak4Q
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org><873a0h1p2c.fsf@devron.myhome.or.jp><876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com><87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com><87zl2j9muz.fsf@devron.myhome.or.jp><87wrxkw52s.fsf_-_@devron.myhome.or.jp> <87sk88w4xk.fsf_-_@devron.myhome.or.jp>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Mar 2010 23:17:00.0010 (UTC) FILETIME=[C92384A0:01CAC0A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, WD will be releasing products that need this patch.

Wouldn't it be a better Linux user experience to never have the problem,
rather than wait for a bug-fix cycle on the kernel?

OTOH, it would be reasonable to wait until someone else had a chance to
test the change.  We are awaiting NDAs from RedHat, Canonical, and
Novell/SUSE to send them the affected products for library/application
development.

Regards,

Dan 

> -----Original Message-----
> From: OGAWA Hirofumi [mailto:hirofumi@mail.parknet.co.jp] 
> Sent: Wednesday, March 10, 2010 7:52 AM
> To: Andrew Morton
> Cc: H. Peter Anvin; Daniel Taylor; linux-kernel@vger.kernel.org
> Subject: [PATCH 2/2] fs/partition/msdos: Fix unusable 
> extended partition for > 512B sector
> 
> We can drop this patch, if we want to delay until someone notice this
> and have some real requests to this.
> 
> 
> 
> 
> Smaller size than a minimum blocksize can't be used, after all it's
> handled like 0 size.
> 
> For extended partition itself, this makes sure to use bigger size than
> one logical sector size at least.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  fs/partitions/msdos.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff -puN fs/partitions/msdos.c~part-support-4k-block-fix 
> fs/partitions/msdos.c
> --- linux-2.6/fs/partitions/msdos.c~part-support-4k-block-fix	
> 2010-03-08 20:11:39.000000000 +0900
> +++ linux-2.6-hirofumi/fs/partitions/msdos.c	2010-03-08 
> 20:32:19.000000000 +0900
> @@ -492,9 +492,16 @@ int msdos_partition(struct parsed_partit
>  		if (!size)
>  			continue;
>  		if (is_extended_partition(p)) {
> -			/* prevent someone doing mkfs or mkswap on an
> -			   extended partition, but leave room 
> for LILO */
> -			put_partition(state, slot, start, size 
> == 1 ? 1 : 2);
> +			/*
> +			 * prevent someone doing mkfs or mkswap on an
> +			 * extended partition, but leave room for LILO
> +			 * FIXME: this uses one logical sector 
> for > 512b
> +			 * sector, although it may not be enough/proper.
> +			 */
> +			sector_t n = 2;
> +			n = min(size, max(sector_size, n));
> +			put_partition(state, slot, start, n);
> +
>  			printk(" <");
>  			parse_extended(state, bdev, start, size);
>  			printk(" >");
> _
> 
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
