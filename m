Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZAECOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZAECOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZAECOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:14:09 -0500
Received: from mail2.shareable.org ([80.68.89.115]:52123 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZAECOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:14:08 -0500
Date: Mon, 5 Jan 2009 02:13:58 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: tux3@tux3.org, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Message-ID: <20090105021357.GA1345@shareable.org>
References: <200812301935.49303.phillips@phunq.net> <20090104031733.GB20929@shareable.org> <20090104130446.GA17558@mit.edu> <200901041710.12435.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901041710.12435.phillips@phunq.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> > Arguably you want to do this in the VFS layer, not in the low-level
> > filesystem level if you want most applications to adopt it.
> 
> It has to be generic all right, but the VFS is not able to do the job
> on its own.  To be useful for indexing, the reported events must
> already be persistently recorded, and the VFS has no idea about when
> that happens.  The filesystem is the expert on that subject, and it
> must generate the events.  I can't imagine a reasonable VFS-level
> emulation, or what value the VFS would add by acting as middleman for
> a stream of filesystem events.

The VFS does have a some helpful generic support for quotas, although
it also requires filesystem-specific help.  This is quite similar.

I see what you mean about knowing when an event reaches _persistent_
storage.  To be accurate, the event log must be folded into the
filesystem's transaction/commit model (including right use of barriers
etc.), and during journal/equivalent recovery, and fsck repair, the
event log must err on the side of too many rather than too few events.
(Or have a "rescan everything needed" event.)

An event log does not have to be _entirely_ accurate to be useful for
things like security scanning and indexing.  It is enough that it errs
on the side of recording a few too many, causing a few more app level
checks.

On the other hand, when used for an audit trail, you never want extra
events to be logged.

It seems to me whatever transaction/commit support is needed for event
logging is similarly needed for accurate quotas.

I've read that sometimes quotas get out of sync with the real amount
of user data stored on some filesystems, and then need to be
recalculated with a filesystem scan.  If true, this is unfortunate.

> The natural way to do this is for the filesystem to stream events
> directly to the monitoring application over a pipe-like fd.  Maybe a
> library for event delivery could be shared by filesystems, to impose
> a standard format.  The role of the VFS would be simply to set up the
> event connection, or to report that it is not supported.

There was an extension to inotify posted a few months ago to do this.
Additional events when something becomes persistent.

> An event stream accurate enough to support indexing is a considerably
> harder problem, I think.

No really.  It's enough if an indexer can efficiently find all changed
files since it was last running.  That doesn't have to be an accurate
event stream.  For example, simply having xattrs
"user.scanned.indexer_app_name" automatically deleted whenever the
file is modified, and recursively doing the same to parent
directories, would be enough in most cases.  Not for hard links,
obviously, but indexers can treat those separately and detect them by
link count.

There's one other application which needs *really accurate* event
notification delivery.  That is, anything which caches the result of
reading one or more files (such as for example compiling a script and
its dependencies to an internal representation in memory or into
another disk file), but where the caching must be *absolutely*
reliably invalidated at the time it's checked so that the behaviour is
guaranteed identical to not caching.

That kind of app needs to be able to say "are there any change events
pending since I last looked?" efficiently for many files (e.g. inotify
is ok, 1 syscall for many files), but with the guarantee that when the
answer is "no change events", calling read() and stat() on all the
files really would see no changes.  Networked inotify does not
guarantee this, because event reception is delayed.

-- Jamie
