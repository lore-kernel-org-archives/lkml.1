Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZG1SAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZG1SAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZG1SAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:00:20 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57365 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZG1SAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:00:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Tue, 28 Jul 2009 11:59:02 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: fanotify - overall design before I start sending patches
In-reply-to: <20090727192342.GA27895@shareable.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
Message-id: <20090728175902.GY4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1248466429.3567.82.camel@localhost>
 <20090724224813.GK27755@shareable.org> <1248479367.3567.133.camel@localhost>
 <20090725002916.GB13556@shareable.org>
 <20090727183354.GM4231@webber.adilger.int>
 <20090727192342.GA27895@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 27, 2009  20:23 +0100, Jamie Lokier wrote:
> Andreas Dilger wrote:
> > I think the "fanotify doesn't generate more fanotify events" makes the
> > most sense.  Given that the open will be done in the kernel specifically
> > due to fanotify, this doesn't actually allow the listener to open files
> > without detection (unlike the "O_NONOTIFY" flag would).  The fanotify
> > "opens" would only be in response to other processes opening the file.
> 
> Nice idea (if I understand it) - the file descriptors opened by
> fanotify wouldn't cause fanotify events?  Effectively having an
> in-kernel O_NONOTIFY flag which can't be set from userspace?

Right.

> 'if you have fanotify open, you don't create other fanotify events' is
> too severe - it means you can circumvent fanotify entirely for
> everything your process does by just opening a fanotify socket and not
> using it, which is clearly worse than having an O_NONOTIFY flag.

That isn't what I meant...  It was only "operations on fanotify file
descriptors don't produce further fanotify events", otherwise madness
ensues.

> What's wrong with fanotify-using applications generating events when
> they modify files themselves?
> 
> An example was given where app A gets an event and modifies the file,
> then app B gets an event and modifies the file, and app A... cycling.
> 
> But if you have two "virus checker" style applications fighting over
> modifying the same file without locking, you have much bigger problems
> already.  There's nothing to gain by fixing the fanotify cycle.

I don't think they are fighting over modifying the file, they are
generating an endless stream of events for each other to process.
I don't think locking will help.

It's the same as e.g. having verbose kernel debug messages related
to filesystem/block IO going to /var/log/messages on the filesystem
you are monitoring.  After the first (external) IO, it is logged
to disk, which causes an IO to the filesystem, which is logged to
disk, which causes an IO...

There has to be some way to NOT generate any events on the files
that you are monitoring.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

