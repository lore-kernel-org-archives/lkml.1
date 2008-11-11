Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYKKBI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYKKBI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYKKBIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:08:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbYKKBIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:08:43 -0500
Date: Mon, 10 Nov 2008 17:08:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alain Knaff <alain@knaff.lu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, alain@knaff.lu
Subject: Re: [PATCH] VFS: lseek(fd, 0, SEEK_CUR) race condition
Message-Id: <20081110170808.831093ec.akpm@linux-foundation.org>
In-Reply-To: <200811062021.mA6KLCEp030336@hitchhiker.org.lu>
References: <200811062021.mA6KLCEp030336@hitchhiker.org.lu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 21:21:12 +0100
Alain Knaff <alain@knaff.lu> wrote:

> This patch fixes a race condition in lseek. While it is expected that
> unpredictable behaviour may result while repositioning the offset of a
> file descriptor concurrently with reading/writing to the same file
> descriptor, this should not happen when merely *reading* the file
> descriptor's offset.
> 
> Unfortunately, the only portable way in Unix to read a file
> descriptor's offset is lseek(fd, 0, SEEK_CUR); however executing this
> concurrently with read/write may mess up the position, as shown by the
> testcase below:
> 
> #include <sys/types.h>
> #include <stdio.h>
> #include <pthread.h>
> #include <unistd.h>
> #include <errno.h>
> #include <string.h>
> #include <pthread.h>
> 
> 
> void *loop(void *ptr)
> {
>   fprintf(stderr, "Starting seek thread\n");
>   while(1) {
>     if(lseek(0, 0LL, SEEK_CUR) < 0LL)
>       perror("seek");
>   }
> }
> 
> int main(int argc, char **argv) {
>   long long l=0;
>   int r;
>   char buf[4096];
> 
>   pthread_t thread;
>   pthread_create(&thread, 0, loop, 0);
> 
>   for(r=0; 1 ; r++) {
>     int n = read(0, buf, 4096);
>     if(n == 0)
>       break;
>     if(n < 4096) {
>       fprintf(stderr, "Short read %d %s\n", n, strerror(errno));
>     }
>     l+= n;
>   }
>   fprintf(stderr, "Read %lld bytes\n", l);
>   
>   return 0;
> }
> 
> Compile this and run it on a multi-processor machine as
>  ./a.out <bigFile
> 
> where bigFile is a 1 Gigabyte file. It should print 1073741824.
> However, on a buggy kernel, it usually produces a bigger number. The
> problem only happens on a multiprocessor machine. This is because an
> lseek(fd, 0, SEEK_CUR) running concurrently with a read() or write()
> will reset the position back to what it used to be when the read()
> started.
> 
> This behavior was observed "in the wild" when using udpcast which uses
> lseek to monitor progress of reading/writing the uncompressed data.
> 
> The patch below fixes the issue by "special-casing" the lseek(fd, 0,
> SEEK_CUR) pattern.
> 
> Apparently, an attempt was already made to fix the issue by the
> following code:
> 
> 		if (offset != file->f_pos) {
> 			file->f_pos = offset;
> 			file->f_version = 0;
> 		}
> 
> However, this doesn't work if file->f_pos was changed (by read() or
> write()) between the time offset was computed, and the time where it
> considers writing it back.
> 
> Signed-off-by: Alain Knaff <alain@knaff.lu>
> 
> ---
> 
> diff -pur kernel.orig/fs/read_write.c kernel/fs/read_write.c
> --- kernel.orig/fs/read_write.c	2008-10-11 14:12:07.000000000 +0200
> +++ kernel/fs/read_write.c	2008-11-06 19:55:59.000000000 +0100
> @@ -42,6 +42,8 @@ generic_file_llseek_unlocked(struct file
>  			offset += inode->i_size;
>  			break;
>  		case SEEK_CUR:
> +			if(offset == 0)
> +				return file->f_pos;
>  			offset += file->f_pos;
>  	}
>  	retval = -EINVAL;

OK, I think that a concurrent lseek(fd, 0, SEEK_CUR) is a sufficiently
sane operation that this is worth doing.  As you point out, there is no
other way of userspace doing what is effectively a read-only operation
- userspace would be entitled to wonder "ytf did the kernel rewrite the
file offset for that?".


Do the below additions look OK?

From: Andrew Morton <akpm@linux-foundation.org>

- fix coding-style
- fix default_llseek() as well
- add comments

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN fs/read_write.c~vfs-lseekfd-0-seek_cur-race-condition-fix fs/read_write.c
--- a/fs/read_write.c~vfs-lseekfd-0-seek_cur-race-condition-fix
+++ a/fs/read_write.c
@@ -50,6 +50,14 @@ generic_file_llseek_unlocked(struct file
 		offset += inode->i_size;
 		break;
 	case SEEK_CUR:
+		/*
+		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
+		 * position-querying operation.  Avoid rewriting the "same"
+		 * f_pos value back to the file because a concurrent read(),
+		 * write() or lseek() might have altered it
+		 */
+		if (offset == 0)
+			return file->f_pos;
 		offset += file->f_pos;
 		break;
 	}
@@ -105,8 +113,14 @@ loff_t default_llseek(struct file *file,
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
 		case SEEK_CUR:
-			if(offset == 0)
-				return file->f_pos;
+			/*
+			 * See SEEK_CUR description in
+			 * generic_file_llseek_unlocked()
+			 */
+			if (offset == 0) {
+				retval = file->f_pos;
+				goto out;
+			}
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
@@ -117,6 +131,7 @@ loff_t default_llseek(struct file *file,
 		}
 		retval = offset;
 	}
+out:
 	unlock_kernel();
 	return retval;
 }
_

