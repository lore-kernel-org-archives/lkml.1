Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZCaJ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZCaJ7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZCaJ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:58:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:47729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZCaJ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:58:51 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Tue, 31 Mar 2009 20:58:50 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18897.59738.288956.245513@notabene.brown>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: message from Theodore Tso on Friday March 27
References: <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
	<20090327161553.31436545@lxorguk.ukuu.org.uk>
	<20090327162841.GA26860@srcf.ucam.org>
	<20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	<20090327170208.GA27646@srcf.ucam.org>
	<20090327171955.78662c1e@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
	<20090327190339.GW6239@mit.edu>
	<20090327191426.3d478b6b@lxorguk.ukuu.org.uk>
	<20090327193249.GY6239@mit.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday March 27, tytso@mit.edu wrote:
> On Fri, Mar 27, 2009 at 07:14:26PM +0000, Alan Cox wrote:
> > > Agreed, we need a middle ground.  We need a transition path that
> > > recognizes that ext3 won't be the dominant filesystem for Linux in
> > > perpetuity, and that ext3's data=ordered semantics will someday no
> > > longer be a major factor in application design.  fbarrier() semantics
> > > might be one approach; there may be others.  It's something we need to
> > > figure out.
> > 
> > Would making close imply fbarrier() rather than fsync() work for this ?
> > That would give people the ordering they want even if they are less
> > careful but wouldn't give the media error cases - which are less
> > interesting.
> 
> The thought that I had was to create a new system call, fbarrier()
> which has the semantics that it will request the filesystem to make
> sure that (at least) changes that have been made data blocks to date
> should be forced out to disk when the next metadata operation is
> committed.

I'm curious about the exact semantics that you are suggesting.
Do you mean that
 1/ any data block in any file will be forced out before any metadata
    for any file? or
 2/ any data block for 'this' file will be forced out before any
    metadata for any file? or
 3/ any data block for 'this' file will be forced out before any 
    metadata for this file?

I assume the contents of directories are metadata.  If 3 is that case
do we included the metadata of any directories known to contain this
file?  Recursively?

I think that if we do introduce new semantics, they should be as weak
as possibly while still achieving the goal, so that fs designers have
as much freedom as possible.  It should also be as expressive as
possible so that we don't find we want to extend it later.

What would you think of:
   fcntl(fd, F_BEFORE, fd2)

with the semantics that it sets up a transaction dependency between fd
and fd2 and more particularly the operations requested through each
fd.

So if 'fd' is a file, and 'fd2' is the directory holding that file,
then
   fcntl(fd, F_BEFORE, fd2)
   write(fd, stuff)
   renameat(fd2, 'file', fd2, 'newname')

would ensure that the writes to the file were visible on storage
before the rename.
You could also do
   fd1 = open("afile", O_RDWR);
   fd2 = open("afile", O_RDWR);
   fcntl(fd1, F_BEFORE, fd2);

then use write(fd1) to write journal updates to one part of the
(database) file, and write(fd2) to write in-place updates,
and it would just "do the right thing". (You might want to call
fcntl(fd2, F_BEFORE, fd1) as well ... I haven't quite thought through
the details of that yet).

If you gave AT_FDCWD as the fd2 in the fcntl, then operations on fd1
would be ordered before any namespace operations which did not specify a
particular directory, which would be fairly close to option 2 above.

A minimal implementation could fsync fd1 before allowing any operation
on fd2.  A more sophisticated implementation could record set up
dependencies in internal data structures and start writeout of the fd1
changes without actually waiting for them to complete.


Just a thought....

NeilBrown
