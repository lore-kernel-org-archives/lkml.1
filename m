Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYFCNF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYFCNF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYFCNFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:05:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54382 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYFCNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:05:46 -0400
Date: Tue, 3 Jun 2008 14:05:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mtk.manpages@googlemail.com, drepper@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Message-ID: <20080603130538.GA28946@ZenIV.linux.org.uk>
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com> <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu> <20080603112221.GW28946@ZenIV.linux.org.uk> <E1K3VRJ-00065P-Pq@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K3VRJ-00065P-Pq@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 02:16:33PM +0200, Miklos Szeredi wrote:
> > > > > I'm not sure of the correct way to get the required nameidata (to do a
> > > > > vfs_permission() call) from the file descriptor.  Can you give me a
> > > > > tip there?
> > > > 
> > > > Could you point me at the right way of doing this?
> > > 
> > > You don't need nameidata for this at all.  Just call permission() with
> > > a NULL nameidata.
> > > 
> > > Ugly API?  Yes, will be cleaned up if we manage to find some common
> > > ground with the VFS maintainers.
> > 
> > As soon as I'm done with sysctls...
> 
> Can't you just do that independently (for now just put a
> d_find_alias() in there and be done with it)?  If you fix every piece
> of horrid code that you come across, it'll never be done...

There's not much left to do, actually...  FWIW, solution goes like this:
	* introduce structure on the classes of sysctls
(currently - root and per-network-namespace).  Namely "X is parent of Y",
with "if task T sees Y, it also sees X" as defining property.
	* when adding a sysctl table, find a "parent" one.  Which is to say,
find the deepest node on its stem that already is present in one of the
tables from our class or its ancestor classes.  That table will be our
parent and that node in it - attachment point.
	* delay freeing the table headers; have them refcounted and instead
of unconditionally freeing the sucker on unregistration just drop the refcount.

Now we can keep a pair (reference to header, pointer to ctl table entry)
as long as we hold refcount on header.  It won't affect unregistration
in any way.  And at any point we can try to acquire "active" (use) reference
to header.  If that succeeds, we know that
	+ unregistration hadn't been started
	+ unregistration won't be finished until we unuse the sucker
	+ table entry is alive and will stay alive until then.

So we can hold references to those puppies from inodes under /proc/sys
without blocking unregistration, etc.

What's more, we can associate such pair with each node in sysctl tree.
For non-directories that's obvious.  For directories, take the tree such
that directory belongs to tree \setminus parent of tree.

That's pretty much it.  Filesystem side is simple - we keep a pointer to
class of tree responsible for a node (see directly above) in dentry.
And ->d_compare() checks that class of candidate match should be visible
for task doing the lookup.  ->lookup() tries finding an entry with requested
name in sysctl table (found by directory inode) and in case of miss it goes
through the list of tables attached at that node, searching in those that
ought to be visible to us.

As the result, we have direct access to sysctl table entry right from inode,
maintain these references accross lookups without going through the contortions
done by current code and we do *NOT* use the same dentry for flipping between
unrelated sysctl nodes with different visibility...
