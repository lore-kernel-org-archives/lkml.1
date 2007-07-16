Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbXGPBVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbXGPBVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 21:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXGPBVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 21:21:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42898 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbXGPBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 21:21:05 -0400
Date: Sun, 15 Jul 2007 18:23:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Subject: Re: [RFC PATCH 2/6] Driver Tracing Interface (DTI) code
Message-Id: <20070715182346.14e591c7.randy.dunlap@oracle.com>
In-Reply-To: <1183173834.24291.138.camel@ubuntu>
References: <1183173834.24291.138.camel@ubuntu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 22:23:53 -0500 Tom Zanussi wrote:

> The Driver Tracing Interface (DTI) code.
> 
> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  drivers/base/Kconfig           |   11 
>  drivers/base/Makefile          |    1 
>  drivers/base/dti.c             |  836 +++++++++++++++++++++++++++++++++++++++++
>  drivers/base/dti_merged_view.c |  332 ++++++++++++++++
>  include/linux/dti.h            |  293 ++++++++++++++
>  5 files changed, 1473 insertions(+)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 5d6312e..fbc9c0e 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -49,6 +49,17 @@ config DEBUG_DEVRES
>  
>  	  If you are unsure about this, Say N here.
>  
> +config DTI
> +	bool "Driver Tracing Interface (DTI)"
> +	select GTSC
> +	help
> +	Provides  functions to write variable length trace records
> +	into a wraparound memory trace buffer. One purpose of
> +	this is to inspect the debug traces after a system crash in order to
> +	analyze the reason for the failure. The traces are accessable from
> +	system dumps via dump analysis tools like crash or lcrash. In live
> +	systems the traces can be read via a debugfs interface.
> +

Indent help text by 2 spaces, i.e., tab + 2 spaces.

>  config SYS_HYPERVISOR
>  	bool
>  	default n

> diff --git a/drivers/base/dti.c b/drivers/base/dti.c
> new file mode 100644
> index 0000000..2feec11
> --- /dev/null
> +++ b/drivers/base/dti.c
> @@ -0,0 +1,836 @@
> +
> +extern int dti_create_merged_views(struct dti_info *dti);
> +extern void dti_remove_merged_views(struct dti_info *dti);

externs need to be in some header file.

> +struct file_operations level_fops;
> +

> +/**
> + * dti_register_level: create trace dir and level ctrl file

s/: / - / to be consistent with rest (or most) of kernel.  I.e.,
kernel-doc function format is

 * @func - short description

(throughout source file(s))
OK, the : is optional, but the - is needed.

> + *
> + * Internal - exported for setup macros.
> + */
> +struct dti_info *dti_register_level(const char *name, int level,
> +				    struct dti_handle *handle)
> +{
> +	return __dti_register_level(name, level, sub_size(handle->size),
> +				    nr_sub(handle->size), handle);
> +}
> +EXPORT_SYMBOL_GPL(dti_register_level);
> +

> diff --git a/drivers/base/dti_merged_view.c b/drivers/base/dti_merged_view.c
> new file mode 100644
> index 0000000..b3fee0f
> --- /dev/null
> +++ b/drivers/base/dti_merged_view.c
> @@ -0,0 +1,332 @@
> +
> +struct dti_merged_view_info {
> +	void *next_event; /* NULL if at end of buffer */
> +	struct timeval last_read;
> +	int cpu;
> +	unsigned long long bytes_left;
> +	void *buf;
> +        loff_t pos;

use tab above instead of spaces.

> +};
> +
> +struct dti_merged_view {
> +	void *current_header; /* header currently being read */
> +	ssize_t header_bytes_left;
> +	char header[80];
> +	void *current_event; /* record currently being read */
> +	ssize_t event_bytes_left;
> +	struct rchan *chan;
> +	int show_timestamps;
> +	struct dti_merged_view_info info[NR_CPUS]; /* per-cpu buffer info */
> +} __attribute__ ((packed));
> +
> +struct file_operations dti_merged_view_fops;
> +struct file_operations dti_merged_ts_view_fops;
> +
> +/**
> + * dti_create_merged_views:
> + * Creates merged view files in the trace's parent.

Short description needs to be on same line as function name.

> + *
> + * @trace: trace handle to create view of
> + *
> + * returns 0 on sucess.
> + */
> +int dti_create_merged_views(struct dti_info *dti)
> +{
> +	struct dentry *parent = dti->trace->dir;
> +
> +	dti->merged_view = debugfs_create_file("merged", 0, parent, dti,
> +					       &dti_merged_view_fops);
> +
> +	if (dti->merged_view == NULL ||
> +	    dti->merged_view == (struct dentry *)-ENODEV) 
> +		goto cleanup;
> +
> +	dti->merged_ts_view = debugfs_create_file("merged-ts",
> +						  0, parent, dti,
> +						  &dti_merged_ts_view_fops);
> +
> +	if (dti->merged_ts_view == NULL ||
> +	    dti->merged_ts_view == (struct dentry *)-ENODEV) 
> +		goto cleanup;
> +
> +	return 0;
> +cleanup:
> +	dti_remove_merged_views(dti);
> +
> +	return -ENOMEM;
> +}
> +
> +static int dti_merged_view_close(struct inode *inode, struct file *filp)
> +{
> +	int i;
> +	struct dti_merged_view *view = filp->private_data;
> +	
> +	for_each_possible_cpu(i)
> +                if (view->info[i].buf)
> +			free_page((unsigned long)view->info[i].buf);
> +        kfree(view);

use tab instead of spaces.

> +
> +	return 0;
> +}
> +

> +static void *next_smallest(int *smallest_cpu, struct dti_merged_view *view )
> +{
> +        int i;
> +        void *next, *smallest = NULL;

use tab instead of spaces....

> +
> +	for_each_possible_cpu(i) {
> +		if (!events_left(i, view))
> +			continue;
> +
> +                next = view->info[i].next_event;
> +                if (next) {
> +                        if (!smallest) {
> +                                smallest = next;
> +                                *smallest_cpu = i;
> +                                continue;
> +                        }
> +                        if (compare_recs(next, smallest) < 0) {
> +                                smallest = next;
> +                                *smallest_cpu = i;
> +                                continue;
> +                        }
> +                }
> +        }
> +
> +        return smallest;
> +}
> +

> diff --git a/include/linux/dti.h b/include/linux/dti.h
> new file mode 100644
> index 0000000..3206e6a
> --- /dev/null
> +++ b/include/linux/dti.h
> @@ -0,0 +1,293 @@
> +#ifndef _LINUX_DTI_H
> +#define _LINUX_DTI_H
> +
> +/*
> + * autoregistering channel handle
> + */
> +struct dti_handle {
> +	char *name;
> +	int size;
> +	int initlevel;
> +	struct dti_info *info;
> +	spinlock_t lock;
> +	int registered;
> +	struct delayed_work work;
> +        void *initbuf;

use tab... (more below)  use checkpatch.pl  :)

> +	unsigned int initbuf_size;
> +        unsigned int initbuf_offset;
> +	unsigned int initbuf_wrapped;
> +	unsigned int initbuf_pad[2];
> +
> +	int (*printk) (struct dti_handle *handle,
> +		       int prio,
> +		       const char *fmt,
> +		       va_list args);
> +	int (*event) (struct dti_handle *handle,
> +		      int prio,
> +		      const void* buf,
> +		      size_t len);
> +	void *(*reserve) (struct dti_handle *handle,
> +			  int prio,
> +			  size_t len);
> +};

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
