Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbZDBTxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbZDBTxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763755AbZDBTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:52:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:33498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762132AbZDBTw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:52:57 -0400
Date: Thu, 2 Apr 2009 21:52:53 +0200
From: Jan Kara <jack@suse.cz>
To: Alexander Larsson <alexl@redhat.com>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Issues with using fanotify for a filesystem indexer
Message-ID: <20090402195253.GH3010@duck.suse.cz>
References: <1238158043.23703.20.camel@fatty> <20090402145457.GA17275@atrey.karlin.mff.cuni.cz> <1238689744.5704.1.camel@localhost.localdomain> <20090402165023.GG3010@duck.suse.cz> <1238692537.5704.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238692537.5704.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-04-09 19:15:37, Alexander Larsson wrote:
> On Thu, 2009-04-02 at 18:50 +0200, Jan Kara wrote:
> > On Thu 02-04-09 18:29:04, Alexander Larsson wrote:
> > > Another potential issue with this is that every change bubbles up to the
> > > top, modifying the recursive mtime of that. This will become very
> > > contented, and may imply a partial serialization of fs activity, which
> > > is kinda costly.
> >   Not every change - only the first change bubbles to the top, clearing the
> > flag on its way. Then next change stops bubbling up as soon as it reaches
> > a directory with the flag cleared. So no contention happen - we update flag
> > + timestamp only at most once per scan of the directory by indexer (or
> > someone else interested in recursive mtime) => once per a few minutes on
> > average system.
> 
> Ah, I see. The indexer sets the flag. 
> I see some issues. First of all, writing the flag/mtime to disk seems
> like a bad idea. It'll cause a lot of writing when the indexer recurses
> throught the filesystem, similar to atimes. But, if you're not
  There's some cost but it's not nearly as bad as with atimes. Indexer only
has to change flags on directories in whose subtree something has changed -
so we modify only directories (atime is modified for all files +
directories) and we even modify only a small fraction of them because only
a small amount of them has changed and thus has the flag reset.
  Similarly a write to a file can cause some additional modifications to
above directories as we traverse up the tree but again, there aren't going
to be many of those since most of the time quickly hit a directory with a
flag reset. Now I understand this is a handwaving and one does not believe
it until he tries it on his machine if it is really a noticable slowdown or
not ;)
  Also I'm not saying it's a perfect fit for things like desktop indexing
because as you said, it's desirable to rescan the system every few minutes
while I was rather aiming at usecases where either the rescan is done only
once per few hours (rsync, updatedb) or where files change only
exceptionally (e.g.  KDE/GNOME watching desktop config files). But still I
don't think it's completely insane to try something like that...

> persisting the flag/mtime then you need to keep all the dentries with
> the flag set in memory, which has resource use risks similar to
> unbounded event queues.
  Ah, true - I have implemented just the persistent case and have not
thought too much about the non-persistent one. You're right that it won't
work because we'd pin memory.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
