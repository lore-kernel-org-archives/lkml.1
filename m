Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXCUIWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXCUIWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXCUIWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:22:53 -0400
Received: from saeurebad.de ([85.214.36.134]:35051 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXCUIWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:22:52 -0400
Date: Wed, 21 Mar 2007 09:22:39 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Wink Saville <wink@saville.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Initial implementation of the trec driver and include files
Message-ID: <20070321082238.GA16768@leiferikson>
Mail-Followup-To: Wink Saville <wink@saville.com>,
	linux-kernel@vger.kernel.org
References: <d4cf37a60703202347o67740694jc1c9030c647ff7c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4cf37a60703202347o67740694jc1c9030c647ff7c6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 20, 2007 at 11:47:35PM -0700, Wink Saville wrote:
> --- /dev/null
> +++ b/drivers/trec/trec.c
> [...]
> +struct trec_dev_struct
> +{
> +	struct	cdev		cdev;			/* Character device 
> structure */

Your patch has broken lines where there shouldn't be any.

> +#define TREC_DATA_SIZE 0x200
> +struct trec_buffer_struct {
> +	struct trec_buffer_struct *	pNext;
> +	struct trec_struct *		pCur;
> +	struct trec_struct *		pEnd;
> +	struct trec_struct		data[TREC_DATA_SIZE];
> +};

Please don't use camel-case - in general.

> +static int snprint_address(char *b, int bsize, unsigned long address)
> +{
> +#ifdef CONFIG_KALLSYMS
> +	unsigned long offset = 0, symsize;
> +	const char *symname;
> +	char *modname;
> +	char *delim = ":";
> +	int n;
> +	char namebuf[128];
> +
> +	symname = kallsyms_lookup(address, &symsize, &offset, &modname, 
> namebuf);
> +	if (!symname) {
> +		n = 0;
> +	} else {
> +		if (!modname)
> +			modname = delim = ""; 		
> +		n = snprintf(b, bsize, "0x%016lx %s%s%s%s+0x%lx/0x%lx",
> +			address, delim, modname, delim, symname, offset, 
> symsize);
> +	}
> +	return n;
> +#else
> +	return snprintf(b, bsize, "0x%016lx", address);
> +	return 0;
> +#endif
> +}

Would it make sense to #ifdef the whole function?
Make it static int (*)(...) if CONFIG_KALLSYMS and otherwise just a
static inline int (*)(...) { return 0; }

> [...]
> +static int trec_device_init(void)
> +{
> +	int 		result;
> +	dev_t 		dev_number = 0;
> +	static struct 	class *trec_class;
> +
> +	DPK("trec_device_init: E\n");
> +
> +	if (major) {
> +		dev_number = MKDEV(major, minor);
> +		result = register_chrdev_region(dev_number, 1, "trec");
> +		DPK("trec_device_init: static major result=%d\n", result);
> +	} else {
> +		result = alloc_chrdev_region(&dev_number, minor, 1, "trec");
> +		major = MAJOR(dev_number);
> +		DPK("trec_device_init: dynamic major result=%d\n", result);
> +	}	
> +
> +	if (result < 0) {
> +		printk(KERN_WARNING "trec: can't get major %d\n", major);
> +		goto done;
> +	}
> +
> +	cdev_init(&trec_dev.cdev, &trec_f_ops);
> +	trec_dev.cdev.owner = THIS_MODULE;
> +	trec_dev.cdev.ops = &trec_f_ops;
> +	
> +	result = cdev_add(&trec_dev.cdev, dev_number, 1);
> +	if (result)
> +	{
> +		DPK("trec_device_init: cdev_add failed\n");
> +		goto done;

If you jump to `done' here, unregister_chrdev_region is never called.

You should also declare trec_device_init as __init and trex_device_exit
as __exit.

> --- /dev/null
> +++ b/include/linux/trec.h
> @@ -0,0 +1,34 @@
> +/*
> + * Copyright (C) 2007 Saville Software, Inc.
> + *
> + * This code may be used for any purpose whatsoever, but
> + * no warranty of any kind is provided.
> + */
> +
> +#ifndef _TREC_H
> +#define _TREC_H
> +
> +#include <linux/sched.h>	/* For current->pid */
> +#include <asm/processor.h>	/* For current_text_addr */
> +
> +#define TREC_PC_ADDR		((unsigned long)(current_text_addr()))
> +#define TREC_PID		(current->pid)
> +
> +#define TREC0()			trec_write(TREC_PC_ADDR, TREC_PID, 
> 0, 0)
> +#define TREC1(__v)		trec_write(TREC_PC_ADDR, TREC_PID, (unsigned 
> long)(__v), 0)
> +#define TREC2(__v1, __v2)	trec_write(TREC_PC_ADDR, TREC_PID,
> (unsigned long)(__v1), (unsigned long)(__v2))
> +#define TREC_RETV(__retv) 	do { TREC0(); return(__retv); } while (0)
> +#define TREC_RET() 		do { TREC0(); return; } while (0)
> +
> +#define ZREC0()			do { } while (0)
> +#define ZREC1(__v)		do { } while (0)
> +#define ZREC2(__v1, __v2)	do { } while (0)
> +#define ZREC_RETV(__retv) 	do { } while (0)
> +#define ZREC_RET() 		do { } while (0)

Why not seperate them by an #ifndef? So you don't have to replace TREC?
with ZREC? but rather change one #define knob.

=Hannes
