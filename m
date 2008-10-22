Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbYJVQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbYJVQO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYJVQN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:13:57 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61986 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753527AbYJVQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:13:54 -0400
Date: Wed, 22 Oct 2008 18:13:52 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 12/16] Squashfs: header files
In-Reply-To: <E1KqrTX-0001y4-JE@dylan>
Message-ID: <Pine.LNX.4.64.0810221801570.5634@vixen.sonytel.be>
References: <E1KqrTX-0001y4-JE@dylan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-483830937-1224691556=:5634"
Content-ID: <Pine.LNX.4.64.0810221806000.5634@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-483830937-1224691556=:5634
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0810221806001.5634@vixen.sonytel.be>

On Fri, 17 Oct 2008, Phillip Lougher wrote:
> --- /dev/null
> +++ b/fs/squashfs/squashfs.h

> +#ifdef SQUASHFS_TRACE
> +#define TRACE(s, args...)	printk(KERN_NOTICE "SQUASHFS: "s, ## args)
> +#else
> +#define TRACE(s, args...)	{}
> +#endif

Just use

    #define TRACE(s, args...)	pr_debug("SQUASHFS: "s, ## args)

so we always get printf()-format checking, irrespective of whether DEBUG is
defined or not.

If you really want to keep the KERN_NOTICE (and the SQUASHFS_TRACE), you can
use

    #ifdef SQUASHFS_TRACE
    #define TRACE(s, args...)	pr_notice("SQUASHFS: "s, ## args)
    #else
    #define TRACE(s, args...)	pr_debug("SQUASHFS: "s, ## args)
    #endif

> +#define ERROR(s, args...)	printk(KERN_ERR "SQUASHFS error: "s, ## args)
                                ^^^^^^^^^^^^^^^^
				pr_err(
> +
> +#define SERROR(s, args...)	\
> +		do { \
> +			if (!silent) \
> +				printk(KERN_ERR "SQUASHFS error: "s, ## args);\
                                ^^^^^^^^^^^^^^^^
				pr_err(
> +		} while (0)

(yes, I know SERROR() no longer exists in CVS)

> +
> +#define WARNING(s, args...)	printk(KERN_WARNING "SQUASHFS: "s, ## args)
                                ^^^^^^^^^^^^^^^^
				pr_warning(

> --- /dev/null
> +++ b/include/linux/squashfs_fs.h

> +/* Filesystem flags */
> +#define SQUASHFS_NOI			0
> +#define SQUASHFS_NOD			1
> +#define SQUASHFS_NOF			3
> +#define SQUASHFS_NO_FRAG		4
> +#define SQUASHFS_ALWAYS_FRAG		5
> +#define SQUASHFS_DUPLICATE		6
> +#define SQUASHFS_EXPORT			7
> +
> +#define SQUASHFS_BIT(flag, bit)		((flag >> bit) & 1)
> +
> +#define SQUASHFS_UNCOMPRESSED_INODES(flags)	SQUASHFS_BIT(flags, \
> +						SQUASHFS_NOI)
> +
> +#define SQUASHFS_UNCOMPRESSED_DATA(flags)	SQUASHFS_BIT(flags, \
> +						SQUASHFS_NOD)
> +
> +#define SQUASHFS_UNCOMPRESSED_FRAGMENTS(flags)	SQUASHFS_BIT(flags, \
> +						SQUASHFS_NOF)
> +
> +#define SQUASHFS_NO_FRAGMENTS(flags)		SQUASHFS_BIT(flags, \
> +						SQUASHFS_NO_FRAG)
> +
> +#define SQUASHFS_ALWAYS_FRAGMENTS(flags)	SQUASHFS_BIT(flags, \
> +						SQUASHFS_ALWAYS_FRAG)
> +
> +#define SQUASHFS_DUPLICATES(flags)		SQUASHFS_BIT(flags, \
> +						SQUASHFS_DUPLICATE)
> +
> +#define SQUASHFS_EXPORTABLE(flags)		SQUASHFS_BIT(flags, \
> +						SQUASHFS_EXPORT)
> +
> +#define SQUASHFS_MKFLAGS(noi, nod, nof, no_frag, always_frag, \
> +		duplicate_checking, exportable)	(noi | (nod << 1) \
                                                               ^
> +		| (nof << 3) | (no_frag << 4) | (always_frag << 5) | \
                          ^                ^                    ^
> +		(duplicate_checking << 6) | (exportable << 7))
                                       ^                   ^
For the shifts, you can use the SQUASHFS_* filesystem flags defined above
instead of the hardcoded numbers.

SQUASHFS_MKFLAGS() isn't used by the kernel, only by the tools (mksquashfs)?

> +/* meta index cache */
> +#define SQUASHFS_META_INDEXES	(SQUASHFS_METADATA_SIZE / sizeof(unsigned int))
                                                                         ^^^^^^^^^^^^
I was wondering whether a meta index is an `unsigned int' or an `__le32', but I
couldn't find it easily.

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
---584349381-483830937-1224691556=:5634--
