Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYHSSul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYHSSul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYHSSub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:50:31 -0400
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:49835 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756234AbYHSSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:50:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ZLYLjJB0l5ebYU0lijWOjzZUVCUaRAw/3sJWdJujooGsE4RUPEt+JRHEHa1fnnBhmYbFv13rgv6kmOr8fP6O4EC+E9nXTKa0A56sqNsf7QPZU0epBUdr9iJHQnrZynPb;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Tue, 19 Aug 2008 11:50:11 -0700
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <200808192000.47070.nickpiggin@yahoo.com.au> <1219164367.10772.420.camel@koto.keithp.com>
In-Reply-To: <1219164367.10772.420.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191150.12345.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 19, 2008 9:46 am Keith Packard wrote:
> On Tue, 2008-08-19 at 20:00 +1000, Nick Piggin wrote:
> > Not exactly sure what you mean by this. But I would like to see an effort
> > made to use existing userspace APIs in order to do this swappable object
> > allocation over tmpfs scheme. As I said, I don't object to a nice kernel
> > implementation, but we would be in a much better position to assess it if
> > we had an existing userspace implementation to compare it with.
>
> We need to allocate objects from kernel mode to get the console running.
> I'd prefer to let that occur before user mode was available. Also,
> emulating the existing fbdev syscall interface will require that we
> allocate objects within the kernel.

Yeah there's no question we need early kernel space allocations of GEM 
objects.  We need to setup the frame buffer, ring buffer, hardware status 
page, and potentially other state at module init time so that people can see 
their boot messages.

> Hence, the question about how we should create objects from kernel mode.
> I think we can do this with a series of VFS function calls. Would that
> series of VFS calls be preferable to directly accessing the existing
> shmem API?
>
> Another alternative is to improve the existing shmem API to better
> capture what we're trying to do here. Both drm and sysv shm just want
> anonymous pages that are backed by swap. If we started from scratch,
> what API would we like to have here? Would we have it support both shmem
> and hugetlbfs?

Improving the shmem API makes sense to me.  There's a flip side to using the 
ioctls as well; in doing the GTT mapping with the current code, I had to add 
a new ioctl and create a new core function that would allow me to do I/O 
remapping from something other than an ->mmap hook.  I think we could have 
conceptually cleaner code and less hassle if we extended shmem a bit to allow 
for shmem "drivers" that could hook into its open/close/mmap/etc. routines 
(though in the mmap case in particular we'd either need to abuse an existing 
mmap flag or create a new one to recognize the backing store/GTT mapping 
distinction).

What do you think, Nick?  Adding this stuff to shmem would probably involve 
using the file->private_data inside shmem, and creating a new sub-driver 
registration function, then checking for sub-ops in the various important 
shmem operations structs...

The advantage of all this is that we could probably use regular fds for the 
most part (assuming we get a "high fd" mapping function sometime soon), and 
all the regular file operations routines, making GEM look a like more like a 
regular file system driver.

As for in-kernel stuff, as long as we keep the GEM shmem hooks separate from 
the actual bookkeeping (like we do now with i915_gem_create_ioctl() vs 
drm_gem_object_alloc() for example) we should be able to do the in-kernel 
stuff w/o jumping through too many VFS/VM hoops.  That would also assume we 
don't care about swapping in the in-kernel case, which we don't; we want to 
pin the kernel allocated frame buffer and other memory anyway, so using the 
internal functions should be fine.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
