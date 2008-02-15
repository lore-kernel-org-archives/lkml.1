Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbYBOIli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbYBOIli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYBOIlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:41:31 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:58630 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYBOIla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:41:30 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Keith Mok <ek9852@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfat: bug fix for vfat cannot handle filename with 255 asian characters when mounted with utf8
References: <47B3213E.1020407@gmail.com>
Date: Fri, 15 Feb 2008 17:41:23 +0900
In-Reply-To: <47B3213E.1020407@gmail.com> (Keith Mok's message of "Thu, 14 Feb
	2008 00:56:30 +0800")
Message-ID: <87ejbea9xo.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Mok <ek9852@gmail.com> writes:

> This patch fix the problem that the buffer allocated for convert of
> unicode to utf8 in fat/dir.c is too small.
> And cannot handle filename with 255 asian characters when mounted with
> utf8 options.
>
> Also it fix the filename length limitation checking in vfat/namei.c that
> the filename length should be checked against the number of converted
> unicode characters.
> Not the length before NLS/UTF8 converted.
>
> Any comments ?

Looks good. But it seems to have some problems.

And we will need cleanup the original code related this
patch. Unfortunately, it's really dirty although unrelated to this
patch.

> --- linux-source-2.6.22/fs/vfat/namei.c.orig	2007-07-09 07:32:17.000000000 +0800
> +++ linux-source-2.6.22/fs/vfat/namei.c	2008-02-13 22:56:14.000000000 +0800
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
> +	if(s[i-1] == 0x0020) /* last character cannot be space */

Please use the following style. (See Documentation/CodingStyle)

	if (s[i - 1] == 0x0020)

> @@ -489,7 +482,7 @@ xlate_to_uni(const unsigned char *name, 
>  	} else {
>  		if (nls) {
>  			for (i = 0, ip = name, op = outname, *outlen = 0;
> -			     i < len && *outlen <= 260;
> +			     i < len && *outlen <= 255;
>  			     *outlen += 1)
>  			{
>  				if (escape && (*ip == ':')) {

Don't we also need to fix the "utf8" option case?

> --- linux-source-2.6.22/fs/fat/dir.c.orig	2007-07-09 07:32:17.000000000 +0800
> +++ linux-source-2.6.22/fs/fat/dir.c	2008-02-14 00:42:52.000000000 +0800
> @@ -124,7 +124,7 @@ static inline int fat_get_entry(struct i
>   * but ignore that right now.
>   * Ahem... Stack smashing in ring 0 isn't fun. Fixed.
>   */
> -static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int uni_xlate,
> +static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int len, int uni_xlate,
>  		       struct nls_table *nls)
>  {
>  	wchar_t *ip, ec;
> @@ -135,10 +135,13 @@ static int uni16_to_x8(unsigned char *as
>  	ip = uni;
>  	op = ascii;
>  
> -	while (*ip) {
> +	BUG_ON(len <= NLS_MAX_CHARSET_SIZE);

Do we need this check?

> +	while (*ip && (len-NLS_MAX_CHARSET_SIZE)>0) {

coding style
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
