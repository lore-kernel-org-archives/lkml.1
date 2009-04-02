Return-Path: <linux-kernel-owner+w=401wt.eu-S935286AbZDBGa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286AbZDBGa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbZDBG37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:29:59 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:60235 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbZDBG36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:29:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEFAKby00lMQW1W/2dsb2JhbACBUs0Sg30G
Date: Thu, 2 Apr 2009 02:29:53 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-embedded@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] nfs: add support for splice writes
Message-ID: <20090402062952.GA24846@Krystal>
References: <49D45974.2060202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49D45974.2060202@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:29:02 up 33 days,  2:55,  1 user,  load average: 0.10, 0.21,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Jayaraman (sjayaraman@suse.de) wrote:
> This patch attempts to add splice writes support. In essence, it just
> calls generic_file_splice_write() after doing a little sanity check.
> This would allow LTTng users that are using NFS to store trace data.
> There could be more applications that could be benefitted too.
> 
> I have tested this using the Jens' test program and have found no
> real issues. The test program is inlined below:
> 

That's great ! I'll pull it in the LTTng tree so my users can try it.
They currently cannot write LTTng traces to NFS mounts anyway.

Thanks !

Mathieu

> /*
>  * splice-out.c: Splice stdout to file
>  */
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> 
> #define SPLICE_SIZE (64*1024)
> 
> int main(int argc, char *argv[])
> {
>         int fd;
> 
>         if (argc < 2) {
>                 printf("%s: outfile\n", argv[0]);
>                 return 1;
>         }
> 
>         fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
>         if (fd < 0) {
>                 perror("open");
>                 return 1;
>         }
> 
>         do {
>                 int ret = splice(STDIN_FILENO, NULL, fd, NULL, SPLICE_SIZE, 0);
> 
>                 if (ret < 0) {
>                         perror("splice");
>                         break;
>                 } else if (ret < SPLICE_SIZE)
>                         break;
>         } while (1);
> 
>         close(fd);
>         return 0;
> }
> 
> Compile with -D _GNU_SOURCE and do something like:
> 	echo "some stuff" | ./splice-out <outfile>
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>  fs/nfs/file.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 90f292b..13d6a00 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -47,6 +47,9 @@ static ssize_t nfs_file_splice_read(struct file *filp, loff_t *ppos,
>  					size_t count, unsigned int flags);
>  static ssize_t nfs_file_read(struct kiocb *, const struct iovec *iov,
>  				unsigned long nr_segs, loff_t pos);
> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
> +					struct file *filp, loff_t *ppos,
> +					size_t count, unsigned int flags);
>  static ssize_t nfs_file_write(struct kiocb *, const struct iovec *iov,
>  				unsigned long nr_segs, loff_t pos);
>  static int  nfs_file_flush(struct file *, fl_owner_t id);
> @@ -76,6 +79,7 @@ const struct file_operations nfs_file_operations = {
>  	.lock		= nfs_lock,
>  	.flock		= nfs_flock,
>  	.splice_read	= nfs_file_splice_read,
> +	.splice_write	= nfs_file_splice_write,
>  	.check_flags	= nfs_check_flags,
>  	.setlease	= nfs_setlease,
>  };
> @@ -550,6 +554,26 @@ out_swapfile:
>  	goto out;
>  }
>  
> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
> +				     struct file *filp, loff_t *ppos,
> +				     size_t count, unsigned int flags)
> +{
> +	struct dentry *dentry = filp->f_path.dentry;
> +	struct inode *inode = dentry->d_inode;
> +
> +	dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
> +		dentry->d_parent->d_name.name, dentry->d_name.name,
> +		(unsigned long) count, (unsigned long long) *ppos);
> +
> +	if (IS_SWAPFILE(inode)) {
> +		printk(KERN_INFO "NFS: attempt to write to active swap"
> +		       "file!\n");
> +		return -EBUSY;
> +	}
> +
> +	return generic_file_splice_write(pipe, filp, ppos, count, flags);
> +}
> +
>  static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
>  {
>  	struct inode *inode = filp->f_mapping->host;
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
