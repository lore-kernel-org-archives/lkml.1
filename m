Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0CJOoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:44:34 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:38446 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab0CJOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:44:33 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] allow retrieving entries with trailing dots
References: <20100310123257.GA2899@frolo.macqel>
Date: Wed, 10 Mar 2010 23:44:27 +0900
In-Reply-To: <20100310123257.GA2899@frolo.macqel> (Philippe De Muyter's
	message of "Wed, 10 Mar 2010 13:32:57 +0100")
Message-ID: <87d3zc1bjo.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

> --- a/fs/fat/namei_vfat.c	2009-09-10 00:13:59.000000000 +0200
> +++ b/fs/fat/namei_vfat.c	2010-02-08 02:28:37.010096903 +0100
> @@ -702,9 +702,22 @@
>  static int vfat_find(struct inode *dir, struct qstr *qname,
>  		     struct fat_slot_info *sinfo)
>  {
> -	unsigned int len = vfat_striptail_len(qname);
> +	int err;
> +	unsigned int len;
> +
> +	/* Some combined ethernet + usb external hard drive do not
> +	 * remove the trailing dots when creating entries in ethernet mode.
> +	 * (e.g. Iomega Home Network Hard Drive)
> +	 * Make accessing those entries possible.
> +	 */
> +	err = fat_search_long(dir, qname->name, qname->len, sinfo);
> +	if (!err)
> +		return err;
> +	len = vfat_striptail_len(qname);
>  	if (len == 0)
>  		return -ENOENT;
> +	if (len == qname->len)
> +		return err;
>  	return fat_search_long(dir, qname->name, len, sinfo);
>  }

This would be bad for both (standard and IO-MEGA hack).

This introduces unneeded directory-parse to standard one.  And for
IO-MEGA, this wouldn't provide proper filename handling.

If it wants to handle the tailing-dot as a part of filename, it
shouldn't be able to access to the stripped-dots filename. (For simple
example, I guess you can't do "mv a a." with this patch.)

I'm not still sure if we should include this or not, however, I think
improper/imperfect quick hack wouldn't be acceptable at least.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
