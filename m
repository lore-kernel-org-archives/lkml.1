Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbZABWpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbZABWpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZABWpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:45:41 -0500
Received: from phunq.net ([64.81.85.152]:43471 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751168AbZABWpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:45:40 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
User-Agent: KMail/1.9.5
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
References: <200812301935.49303.phillips@phunq.net> <495BAED9.3000305@gmail.com> <200901022117.24504.Martin@Lichtvoll.de>
In-Reply-To: <200901022117.24504.Martin@Lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 2 Jan 2009 14:45:36 -0800
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901021445.37062.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 12:17, Martin Steigerwald wrote:
> Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
> > I guess this is what is confusing to me:
> > atomic commit, btree-based versioning.
> 
> Ah, the buzz words. ;)
> 
> The tux3 mailing list contains quite some design notes about these 
> concepts. I think others can give better answers about these concepts - I 
> think I understood what it is for, not the implementation details. But 
> basically "atomic commit" is a strategy to have the filesystem always in 
> a consistent state

Right.  Atomic commit is a term that came from the database world and
was first applied to filesystems in an LKML message from Victor
Yodaiken back in 1998 as I dimly recall, and I adopted it to describe
the tree ased atomic update strategy I was developing for Tux2 at the
time.  Tux3 uses a new logging variant that is supposed to avoid the
write-twice behaviour of journalling and the recursive copy behavior of
WAFL, ZFS and Btrfs, so should be pretty good at synchronous write
loads and generally reduce write traffic.

> and btree-based versioning allows to keep different  
> versions of a file / directory around. And unlike other filesystem tux3  
> has this per inode and not for the complete filesystem. At least if I 
> understand correctly.

You do.

"Btree-based" and "versioning" are separate buzzwords.  Tux3 is a btree
of btrees: the inode table is a btree, containing files that are
btrees.  It was conceived to demonstrate a new method of versioning
files that puts the versioning information at the btree leaves instead
of having multiple independently rooted trees sharing subtrees:

   Versioned pointers: a new method of representing snapshots
   http://lwn.net/Articles/288896/

This approach lends itself to per-object versioning: each data pointer
and each inode attribute has its own version label.  Making it work
per file and even per directory is a matter of clever mapping tricks to
turn global version numbers into per pointer version numbers.

But note that versioning support is still just a nice demo: the focus
has shifted to Tux3 as general purpose filesystem, with versioning
seen as a feature to be integrated after the basic Ext3-class
functionality is solid and reviewed.

> But at least it should clear that tux3 is a filesystem and not a video 
> game ;).

It's kind of like a video game where you sneak through IRC channels
trying to frag bugs with your BFG.

Regards,

Daniel
