Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZAHCv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZAHCv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZAHCvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:51:17 -0500
Received: from phunq.net ([64.81.85.152]:46811 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbZAHCvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:51:16 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Wed, 7 Jan 2009 18:50:59 -0800
User-Agent: KMail/1.9.5
Cc: tux3@tux3.org, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <200901041710.12435.phillips@phunq.net> <20090105021357.GA1345@shareable.org>
In-Reply-To: <20090105021357.GA1345@shareable.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901071850.59565.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

On Sunday 04 January 2009 18:13, Jamie Lokier wrote:
> Daniel Phillips wrote:
> > > Arguably you want to do this in the VFS layer, not in the low-level
> > > filesystem level if you want most applications to adopt it.
> > 
> > It has to be generic all right, but the VFS is not able to do the job
> > on its own.  To be useful for indexing, the reported events must
> > already be persistently recorded, and the VFS has no idea about when
> > that happens.  The filesystem is the expert on that subject, and it
> > must generate the events.  I can't imagine a reasonable VFS-level
> > emulation, or what value the VFS would add by acting as middleman for
> > a stream of filesystem events.
> 
> The VFS does have a some helpful generic support for quotas, although
> it also requires filesystem-specific help.  This is quite similar.

If the VFS stored the index on the filesystem then it would be similar,
but I don't think anybody will like the idea of the VFS operating an
indexer in-kernel.  Given that the indexer is maintained by user space,
the kernel's job is just to deliver the events the user space indexer
needs, which is a very different activity pattern from the generic quota
file scheme.

> I see what you mean about knowing when an event reaches _persistent_
> storage.  To be accurate, the event log must be folded into the
> filesystem's transaction/commit model (including right use of barriers
> etc.), and during journal/equivalent recovery, and fsck repair, the
> event log must err on the side of too many rather than too few events.
> (Or have a "rescan everything needed" event.)
> 
> An event log does not have to be _entirely_ accurate to be useful for
> things like security scanning and indexing.  It is enough that it errs
> on the side of recording a few too many, causing a few more app level
> checks.

Suppose a file delete event is sent, the external indexer dutifully
deletes its index entry for the file, then the machine crashes without
completing the delete transaction.  On reboot, the file still exists
but it has leaked from the index.  Ideas?

> On the other hand, when used for an audit trail, you never want extra
> events to be logged.
> 
> It seems to me whatever transaction/commit support is needed for event
> logging is similarly needed for accurate quotas.
> 
> I've read that sometimes quotas get out of sync with the real amount
> of user data stored on some filesystems, and then need to be
> recalculated with a filesystem scan.  If true, this is unfortunate.

True, that.  The quota file support really seems like it is driven
from the wrong end.  It should just be a helpful library that the
filesystem calls at just the right time, to format quota blocks that
are otherwised managed by the filesystem however it chooses.  When we
get to quota support, I think we will take a look at hooking into the
top level quota API instead of the generic quota file support.  I
really hate the idea of recursive journal transactions you see in Ext3
as a result of the weird dance with the quota api.  I don't know, maybe
it will all make sense when we get there, but chances are, Tux3 will
have to do something kooky too, to use generic quota file support.

> > The natural way to do this is for the filesystem to stream events
> > directly to the monitoring application over a pipe-like fd.  Maybe a
> > library for event delivery could be shared by filesystems, to impose
> > a standard format.  The role of the VFS would be simply to set up the
> > event connection, or to report that it is not supported.
> 
> There was an extension to inotify posted a few months ago to do this.
> Additional events when something becomes persistent.

Do you have a pointer?

> > An event stream accurate enough to support indexing is a considerably
> > harder problem, I think.
> 
> No really.  It's enough if an indexer can efficiently find all changed
> files since it was last running.  That doesn't have to be an accurate
> event stream.

Actually, it is not much like an event stream at all, it's like a delta
stream.  Looking at it that way suggests a new model: the indexer
receives periodic deltas from the filesystem and processes them to
find all the changes it is interested in.  Attractive features of the
delta model:

  - The filesystem must already make this persistent and completely
    accurate.

  - Deltas are efficient at consolidating large numbers of changes.

  - The new crop of next gen snapshotting filesystems will all be
    able to do this.

Just an alternative way of looking at the problem.

> For example, simply having xattrs 
> "user.scanned.indexer_app_name" automatically deleted whenever the
> file is modified, and recursively doing the same to parent
> directories, would be enough in most cases.  Not for hard links,
> obviously, but indexers can treat those separately and detect them by
> link count.

Hand waving alert!  Hard link handling is a basic requirement of any
indexer worthy of the name.  This is my main litmus test for whether
an API proposal satisfies the ACID test.  Do you have a specific
suggestion for indexing hard links?

Anyway, I would prefer if the indexer could build its index using just
the event stream, which would create significantly less disk activity.
It should be able to rescan like you suggest, for a reality check.

> There's one other application which needs *really accurate* event
> notification delivery.  That is, anything which caches the result of
> reading one or more files (such as for example compiling a script and
> its dependencies to an internal representation in memory or into
> another disk file), but where the caching must be *absolutely*
> reliably invalidated at the time it's checked so that the behaviour is
> guaranteed identical to not caching.

Good example.  I think my position is, if the API doesn't support a
_completely_ accurate consistency model, I am not interested in
proposing it.  It will be a few months before we're ready to add any
kind of log at all, and in that time, I hope to gather requirements and
get into some blue sky discussion of specific designs.  It was the
Strigi guys who brought this up, and I'm sure they will be more than
willing to find the holes in specific proposals.

> That kind of app needs to be able to say "are there any change events
> pending since I last looked?" efficiently for many files (e.g. inotify
> is ok, 1 syscall for many files), but with the guarantee that when the
> answer is "no change events", calling read() and stat() on all the
> files really would see no changes.  Networked inotify does not
> guarantee this, because event reception is delayed.
> 
> -- Jamie

The delta model of thinking about this problem may help.  If the indexer
is aware of the delta boundaries, it can be sure it has all the changes
as of exactly some delta.  Then if the indexer and filesystem crash at
different times, they can sync back up.  The indexer does have to
acknowledge receipt of each delta, so that the filesystem knows when it
can drop that part of the log.

In the common case where the index is stored on the filesystem being
indexed, it's interesting to note the behavior where the persistent log
is delivered to the indexer, which massages it and stores it on a file
on the filesystem, then lets the filesystem discard part of its log.
The persistent data moves from one place to another on the filesystem,
filtered by userspace as it goes.  This seems to make some kind of
sense.

As for indexing in-memory filesystem changes before they arrive on
stable storage, I think that is the business of an inotify-type
mechanism.  That seems to me to be a separate problem.  I think we have
two layers of events mashed together here.  One is the current view of
filesystem cache as required by Samba, for example, to export a current
view of files as they change, or by a desktop to refresh a directory
view when it changes.  The other is the long term stable, checkpointed
view of the filesystem as required by an indexer.  I think some head
scratching needs to be done about the relationship between these two
layers, and whether there are applications that actually need access to
both at the same time.  If not, then two separate kinds of event stream
sounds like not such a bad idea.

Regards,

Daniel
