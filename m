Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbZJKHxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbZJKHxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 03:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZJKHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 03:53:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbZJKHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 03:53:11 -0400
Date: Sun, 11 Oct 2009 00:51:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, Eric Sesterhenn <snakebyte@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>, 550010@bugs.debian.org
Subject: Re: [PATCH] hfsplus: Refuse to mount volumes larger than 2TB
Message-Id: <20091011005153.cc723dca.akpm@linux-foundation.org>
In-Reply-To: <1255227087.25061.76.camel@localhost>
References: <1254883878.4246.191.camel@localhost>
	<1255227087.25061.76.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 03:11:27 +0100 Ben Hutchings <ben@decadent.org.uk> wrote:

> As found in <http://bugs.debian.org/550010>, hfsplus is using type u32
> rather than sector_t for some sector number calculations.
> 
> In particular, hfsplus_get_block() does:
> 
>         u32 ablock, dblock, mask;
> ...
>         map_bh(bh_result, sb, (dblock << HFSPLUS_SB(sb).fs_shift) + HFSPLUS_SB(sb).blockoffset + (iblock & mask));
> 
> I am not confident that I can find and fix all cases where a sector
> number may be truncated.  For now, avoid data loss by refusing to mount
> HFS+ volumes with more than 2^32 sectors (2TB).
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@kernel.org
> ---
> --- a/fs/hfsplus/wrapper.c
> +++ b/fs/hfsplus/wrapper.c
> @@ -99,6 +99,10 @@
>  
>  	if (hfsplus_get_last_session(sb, &part_start, &part_size))
>  		return -EINVAL;
> +	if (part_start + part_size > 0x100000000) {
> +		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
> +		return -EINVAL;
> +	}

part_start and part_size are sector_t.  This code will do weird overflow
things when sector_t is 32-bit.  Also 32-bit compilers will get upset at the
excessively large hex constant.

This should fix both issues:

--- a/fs/hfsplus/wrapper.c~hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix
+++ a/fs/hfsplus/wrapper.c
@@ -99,7 +99,7 @@ int hfsplus_read_wrapper(struct super_bl
 
 	if (hfsplus_get_last_session(sb, &part_start, &part_size))
 		return -EINVAL;
-	if (part_start + part_size > 0x100000000) {
+	if ((u64)part_start + part_size > 0x100000000ULL) {
 		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
 		return -EINVAL;
 	}
_

