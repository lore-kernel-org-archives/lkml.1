Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYIQXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYIQXGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 19:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYIQXGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 19:06:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbYIQXF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:05:59 -0400
Date: Wed, 17 Sep 2008 16:00:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, bernhard.weirich@riedel.net
Subject: Re: [1/1] w1: new driver. DS2431 chip.
Message-Id: <20080917160007.1fc58f28.akpm@linux-foundation.org>
In-Reply-To: <20080917154928.GB490@2ka.mipt.ru>
References: <20080917154928.GB490@2ka.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 19:49:29 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Signed-off-by: Bernhard Weirich <bernhard.weirich@riedel.net>
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

This was authored by Bernhard, but the way in which it was sent claims
that it was authored by yourself.  Please add a From: line at the very
top of the changelog body to indicate authorship.

> --- linux-2.6.26.1/drivers/w1/w1_family.h	2008-07-18 14:51:32.000000000 +0200
> +++ linux-2.6.26.5/drivers/w1/w1_family.h	2008-09-16 11:48:30.000000000 +0200
> @@ -33,6 +33,7 @@
>  #define W1_THERM_DS1822  	0x22
>  #define W1_EEPROM_DS2433  	0x23
>  #define W1_THERM_DS18B20 	0x28
> +#define W1_EEPROM_DS2431	0x2D
>  #define W1_FAMILY_DS2760	0x30
>  
>  #define MAXNAMELEN		32
> --- linux-2.6.25.3/drivers/w1/slaves/w1_ds2431.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.26.5/drivers/w1/slaves/w1_ds2431.c	2008-09-17 09:02:13.000000000 +0200
> @@ -0,0 +1,318 @@
> +/*
> + *	w1_DS2431.c - w1 family 2d (DS2431) driver

case-insensitive filenames? ;)

> + * Copyright (c) 2008 Bernhard Weirich <bernhard.weirich@riedel.net>
> + *
> + * Heavily inspired by w1_DS2433 driver from Ben Gardner <bgardner@wabtec.com>
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2. See the file COPYING for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/device.h>
> +#include <linux/types.h>
> +#include <linux/delay.h>
> +
> +#include "../w1.h"
> +#include "../w1_int.h"
> +#include "../w1_family.h"
> +
> +#define W1_F2D_EEPROM_SIZE		128
> +#define W1_F2D_PAGE_COUNT		4
> +#define W1_F2D_PAGE_BITS		5
> +#define W1_F2D_PAGE_SIZE		(1<<W1_F2D_PAGE_BITS)
> +#define W1_F2D_PAGE_MASK		0x1F
> +
> +#define W1_F2D_SCRATCH_BITS  3
> +#define W1_F2D_SCRATCH_SIZE  (1<<W1_F2D_SCRATCH_BITS)
> +#define W1_F2D_SCRATCH_MASK  (W1_F2D_SCRATCH_SIZE-1)
> +
> +#define W1_F2D_READ_EEPROM	0xF0
> +#define W1_F2D_WRITE_SCRATCH	0x0F
> +#define W1_F2D_READ_SCRATCH	0xAA
> +#define W1_F2D_COPY_SCRATCH	0x55
> +
> +
> +#define W1_F2D_TPROG_MS		11
> +
> +#define W1_F2D_READ_RETRIES		10
> +#define W1_F2D_READ_MAXLEN		8
> +
> +/**
> + * Check the file size bounds and adjusts count as needed.
> + * This would not be needed if the file size didn't reset to 0 after a write.
> + */

The driver has a number of comments whcih start with /**.  But that
pattern is specifically used to flag the presence of a kerneldoc-format
comment.  And these comments are in fact not in kerneldoc form.

> +/**
> + * Writes to the scratchpad and reads it back for verification.
> + * Then copies the scratchpad to EEPROM.
> + * The data must be aligned at W1_F2D_SCRATCH_SIZE bytes and
> + * must be W1_F2D_SCRATCH_SIZE bytes long.
> + * The master must be locked.
> + *
> + * @param sl	The slave structure
> + * @param addr	Address for the write
> + * @param len   length must be <= (W1_F2D_PAGE_SIZE - (addr & W1_F2D_PAGE_MASK))
> + * @param data	The data to write
> + * @return	0=Success -1=failure
> + */

This one looks a bit kerneldoc-like but actually isn't kerneldoc.


little fixes:

--- a/drivers/w1/slaves/w1_ds2431.c~w1-new-driver-ds2431-chip-fix
+++ a/drivers/w1/slaves/w1_ds2431.c
@@ -1,5 +1,5 @@
 /*
- *	w1_DS2431.c - w1 family 2d (DS2431) driver
+ * w1_ds2431.c - w1 family 2d (DS2431) driver
  *
  * Copyright (c) 2008 Bernhard Weirich <bernhard.weirich@riedel.net>
  *
@@ -41,7 +41,7 @@
 #define W1_F2D_READ_RETRIES		10
 #define W1_F2D_READ_MAXLEN		8
 
-/**
+/*
  * Check the file size bounds and adjusts count as needed.
  * This would not be needed if the file size didn't reset to 0 after a write.
  */
@@ -56,7 +56,7 @@ static inline size_t w1_f2d_fix_count(lo
 	return count;
 }
 
-/**
+/*
  * Read a block from W1 ROM two times and compares the results.
  * If they are equal they are returned, otherwise the read
  * is repeated W1_F2D_READ_RETRIES times.
@@ -88,8 +88,6 @@ static int w1_f2d_readblock(struct w1_sl
 
 		if (!memcmp(cmp, buf, count))
 			return 0;
-
-
 	} while (--tries);
 
 	dev_err(&sl->dev, "proof reading failed %d times\n",
@@ -98,7 +96,6 @@ static int w1_f2d_readblock(struct w1_sl
 	return -1;
 }
 
-
 static ssize_t w1_f2d_read_bin(struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
@@ -134,7 +131,7 @@ static ssize_t w1_f2d_read_bin(struct ko
 	return count;
 }
 
-/**
+/*
  * Writes to the scratchpad and reads it back for verification.
  * Then copies the scratchpad to EEPROM.
  * The data must be aligned at W1_F2D_SCRATCH_SIZE bytes and
@@ -279,10 +276,7 @@ static struct bin_attribute w1_f2d_bin_a
 
 static int w1_f2d_add_slave(struct w1_slave *sl)
 {
-	int err;
-	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f2d_bin_attr);
-
-	return err;
+	return sysfs_create_bin_file(&sl->dev.kobj, &w1_f2d_bin_attr);
 }
 
 static void w1_f2d_remove_slave(struct w1_slave *sl)

