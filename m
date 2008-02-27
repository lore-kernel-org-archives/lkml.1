Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYB0Sjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYB0Sjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYB0Sjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:39:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49482 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbYB0Sjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:39:39 -0500
Date: Wed, 27 Feb 2008 10:37:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC, BAD IDEA] /proc/tty/console
Message-Id: <20080227103730.761c35d4.randy.dunlap@oracle.com>
In-Reply-To: <20080227181857.GA3137@nostromo.devel.redhat.com>
References: <20080227181857.GA3137@nostromo.devel.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 13:18:57 -0500 Bill Nottingham wrote:

> I'm not seriously proposing this. But, as far as I can tell, this
> information isn't exposed to userspace anywhere, and it's a useful
> thing to know. I'm certainly open for better ideas on how to expose
> this (sysfs attributes? other?)
> 
> ....
> 
> The attached patch adds /proc/tty/console. The contents of it are
> simply a description of the current drivers attached to /dev/console.
> For example, a boot with 'console=ttyS3,115200n1 console=tty0' would
> yield:
> 
> # cat /proc/tty/console
> unknown             /dev/tty0
> serial              /dev/ttyS3
> 

So it omits other consoles (non-tty) intentionally?
or does it include them even though the procfs filename contains "tty"?

Anyway, I'd like to see something like this.
Compare http://www.xenotime.net/linux/patches/consoles-list.patch
(April-2006).


> 
> ---
> diff -ru linux-2.6.24.noarch/fs/proc/proc_tty.c linux/fs/proc/proc_tty.c
> --- linux-2.6.24.noarch/fs/proc/proc_tty.c	2008-02-27 12:50:59.000000000 -0500
> +++ linux/fs/proc/proc_tty.c	2008-02-27 12:25:54.000000000 -0500
> @@ -6,6 +6,7 @@
>  
>  #include <asm/uaccess.h>
>  
> +#include <linux/console.h>
>  #include <linux/init.h>
>  #include <linux/errno.h>
>  #include <linux/time.h>
> @@ -129,6 +130,38 @@
>  	return seq_open(file, &tty_drivers_op);
>  }
>  
> +static int show_tty_console(struct seq_file *m, void *v)
> +{
> +	int index;
> +	struct console *c;
> +
> +	for (c = console_drivers; c ; c = c->next) {
> +		struct tty_driver *t = NULL;
> +		if (!c->device)
> +			continue;
> +		t = c->device(c, &index);
> +		seq_printf(m, "%-20s", t->driver_name ? t->driver_name : "unknown");
> +		seq_printf(m, "/dev/%s%d", t->name, c->index);
> +		seq_printf(m, "\n");
> +	}
> +	return 0;
> +}
> +
> +static void *c_start(struct seq_file *m, loff_t *pos)
> +{
> +	return *pos == 0 ? &c_start : NULL;
> +}
> +
> +static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	++*pos;
> +	return c_start(m, pos);
> +}
> +
> +static void c_stop(struct seq_file *m, void *v)
> +{
> +}
> +
>  static const struct file_operations proc_tty_drivers_operations = {
>  	.open		= tty_drivers_open,
>  	.read		= seq_read,
> @@ -136,6 +169,25 @@
>  	.release	= seq_release,
>  };
>  
> +static const struct seq_operations tty_console_op = {
> +	.start		= c_start,
> +	.next		= c_next,
> +	.stop		= c_stop,
> +	.show		= show_tty_console
> +};
> +
> +static int tty_console_open(struct inode *inode, struct file *file)
> +{
> +	return seq_open(file, &tty_console_op);
> +}
> +
> +static const struct file_operations proc_tty_console_operations = {
> +	.open		= tty_console_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release
> +};
> +
>  /*
>   * This is the handler for /proc/tty/ldiscs
>   */
> @@ -230,4 +282,7 @@
>  	entry = create_proc_entry("tty/drivers", 0, NULL);
>  	if (entry)
>  		entry->proc_fops = &proc_tty_drivers_operations;
> +	entry = create_proc_entry("tty/console", 0, NULL);
> +	if (entry)
> +		entry->proc_fops = &proc_tty_console_operations;
>  }

---
~Randy
