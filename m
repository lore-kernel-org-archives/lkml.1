Return-Path: <linux-kernel-owner+w=401wt.eu-S1764978AbZDBGmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764978AbZDBGmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZDBGmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:42:22 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50755 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZDBGmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:42:20 -0400
Message-ID: <49D45E42.3050502@suse.de>
Date: Thu, 02 Apr 2009 12:12:10 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-embedded@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] nfs: add support for splice writes
References: <49D45974.2060202@suse.de> <20090402063235.GB24846@Krystal>
In-Reply-To: <20090402063235.GB24846@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Suresh Jayaraman (sjayaraman@suse.de) wrote:
>> This patch attempts to add splice writes support. In essence, it just
>> calls generic_file_splice_write() after doing a little sanity check.
>> This would allow LTTng users that are using NFS to store trace data.
>> There could be more applications that could be benefitted too.
>>
>> I have tested this using the Jens' test program and have found no
>> real issues. The test program is inlined below:
>>
> 
> There is just a small checkpatch nit that I'll fix directly in place in
> the LTTng tree.
> 
> WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
> #93: FILE: fs/nfs/file.c:564:
> +	dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
> 
> total: 0 errors, 1 warnings, 42 lines checked
> 

Yes, I noticed it. There are quite a few places in nfs code where we
happened to use that (that doesn't imply that it shouldn't be fixed), so
I thought it's OK.

> That's great ! I'll pull it in the LTTng tree so my users can try it.
> They currently cannot write LTTng traces to NFS mounts anyway.

Yes, please report the test results. Would appreciate it very much.


Thanks,

>>
>> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
>> index 90f292b..13d6a00 100644
>> --- a/fs/nfs/file.c
>> +++ b/fs/nfs/file.c
>> @@ -47,6 +47,9 @@ static ssize_t nfs_file_splice_read(struct file *filp, loff_t *ppos,
>>  					size_t count, unsigned int flags);
>>  static ssize_t nfs_file_read(struct kiocb *, const struct iovec *iov,
>>  				unsigned long nr_segs, loff_t pos);
>> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
>> +					struct file *filp, loff_t *ppos,
>> +					size_t count, unsigned int flags);
>>  static ssize_t nfs_file_write(struct kiocb *, const struct iovec *iov,
>>  				unsigned long nr_segs, loff_t pos);
>>  static int  nfs_file_flush(struct file *, fl_owner_t id);
>> @@ -76,6 +79,7 @@ const struct file_operations nfs_file_operations = {
>>  	.lock		= nfs_lock,
>>  	.flock		= nfs_flock,
>>  	.splice_read	= nfs_file_splice_read,
>> +	.splice_write	= nfs_file_splice_write,
>>  	.check_flags	= nfs_check_flags,
>>  	.setlease	= nfs_setlease,
>>  };
>> @@ -550,6 +554,26 @@ out_swapfile:
>>  	goto out;
>>  }
>>  
>> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
>> +				     struct file *filp, loff_t *ppos,
>> +				     size_t count, unsigned int flags)
>> +{
>> +	struct dentry *dentry = filp->f_path.dentry;
>> +	struct inode *inode = dentry->d_inode;
>> +
>> +	dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
>> +		dentry->d_parent->d_name.name, dentry->d_name.name,
>> +		(unsigned long) count, (unsigned long long) *ppos);
>> +
>> +	if (IS_SWAPFILE(inode)) {
>> +		printk(KERN_INFO "NFS: attempt to write to active swap"
>> +		       "file!\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	return generic_file_splice_write(pipe, filp, ppos, count, flags);
>> +}
>> +
>>  static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
>>  {
>>  	struct inode *inode = filp->f_mapping->host;
>>
> 


-- 
Suresh Jayaraman
