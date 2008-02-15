Return-Path: <linux-kernel-owner+w=401wt.eu-S933685AbYBOKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbYBOKxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbYBOKxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:53:03 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:46833 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834AbYBOKxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:53:01 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Keith Mok <ek9852@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfat: bug fix for vfat cannot handle filename with 255 asian characters when mounted with utf8
References: <47B3213E.1020407@gmail.com> <87ejbea9xo.fsf@duaron.myhome.or.jp>
	<47B56C20.3030200@gmail.com>
Date: Fri, 15 Feb 2008 19:52:50 +0900
In-Reply-To: <47B56C20.3030200@gmail.com> (Keith Mok's message of "Fri, 15 Feb
	2008 18:40:32 +0800")
Message-ID: <87abm2a3ul.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Mok <ek9852@gmail.com> writes:

> Patch modified according to coding style in Linux.
> NLS and UTF8 filename length are checked and limited to 255 after convert to unicode in xlate_to_uni function.
>
>
> Signed-off-by: Keith Mok <ek9852@gmail.com>

Looks good to me. I'll submit after some test. (and maybe some cleanup
of this area).

Thanks.

> --- linux-source-2.6.22/fs/fat/dir.c.orig	2007-07-09 07:32:17.000000000 +0800
> +++ linux-source-2.6.22/fs/fat/dir.c	2008-02-15 17:24:18.000000000 +0800
> @@ -124,7 +124,7 @@ static inline int fat_get_entry(struct i
>   * but ignore that right now.
>   * Ahem... Stack smashing in ring 0 isn't fun. Fixed.
>   */
> -static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int uni_xlate,
> +static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int len, int uni_xlate,
>  		       struct nls_table *nls)
>  {
>  	wchar_t *ip, ec;
> @@ -135,10 +135,11 @@ static int uni16_to_x8(unsigned char *as
>  	ip = uni;
>  	op = ascii;
>  
> -	while (*ip) {
> +	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
>  		ec = *ip++;
>  		if ( (charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
>  			op += charlen;
> +			len -= charlen;
>  		} else {
>  			if (uni_xlate == 1) {
>  				*op = ':';
> @@ -149,15 +150,18 @@ static int uni16_to_x8(unsigned char *as
>  					ec >>= 4;
>  				}
>  				op += 5;
> +				len -= 5;
>  			} else {
>  				*op++ = '?';
> +				len--;
>  			}
>  		}
> -		/* We have some slack there, so it's OK */
> -		if (op>ascii+256) {
> -			op = ascii + 256;
> -			break;
> -		}
> +	}
> +	
> +	if(unlikely(*ip)) {
> +		printk(KERN_WARNING
> +			"FAT: truncated while convert unicode characters in %s\n",
> +			__FUNCTION__);
>  	}
>  	*op = 0;
>  	return (op - ascii);
> @@ -311,9 +315,11 @@ int fat_search_long(struct inode *inode,
>  	struct nls_table *nls_io = sbi->nls_io;
>  	struct nls_table *nls_disk = sbi->nls_disk;
>  	wchar_t bufuname[14];
> -	unsigned char xlate_len, nr_slots;
> +	int xlate_len;
> +	unsigned char nr_slots;
>  	wchar_t *unicode = NULL;
> -	unsigned char work[8], bufname[260];	/* 256 + 4 */
> +	unsigned char work[8];
> +	unsigned char *bufname = NULL;
>  	int uni_xlate = sbi->options.unicode_xlate;
>  	int utf8 = sbi->options.utf8;
>  	int anycase = (sbi->options.name_check != 's');
> @@ -321,6 +327,10 @@ int fat_search_long(struct inode *inode,
>  	loff_t cpos = 0;
>  	int chl, i, j, last_u, err;
>  
> +	bufname = (unsigned char*)__get_free_page(GFP_KERNEL);
> +	if (!bufname) {
> +		return -ENOMEM;
> +	}
>  	err = -ENOENT;
>  	while(1) {
>  		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
> @@ -383,8 +393,8 @@ parse_record:
>  
>  		bufuname[last_u] = 0x0000;
>  		xlate_len = utf8
> -			?utf8_wcstombs(bufname, bufuname, sizeof(bufname))
> -			:uni16_to_x8(bufname, bufuname, uni_xlate, nls_io);
> +			?utf8_wcstombs(bufname, bufuname, PAGE_SIZE)
> +			:uni16_to_x8(bufname, bufuname, PAGE_SIZE, uni_xlate, nls_io);
>  		if (xlate_len == name_len)
>  			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
>  			    (anycase && !nls_strnicmp(nls_io, name, bufname,
> @@ -393,8 +403,8 @@ parse_record:
>  
>  		if (nr_slots) {
>  			xlate_len = utf8
> -				?utf8_wcstombs(bufname, unicode, sizeof(bufname))
> -				:uni16_to_x8(bufname, unicode, uni_xlate, nls_io);
> +				?utf8_wcstombs(bufname, unicode, PAGE_SIZE)
> +				:uni16_to_x8(bufname, unicode, PAGE_SIZE, uni_xlate, nls_io);
>  			if (xlate_len != name_len)
>  				continue;
>  			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
> @@ -413,6 +423,8 @@ Found:
>  	sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
>  	err = 0;
>  EODir:
> +	if (bufname)
> +		free_page((unsigned long)bufname);
>  	if (unicode)
>  		free_page((unsigned long)unicode);
>  
> @@ -593,7 +605,7 @@ parse_record:
>  	if (isvfat) {
>  		bufuname[j] = 0x0000;
>  		i = utf8 ? utf8_wcstombs(bufname, bufuname, sizeof(bufname))
> -			 : uni16_to_x8(bufname, bufuname, uni_xlate, nls_io);
> +			 : uni16_to_x8(bufname, bufuname, sizeof(bufname), uni_xlate, nls_io);
>  	}
>  
>  	fill_name = bufname;
> @@ -605,7 +617,7 @@ parse_record:
>  		int buf_size = PAGE_SIZE - (261 * sizeof(unicode[0]));
>  		int long_len = utf8
>  			? utf8_wcstombs(longname, unicode, buf_size)
> -			: uni16_to_x8(longname, unicode, uni_xlate, nls_io);
> +			: uni16_to_x8(longname, unicode, buf_size, uni_xlate, nls_io);
>  
>  		if (!both) {
>  			fill_name = longname;
> --- linux-source-2.6.22/fs/vfat/namei.c.orig	2007-07-09 07:32:17.000000000 +0800
> +++ linux-source-2.6.22/fs/vfat/namei.c	2008-02-15 18:33:15.000000000 +0800
> @@ -176,15 +176,8 @@ static inline int vfat_is_used_badchars(
>  	for (i = 0; i < len; i++)
>  		if (vfat_bad_char(s[i]))
>  			return -EINVAL;
> -	return 0;
> -}
> -
> -static int vfat_valid_longname(const unsigned char *name, unsigned int len)
> -{
> -	if (name[len - 1] == ' ')
> +	if (s[i - 1] == 0x0020) /* last character cannot be space */
>  		return -EINVAL;
> -	if (len >= 256)
> -		return -ENAMETOOLONG;
>  	return 0;
>  }
>  
> @@ -485,11 +478,14 @@ xlate_to_uni(const unsigned char *name, 
>  		 */
>  		*outlen -= (name_len - len);
>  
> +		if (*outlen > 255)
> +			return -ENAMETOOLONG;
> +
>  		op = &outname[*outlen * sizeof(wchar_t)];
>  	} else {
>  		if (nls) {
>  			for (i = 0, ip = name, op = outname, *outlen = 0;
> -			     i < len && *outlen <= 260;
> +			     i < len && *outlen <= 255;
>  			     *outlen += 1)
>  			{
>  				if (escape && (*ip == ':')) {
> @@ -525,18 +521,20 @@ xlate_to_uni(const unsigned char *name, 
>  					op += 2;
>  				}
>  			}
> +			if (i < len)
> +				return -ENAMETOOLONG;
>  		} else {
>  			for (i = 0, ip = name, op = outname, *outlen = 0;
> -			     i < len && *outlen <= 260;
> +			     i < len && *outlen <= 255;
>  			     i++, *outlen += 1)
>  			{
>  				*op++ = *ip++;
>  				*op++ = 0;
>  			}
> +			if (i < len)
> +				return -ENAMETOOLONG;
>  		}
>  	}
> -	if (*outlen > 260)
> -		return -ENAMETOOLONG;
>  
>  	*longlen = *outlen;
>  	if (*outlen % 13) {
> @@ -574,9 +572,6 @@ static int vfat_build_slots(struct inode
>  	loff_t offset;
>  
>  	*nr_slots = 0;
> -	err = vfat_valid_longname(name, len);
> -	if (err)
> -		return err;
>  
>  	page = __get_free_page(GFP_KERNEL);
>  	if (!page)
>
>
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
