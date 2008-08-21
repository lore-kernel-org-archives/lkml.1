Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYHULch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYHULch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbYHULcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:32:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYHULcX (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:32:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: jaredeh@gmail.com
Subject: Re: [PATCH 03/10] AXFS: axfs.h
Date: Thu, 21 Aug 2008 13:31:35 +0200
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00E6.2070505@gmail.com>
In-Reply-To: <48AD00E6.2070505@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211331.36346.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/8ulayxtIkZ2utIrgHV6+xTUryGr1kIXhvUNk
 hfG400oeX4l9B/+fDij5L1jpmcvzIukb1mtuZxGRRhMuC2g7In
 NuNa5staJQzmcg600QtCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
>
> +#ifndef __AXFS_H
> +#define __AXFS_H
> +
> +
> +#ifdef __KERNEL__
> +#include <linux/rwsem.h>
> +#endif
> +#include <linux/errno.h>
> +#include <linux/time.h>
> +
> +#define AXFS_MAGIC	0x48A0E4CD	/* some random number */
> +#define AXFS_SIGNATURE	"Advanced XIP FS"
> +#define AXFS_MAXPATHLEN 255
> +
> +/* Uncompression interfaces to the underlying zlib */
> +int axfs_uncompress_block(void *, int, void *, int);
> +int axfs_uncompress_init(void);
> +int axfs_uncompress_exit(void);

You already have both __KERNEL__ and user space parts in your header.
Function declarations clearly don't belong in the user visible parts.
I suggest you only leave on-disk data structure definitions and user
interfaces in the user-visible include/linux/axfs.h file, and move
all internal interfaces to fs/axfs/axfs.h.

> +/*
> + *  on media struct describing a data region
> + */
> +struct axfs_region_desc_onmedia {
> +	u64 fsoffset;
> +	u64 size;
> +	u64 compressed_size;
> +	u64 max_index;
> +	u8 table_byte_depth;
> +	u8 incore;
> +};

For on-disk data structures, I would use __be64 or __le64 types,
preferrably the opposite of your native CPU byte order on the system
you are developing most code on, to make sure that you get endianess
right.

> +#define AXFS_PAGE_SIZE 4096

What happens on systems where AXFS_PAGE_SIZE != PAGE_SIZE?

> +#ifndef TRUE
> +#define TRUE 1
> +#endif
> +#ifndef FALSE
> +#define FALSE 0
> +#endif
> +

These are already defined in <linux/kernel.h>, so please use the
existing definitions.

	Arnd <><
