Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbXHRP4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbXHRP4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 11:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXHRP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 11:56:15 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:58876 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbXHRP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 11:56:14 -0400
Date: Sat, 18 Aug 2007 11:56:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Al Viro <viro@ftp.linux.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <rddunlap@osdl.org>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [patch 2/2] Sort module list by pointer address to get coherent sleepable seq_file iterators
Message-ID: <20070818155609.GA20219@Krystal>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk> <20070815063741.GB5175@mail.ustc.edu.cn> <20070815065301.GK21089@ftp.linux.org.uk> <20070815084625.GA18892@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070815084625.GA18892@mail.ustc.edu.cn>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:41:19 up 19 days, 15:00,  4 users,  load average: 1.73, 1.36, 1.31
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Fengguang Wu (wfg@mail.ustc.edu.cn) wrote:
> Al Viro,
> 
> Does this sounds like a good fix?
> ===
> 
> seq_file version fixes
> 
> - f_version is 'unsigned long', it's pointless to do more than that.

Hrm, this is weird...

fs.h:

struct inode
  u64                     i_version;

and

struct file
  unsigned long           f_version;

Users do:

fs/ext3/dir.c:

if (filp->f_version != inode->i_version) {

So why isn't f_version a u64 ? It becomes a problem if versions gets
higher than 2^32 and we are on an architecture where longs are 32 bits.
I think the problem is the f_version field type, not in seq_file at all.
I'll prepare a patch for this.

> - m->version should not be reset when we are bumping up the buf size.
> 

Hrmmmm, what is this twisted use of versions anyway ?!?

If I look at other version users elsewhere in the kernel, they mostly
do:

repeat:
f_version = i_version
do something
if (f_version != i_version)
   repeat;

So they can see if the underlying inode has changed during the
operation. seq_file does it completely the other way around:

m->version = f_version;
do something

and, well, versions are never really used at all.

If we want to use versioning there, we should keep a version counter
associated with the ressource pointed used by seq_files that would be
incremented each time the data structures are modified.

Then, in the read side, we could sanely do:

seq open():
f_version = current version

seq read():
repeat:
m->version = f_version;
do something
if (m->version != current version)
  repeat;

This would only make sure that the given read operation has consistent
data. It would not certify data consistency across reads.

I have looked at fs/proc.c/task_mmu.c use of m->version, and I think it
is just really weird. I think the proper way to do it would be to put
the last_addr in a field of a structure to which m->private would point
to.

Mathieu

> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  fs/seq_file.c            |    1 -
>  include/linux/seq_file.h |    2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc3.orig/include/linux/seq_file.h
> +++ linux-2.6.23-rc3/include/linux/seq_file.h
> @@ -18,7 +18,7 @@ struct seq_file {
>  	size_t from;
>  	size_t count;
>  	loff_t index;
> -	loff_t version;
> +	unsigned long version;
>  	struct mutex lock;
>  	const struct seq_operations *op;
>  	void *private;
> --- linux-2.6.23-rc3.orig/fs/seq_file.c
> +++ linux-2.6.23-rc3/fs/seq_file.c
> @@ -134,7 +134,6 @@ ssize_t seq_read(struct file *file, char
>  		if (!m->buf)
>  			goto Enomem;
>  		m->count = 0;
> -		m->version = 0;
>  	}
>  	m->op->stop(m, p);
>  	m->count = 0;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
