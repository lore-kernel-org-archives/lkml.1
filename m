Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYICMjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYICMjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYICMjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:39:09 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:52872 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbYICMjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:39:08 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 08:39:07 EDT
X-IronPort-AV: E=Sophos;i="4.32,320,1217800800"; 
   d="scan'208";a="14525672"
Message-ID: <48BE8315.6030907@irisa.fr>
Date: Wed, 03 Sep 2008 14:29:09 +0200
From: =?UTF-8?B?TWF0dGhpZXUgRmVydHLDqQ==?= <Matthieu.Fertre@irisa.fr>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 3/9] Introduce context structure needed during	checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<1220439476-16465-2-git-send-email-major@openvz.org>	<1220439476-16465-3-git-send-email-major@openvz.org> <1220439476-16465-4-git-send-email-major@openvz.org>
In-Reply-To: <1220439476-16465-4-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Mirkin a écrit :
> Add functions for context allocation/destroy.
> Introduce functions to read/write image.
> Introduce image header and object header.
>
> Signed-off-by: Andrey Mirkin <major@openvz.org>
> ---
>  cpt/cpt.h       |   37 ++++++++++++++++
>  cpt/cpt_image.h |   63 +++++++++++++++++++++++++++
>  cpt/sys.c       |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 224 insertions(+), 3 deletions(-)
>  create mode 100644 cpt/cpt_image.h
>
> diff --git a/cpt/cpt.h b/cpt/cpt.h
> index 381a9bf..607ac1b 100644
> --- a/cpt/cpt.h
> +++ b/cpt/cpt.h
> @@ -10,6 +10,8 @@
>   *
>   */
>  
> +#include "cpt_image.h"
> +
>  struct cpt_operations
>  {
>  	struct module * owner;
> @@ -17,3 +19,38 @@ struct cpt_operations
>  	int (*restart)(int ctid, int fd, unsigned long flags);
>  };
>  extern struct cpt_operations cpt_ops;
> +
> +#define CPT_CTX_ERROR           -1
> +#define CPT_CTX_IDLE            0
> +#define CPT_CTX_DUMPING         1
> +#define CPT_CTX_UNDUMPING       2
>   

Maybe you can define an enum here instead.


> +
> +typedef struct cpt_context
> +{
> +	pid_t		pid;		/* should be changed to ctid later */
> +	int		ctx_id;		/* context id */
> +	struct list_head ctx_list;
> +	int		refcount;
> +	int		ctx_state;
>   

It will be more clear that ctx_state refers to it.

Thanks,

Matthieu


> +	struct semaphore main_sem;
> +
> +	int		errno;
> +
> +	struct file	*file;
> +	loff_t		current_object;
> +
> +	struct list_head object_array[CPT_OBJ_MAX];
> +
> +	int		(*write)(const void *addr, size_t count, struct cpt_context *ctx);
> +	int		(*read)(void *addr, size_t count, struct cpt_context *ctx);
> +} cpt_context_t;
> +
> +extern int debug_level;
> +
> +#define cpt_printk(lvl, fmt, args...)	do {	\
> +		if (lvl <= debug_level)		\
> +			printk(fmt, ##args);	\
> +	} while (0)
> +
> +#define eprintk(a...) cpt_printk(1, "CPT ERR: " a)
> +#define dprintk(a...) cpt_printk(1, "CPT DBG: " a)
> diff --git a/cpt/cpt_image.h b/cpt/cpt_image.h
> new file mode 100644
> index 0000000..3d26229
> --- /dev/null
> +++ b/cpt/cpt_image.h
> @@ -0,0 +1,63 @@
> +/*
> + *  Copyright (C) 2008 Parallels, Inc.
> + *
> + *  Author: Andrey Mirkin <major@openvz.org>
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License as
> + *  published by the Free Software Foundation, version 2 of the
> + *  License.
> + *
> + */
> +
> +#ifndef __CPT_IMAGE_H_
> +#define __CPT_IMAGE_H_ 1
> +
> +enum _cpt_object_type
> +{
> +	CPT_OBJ_TASK = 0,
> +	CPT_OBJ_MAX,
> +	/* The objects above are stored in memory while checkpointing */
> +
> +	CPT_OBJ_HEAD = 1024,
> +};
> +
> +enum _cpt_content_type {
> +	CPT_CONTENT_VOID,
> +	CPT_CONTENT_ARRAY,
> +	CPT_CONTENT_DATA,
> +	CPT_CONTENT_NAME,
> +	CPT_CONTENT_REF,
> +	CPT_CONTENT_MAX
> +};
> +
> +#define CPT_SIGNATURE0 0x79
> +#define CPT_SIGNATURE1 0x1c
> +#define CPT_SIGNATURE2 0x01
> +#define CPT_SIGNATURE3 0x63
> +
> +struct cpt_head
> +{
> +	__u8	cpt_signature[4];	/* Magic number */
> +	__u32	cpt_hdrlen;		/* Header length */
> +	__u16	cpt_image_major;	/* Format of this file */
> +	__u16	cpt_image_minor;	/* Format of this file */
> +	__u16	cpt_image_sublevel;	/* Format of this file */
> +	__u16	cpt_image_extra;	/* Format of this file */
> +	__u16	cpt_arch;		/* Architecture */
> +	__u16	cpt_pad1;
> +	__u32	cpt_pad2;
> +#define CPT_ARCH_I386		0
> +	__u64	cpt_time;		/* Time */
> +} __attribute__ ((aligned (8)));
> +
> +/* Common object header. */
> +struct cpt_object_hdr
> +{
> +	__u64	cpt_len;		/* Size of current chunk of data */
> +	__u16	cpt_type;		/* Type of object */
> +	__u32	cpt_hdrlen;		/* Size of header */
> +	__u16	cpt_content;		/* Content type: array, reference... */
> +} __attribute__ ((aligned (8)));
> +
> +#endif /* __CPT_IMAGE_H_ */
> diff --git a/cpt/sys.c b/cpt/sys.c
> index 4051286..8334c4c 100644
> --- a/cpt/sys.c
> +++ b/cpt/sys.c
> @@ -13,21 +13,142 @@
>  #include <linux/sched.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
> -#include <linux/notifier.h>
> +#include <linux/uaccess.h>
>  #include <linux/module.h>
>  
>  #include "cpt.h"
> +#include "cpt_image.h"
>  
>  MODULE_LICENSE("GPL");
>  
> +/* Debug level, constant for now */
> +int debug_level = 1;
> +
> +static int file_write(const void *addr, size_t count, struct cpt_context *ctx)
> +{
> +	mm_segment_t oldfs;
> +	ssize_t err = -EBADF;
> +	struct file *file = ctx->file;
> +
> +	oldfs = get_fs(); set_fs(KERNEL_DS);
> +	if (file)
> +		err = file->f_op->write(file, addr, count, &file->f_pos);
> +	set_fs(oldfs);
> +	if (err != count)
> +		return err >= 0 ? -EIO : err;
> +	return 0;
> +}
> +
> +static int file_read(void *addr, size_t count, struct cpt_context *ctx)
> +{
> +	mm_segment_t oldfs;
> +	ssize_t err = -EBADF;
> +	struct file *file = ctx->file;
> +
> +	oldfs = get_fs(); set_fs(KERNEL_DS);
> +	if (file)
> +		err = file->f_op->read(file, addr, count, &file->f_pos);
> +	set_fs(oldfs);
> +	if (err != count)
> +		return err >= 0 ? -EIO : err;
> +	return 0;
> +}
> +
> +struct cpt_context * context_alloc(void)
> +{
> +	struct cpt_context *ctx;
> +	int i;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return NULL;
> +
> +	init_MUTEX(&ctx->main_sem);
> +	ctx->refcount = 1;
> +
> +	ctx->current_object = -1;
> +	ctx->write = file_write;
> +	ctx->read = file_read;
> +	for (i = 0; i < CPT_OBJ_MAX; i++) {
> +		INIT_LIST_HEAD(&ctx->object_array[i]);
> +	}
> +
> +	return ctx;
> +}
> +
> +void context_release(struct cpt_context *ctx)
> +{
> +	ctx->ctx_state = CPT_CTX_ERROR;
> +
> +	if (ctx->file)
> +		fput(ctx->file);
> +	kfree(ctx);
> +}
> +
> +static void context_put(struct cpt_context *ctx)
> +{
> +	if (!--ctx->refcount)
> +		context_release(ctx);
> +}
> +
>  static int checkpoint(pid_t pid, int fd, unsigned long flags)
>  {
> -	return -ENOSYS; 
> +	struct file *file;
> +	struct cpt_context *ctx;
> +	int err;
> +
> +	err = -EBADF;
> +	file = fget(fd);
> +	if (!file)
> +		goto out;
> +
> +	err = -ENOMEM;
> +	ctx = context_alloc();
> +	if (!ctx)
> +		goto out_file;
> +
> +	ctx->file = file;
> +	ctx->ctx_state = CPT_CTX_DUMPING;
> +
> +	/* checkpoint */
> +	err = -ENOSYS;
> +
> +	context_put(ctx);
> +
> +out_file:
> +	fput(file);
> +out:
> +	return err; 
>  }
>  
>  static int restart(int ctid, int fd, unsigned long flags)
>  {
> -	return -ENOSYS; 
> +	struct file *file;
> +	struct cpt_context *ctx;
> +	int err;
> +
> +	err = -EBADF;
> +	file = fget(fd);
> +	if (!file)
> +		goto out;
> +
> +	err = -ENOMEM;
> +	ctx = context_alloc();
> +	if (!ctx)
> +		goto out_file;
> +
> +	ctx->file = file;
> +	ctx->ctx_state = CPT_CTX_UNDUMPING;
> +
> +	/* restart */
> +	err = -ENOSYS;
> +
> +	context_put(ctx);
> +
> +out_file:
> +	fput(file);
> +out:
> +	return err; 
>  }
>  
>  static int __init init_cptrst(void)
>   


-- 
Matthieu Fertré

IRISA, Campus universitaire de Beaulieu - 35 042 Rennes, France
tel: +33 2 99 84 22 74
fax: +33 2 99 84 71 71
mail: mfertre@irisa.fr

