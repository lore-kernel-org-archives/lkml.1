Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZAXDud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZAXDud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 22:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZAXDuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 22:50:24 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52245 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbZAXDuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 22:50:23 -0500
Date: Sat, 24 Jan 2009 14:50:07 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Greg KH <gregkh@suse.de>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090124035006.GA8051@brong.net>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123170631.GB11566@suse.de>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 09:06:31AM -0800, Greg KH wrote:
> On Fri, Jan 23, 2009 at 08:47:45PM +1100, Bron Gondwana wrote:
> > On Thu, 22 Jan 2009 21:16 -0800, "Greg KH" <gregkh@suse.de> wrote:
> > > 
> > > I would suggest just changing this default value then, it's a simple
> > > userspace configuration item, and for your boxes, it sounds like a
> > > larger value would be more suitable.

If everyone, or every distribution at least, has to change it then the
default is probably wrong.  The error message in the postfix logs didn't
immediately point me at the issue, especially since I tried debugging on
one of our "production" mxes, only to discover that the epoll limit
didn't exist there.  They're slightly behind in kernel versions.

> > I guess Postfix is a bit of an odd case here.   It runs lots of 
> > processes, yet uses epoll within many of them as well - sort of 
> > a historical design in some ways, but also to enforce maximum 
> > privilege separation with many of the daemons able to
> > be run under chroot with limited capabilities.
> > 
> > So I guess I have a few questions left:
> > 
> > 1) is this value ever supposed to be hit in practice by 
> >    non-malicious software? If not, it appears 128 is too low.
> 
> It does appear a bit low.  What looks to you like a good value to use as
> a default?

This thread suggests that it's not just postfix having the issue, and
offers 1024 as a saner default:

http://www.mail-archive.com/fedora-kernel-list@redhat.com/msg01618.html

There's also a Russian thread that pointed me at this patch in the first
place, and another place that suggested 1024 as well.  Seems "the
cloud"[tm] is converging on 1024.
 
> > 2) if we're going to stick with 128, is there any way to query 
> >    the kernel as to how close to the limit it's getting?  As an 
> >    example, our system checks poll /proc/sys/fs/file-max every
> >    2 minutes, and warn us if its getting "full".
> 
> Good idea, we should report this somewhere for the very reasons you
> suggest.  Can you write up a patch to do this?  If not, I'll see what I
> can do.

I'll have a look at it.  There are two main choices I think - either one
file with just the "max", or some data view that shows all the users'
counts.  It looks like it will have to enumerate the user list anyway.
(I've been poking around in kernel/user.c.  Looks like a
hlist_for_each_entry on uidhash_table will do the trick.  I'm guessing
we only want to display the value for the current user_ns anyway.  I
don't really understand the user namespacing stuff, since I've never
used it)

Most of all I'm interested in this because if it's a good way to
actually have some viable statistics on what the default vaule 
should be.

Bron ( still learning my way around the kernel - I've only written one
       patch before, and it had a lot of babysitting from Linus! )
