Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYJQSKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYJQSKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYJQSKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:10:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbYJQSKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:10:20 -0400
Date: Fri, 17 Oct 2008 14:10:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French" <smfrench@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: unlink behavior when file is open by
 other process
Message-ID: <20081017141013.3aecc88a@tleilax.poochiereds.net>
In-Reply-To: <524f69650810171041i57ab4466s8cecbdf0268f8417@mail.gmail.com>
References: <524f69650810170809u2df1a309o2f357dc8489c06c6@mail.gmail.com>
	<524f69650810170824x4f9ff975qb03d687c8d3557ff@mail.gmail.com>
	<20081017132714.111e33f9@tleilax.poochiereds.net>
	<524f69650810171041i57ab4466s8cecbdf0268f8417@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 12:41:07 -0500
"Steve French" <smfrench@gmail.com> wrote:

> On Fri, Oct 17, 2008 at 12:27 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > On Fri, 17 Oct 2008 10:24:29 -0500
> > "Steve French" <smfrench@gmail.com> wrote:
> >
> >> On Fri, Oct 17, 2008 at 10:09 AM, Steve French <smfrench@gmail.com> wrote:
> >> > Even when a file is open by another process, posix allows the file to
> >> > be deleted (the file is removed from the namespace and eventually the
> >> > data is removed from disk).   Unfortunately due to problems in some
> >> > NAS filers/servers this can be hard to implement, and I am not sure
> >> > what the "best" behavior is in that case.
> >
> > My argument is that the primary function of unlink() is to remove a
> > filename from the filesystem. If we return success from such a call
> > without actually having freed up that filename, then that's a bug. It's
> > unfortunate that some servers don't support the calls we need to make
> > this work all the time.
> The filename will be freed - and the trade off is which breaks fewer apps.
> Both open and unlink man pages list plausible return codes but I
> am worried that the sequence of file operations open/unlink/close
> (I think we see both dbench and connectathon do this IIRC)
> is as common a a sequence as open/unlink/create/close
> thus we could break more apps your way than leaving it as is.
> 

I think we have to shoot for mimicking POSIX as closely as we can. If
we can't do it, I don't think we have any option other than to return
error. We also have to consider that the existing behavior is racy and
unreliable. Suppose we have 2 processes:

Process 1		Process 2
======================================
creates file
			opens file
unlinks file
closes file
			closes file
creates file

So this will work against a server that doesn't support rename by
filehandle, but what happens if the second create comes in before
process 2 closes the file? The create will fail. The problem is that we
can't predict this. It all depends on the timing.

Someone may QA their application and have it work great, then all of a
sudden when they move to a big load, this sort of thing starts failing
because the timing has changed.

I would *much* prefer to have an application fail reliably than work 90%
of the time, and fail unpredictably the other 10%. Consistency is key.

> > We can't however make assumptions about what applications want. We
> > could, in principle, fix up the situation where a server does
> > open->unlink->create by truncating the old file and pretending that
> > it's a new one.
> That could corrupt data - the original opener may need that data up
> to the moment they close that handle.
> 

Good point, all the more reason not do this.

> > All we can reasonably do is try to have each syscall give us the
> > expected end result or an error if it can't be done.
> The open syscall is allowed to fail with ETXTBUSY (or even access
> denied among other).
> Although this type of situation is not common on open, it more common in
> open (and create) than on unlink and thus A likely that an app could deal with
> an open error than on the unlink that preceeded it.   The other argument
> here is that whether or not we allow unlink (when it can be marked for deletion
> but not silly renamed) - we have apps that will get the same error on open due
> to Windows, MacOS and other non-Linux clients setting the flag (ie open/create
> failures for a filename that was marked delete-on-close can still
> happen even if we aren't the
> ones who set the flag on the file since Windows and various other OS can and do
> set this file on the server or remotely)
> 
> 

Sure, I'm not disputing whether returning an error on open is right or
wrong. The problem is that it's not expected. We've just unlinked the
filename and returned success -- there is *no* reason that the create
should fail here. An application programmer will (rightfully) consider
this a bug.

Again, I think we have to try and mimic POSIX to the best of our
ability and just return error on anything else.
-- 
Jeff Layton <jlayton@redhat.com>
