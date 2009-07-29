Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZG2UJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZG2UJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZG2UJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:09:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbZG2UJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:09:22 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
In-Reply-To: <20090725002916.GB13556@shareable.org>
References: <1248466429.3567.82.camel@localhost>
	 <20090724224813.GK27755@shareable.org>
	 <1248479367.3567.133.camel@localhost>
	 <20090725002916.GB13556@shareable.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:07:50 -0400
Message-Id: <1248898070.2597.53.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 01:29 +0100, Jamie Lokier wrote:
> Eric Paris wrote:
> > But maybe I should jsut do the 'if you have fanotify open, you don't
> > create other fanotify events'...   so everyone gets what they expect...
> 
> O_NONOTIFY.  Similar security concerns, more control.
> 
> The security concern is clear: If you allow a process with fanotify
> open to not create events, then any (root) process can open a fanotify
> socket to hide it's behaviour.

Let me first say I'm not sure of how many useful 'security' goals can be
met using fanotify mainly because I haven't focused on any.  You can do
data integrity checking before access but I'm saying up front, malicious
programs can almost certainly sneak information across these checks.

The 'problem' is really strongly with the open and open_perm, but there
are problems with read_perm as well.  With just 2 groups listening to
'open' for the same file we get that infinite event loop as they each
see the open from the other listener as each listener opens an fd on the
object in question.  If both groups are listening to open_perm you
obviously have a deadlock....

The same applies if 2 fanotify groups need read_perm as they both may
need to block waiting for the decision of the other.

I have an easy solution to the 'open' problems, just don't fire the open
and open_perm events when it is fanotify doing the open.  I guess I
could use file->private_data when the fanotify listener does io on an
fanotify opened file to see if it was an fanotify opened fd and ignore
only those events....   I'll try this afternoon.

So really now I'm planning to only not send events to other fanotify
listeners which are on fanotify opened fds.

> Do I see right that you need to open the directory before you can set
> the mark on it?

Correct.  But unlike dnotify, you don't have to keep it open.

> The main reason behind inotify's design wasn't the API (although it is
> better than dnotify); it was to avoid having to open thousands of
> directories, and to allow a filesystem to be unmounted while it is
> being watched.

I could make fanotify_so_mark pathname rather than fd based.  But fd
based works very nicely in global mode as the fd you get in the event
metadata can be used in setting marks.

You need to open the directory so you have an fd, so you can set the
mark.  You can then close the directory.  If the directory is deleted,
your mark is gone (forever.)

> Does a fanotify mark stop a filesystem from being unmounted?  If not,
> if the filesystem is unmounted and remounted, is the mark lost?

No, it does not prevent unmounting.  Yes, if it is unmounted and
remounted the marks are lost forever.

-Eric

