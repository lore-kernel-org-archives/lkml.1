Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZGYA3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZGYA3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 20:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZGYA33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 20:29:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42186 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZGYA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 20:29:29 -0400
Date: Sat, 25 Jul 2009 01:29:16 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090725002916.GB13556@shareable.org>
References: <1248466429.3567.82.camel@localhost> <20090724224813.GK27755@shareable.org> <1248479367.3567.133.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248479367.3567.133.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> But maybe I should jsut do the 'if you have fanotify open, you don't
> create other fanotify events'...   so everyone gets what they expect...

O_NONOTIFY.  Similar security concerns, more control.

The security concern is clear: If you allow a process with fanotify
open to not create events, then any (root) process can open a fanotify
socket to hide it's behaviour.

> >    - No file name for things that happen in a subdirectory.
> 
> Actually I should be more clear about that.  If you call
> setsockopt(FANOTIFY_ADD_MARK) where
> 
> struct fanotify_so_inode_mark {
>         __s32 fd;	= "/tmp/"
>         __u32 mask;	= (FAN_OPEN | FAN_EVENT_ON_CHILD);
>         __u32 ignored_mask; = 0
> };
> 
> and someone opens /tmp/file1 you are going to get an open fd
> for /tmp/file1 NOT for /tmp.  This is different than inotify.

If you inotify for IN_OPEN on /tmp, it would return an event when you
open /tmp/file1, with the name "file1" and the directory /tmp.  It's
no so different.  The main difference is inotify returns a name and no
inode number (so it's racy, sigh), whereas fanotify returns an open file.

Do I see right that you need to open the directory before you can set
the mark on it?

The main reason behind inotify's design wasn't the API (although it is
better than dnotify); it was to avoid having to open thousands of
directories, and to allow a filesystem to be unmounted while it is
being watched.

Does a fanotify mark stop a filesystem from being unmounted?  If not,
if the filesystem is unmounted and remounted, is the mark lost?

-- Jamie
