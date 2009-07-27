Return-Path: <linux-kernel-owner+w=401wt.eu-S1751106AbZG0TYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbZG0TYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZG0TYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:24:04 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36935 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZG0TYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:24:03 -0400
Date: Mon, 27 Jul 2009 20:23:42 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090727192342.GA27895@shareable.org>
References: <1248466429.3567.82.camel@localhost> <20090724224813.GK27755@shareable.org> <1248479367.3567.133.camel@localhost> <20090725002916.GB13556@shareable.org> <20090727183354.GM4231@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727183354.GM4231@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> On Jul 25, 2009  01:29 +0100, Jamie Lokier wrote:
> > Eric Paris wrote:
> > > But maybe I should jsut do the 'if you have fanotify open, you don't
> > > create other fanotify events'...   so everyone gets what they expect...
> > 
> > O_NONOTIFY.  Similar security concerns, more control.
> > 
> > The security concern is clear: If you allow a process with fanotify
> > open to not create events, then any (root) process can open a fanotify
> > socket to hide it's behaviour.
> 
> I think the "fanotify doesn't generate more fanotify events" makes the
> most sense.  Given that the open will be done in the kernel specifically
> due to fanotify, this doesn't actually allow the listener to open files
> without detection (unlike the "O_NONOTIFY" flag would).  The fanotify
> "opens" would only be in response to other processes opening the file.

Nice idea (if I understand it) - the file descriptors opened by
fanotify wouldn't cause fanotify events?  Effectively having an
in-kernel O_NONOTIFY flag which can't be set from userspace?

'if you have fanotify open, you don't create other fanotify events' is
too severe - it means you can circumvent fanotify entirely for
everything your process does by just opening a fanotify socket and not
using it, which is clearly worse than having an O_NONOTIFY flag.

All ways to avoid creating fanotify events introduce security and
cache integrity problems though.

Why should processes which simply _watch_ the filesystem, without
modifying any files, ever fail to receive information about file
changes?  Why should they be unable to claim they provide integrity
guarantees because of the loophole?

So before we implement that loophole: let's ask ourselves if we really
need it at all.

What's wrong with fanotify-using applications generating events when
they modify files themselves?

An example was given where app A gets an event and modifies the file,
then app B gets an event and modifies the file, and app A... cycling.

But if you have two "virus checker" style applications fighting over
modifying the same file without locking, you have much bigger problems
already.  There's nothing to gain by fixing the fanotify cycle.

Maybe there's no need to suppress events after all.

Programs monitoring for writes to maintain caches or integrity checks
will be much happier if they know they're getting all file modifications.

-- Jamie
