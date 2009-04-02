Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbZDBOzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbZDBOzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZDBOzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:55:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56883 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552AbZDBOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:55:00 -0400
Date: Thu, 2 Apr 2009 16:54:57 +0200
From: Jan Kara <jack@suse.cz>
To: Alexander Larsson <alexl@redhat.com>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Issues with using fanotify for a filesystem indexer
Message-ID: <20090402145457.GA17275@atrey.karlin.mff.cuni.cz>
References: <1238158043.23703.20.camel@fatty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238158043.23703.20.camel@fatty>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> I took a look at fanotify to see if it would be a better fit for a
> filesystem indexer (like tracker or beagle), as inotify is pretty bad.
> I think it is a better fit in general, but it needs some additions.
> 
> Lets first define the requirements. By "indexer" I mean a userspace
> program that keeps a database that stores information about files on
> some form of pathname basis. You can use this to do a query for
> something and reverse-map back to the filename. As a minimally complex,
> yet sufficient model we have locate/updatedb that lets you quickly
> search for files by filename. However, instead of indexing everything
> each night we want to continuosly index things "soon" after they change,
> for some loose definition of soon (say within a few minutes in the
> normal case). 
> 
> Its not realistic to imagine the indexer handling each file change as
> they happen, as modern machines can dirty a lot of files in a short
> time which would immediately result in change event queues
> overflowing. It as also not really what isis desired. Many kinds of
> activities produce a lot of filesystem activity with creation of
> temporary files and changing of files multiple times over some time
> (for instance a compile). What we really want is to ignore all these
> temporary files and the flury of changes and wait for a more quiescent
> state to reindex.
> 
> One of the core properties of the indexer is that it knows what the
> filesystem looked like last time it indexed, so a more adequate model
> for changes would be to get told on a per-directory basis that
> "something changed in this directory" with a much more coarse-grained
> time scale, say e.g. at most once every 30 seconds. The indexer could
> then schedule a re-indexing of that directory, comparing mtimes with
> what is stored in its db to see which files changed. This is how the
> MacOS FSEvents userspace framework[1] works, and it seems reasonable.  
> 
> updatedb keeps track of the full filesystem tree, based on the
> "current" mounts in it (at the time updatedb ran). While this was
> probably valid when it was designed it is not really adequate for
> current use which is much more dynamic in how things get plugged in and
> out. A more modern way to look at this is to consider the full set of
> mounted filesystems being a forrest of trees, with the current process
> namespace being composed of a subset of these mounted in various places
> in the namespace.
> 
> So, in order to handle a filesystem being unmounted, and then later
> e.g. mounted in another place or another filesystem mounted in the
> same location we shouldn't index based on how things are mounted, but
> rather keep an index per filesystem. The kernel identifier for a
> filesystem is the major:minor of the block device its mounted on. This
> is not a persistent identifier, but given such an identifier a
> userspace app could use a library like libvolume_id to make up a
> persistent identifier for use as the key in its index. It would then
> store each item in its database by a volume id + relative path pair,
> which can be mapped to a pathname in the current namespace by using
> e.g. /proc/self/mountinfo.
  Some time ago I was trying to solve a similar problem and I've come up
with a solution which I've called recursive mtime. The general idea is
that with each directory, kernel additionally keeps a flag and a
timestamp. When a directory is modified, we do:
  dir = changed dir;
  while dir has flag set do
    update timestamp to current time
    clear flag
    dir = parent dir

  When a file is modified, you just start with a parent directory of
that file. With this scheme, you are able to find reasonably quickly
(without looking at unchanged directories) what has changed since
you've looked last time (you look for timestamps newer than the time
when you started last scan and you set flags as you go). Also the scheme
is quite cheap to maintain and has no problems with overflowing event
queues etc. (observe that the scheme works perfectly fine for several
independent scanners in parallel). As a bonus, if you store the flag +
timestamp persistently on disk, you can use this scheme to speedup things
like rsync.
  What gets nasty (but solvable) are hardlinks and bind mounts. I was
writing a library to handle these last summer but then had to work on
something else and didn't get back to it yet.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
