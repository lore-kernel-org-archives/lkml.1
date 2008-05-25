Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbYEYPmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbYEYPmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYEYPmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:42:38 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:41248 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYEYPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:42:37 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: =?iso-8859-1?Q?Ren=E9?= Scharfe <rene.scharfe@lsrfire.ath.cx>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
References: <1211717062.5782.16.camel@ubuntu>
Date: Mon, 26 May 2008 00:42:29 +0900
In-Reply-To: <1211717062.5782.16.camel@ubuntu> (=?iso-8859-1?Q?=22Ren=E9?=
 Scharfe"'s message of
	"Sun, 25 May 2008 14:04:22 +0200")
Message-ID: <87ve12s849.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

René Scharfe <rene.scharfe@lsrfire.ath.cx> writes:

> It has been impossible to set the option 'atari' of the MSDOS filesystem
> for several years.  Since nobody seems to have missed it, let's remove
> its remains.
>
> Signed-off-by: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
> ---

Looks good to me. Thanks.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

>  fs/msdos/namei.c         |   18 ++++++------------
>  include/linux/msdos_fs.h |    1 -
>  2 files changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/fs/msdos/namei.c b/fs/msdos/namei.c
> index 05ff4f1..8240d22 100644
> --- a/fs/msdos/namei.c
> +++ b/fs/msdos/namei.c
> @@ -14,12 +14,7 @@
>  
>  /* Characters that are undesirable in an MS-DOS file name */
>  static unsigned char bad_chars[] = "*?<>|\"";
> -static unsigned char bad_if_strict_pc[] = "+=,; ";
> -/* GEMDOS is less restrictive */
> -static unsigned char bad_if_strict_atari[] = " ";
> -
> -#define bad_if_strict(opts) \
> -	((opts)->atari ? bad_if_strict_atari : bad_if_strict_pc)
> +static unsigned char bad_if_strict[] = "+=,; ";
>  
>  /***** Formats an MS-DOS file name. Rejects invalid names. */
>  static int msdos_format_name(const unsigned char *name, int len,
> @@ -40,21 +35,20 @@ static int msdos_format_name(const unsigned char *name, int len,
>  			/* Get rid of dot - test for it elsewhere */
>  			name++;
>  			len--;
> -		} else if (!opts->atari)
> +		} else
>  			return -EINVAL;
>  	}
>  	/*
> -	 * disallow names that _really_ start with a dot for MS-DOS,
> -	 * GEMDOS does not care
> +	 * disallow names that _really_ start with a dot
>  	 */
> -	space = !opts->atari;
> +	space = 1;
>  	c = 0;
>  	for (walk = res; len && walk - res < 8; walk++) {
>  		c = *name++;
>  		len--;
>  		if (opts->name_check != 'r' && strchr(bad_chars, c))
>  			return -EINVAL;
> -		if (opts->name_check == 's' && strchr(bad_if_strict(opts), c))
> +		if (opts->name_check == 's' && strchr(bad_if_strict, c))
>  			return -EINVAL;
>  		if (c >= 'A' && c <= 'Z' && opts->name_check == 's')
>  			return -EINVAL;
> @@ -94,7 +88,7 @@ static int msdos_format_name(const unsigned char *name, int len,
>  			if (opts->name_check != 'r' && strchr(bad_chars, c))
>  				return -EINVAL;
>  			if (opts->name_check == 's' &&
> -			    strchr(bad_if_strict(opts), c))
> +			    strchr(bad_if_strict, c))
>  				return -EINVAL;
>  			if (c < ' ' || c == ':' || c == '\\')
>  				return -EINVAL;
> diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
> index b03b274..ceb5d16 100644
> --- a/include/linux/msdos_fs.h
> +++ b/include/linux/msdos_fs.h
> @@ -208,7 +208,6 @@ struct fat_mount_options {
>  		 utf8:1,	  /* Use of UTF-8 character set (Default) */
>  		 unicode_xlate:1, /* create escape sequences for unhandled Unicode */
>  		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
> -		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
>  		 flush:1,	  /* write things quickly */
>  		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
>  		 usefree:1;	  /* Use free_clusters for FAT32 */
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
