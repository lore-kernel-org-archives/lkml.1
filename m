Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYE2Ddo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYE2Ddo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYE2Ddd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:33:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35481 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbYE2Ddc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:33:32 -0400
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080528012242.a0e98d87.akpm@linux-foundation.org>
References: <1211555145.16195.18.camel@new-host>
	 <20080528012242.a0e98d87.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 23:33:28 -0400
Message-Id: <1212032008.4747.65.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-28 at 01:22 -0700, Andrew Morton wrote:

> 	+/**
> 	+ * ima_must_measure - measure decision based on policy.
> 	+ * @d - pointer to struct ima_data containing ima_args_data
> 
>   So if we know the type of d, did we _have_ to make it void*?  It's
>   much better to use the C yype system if at all possible.

This is one of the five integrity API calls.  Each integrity template 
will define it differently, using a different data structure. 

> - ditto ima_collect_measurement()

ima_collect_measurement is also one of the five integrity API calls.

Here is a sample template kernel module that measures kernel memory.
Of the five integrity API calls, it implements 
integrity_collect_measurement(), integrity_store_measurement(), and
integrity_display_measurement(). It collects and stores measurements
based on data read from security/kmem-template. The format is 
"name length address".  The name can be any string identifier such as
"proc_root"; the length is the number of bytes to measure; and address
is a kernel memory address, which can be looked up in /proc/kallsyms.
One caveat, the sample program currently does not validate the address.  
A userspace application triggers the measurement by writing to 
security/kmem-template.

/* 
 * Copyright (C) 2008 IBM Corporation
 * Author: Mimi Zohar <zohar@us.ibm.com>
 *
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License as published by
 *      the Free Software Foundation, version 2 of the License.
 *
 * kmem-template.c
 * 	- defines a kernel memory template
 * 	- reads from security/kmem-template "name length address"
 * 	- collects and stores measurement from address for length bytes
 */

#include <asm/uaccess.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/crypto.h>
#include <linux/scatterlist.h>
#include <linux/notifier.h>
#include <linux/security.h>
#include <linux/debugfs.h>
#include <linux/seq_file.h>
#include <linux/string.h>
#include <linux/proc_fs.h>
#include <linux/security.h>
#include <linux/integrity.h>
#include <linux/ima.h>

#define MY_NAME THIS_MODULE->name
#define IMA_DIGEST_SIZE		20

static int __init init_kmem_template(void);
static void __exit cleanup_kmem_template(void);

struct kmem_data {
	char name[25];
	char *buf;
	int buflen;
	u8 digest[IMA_DIGEST_SIZE];
};

static void hexdump(unsigned char *buf, unsigned int len)
{
	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
			16, 1,
			buf, len, false);
}

int calc_hash(int buflen, char *buf, char *digest)
{
	struct crypto_hash *tfm;
	struct hash_desc desc;
	struct scatterlist sg[1];
	int error, result = 0;

	tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
	if (IS_ERR(tfm)) {
		printk(KERN_INFO "%s: failed to load %s transform: %ld\n",
		       __func__, "sha1", PTR_ERR(tfm));
		return -ENOSYS;
	}
	desc.tfm = tfm;
	desc.flags = 0;
	error = crypto_hash_init(&desc);
	if (error) {
		result = -EINVAL;
		goto out;
	}

	sg_set_buf(sg, buf, buflen);
	result = crypto_hash_update(&desc, sg, buflen);
	if (!result) {
		error = crypto_hash_final(&desc, digest);
		if (error)
			result = -EINVAL;
	}

out:
	crypto_free_hash(tfm);
	return result;
}

static int kmem_collect_measurement(void *d)
{
	struct kmem_data *data = (struct kmem_data *)d;

	memset(data->digest, 0, sizeof data->digest);
	calc_hash(data->buflen, data->buf, data->digest);
	hexdump(data->buf, data->buflen);
	return 0;
}

/* Transform local kmem data to store data */
void kmem_store_measurement(void *d)
{
	struct kmem_data *data = (struct kmem_data *)d;
	struct ima_data idata;
	struct ima_store_data *template = &idata.data.template;

	idata.type = IMA_TEMPLATE;
	template->name = "kmem"; 
	template->len = sizeof *data;
	template->data = (char *)data;
	template->violation = 0;
	integrity_store_measurement("ima", (void *)&idata);
	return;
}

static void kmem_template_show(struct seq_file *m, void *e, 
				     enum integrity_show_type show)
{
	struct kmem_data *data = (struct kmem_data *)e;
	int filename_len;
	char len[4];
	int i;

	for (i = 0; i < 20; i++) {
		switch (show) {
		case INTEGRITY_SHOW_ASCII:
			seq_printf(m, "%02x", data->digest[i]);
			break;
		case INTEGRITY_SHOW_BINARY:
			seq_putc(m, data->digest[i]);
		default:
			break;
		}
	}

	switch (show) {
	case INTEGRITY_SHOW_ASCII:
		seq_printf(m, " %s %d \n", data->name, data->buflen);
		break;
	case INTEGRITY_SHOW_BINARY:
		filename_len = strlen(data->name);
		memcpy(len, &filename_len, 4);
		for (i = 0; i < 4; i++)
			seq_putc(m, len[i]);
		for (i = 0; i < strlen(data->name); i++)
			seq_putc(m, data->name[i]);
	default:
		break;
	}
}

static struct template_operations kmem_ops = {
	.collect_measurement = kmem_collect_measurement,
	.store_measurement = kmem_store_measurement,
	.display_template = kmem_template_show
};

static int kmem_add_measure(char *name, unsigned int buflen, 
				unsigned int addr)
{
	struct kmem_data data;
	int rc;
	
	strncpy(data.name, name, sizeof data.name);
	data.buflen = buflen;
	data.buf = (char *)addr;
	rc = integrity_collect_measurement("kmem", &data);
	if (!rc) 
		integrity_store_measurement("kmem", &data);
	return rc;
}	

static ssize_t kmem_write_template(struct file *file, const char __user *buf,
				size_t buflen, loff_t *ppos)
{
	char *data;
	char name[26];
	size_t result = 0, datalen;
	int rc;
	unsigned int addr, len;

	datalen = buflen > 256 ? 256 : buflen;
	data = kzalloc(datalen + 1, GFP_KERNEL);
	if (!data)
		result = -ENOMEM;

	if (copy_from_user(data, buf, datalen)) {
		result = -EFAULT;
		goto out;
	}

	result = datalen;

	rc = sscanf(data, "%25s %d %x ", name, &len, &addr);
	if (rc == 3) 
		kmem_add_measure(name, len, addr);
	else {
		printk(KERN_INFO "%s: rc = %d\n", __func__, rc);
		result = -EINVAL;
	}
out:
	if (!data)
		kfree(data);
	return result;
}

static struct file_operations kmem_template_ops = {
	.write = kmem_write_template
};

static struct dentry *kmem_template;

static int __init init_kmem_template(void)
{

	printk(KERN_INFO "%s: \n", __func__);
	register_template("kmem", &kmem_ops);

	kmem_template = securityfs_create_file("kmem-template",
					   S_IRUSR | S_IRGRP | S_IWUSR,
					   NULL, NULL, &kmem_template_ops);
	return 0;
}

static void __exit cleanup_kmem_template(void)
{
	printk(KERN_INFO "%s\n", __FUNCTION__);
	unregister_template("kmem");

	securityfs_remove(kmem_template);
}
module_init(init_kmem_template);
module_exit(cleanup_kmem_template);

MODULE_LICENSE("GPL");

