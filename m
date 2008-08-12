Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYHLDqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYHLDqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYHLDqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:46:14 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:38884 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYHLDqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:46:13 -0400
Message-ID: <48A1072E.6010200@cs.columbia.edu>
Date: Mon, 11 Aug 2008 23:44:46 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Jonathan Corbet <corbet@lwn.net>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
References: <20080807224033.FFB3A2C1@kernel>	 <20080807224034.735B1F84@kernel>  <20080811120315.4b3ba2c8@bike.lwn.net> <1218479921.5598.35.camel@nimitz>
In-Reply-To: <1218479921.5598.35.camel@nimitz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Mon, 2008-08-11 at 12:03 -0600, Jonathan Corbet wrote:
>> I'm trying to figure out this patch set...here's a few things which
>> have caught my eye in passing.
>>
>>> +/**
>>> + * cr_get_fname - return pathname of a given file
>>> + * @file: file pointer
>>> + * @buf: buffer for pathname
>>> + * @n: buffer length (in) and pathname length (out)
>>> + *
>>> + * if the buffer provivded by the caller is too small, allocate a new
>>> + * buffer; caller should call cr_put_pathname() for cleanup
>>> + */
>>> +char *cr_get_fname(struct path *path, struct path *root, char *buf,
>>> int *n) +{
>>> +	char *fname;
>>> +
>>> +	fname = __d_path(path, root, buf, *n);
>>> +
>>> +	if (IS_ERR(fname) && PTR_ERR(fname) == -ENAMETOOLONG) {
>>> +		 if (!(buf = (char *) __get_free_pages(GFP_KERNEL, 0)))
>> This seems like a clunky and error-prone interface - why not just have it
>> allocate the memory always?  But, in this case, cr_get_fname() always seems
>> to be called with ctx->tbuf, which, in turn, is an order-1 allocation.
>> Here you're saying that if it's too small, you'll try replacing it with an
>> order-0 allocation instead.  I rather suspect that's not going to help.
> 
> Yeah, it doesn't make much sense on the surface.  I would imagine that
> this has some use for when we're stacking things up in the ctx->hbuf
> rather than just using it as a completely temporary buffer.  But, in any
> case, it doesn't make sense as it stands now, so I think it needs to be
> reworked.

Dave is right on the money: in Zap (the equivalent of) cr_get_fname()
may be called with a buffer smaller than PATH_MAX (one page) and hence
the need to allocate ad-hoc. Indeed in the current code this is not the
case (yet?) so I'll go ahead and simplify it.

> 
>>> +/* write the checkpoint header */
>>> +static int cr_write_hdr(struct cr_ctx *ctx)
>>> +{
>>> +	struct cr_hdr h;
>>> +	struct cr_hdr_head *hh = ctx->tbuf;
>>> +	struct timeval ktv;
>>> +
>>> +	h.type = CR_HDR_HEAD;
>>> +	h.len = sizeof(*hh);
>>> +	h.id = 0;
>>> +
>>> +	do_gettimeofday(&ktv);
>>> +
>>> +	hh->magic = 0x00a2d200;
>> This magic number is hard-coded in a number of places.  Could it maybe
>> benefit from a macro, which, in turn, could maybe end up in linux/magic.h?
>>
>>> +/* dump the task_struct of a given task */
>>> +static int cr_write_task_struct(struct cr_ctx *ctx, struct task_struct *t)
>> This function is going to break every time somebody changes struct
>> task_struct.  I'm not quite sure how to prevent that.  I wonder if the
>> modversions stuff could somehow be employed to detect changes and make the
>> build fail?
> 
> In general, I think any time that we are checkpointing $THING and $THING
> changes, the checkpoint will break.  It just so happens that all we're
> checkpointing here is the task_struct, so $THING == task_struct for
> now. :)
> 
> The things that *really* worry me are things like when flags change
> semantics subtly.  Or, let's say a flag is used for two different things
> in 2.6.26.4 vs ﻿2.6.27.  I'm not sure we're ever going to be in a
> position to find and fix up stuff like that.

One way to reduce the risk is to use an intermediate representation to
kernel native data and properties (e.g. classify VMAs during checkpoint
instead of relying blindly on the flags).

The problem is not so much in restarting a checkpoint image from old
kernel on a new kernel - that can be handled by conversion in user space.

Tracking changes affecting the checkpoint/restart logic - well, if
eventually checkpoint/restart gets to becomes main-stream enough that
developers will be aware of it.

> 
> That's one reason I have been advocating doing checkpoint/restart in
> much tinier bits so that we can understand each of them as we go along.
> I also think that the *less* we expose to userspace, the better.
> 
>>> +/**
>>> + * sys_checkpoint - checkpoint a container
>>> + * @pid: pid of the container init(1) process
>>> + * @fd: file to which dump the checkpoint image
>>> + * @flags: checkpoint operation flags
>>> + */
>>> +asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long
>>> flags) +{
>>> +	struct cr_ctx *ctx;
>>> +	struct file *file;
>>> +	int fput_needed;
>>> +	int ret;
>>> +
>>> +	if (!capable(CAP_SYS_ADMIN))
>>> +		return -EPERM;
>> Like others, I wondered why CAP_SYS_ADMIN was required here.  I *still*
>> wonder, though, how you'll ever be able to do restart without a privilege
>> check.  There must be a thousand ways to compromise a system by messing
>> with the checkpoint file.
> 
> As with everything else coming from userspace, the checkpoint file
> should be completely untrusted.  I do think, though, that the ptrace
> analogy that Serge?? made is a good one.

The only reason I made the analogy without actually implementing it is lack
of time and familiarity with the ptrace permission world.

> 
>>> +	file = fget_light(fd, &fput_needed);
>>> +	if (!file)
>>> +		return -EBADF;
>> Should you maybe check for write access?  An attempt to overwrite a
>> read-only file won't succeed, but you could save a lot of work by just
>> failing it with a clear code here.  
> 
> That's true.  I'll take a look and see.
> 
> This patch does reach down and use vfs_write() at some point.  There
> really aren't any other in-kernel users that do this (short of ecryptfs
> and plan9fs).  That makes me doubt that we're even using a good approach
> here.
> 
>> What about the file position?  Perhaps there could be a good reason to
>> checkpoint a process into the middle of a file, don't know.
> 
> I think this is a good example of a place where the kernel can let
> userspace shoot itself in its foot if it wants.  We might also want to
> allow things to be sent over fds that don't necessarily have positions,
> like sockets or pipes.
> 
>> In general, I don't see a whole lot of locking going on.  Is it really
>> possible to save and restore memory without ever holding mmap_sem?
> 
> I personally haven't audited the locking, yet.  It is going to be fun!

There is some optimistic locking (mmap_sem), improved in the next version.

Thanks,

Oren.

