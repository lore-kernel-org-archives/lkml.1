Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbXLMP3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbXLMP3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbXLMP3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:29:31 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49563 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXLMP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:29:29 -0500
Date: Thu, 13 Dec 2007 10:29:05 -0500
Message-Id: <200712131529.lBDFT5Ch025553@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hooanon05@yahoo.co.jp
Cc: Erez Zadok <ezk@cs.sunysb.edu>, hch@infradead.org, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [UNIONFS] 00/42 Unionfs and related patches review 
In-reply-to: Your message of "Mon, 10 Dec 2007 12:20:20 +0900."
             <E1J1ZBs-0006M0-VL@jroun> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Junjiro, thanks for your comments.  I am familiar with the issues and
techniques you mention below, and more.  To properly address your comments,
I had to explain some background before addressing each of your points.  So
my apologies in advance to everyone for the length of this reply.

When stackable file systems were first proposed in the early 90s, they were
nothing more than a research curiosity.  In 1994 I first came across them
and saw their premise as easing file system development.  In order to help
as many people actually use stackable file systems, I developed a set of
stackable f/s templates for several OSs (linux, bsd, and solaris), and
provided several working examples of how to use them (e.g., the older
"cryptfs").  One of my key criteria then was to make it as easy as possible
for people to use stackable file systems.  Therefore I avoided VFS changes
at all costs, even if it meant I had to copy-n-paste VFS code into the
stackable template, and hack it there, among other workarounds.  This was
difficult to do but necessary to promote greater use of stacking.  There
were many instances I wished I could have changed the VFS to better suit my
stacking needs (to be fair, several small patches made it into the 2.3.x
kernel thanks to Al).

Nearly 14 years later, I still maintain those "FiST" stackable templates,
but things are very different nowadays.  There's a greater awareness of
stackable file systems, Linux has one in mainline, and lots of others are in
use in commercial and research settings.  Therefore, this is a good time to
seriously consider VFS-level changes that can help to better support all
types of stackable file systems.

I believe that small VFS changes to help stackable file systems are
perfectly reasonable, and a good thing; and I'm working on such patches.
Conversely, I am very mindful of the VFS's complexity, so I also believe
that massive VFS changes are a bad thing; I want to avoid bloating the VFS
or de-stabilizing it just for the sake of stacking or any single stackable
f/s.  I am also concerned about not changing existing "lower" file systems
whatsoever, because they are well tested and stable.


In message <E1J1ZBs-0006M0-VL@jroun>, hooanon05@yahoo.co.jp writes:
> 
> Erez Zadok:
> > (1) Cache coherency: by far, the biggest concern had been around cache
> 	:::
> > unionfs.  The solution we have implemented is to compare the mtime/ctime of
> > upper/lower objects during revalidation (esp. of dentries); and if the lower
> > times are newer, we reconstruct the union object (drop the older objects,
> > and re-lookup them).  This time-based cache-coherency works well and is
> 	:::
> 
> The resolution of mtime/ctime may be too low since some filesystems sets
> them in unit of a second, which means you cannot detect the changes made
> within a second.
> I think it is better to use inotify for every directory while it
> consumes a little more resources.

Let's analyze the chance of this problem happening.  First, the vast
majority of time, users access files via the union.  Of the small fraction
of instances where users perform some operations on the lower branches
directly, the most common usage scenario is a large burst of activity
(people like to untar a package, copy a whole dir, etc.); such a large burst
of activity is very likely to cross the 1-second boundary or to at least
cause a change in the mtime/ctime.  Moreover, several file systems already
support sub-second granularity (so users have several options to choose
from).  So in my opinion, the chances are very slim that a large amount of
data changes will happen on a lower inode all within one second and not be
detected by our mtime/cite cache-coherency algorithms.

The 1-second granularity is a well known problem, which had bitten "make"
more and more over time, as CPUs and disks have been getting faster.
Consequently, there's been a push from many file system developers to
support higher-resolution timestamps.  This is happening gradually, and as
it happens, unionfs will automatically benefit from it.

Also, time-based cache coherency is a [sic] time-honored technique in NFS.
Users have gotten used to the fact that if they change something on the
server (i.e., the "layer" below the client), that those changes many not be
immediately visible on the client (esp. with heavy caching on the client).
So if it's been good enough for NFS for over two decades, I don't see a
compelling reason to complicate unionfs for a slim chance of detecting
changes that occur within one second.

Now, you propose fsnotify.  Fsnotify is a neat system, but I don't believe
it was designed with stackable file system inter-layer cache coherency in
mind.  It takes a fair amount of effort (e.g., amount of code) to register,
monitor, and de-register for notifications.  And I'm also not sure how well
it scales when one has to register for notifications on many thousands of
objects.  It seems to me that fsnotify is more suitable for user-level apps
which want to monitor a small number of objects.  Given the overheads and
complexity associated with using fsnotify, and the slim chance that
mtime/ctime won't be enough, I don't feel at this stage that the benefits of
using fsnotify are worth the complexity.

Right now my code to detect when a lower object has changed is very simple
and short: just one "if" statement to compare the corresponding inode
mtimes.  I'd like to keep things simple if at all possible.  Fundamentally,
all I need is ONE simple bit of information that will tell me that the upper
and lower inodes are no longer in sync.  Just one bit, not a whole complex
data structure with callbacks and bit-maps and such.

We're exploring few ideas to see how to implement this cleanly and simply
(some of which are based on our presentation at OLS'07).  One way we're
trying is to set a "stale" bit in the upper inode when the lower one
changes; another is to set a "dirty" bit in the lower inode that the upper
can check; another method we're testing is setting a "modification
generation counter" in stacked inode so that can be compared by a stacked
f/s.  As I've not looked at fsnotify recently, I'll also take a fresh look
at it and see if something lightweight and generic can be made available for
all stackable file systems.

> Additionally, if you implement vm_operations instead of
> struggling along address_space_operations or VFS patches, in order to
> share the mmap-ed memory pages between lower inode and unionfs inode,
> then most of issues will be gone.

What you propose violates the clean layer separation in a way that I'm not
too comfortable with (even if it works for you :-) I believe stackable file
system layers should exhibit as clear a separation of layers as possible
(esp. once people begin stacking more than two layers together).  This layer
separation tends to be the safer approach and also makes it easier to
maintain and debug multiple layers.

Over the years we've explored various layering methodologies to try and
trade off code size/complexity vs. performance.  In a normal stackable file
system, each struct file/dentry/inode has a corresponding lower object.  Our
FiST templates for Linux include an extra mode---called "fist lite"---which
saves on inodes and pages by having BOTH the upper and lower dentry point to
the lower inode.  This saves memory (shared pages) and reduces layering
overhead (but you can't intercept mmap ops, which some stackable f/s like to
do).  The cost of such trick is violating the clean layering separation: a
dentry of the upper file system now points to an inode (via dentry->d_inode)
of the lower file system!  To me, this is dangerous in the long run because
objects from one layer can be "leaked" to another layer, with potentially
disastrous results.

What you propose above with vm_operations requires a sequence of operations
in the vm->fault operation which looks like:

	saved_file = vma->vm_file;
	vma->vm_file = hidden_file;
	call the lower ->fault op passing it the modified vma
	vma->vm_file = saved_file;

We've done something different to achieve a similar goal, in an experimental
version of wrapfs (our "pass-through" layer in FiST).  In the address_space
ops, we wanted to share the upper/lower pages, but since the
page->mapping->host points to our inode, we temporarily overrode it:

	saved_inode = page->mapping->host;
	page->mapping->host = lower_inode;
	call lower f/s ->writepage with upper "fixed up" page
	page->mapping->host = saved_inode;

Even if both of these techniques work (and they do, at least in limited
testing I've done), there is something very unpleasant about having to
temporarily override a field's value, then fix it again, after coming back
from calling the lower op.  Aside from the uncleanliness of this kind of
technique, it can seriously lead to races and other data corruptions when/if
the temporarily-fixed fields "leak" outside the current code.  (I have a
strong feeling that several kernel developers might vomit in disgust if I
dared to submit such hacky patches to unionfs... :-)

To me, any time such a hack has to be employed, it tells me that there's
something wrong with the API in question.  And so I'd much rather see the
API fixed The Right Way[tm], than promote such potentially unsafe practices.
Consequently, in unionfs I take a safer, more conservative approach and
avoid any such cute by potentially dangerous hacks.

> But I am afraid the approach sharing memory pages will not be avaiable
> for ecryptfs.

Agreed.  Although my focus in recent times had been on unionfs, I'm also
looking ahead to a day when linux might have several stackable file systems.
As such, I'd like to consider developing and contributing VFS techniques
that will work for many/all stackable file systems, in a clean manner that
the VFS+MM maintainers will like.

> Junjiro Okajima

Sincerely,
Erez.
