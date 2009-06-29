Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZF2Q7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZF2Q7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZF2Q7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:59:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:56942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZF2Q7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:59:17 -0400
Message-ID: <4A48F2F8.5090105@kernel.org>
Date: Tue, 30 Jun 2009 01:59:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, npiggin@suse.de
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org>	<1245317073-24000-5-git-send-email-tj@kernel.org> <20090623171441.535c6c98.akpm@linux-foundation.org>
In-Reply-To: <20090623171441.535c6c98.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 16:57:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

Andrew Morton wrote:
>> +static int fuse_mmap_commit_prep(struct fuse_conn *fc, struct fuse_req *req)
>> +{
>> +	struct fuse_mmap_commit_in *commit_in = (void *)req->in.args[0].value;
>> +	struct file *mfile = req->misc.mmap.file;
>> +	int fd;
>> +
>> +	if (!mfile)
>> +		return 0;
>> +
>> +	/* new mmap.file has been created, assign a fd to it */
>> +	fd = commit_in->fd = get_unused_fd_flags(O_CLOEXEC);
>> +	if (fd < 0)
>> +		return 0;
> 
> Shouldn't this be `return fd;'?

Non-zero return from prep aborts the command immediately and starts
processing the next command.  However, when the fd assigning fails,
the failure should be communicated to the userland server so that it
can release any resource it might be holding for the mmap.  So, the
failure state is recorded in commit_in->fd which and the prep callback
returns 0 so that the failure status can be transmitted to the
userland server.

>> +	fmmap->vm_ops = *vma->vm_ops;
>> +	vma->vm_ops = &fmmap->vm_ops;
>> +	vma->vm_ops->open = fuse_vm_open;
>> +	vma->vm_ops->close = fuse_vm_close;
>> +	vma->vm_private_data = fmmap;
>> +	err = 0;
> 
> Yes, the vm_operations save/overwrite/restore is the stinky part here.
> 
> I'm not completely clear what's going on here, and why, and what the
> overall implications and risks are.  Some discussion in the changelog
> would help.  With all that information we then would be better situated
> to discuss and perhaps solve <whatever problem this solves> by more
> pleasing means.
> 
> I mean, if the need for this hack indicates that there is some
> shortcoming in core VM then perhaps we can improve core VM.  Dunno.

Sorry about lack of explanation, in a nutshell, fuse direct mmap
implementation wants to use shmem but wants to know when each mmap is
opened and closed so that it can determine when the mmap is finally
released and tell the userland to release related resources.  I think
the following two approaches would be more regular for situations like
this.

1. Export the necessary parts of shmem operations and build our fuse's
   own vm_ops using necessary operations.

2. If vma can be nested, create wrapper vma around shmem vma and catch
   open/close calls from there.

#1 might be the better solution here but with two separate shmem
implementations it was a bit awkward.  #2 currently can't be done, so
I used bastardized form of #1.  So, yeap, it's ugly.

Anyways, it looks like the whole fd fiddling and shmem vma trickery
might all go away, so please don't invest too much time into it.

>> +	/* missing commit can cause resource leak on server side, don't fail */
>> +	req = fuse_get_req_nofail(fc, file);
> 
> That's an optimistically-named function.
> 
> <looks>
> 
> hm, it seems to duplicate mempool.c.

It's much more narrowly defined but yeah in a way.

>> +	if (err == -ENOSYS) {
>> +		/* Can't provide the coherency needed for MAP_SHARED */
>> +		if (vma->vm_flags & VM_MAYSHARE)
>> +			return -ENODEV;
>> +
>> +		invalidate_inode_pages2(file->f_mapping);
>> +
>> +		return generic_file_mmap(file, vma);
> 
> Now what's happening on this path?
> 
> We seem to have decided to fallback to a standard mmap of some form? 
> Why?  If the user's request failed, shouldn't we just fail the syscall?
> Hasn't the kernel just lied to userspace about what happened?
> 
> Also, this code looks like it's duplicating the behaviour of core MM? 
> If so then it needs to be kept in sync as core MM changes - that's a
> maintenance problem.  Can it be improved by changing core MM?

That's from the original mmap implementation before the direct mmap is
added.  It's just code movement.  No functional change by this patch
on this path.

>> --- a/fs/fuse/fuse_i.h
>> +++ b/fs/fuse/fuse_i.h
>> @@ -272,6 +272,13 @@ struct fuse_req {
>>  			struct fuse_write_out out;
>>  		} write;
>>  		struct fuse_lk_in lk_in;
>> +		struct {
>> +			/** to move filp for mmap between client and server */
> 
> Comment pretends to be kerneldoc?

Will fix.

>>  
>> +/**
> 
> kerneldoc?  Does this work?

I have no idea.  Will update.

>> + * Mmap flags
>> + *
>> + * FUSE_MMAP_DONT_COPY: don't copy the region on fork
>> + * FUSE_MMAP_DONT_EXPAND: can't be expanded with mremap()
>> + */
>> +#define FUSE_MMAP_DONT_COPY	(1 << 0)
>> +#define FUSE_MMAP_DONT_EXPAND	(1 << 1)
>> +

Thanks.

-- 
tejun
