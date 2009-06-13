Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbZFMOCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbZFMOCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZFMOCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:02:42 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:32920 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZFMOCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:02:41 -0400
Date: Sat, 13 Jun 2009 16:04:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Message-ID: <20090613140459.GC30053@uranus.ravnborg.org>
References: <4A33A7EC.6070008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A33A7EC.6070008@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 03:21:48PM +0200, Marco wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Include files.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 
> diff -uprN linux-2.6.30-orig/fs/pramfs/pram_fs.h linux-2.6.30/fs/pramfs/pram_fs.h
> --- linux-2.6.30-orig/fs/pramfs/pram_fs.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.30/fs/pramfs/pram_fs.h	2009-06-13 12:58:49.000000000 +0200
> @@ -0,0 +1,388 @@
> +/*
> + * FILE NAME include/linux/pram_fs.h
> + *
> + * BRIEF DESCRIPTION
> + *
> + * Definitions for the PRAMFS filesystem.
> + *
> + * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
> + * Copyright 2003 Sony Corporation
> + * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
> + * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +#ifndef _LINUX_PRAM_FS_H
> +#define _LINUX_PRAM_FS_H
> +
> +#include <linux/types.h>
> +
> +#ifdef __KERNEL__
> +#include <linux/sched.h>
> +#include <linux/buffer_head.h>
> +#include "pram_fs_sb.h"
> +#endif

The only reason to have this header file in include/linux/
is that it is used by userspace.
So please split it up so we have one header suitable for exporting
and another header with all the promfs local stuff.
The latter should be in fs/pramsfs/


> +
> +/*
> + * The PRAM filesystem constants/structures
> + */
> +
> +/*
> + * Define PRAMFS_DEBUG to produce debug messages
> + */
> +#define PRAMFS_DEBUG
> +
> +/*
> + * Debug code
> + */
> +#ifdef __KERNEL__
> +#define PFX "pramfs"
> +#ifdef PRAMFS_DEBUG
> +#define pram_dbg(format, arg...) \
> +    printk(KERN_DEBUG PFX ": " format , ## arg)
> +#else
> +#define pram_dbg(format, arg...) do {} while (0)
> +#endif
> +#define pram_err(format, arg...) \
> +    printk(KERN_ERR PFX ": " format , ## arg)
> +#define pram_info(format, arg...) \
> +    printk(KERN_INFO PFX ": " format , ## arg)
> +#define pram_warn(format, arg...) \
> +    printk(KERN_WARNING PFX ": " format , ## arg)
> +#endif

For a typical drivers we have some pr_* to avoid the above.
Can they be used for a filesystem too?

> +
> +/*
> + * The PRAM file system magic number
> + */
> +#define PRAM_SUPER_MAGIC	0xEFFA

Move to include/linux/magic.h

> +
> +/*
> + * Structure of an inode in PRAMFS
> + */
> +struct pram_inode {
> +	__u32   i_sum;          /* checksum of this inode */
> +	__u32	i_uid;		/* Owner Uid */
> +	__u32	i_gid;		/* Group Id */
> +	__u16	i_mode;		/* File mode */
> +	__u16	i_links_count;	/* Links count */
> +	__u32	i_blocks;	/* Blocks count */
> +	__u32	i_size;		/* Size of data in bytes */
> +	__u32	i_atime;	/* Access time */
> +	__u32	i_ctime;	/* Creation time */
> +	__u32	i_mtime;	/* Modification time */
> +	__u32	i_dtime;	/* Deletion Time */
> +
> +	union {
> +		struct {
> +			/*
> +			 * ptr to row block of 2D block pointer array,
> +			 * file block #'s 0 to (blocksize/4)^2 - 1.
> +			 */
> +			off_t row_block;

It is my understanding that we shall use: __kernel_off_t
in exported headers.

The headers are not added to Kbuild - so it is not exported.
I assume thats an oversight.

	Sam
