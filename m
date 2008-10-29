Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYJ2OA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYJ2OA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYJ2N7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:59:50 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34830 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752955AbYJ2N7s (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:59:48 -0400
Date: Wed, 29 Oct 2008 14:59:46 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jared Hulbert <jaredeh@gmail.com>
cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
In-Reply-To: <48AD0101.4020505@gmail.com>
Message-ID: <Pine.LNX.4.64.0810291456320.17174@vixen.sonytel.be>
References: <48AD0101.4020505@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1773774162-1225288786=:17174"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1773774162-1225288786=:17174
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 20 Aug 2008, Jared Hulbert wrote:
> --- /dev/null
> +++ b/fs/axfs/axfs_super.c

> +static int axfs_fill_region_data(struct super_block *sb,
> +				 struct axfs_region_desc *region, int force)
> +{
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	unsigned long addr;
> +	void *buff = NULL;
> +	void *vaddr;
> +	int err = -ENOMEM;
> +	u64 size = region->size;
> +	u64 fsoffset = region->fsoffset;
> +	u64 end = fsoffset + size;
> +	u64 c_size = region->compressed_size;
> +
> +	if (size == 0)
> +		return 0;
> +
> +	if (AXFS_IS_REGION_INCORE(region))
> +		goto incore;
> +
> +	if (AXFS_IS_REGION_COMPRESSED(region))
> +		goto incore;
> +
> +	if (AXFS_IS_REGION_XIP(sbi, region)) {
> +		if ((end > sbi->mmap_size) && (force))
> +			goto incore;
> +		addr = sbi->virt_start_addr;
> +		addr += (unsigned long)fsoffset;
> +		region->virt_addr = (void *)addr;
> +		return 0;
> +	}
> +
> +	if (force)
> +		goto incore;
> +
> +	region->virt_addr = NULL;
> +	return 0;
> +
> +incore:
> +	region->virt_addr = vmalloc(size);
> +	if (!region->virt_addr)
> +		goto out;
> +	vaddr = region->virt_addr;
> +
> +	if (AXFS_IS_REGION_COMPRESSED(region)) {
> +		buff = vmalloc(c_size);
> +		if (!buff)
> +			goto out;
> +		axfs_copy_metadata(sb, buff, fsoffset, c_size);
> +		err = axfs_uncompress_block(vaddr, size, buff, c_size);
                ^^^
axfs_uncompress_block() doesn't return an error code, so `err' is a bit of a
misnomer.

> +		if (!err)
                    ^^^^
Instead, it returns zero for error, hence this check is correct...

> +			goto out;
> +		vfree(buff);
> +	} else {
> +		axfs_copy_metadata(sb, vaddr, fsoffset, size);
> +	}
> +
> +	return 0;
> +
> +out:
> +	if (buff)
> +		vfree(buff);
> +	if (region->virt_addr)
> +		vfree(region->virt_addr);
> +	return err;
               ^^^
... but it will also return zero here, which is not correct.

Probably it's better to let axfs_uncompress_block() return an (negative) error
code (e.g. -EINVAL or -EIO) in case of failure, which you can just let
propagate.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1773774162-1225288786=:17174--
