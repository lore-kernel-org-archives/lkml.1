Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651AbXCEFXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbXCEFXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 00:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXCEFXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 00:23:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:18045 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbXCEFXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 00:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TC8QXLZUYGl2FKmjFobOOmDYQOfHqj4nSmCWYd7rIle1/IMYxFmSQ5bjJGBQ0yl9bh8s/T98os4JCJ0FShhx3XiR100F98T1GzJvefv9NzVZ+k/OpWeqRrrc7p4Nef4igC+ltEQCFC9U2KP6tqDs5AskoQrzPc5uKamSyfFu8WI=
Message-ID: <f2b55d220703042123l53403c12rac225189053e9a98@mail.gmail.com>
Date: Sun, 4 Mar 2007 21:23:40 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Kirk Kuchov" <kirk.kuchov@gmail.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Theodore Tso" <tytso@mit.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <82AD23D8-E5BE-4B69-A602-1B474EC0C4EA@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301131118.GA30228@elte.hu>
	 <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
	 <20070302081047.GA27122@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
	 <20070303100625.GA22557@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
	 <20070303203140.GA756@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
	 <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
	 <82AD23D8-E5BE-4B69-A602-1B474EC0C4EA@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> Well, even this far into 2.6, Linus' patch from 2003 still (mostly)
> applies; the maintenance cost for this kind of code is virtually
> zilch.  If it matters that much to you clean it up and make it apply;
> add an alarmfd() syscall (another 100 lines of code at most?) and
> make a "read" return an architecture-independent siginfo-like
> structure and submit it for inclusion.  Adding epoll() support for
> random objects is as simple as a 75-line object-filesystem and a 25-
> line syscall to return an FD to a new inode.  Have fun!  Go wild!
> Something this trivially simple could probably spend a week in -mm
> and go to linus for 2.6.22.

Or, if you want to do slightly more work and produce something a great
deal more useful, you could implement additional netlink address
families for additional "event" sources.  The socket - setsockopt -
bind - sendmsg/recvmsg sequence is a well understood and well
documented UNIX paradigm for multiplexing non-blocking I/O to many
destinations over one socket.  Everyone who has read Stevens is
familiar with the basic UDP and "fd open server" techniques, and if
you look at Linux's IP_PKTINFO and NETLINK_W1 (bravo, Evgeniy!) you'll
see how easily they could be extended to file AIO and other kinds of
event sources.

For file AIO, you might have the application open one AIO socket per
mount point, open files indirectly via the SCM_RIGHTS mechanism, and
submit/retire read/write requests via sendmsg/recvmsg with ancillary
data consisting of an lseek64 tuple and a user-provided cookie.
Although the process still has to have one fd open per actual open
file (because trying to authenticate file accesses without opening fds
is madness), the only fds it has to manipulate directly are those
representing entire pools of outstanding requests.  This is usually a
small enough set that select() will do just fine, if you're careful
with fd allocation.  (You can simply punt indirectly opened fds up to
a high numerical range, where they can't be accessed directly from
userspace but still make fine cookies for use in lseek64 tuples within
cmsg headers).

The same basic approach will work for timers, signals, and just about
any other event source.  Userspace is of course still stuck doing its
own state machines / thread scheduling / however you choose to think
of it.  But all the important activity goes through socketcall(), and
the data and control parameters are all packaged up into a struct
msghdr instead of the bare buffer pointers of read/write.  So if
someone else does come along later and design an ultralight threading
mechanism that isn't a total botch, the actual data paths won't need
much rework; the exception handling will just get a lot simpler.

Cheers,
- Michael
