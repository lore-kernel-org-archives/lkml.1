Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYDHAYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYDHAYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 20:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYDHAYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 20:24:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYDHAYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 20:24:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: joern@logfs.org
Subject: Re: [patch 2/15] fs/logfs/logfs_abi.h
Date: Tue, 8 Apr 2008 02:24:17 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <20080401181308.512473173@logfs.org> <20080401181332.853833002@logfs.org>
In-Reply-To: <20080401181332.853833002@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804080224.18014.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+nd+9dqPvIzmUpVzhdpYTgJpJSp2NQDY7+RRB
 l8G+r2iNEu2TDHUqxiGWiC6r4z+hdne9vPmtgOmMu1O2ajZNhz
 oZgZUoOpmRE+US1klfa1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörn,

Great to see a new version finally posted again!

A few things that I spotted looking through this header,
I hope I can find some time to look throught the other files
as well.

On Tuesday 01 April 2008, joern@logfs.org wrote:
> --- /dev/null	2008-04-02 16:29:12.813336657 +0200
> +++ linux-2.6.24logfs/fs/logfs/logfs_abi.h	2008-04-01 21:02:34.980239877 +0200
> @@ -0,0 +1,523 @@
> +/*
> + * fs/logfs/logfs.h

The comment doesn't match the file name, and the file name doesn't
match the purpose -- you are not defining an "application" binary
interface but rather the medium format, with the small exception
of the chattr flags.

> +#ifndef fs_logfs_logfs_abi_h
> +#define fs_logfs_logfs_abi_h

Everyone else uses capital letters for these.

> +/*
> + * LOGFS_HEADERSIZE is the size of a single header in the object store,
> + * LOGFS_MAX_OBJECTSIZE the size of the largest possible object, including
> + * its header,
> + * LOGFS_SEGMENT_RESERVE is the amount of space reserved for each segment for
> + * its segment header and the padded space at the end when no further objects
> + * fit.
> + */
> +#define LOGFS_HEADERSIZE	(0x1c)
> +#define LOGFS_SEGMENT_HEADERSIZE (0x18)
> +#define LOGFS_MAX_OBJECTSIZE	(LOGFS_HEADERSIZE + LOGFS_BLOCKSIZE)
> +#define LOGFS_SEGMENT_RESERVE	(LOGFS_HEADERSIZE + LOGFS_MAX_OBJECTSIZE - 1)

The comment makes it sound like the last line should be

#define LOGFS_SEGMENT_RESERVE (LOGFS_SEGMENT_HEADERSIZE + LOGFS_MAX_OBJECTSIZE - 1)

> +/**
> + * struct logfs_disk_dentry - on-medium dentry structure
> + *
> + * @ino:			inode number
> + * @namelen:			length of file name
> + * @type:			file type, identical to bits 12..15 of mode
> + * @name:			file name
> + */
> +struct logfs_disk_dentry {
> +	__be64	ino;
> +	__be16	namelen;
> +	__u8	type;
> +	__u8	name[LOGFS_MAX_NAMELEN];
> +} __attribute__((packed));

With LOGFS_MAX_NAMELEN == 255, this data structure is not aligned to 64
bits, which means that accessing the inode number requires unaligned
memory accesses when you have an array of logfs_disk_dentry structures
on the medium. Is that intentional?

If you add another 32 bits here, you don't need the __packed any more.

> +/**
> + * struct logfs_object_header - per-object header in the ostore
> + *
> + * @crc:			crc32 of header, excluding data_crc
> + * @len:			length of data
> + * @type:			object type, see above
> + * @compr:			compression type
> + * @ino:			inode number
> + * @bix:			block index
> + * @data_crc:			crc32 of payload
> + */
> +struct logfs_object_header {
> +	__be32	crc;
> +	__be16	len;
> +	__u8	type;
> +	__u8	compr;
> +	__be64	ino;
> +	__be64	bix;
> +	__be32	data_crc;
> +} __attribute__((packed));

Similarly, this structure contains 8 byte members but has a smaller
size.

	Arnd <><
