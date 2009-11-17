Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZKQJDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZKQJDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZKQJDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:03:45 -0500
Received: from smtp.nokia.com ([192.100.105.134]:29311 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZKQJDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:03:36 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
In-Reply-To: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 11:03:00 +0200
Message-Id: <1258448580.27437.81.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Nov 2009 09:03:02.0577 (UTC) FILETIME=[C491F210:01CA6764]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pair of nit-picks.

On Wed, 2009-11-11 at 21:13 -0500, David VomLehn wrote:
> @@ -0,0 +1,293 @@
> +/*
> + *				panic-note.c

No need to type file name there.

> + *
> + * Allow a blob to be registered with the kernel that will be printed if
> + * the kernel panics.
> + *
> + * Copyright (C) 2009  Cisco Systems, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +/* Open issues:
> + * Where should the panic_note file be created? It's almost like a sysctl,
> + * but doesn't follow the same rules. When you write to a sysctl file, the
> + * previous data is replaced. When you write to the panic_note file, you
> + * can append to the end of the existing data.
> + */

Please, take a look at what is the kernel comment style at
Documentation/CodingStyle. We use

/*
 * Multi-line
 * comment
 */

style.

> +
> +#include <linux/semaphore.h>
> +#include <linux/fs.h>
> +#include <linux/proc_fs.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +
> +/* Maximum size, in bytes, allowed for the blob. Having this limit prevents
> + * an inadvertant denial of service attack that might happen if someone with
> + * root privileges was automatically generating this note and the generator
> + * had an infinite loop. Perhaps this is more of a a denial of service
> + * suicide. */
> +#define PANIC_NOTE_SIZE		(PAGE_SIZE * 4)
> +
> +/*
> + * struct panic_note_data - Information about the panic note
> + * @n:		Number of bytes in the note
> + * @p:		Pointer to the data in the note
> + * @sem:	Semaphore controlling access to data in the note
> + */
> +struct panic_note_state {
> +	size_t			n;
> +	void			*p;
> +	struct rw_semaphore	sem;
> +};
> +
> +static struct panic_note_state panic_note_state = {
> +	0, NULL, __RWSEM_INITIALIZER(panic_note_state.sem)
> +};
> +static const struct file_operations panic_note_fops;
> +static struct inode_operations panic_note_iops;
> +static struct proc_dir_entry *panic_note_entry;
> +
> +/*
> + * panic_note_print - display the panic note
> + * @priority:	Printk priority to use, e.g. KERN_EMERG
> + */
> +void panic_note_print()
> +{
> +	int i;
> +	int linelen;
int i, lineline is more compact.

> +
> +	/* We skip the semaphore stuff because we're in a panic situation and
> +	 * the scheduler isn't available in case the semaphore is already owned
> +	 * by someone else */
> +	for (i = 0; i < panic_note_state.n; i += linelen) {
> +		const char *p;
> +		int remaining;
> +		const char *nl;

const char *p, *nl is more compact. And there are several more places.
But this is matter of taste, really.

> +
> +		p = panic_note_state.p + i;
> +		remaining = panic_note_state.n - i;
> +
> +		nl = memchr(p, '\n', remaining);
> +
> +		if (nl == NULL) {
> +			linelen = remaining;
> +			pr_emerg("%.*s\n", linelen, p);
> +		} else {
> +			linelen = nl - p + 1;
> +			pr_emerg("%.*s", linelen, p);
> +		}
> +	}
> +}
> +
> +/*
> + * read_write_size - calculate the limited copy_to_user/copy_from_user count
> + * @nbytes:	The number of bytes requested
> + * @pos:	Offset, in bytes, into the file
> + * @size:	Maximum I/O offset, in bytes. For a read, this is the actual
> + *		number of bytes in the file, since you can't read past
> + *		the end. Writes can be done after the number of bytes in the
> + *		file, so this is the maximum possible file size, minus one.
> + *
> + * Returns the number of bytes to copy.
> + */
> +static ssize_t read_write_size(size_t nbytes, loff_t pos, size_t size)
> +{
> +	ssize_t retval;
> +
> +	if (pos >= size)
> +		retval = 0;
> +
Unnecessary \n
> +	else {
> +		retval = size - pos;
> +		if (retval > nbytes)
> +			retval = nbytes;
> +	}
> +
> +	return retval;
> +}


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

