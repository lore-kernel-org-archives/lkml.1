Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZAYCTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZAYCTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 21:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZAYCTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 21:19:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbZAYCTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 21:19:31 -0500
Date: Sat, 24 Jan 2009 18:19:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: Re: Migration of kernel interfaces to seq_files breaks pread()
 consumers
Message-Id: <20090124181924.d633523c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 23:51:35 -0800 (PST) Paul Turner <pjt@google.com> wrote:

> 
> (Specifically) Several interfaces under /proc have been migrated to use 
> seq_files.  This was previously observed to be a problem with VMware's 
> reading of /proc/uptime.  We're now running into the same problem on  
> /proc/<pid>/stat; we have many consumers performing preads on this 
> interface which break under new kernels.
> 
> Reverting these migrations presents other problems and doesn't scale with 
> everyones' pet dependencies over an abi that's been
> broken :(

We changed userspace-visible behaviour and broke real applications. 
This is a serious matter.  So serious in fact that your report has
languished without reply for a week.

Reverting those changes until we have a suitable reimplementation which
doesn't bust userspace is 100% justifiable.

In which kernel versions is this regression present?

What would a revert look like?  Big and ugly or small and simple?  Do
the original commits (which were they?) still revert OK?

> Part of the problem in implementing pread in seq_files is that we don't  
> know know whether the read was issued by pread(2) or read(2).  It's not 
> nice to shoehorn this information down the stack.  I've attached a 
> skeleton patch which shows one way we could push it up (although something 
> like a second f_pos would be necessary to make it maintain pread 
> semantics against reads).
> 
> One advantage of this style of approach is that it doesn't break on 
> partial record reads.  But it's a little gross at the same time.
> 

Yes, that is a bit gross.

Does this patch actually 100% solve the problem, or is it a precursor
to some other fix or what?  It's hard to comment sensibly if it's a
partial thing with no sign how it will be used.

> diff --git a/fs/read_write.c b/fs/read_write.c
> index 2fc2980..744094a 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -407,6 +407,16 @@ asmlinkage ssize_t sys_pread64(unsigned int fd, char __user *buf,
>  		ret = -ESPIPE;
>  		if (file->f_mode & FMODE_PREAD)
>  			ret = vfs_read(file, buf, count, &pos);
> +		else if (file->f_mode & FMODE_SEQ_FILE) {
> +			/*
> +			 * We break the pread semantic and actually make it
> +			 * seek, this prevents inconsistent record reads across
> +			 * boundaries.
> +			 */
> +			vfs_llseek(file, pos, SEEK_SET);
> +			ret = vfs_read(file, buf, count, &pos);
> +			file_pos_write(file, pos);
> +		}

Well yes, that's a userspace-visible wrong change too.

>  		fput_light(file, fput_needed);
>  	}
>  
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3f54dbd..f8c5379 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -50,6 +50,8 @@ int seq_open(struct file *file, const struct seq_operations *op)
>  
>  	/* SEQ files support lseek, but not pread/pwrite */
>  	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
> +	file->f_mode |= FMODE_SEQ_FILE;
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(seq_open);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 5f7b912..c3b5916 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -76,6 +76,8 @@ extern int dir_notify_enable;
>     behavior for cross-node execution/opening_for_writing of files */
>  #define FMODE_EXEC	16
>  
> +#define FMODE_SEQ_FILE_PREAD	32

-EWONTCOMPILE, btw.
