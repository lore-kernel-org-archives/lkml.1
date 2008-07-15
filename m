Return-Path: <linux-kernel-owner+w=401wt.eu-S1763425AbYGOUsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425AbYGOUsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYGOUsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:48:15 -0400
Received: from mail.fieldses.org ([66.93.2.214]:41124 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbYGOUsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:48:14 -0400
Date: Tue, 15 Jul 2008 16:48:12 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
Message-ID: <20080715204812.GD25803@fieldses.org>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net> <20080715195333.GK21590@fieldses.org> <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 01:41:25PM -0700, Sage Weil wrote:
> On Tue, 15 Jul 2008, J. Bruce Fields wrote:
> > >  - There is some built-in delay before statistics fully propagate up 
> > > toward the root of the hierarchy.  Changes are propagated 
> > > opportunistically when lock/lease state allows, with an upper bound of (by 
> > > default) ~30 seconds for each level of directory nesting.
> > 
> > That makes it less useful, e.g., for somebody with cached data trying to
> > validate their cache, or for something like git trying to check a
> > directory tree for changes.
> 
> Having fully up to date values would definitely be nice, but unfortunately 
> doesn't play nice with the fact that different parts of the directory 
> hierarchy may be managed by different metadata servers.  A primary goal in 
> implementing this was to minimize any impact on performance.  The uses I 
> had I mind were more in line with quota-based accounting than cache 
> validation.

Fair enough.

> I think I can adjust the propagation heuristics/timeouts to make updates 
> seem more or less immediate to a user in most cases, but that won't be 
> sufficient for a tool like git that needs to reliably identify very recent 
> updates.  For backup software wanting a consistent file system image, it 
> should really be operating on a snapshot as well, in which case a delay 
> between taking the snapshot and starting the scan for changes would allow 
> those values to propagate.
> 
> > >  - Ceph internally distinguishes between multiple links to the same file 
> > > (there is a single 'primary' link, and then zero or more 'remote' links).  
> > > Only the primary link contributes toward the 'rbytes' total.
> > 
> > Is that only true for 'rbytes'?
> 
> The same goes for rctime.  As far as the recursive stats go, the other 
> stats (file/directory counts) aren't affected.  The primary/remote 
> hard link distinction is fundamental to the way metadata is internally 
> managed and stored by the MDS, though, if that's what you mean (inode 
> content is embedded with the primary link's directory metadata).

I just wonder how one would explain to users (or application writers)
why changes to a file are reflected in the parent's rctime in one case,
and not in another, especially if the primary link is otherwise
indistinguishable from the others.  The symptoms could be a bit
mysterious from their point of view.

--b.
