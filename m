Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYDLEEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYDLEEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 00:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbYDLEEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 00:04:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYDLEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 00:04:05 -0400
Date: Fri, 11 Apr 2008 21:03:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Thomas Graf <tgraf@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
Message-Id: <20080411210316.6e385236.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804111425290.32624@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	<Pine.LNX.4.64.0802261218230.8490@raven.themaw.net>
	<20080227211723.d5d27c09.akpm@linux-foundation.org>
	<1204302250.19890.22.camel@raven.themaw.net>
	<Pine.LNX.4.64.0804111425290.32624@raven.themaw.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 15:02:39 +0800 (WST) Ian Kent <raven@themaw.net> wrote:

> On Sat, 1 Mar 2008, Ian Kent wrote:
> 
> > 
> > On Wed, 2008-02-27 at 21:17 -0800, Andrew Morton wrote:
> > > On Tue, 26 Feb 2008 12:23:55 +0900 (WST) Ian Kent <raven@themaw.net> wrote:
> > > 
> > > > Hi Andrew,
> > > > 
> > > > Patch to add miscellaneous device to autofs4 module for
> > > > ioctls.
> > > 
> > > Could you please document the new kernel interface which you're proposing? 
> > > In Docmentation/ or in the changelog?
> > > 
> > > We seem to be passing some string into a miscdevice ioctl and getting some
> > > results back.  Be aware that this won't be a terribly popular proposal, so
> > > I'd suggest that you fully describe the problem which it's trying to solve,
> > > and how it solves it, and why the various alternatives (sysfs, netlink,
> > > mount options, etc) were judged unsuitable.
> > 
> > It appears I could do this with the generic netlink subsystem.
> > I'll have a go at it.
> > 
> 
> I've spent several weeks on this now and I'm having considerable 
> difficulty with the expire function.
> 
> First, I think using a raw netlink implementation defeats the point of 
> using this approach at all due to increased complexity. So I've used the 
> generic netlink facility and the libnl library for user space. While the 
> complexity on the kernel side is acceptable that isn't the case in user 
> space, the code for the library to issue mount point control commands has 
> more than doubled in size and is still not working for mount point 
> expiration.  This has been made more difficult because libnl isn't 
> thread safe, but I have overcome this limitation for everything but 
> the expire function, I now can't determine whether the problem I have with 
> receiving multicast messages, possibly out of order, on individual 
> netlink sockets opened specifically for this purpose, is due to this or is 
> something I'm doing wrong.
> 
> The generic netlink implementation allows only one message to be in flight 
> at a time. But my expire selects an expire candidate (if possible), sends 
> a request to the daemon to do the umount, obtains the result status and 
> returns this as the result to the original expire request. Consequently, I 
> need to spawn a kernel thread to do this and return, then listen for the
> matching multicast message containing the result. I don't particularly 
> like spawning a thread to do this because it opens the possibility of 
> orphaned threads which introduces other difficulties cleaning them up if 
> the user space application goes away or misbehaves. But I'm also having 
> problems catching the multicast messages. This works fine in normal 
> operation but fails badly when I have multiple concurrent expires 
> happening, such as when shutting down the daemon with several hundred 
> active mounts. I can't avoid the fact that netlink doesn't provide the 
> same functionality as the ioctl interface and clearly isn't meant to.

Gee, it sounds like you went above and beyond the call there.

The one-message-in-flight limitation of genetlink is suprising - one would
expect a kernel subsystem (especially a networking one) to support
queueing.  I guess it was expedient and the need had not arisen.

> So, the question is, what are the criteria to use for deciding that a 
> netlink based implementation isn't appropriate because I think I'm well 
> past it now?
> 
> Comments please.

Do I recall correctly in remembering that your original design didn't
really add any _new_ concepts to autofs interfacing?  That inasmuch as
the patch sinned, it was repeating already-committed sins?

And: you know more about this than anyone else, and you are (now) unbiased
by the presence of existing code.  What's your opinion?
