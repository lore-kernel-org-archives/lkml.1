Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYJBT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYJBT0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYJBT0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:26:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbYJBT0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:26:02 -0400
Subject: Re: [RFC] 0/11 fanotify: fscking all notifiction and file access
	system (intended for antivirus scanning and file indexers)
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       arjan@infradead.org, bunk@kernel.org, tytso@mit.edu,
       tvrtko.ursulin@sophos.com, david@lang.hm, hch@infradead.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, peterz@infradead.org,
       Jonathan.Press@ca.com, riel@redhat.com, greg@kroah.com
In-Reply-To: <20080926223404.7c4894df@lxorguk.ukuu.org.uk>
References: <1222463220.2872.193.camel@localhost.localdomain>
	 <20080926223404.7c4894df@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 15:24:51 -0400
Message-Id: <1222975491.28251.202.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 22:34 +0100, Alan Cox wrote:

> The two discussions are fortunately orthogonal. Is there any reason you
> can't use the socket based notification model - that gives you a much
> more natural way to express the thing
> 
> 
> 		socket
> 		bind(AF_FAN, group=foo+flags etc, PF_FAN);
> 
> 		fd = accept(old_fd, &addr[returned info])
> 
> 		close(fd);
> 
> as well as fairly natural and importantly standards defined semantics for
> poll including polling for a new file handles, for reconfiguration of
> stuff via get/setsockopt (which do pass stuff like object sizes unlike
> ioctls) and for reading/writing data.

An hour, a whiteboard, 3 other hackers and I think I have a handle on
something you might like a little more.

groups will be 'created' when you call bind().  the struct sockaddr will
include a priority and an event mask.  Group names will be eliminated
since priorities must be unique.  Two processes will be allowed to
bind() to the same priority if the mask is the same.  Those will be
considered to be in the same 'group.'

groups will be destroy when ALL fd's associated with that group are
closed.

calling accept() on the socket from bind will return a new fd.  This fd
will be created in the kernel using dentry_open() (just like i do it
today) only I will then try to overload and bastardize the new file to
add additional support so that this it will allow sendmsg() with flags =
MSG_OOB or setsockopt().  I'll also present an alternative below.

the struct sockaddr from the accept() will be filled with a something
like

struct fan_sockaddr {
	int version;
	unsigned int mask;
	pid_t pid;
	pid_t tgid;
	int f_flags;
}

so this will be a binary interface for metadata.  Sending the metadata
about the open fd up the sockaddrs is very slick, but not easily
extended that I can see.  Guess we need to get the metadata right the
first time.

One way to do responses from the listeners (like access decisions and
fastpath entries) would be by sending a message back down the new fd
using sendmsg(MSG_OOB).  The PF_FAN 'stuff' should be able to get this
message and do its magic.  I don't have a format for this message
thought up.  Maybe __u32 len, __u32 version, do whatever.  Maybe people
would prefer I bastardize on setsockopts() for this new fd send to the
listener?  Alternative still to come...

Some operations a listener program might want to do may not be
associated with an event.  This might include flushing all fastpaths on
a definitions update or preemptively adding a fastpath entry for an fd.
I suggest calling connect() on the bound fd to connect to the kernel
PF_FAN system.  This new fd from connect can then take commands using
either sendmsg() or setsockopt() or really anything since it doesn't
have a 'real file' on the backend.

Is this reasonable?  I don't even know the technical hurdles I'm going
to get trying to take a regular file that would pass S_ISREG and adding
on sendmesg() or setsockopt().

So the alternative would be that I could make ALL listener->kernel
communication go over the fd that came from connect().  Setting a
fastpath would be something like

setsockopt(connect_fd, FAN_LEVEL, fastpath_val, fastpath_struct, len);

with fastpath_struct something like

struct fastpath {
	int fd;
	unsigned int mask
}

Where fd was a currently open fd in the listener process that the
fastpath was intended to be applied to.  If I'm using a fd from connect
I can really use any method I want but setsockopt() seems nice since it
includes types and lens.  Is is it bad to have a fd whose only
implemented function is setsockopt?

-Eric

