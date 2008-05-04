Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYEDUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYEDUJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYEDUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:09:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:46881 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbYEDUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=OK2sLzuyaO6GGubYHxMS2V+da6Rwt/23h1ZipaAMh6reE7AEbbYCQFQ2ZkYit2b5LNxLKD5QFTPpyuJd5aSRE2R0Qhem1qUey/X7FVqllTAqtCTG3zgnlKRU6kR9S2HkcZrJbCxt7+IPVih+XzwgjIFICz9CMiOfXKm98g+XyCk=
Date: Mon, 5 May 2008 01:04:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 34/37] LTTng instrumentation ipc
Message-ID: <20080504210433.GB1040@martell.zuzino.mipt.ru>
References: <20080424150324.802695381@polymtl.ca> <20080424151407.622943449@polymtl.ca> <20080424230238.GA11699@martell.zuzino.mipt.ru> <y0mve26r874.fsf@ton.toronto.redhat.com> <20080425125607.GC28411@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425125607.GC28411@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 08:56:07AM -0400, Mathieu Desnoyers wrote:
> * Frank Ch. Eigler (fche@redhat.com) wrote:

> > > Can I write
> > > 	if (rv < 0)
> > > 		trace_mark(foo, "rv %d", rv);
> > 
> > Sure.
> > 
> > > Looks like i could. But people want also want to see success, so what?
> > > Two markers per exit?
> > >
> > > 	rv = ipc_get(...);
> > > 	if (rv < 0)
> > > 		trace_marker(foo_err, ...);
> > > 	trace_marker(foo_all, ...);
> > 
> > That seems excessive.  Just pass "rv" value and let the consumer
> > decide whether they care about < 0.
> > 
> > You seem to be operating under the mistaken assumption that marker
> > consumers will simply have to pass on the full firehose flow without
> > filtering.  That is not so.  I suspect lttng can do it, but I know
> > that with systemtap, it's trivial to encode conditions on the marker
> > parameters and other state (e.g., recent events of interest), so that
> > only finely tuned events actually get sent to the end user.
> > 
> 
> The preferred way to do it would be
> 
>   trace_mark(foo, "rv %d", rv);
> 
> And let the probe deal with rv. The main reason is that by adding
> 
> if (test)
>   trace_mark()
> 
> you will add a branch in the normal kernel code flow and slow down the
> kernel a bit when disabled compared to the optimized markers.

Martin, let's forget for a thread about performance. I don't complain
over performance degradation at all, there is something more serious.
People _will_ find you if something will go noticeably slower. :^)



OK, uncoditional marker forces me to do some post-filtering, that's
probably tolerable. But! Some information can be lost after serialization
to strings is done. Or more difficult to do post-filtering than needed.
Examples below.

> > > Also everything inserted so far is static. Sometimes only one bit in
> > > mask is interesting and to save time to parse nibbles people do:
> > > 	printk("foo = %d\n", !!(mask & foo));
> > > And interesting bits vary.
> > 
> > OK, perhaps pass both mask & foo, and let the consumer perform the
> > arithmetic they deem appropriate.
> > 
> 
> Agreed. However, adding stuff like
> 
> !!(mask & foo)
> 
> as parameter to a marker won't add to the disabled marker runtime cost,
> since it's evaluated within the "marker enabled" block. So, if all you
> really need is !!(mask & foo) (and never other information about foo),
> then it could make sense to use the most restrictive version so we don't
> export internal details about the kernel implementation.

People will want do see different bits, so you'll show full mask and let
people do post-filtering again.

> > > Again, all events aren't interesting:
> > > 	if (file && file->f_op == &shm_file_operations)
> > > 		printk("%s: file = %p: START\n", __func__, file);
> > > Can I write this with markers?
> > 
> > Of course, if you really want to.
> > 
> 
> __func__ is not really interesting here, because you can name your
> marker. A useful trick can be to use __builtin_return_address(0) when
> needed though.

__func__ is just real-world nit.

This example is about very specific set of struct files (hi, Eric!).
Post-filtering again.

> for the rest, a way that would not export too much information about
> kernel's internals :
> 
> trace_mark(shm_start, "is_shm_fop %d file %p",
>   file->f_op == &shm_file_operations, file);

And this is totally unexpected from you.

		In the name of bug-free kernel,
		  I DO WANT KERNEL INTERNALS!


And I perfectly know which ones at which spots!

If you're scared of internals keep this marker thingy on kernel/luserspace
boundary -- TIF_SYSCALL_TRACE or how it's called. Don't do tree-wide
source code pollution!

> If you really really want to, I could modify the markers to make this
> even easier by doing something like :
> 
> trace_mark_cond(file->f_op == &shm_file_operations,
>   shm_start, "file %p", file);

That's also strange to hear.

If I can't reboot a box, I can't insert my carefully crafter marker.
If I can, I can rebuilt kernel with all debugging I want.

> > > So what is proposed? Insert markers at places that look strategic? 
> > 
> > "strategic" is the wrong term.  Choose those places that reflect
> > internal occurrences that are useful but difficult to reverse-engineer
> > from other visible interface points like system calls.  Data that
> > helps answer questions like "Why did (subtle internal phenomenon)
> > happen?" in a live system.

This is what's called strategic :^) But there are too many of them, and you
never know to where bug report will point you at the end.

> > > mm/ patch is full if "file %p". Do you realize that pointers are
> > > only sometimes interesting and sometimes you want dentry (not pointer,
> > > but name!):
> > > 	printk("file = '%s'\n", file->f_dentry->d_name.name);
> > 
> > It may not be excessive to put both file and the dname.name as marker
> > parameters.
> > 
> 
> eek, well, if we really want to identify a file, we need more than its
> name. mount points, full path and file name are required.

Just name sometimes good clue: SYSV00000000 . Somebody will want full
path though.

> It brings me a
> few years back, but I don't think the dentry name gives us that. This is
> why I extract information about all opened files to my tracer once
> (mapping the mount point, path and file name to file pointer) and then I
> don't have to do the lookup each time the marker is encountered. Yes,
> this involved a file pointers dumping at tracer start and keeping track
> of open/close events.

> > > So, let me say even more explicitly. Looking at proposed places elite
> > > enough to be blessed with marker...
> > >
> > > Those which are close enough to system call boundary are essentially
> > > strace(1).
> > 
> > Those may not sound worthwhile to put a marker for, BUT, you're
> > ignoring the huge differences of impact and scope.  A system-wide
> > marker-based trace (filtered a la systemtap if desired) can be done
> > with a tiny fraction of system load and none of the disruption caused
> > by an strace of all the processes.

And finally, systemtap.

Reading some systemtap docs,
http://sourceware.org/systemtap/wiki/UsingMarkers
where examples of intelligent filtering are shown:

	function inode_get_i_ino:long (i:long) %{ /* pure */
		struct inode *inode = (struct inode *)(long)THIS->i;
		THIS->__retvalue = kread(&(inode->i_ino));
		CATCH_DEREF_FAULT();
	%}
	probe kernel.mark("kfunc_entry")
	{
		printf("inode number: %d\n", inode_get_i_ino($arg1))
	}

Is this representative example?

If yes, systemtap only wants marker's name and ignores totally its fmt
string. So, why add them in the first place?

And if systemtap can hook at any place, it doesn't need markers (I
haven't used it though, so correct me).

