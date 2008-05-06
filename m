Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbYEFEhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbYEFEhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYEFEhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:37:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757292AbYEFEhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:37:13 -0400
Date: Mon, 5 May 2008 21:36:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/6] seq_file: add function to write binary data
Message-Id: <20080505213644.b153ee68.akpm@linux-foundation.org>
In-Reply-To: <481F26B5.7010708@de.ibm.com>
References: <481F26B5.7010708@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 17:24:37 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> seq_write() can be used to construct seq_files containing arbitrary
> data. Required by the gcov-profiling interface to synthesize binary
> profiling data files.
> 
> Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> ---
>  fs/seq_file.c            |   12 ++++++++++++
>  include/linux/seq_file.h |    1 +
>  2 files changed, 13 insertions(+)
> 
> Index: linux-2.6.26-rc1/fs/seq_file.c
> ===================================================================
> --- linux-2.6.26-rc1.orig/fs/seq_file.c
> +++ linux-2.6.26-rc1/fs/seq_file.c
> @@ -554,6 +554,18 @@ int seq_puts(struct seq_file *m, const c
>  }
>  EXPORT_SYMBOL(seq_puts);
>  
> +int seq_write(struct seq_file *m, const void *s, size_t len)

Most of the other seq_file interface functions are nicely documented.

> +{
> +	if (m->count + len < m->size) {

Are you sure that shouldn't be >=?

> +		memcpy(m->buf + m->count, s, len);
> +		m->count += len;
> +		return 0;
> +	}
> +	m->count = m->size;
> +	return -1;
> +}
> +EXPORT_SYMBOL(seq_write);

Usually when a write-style function is passed too much data it will write
as much as it can and will then return a smaller-than-requested value.

That's inappropriate for your application of seq_write(), but perhaps is
appropriate for other future callers?

This function has an upper limit of PAGE_SIZE bytes, I think?  The covering
documentation should explain such things.

>  struct list_head *seq_list_start(struct list_head *head, loff_t pos)
>  {
>  	struct list_head *lh;
> Index: linux-2.6.26-rc1/include/linux/seq_file.h
> ===================================================================
> --- linux-2.6.26-rc1.orig/include/linux/seq_file.h
> +++ linux-2.6.26-rc1/include/linux/seq_file.h
> @@ -39,6 +39,7 @@ int seq_release(struct inode *, struct f
>  int seq_escape(struct seq_file *, const char *, const char *);
>  int seq_putc(struct seq_file *m, char c);
>  int seq_puts(struct seq_file *m, const char *s);
> +int seq_write(struct seq_file *m, const void *s, size_t len);
>  
>  int seq_printf(struct seq_file *, const char *, ...)
>  	__attribute__ ((format (printf,2,3)));
> 
