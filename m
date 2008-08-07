Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYHGAps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYHGAps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYHGApj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:45:39 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:56584 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751598AbYHGApi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:45:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=s3BfiVyf7o4PZarbZwuWakKN8VowrjzWMZHJN4MnQtOPTAmMtKQiqfxfSjveCMSQ77RGQE390mWUhOuD8OSkPrOpntJN7MZjPpMYu19jgzW2xUYT/uMHVm1+9h463hrQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Wed, 6 Aug 2008 17:45:31 -0700
User-Agent: KMail/1.9.9
Cc: Keith Packard <keithp@keithp.com>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <1217887116.24714.118.camel@koto.keithp.com> <200808051443.11858.nickpiggin@yahoo.com.au>
In-Reply-To: <200808051443.11858.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061745.31594.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 4, 2008 9:43 pm Nick Piggin wrote:
> On Tuesday 05 August 2008 07:58, Keith Packard wrote:
> > On Mon, 2008-08-04 at 19:02 +1000, Nick Piggin wrote:
> > > > I suppose we could have user space allocate the shmem file (either
> > > > via tmpfs or sysv ipc). tmpfs suffers from the maxfd issue, while
> > > > sysv ipc runs up against the SHMMAX value.
> > >
> > > This is how I'd suggested it work as well. I think a little bit
> > > more effort should be spent looking at making this work.
> >
> > Well, I've spent a day thinking about using existing user-space APIs to
> > get at shmem files. While it's nice that we've discovered a
> > filesystem-independent mechanism to pin file pages, we haven't found
> > anything similar for creating the files. In particular, what I want is:
> >
> >  1) Anonymous files backed by swap
> >  2) Freed when the last process using them exits
> >  3) That never appear in the file system
> >  4) Do not consume a low FD (yeah, I know, rewrite the desktop)
> >
> > So, what I could do is
> >
> > 	char	template[] = "/dev/shm/drm-XXXXXX";
> > 	int	fd;
> > 	fd = mkstemp (template);
> > 	unlink (template);
> > 	ftruncate (fd, size)
> > 	object = drm_create_an_object_for_a_file (fd);
> > 	close (fd);
> >
> > While I haven't written any code yet, this should work and will even be
> > compatible with my current user-space API. I have to create a DRM object
> > for the file in any case, and so I don't need to hold onto the fd.
> > Releasing the fd also eliminates any ulimit issues.
> >
> > The drm_create_an_object_for_a_file call could return another fd. But,
> > note that the original shmem fd has no real value to the application in
> > this case.
> >
> > I can imagine other cases where mapping non-shmem files would make sense
> > though, in particular it's fairly easy to envision mapping an image file
> > to the GTT and having the graphics process decode and display it without
> > any additional copies. I think this demonstrates the potential utility
> > of the general file mapping operation.
> >
> > But, I'd like to have you reconsider whether it makes sense for user
> > space to go through the above dance to create anonymous shared objects
> > when the kernel already supports precisely the desired semantics and
> > even exposes them to the ipc/shm implementation.
>
> In my opinion, doing this little song and dance (which is a few lines
> of quite well defined APIs, btw) in userspace is preferable to adding
> a single line or exporting a single function in kernel space. Unless
> there is a better reason than eliminating a few lines of userspace code.
>
> I'm absolutely not against exporting a nice API for a swappable, object
> based memory allocator using ipc or shm to the wider kernel (with a nice
> API rather than just using shmem functions directly of course). But the
> fact that most or all of this seems to be able to be done in userspace
> just tells me that's where it should be prototyped first. It adds
> nothing to maintainence costs of the kernel code, and might actually be
> helpful to show some shortcomings of our user API definition or
> implementation.

Yeah, I like this approach too, but to echo what Keith & Dave already 
mentioned, it would make the in-kernel aspect of things much more difficult 
(without abusing VFS calls from within the kernel anyway).

It's not just the low level gfx libraries that need to create, map, operate 
on, and wait for objects.  The kernel also needs to create objects and map 
them at the very least (hopefully we can avoid most of the other stuff inside 
the kernel).

It seems like that's hard to do without duplicating big chunks of shmem.c.  
Any suggestions, Nick or Christoph?

I'm trying to think of analogues in other kernel subsystems, but the best I 
can come up with is shmem. :)  Some of the cluster fabric cards have similar 
issues (wanting to pin/map/unmap memory, and manage on-board IOMMUs) but I 
think gfx may be different in that it tends to use large chunks of memory for 
long periods of time; and even when a given GPU program is done with a piece 
of memory, the very next program run is likely to need it again.  And I think 
the in-kernel requirements in this case are fairly unique.

Jesse
