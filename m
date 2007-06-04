Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXFDQ0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXFDQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbXFDQ0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:26:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:45351 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbXFDQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o39VJjCwzEqlu38Xw1pzEw32q2DUUJ3MEjwp5nJJ52MThOY9aS+fZFnEYgMW3HYpH+dVY8WSghi9aYY47DHcHCA6GnMP0MkkGcRucVyrpKny0cHF0hZXE5lDFI3sISMO8JkPgdzrOhmcHyakL2BWjNOJkjZoZHRGczNrsHcSFF0=
Message-ID: <e7ca40f70706040926i737cc0dax3f35d89e9fb0104f@mail.gmail.com>
Date: Mon, 4 Jun 2007 12:26:16 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: slow open() calls and o_nonblock
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e7ca40f70706040859g323d813fy3d7e741de8f190dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <e7ca40f70706040720k48aae8efg7a4997ce1d6f2450@mail.gmail.com>
	 <1180971726.17737.36.camel@heimdal.trondhjem.org>
	 <e7ca40f70706040859g323d813fy3d7e741de8f190dc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, lets see if I can summarize this more generically... I
realize I'm suggesting something that probably would be a massive
undertaking, but ..

Regular files are the only interface that requires an application to
wait.  With any other case, the nonblocking interfaces are fairly
complete and easy to work with.  If userspace could treat regular
files in the same fashion as sockets, life would be good.

I admittedly do not understand internal kernel semantics in the
differences between a socket and a regular file.  Why couldn't we just
have a different 'socket type' like PF_FILE or something like this?

Abstracting any IO through the existing interfaces provided to sockets
would be ideal from my perspective.  The code required to use a file
through these interfaces would be more complex in userspace, but the
abstraction of the current open() itself could simply be an aggregate
of these interfaces without a nonblocking flag.

It would, however, fix problems around issues with event-based
applications handling events from both disk and sockets.  I can't
trigger disk read/write events in the same event handlers I use for
sockets (ie, poll or epoll).  I end up having two separate event
handlers - one for disk (currently using glibc's aio thread kludge),
and one for sockets.

I'm sure this isn't a new idea.  Coming from my own development
backround that had little to do with disk, I was actually surprised
when I first discovered that I couldn't edge-trigger disk IO through
poll().

Thoughts, comments?

-Aaron

On 6/4/07, Aaron Wiebe <epiphani@gmail.com> wrote:
> On 6/4/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> >
> > So exactly how would you expect a nonblocking open to work? Should it be
> > starting I/O? What if that involves blocking? How would you know when to
> > try again?
>
> Well, theres a bunch of options - some have been suggested in the
> thread already.  The idea of an open with O_NONBLOCK (or a different
> flag) returning a handle immediately, and subsequent calls returning
> EAGAIN if the open is incomplete, or ESTALE if it fails (with some
> auxiliary method of getting the reason why it failed) are not too far
> a stretch from my perspective.
>
> The other option that comes to mind would be to add an interface that
> behaves like sockets - get a handle from one system call, set it
> nonblocking using fcntl, and use another call to attach it to a
> regular file.  This method would make the most sense to me - but its
> also because I've worked with sockets in the past far far more than
> with regular files.
>
> The one that would take the least amount of work from the application
> perspective would be to simply reply to the nonblocking open call with
> EAGAIN (or something), and when an open on the same file is performed,
> the kernel could have performed its work in the background.  I can
> understand, given the fact that there is no handle provided to the
> application, that this idea could be sloppy.
>
> I'm still getting caught up on some of the other suggestions (I'm
> currently reading about the syslets work that Zach and Ingo are
> doing), and it sounds like this is a common complaint that is being
> addressed through a number of initiatives.  I'm looking forward to
> seeing where that work goes.
>
> -Aaron
>
