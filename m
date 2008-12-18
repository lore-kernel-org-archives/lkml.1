Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752555AbYLRL1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbYLRL1H (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYLRL0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:26:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59994 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYLRL0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:26:53 -0500
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <20081218092744.GB30789@mail.oracle.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
	 <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
	 <20081217134020.42da55fc.akpm@linux-foundation.org>
	 <1229585208.9487.112.camel@twins>  <20081218092744.GB30789@mail.oracle.com>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Thu, 18 Dec 2008 11:26:58 +0000
Message-Id: <1229599618.3538.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have to say that when I brought this subject up, I didn't realise
quite how tricky this was going to be, however...

On Thu, 2008-12-18 at 01:27 -0800, Joel Becker wrote:
> On Thu, Dec 18, 2008 at 08:26:48AM +0100, Peter Zijlstra wrote:
> > On Wed, 2008-12-17 at 13:40 -0800, Andrew Morton wrote:
> > > On Fri, 12 Dec 2008 16:29:11 +0100
> > > Louis Rilling <louis.rilling@kerlabs.com> wrote:
> > > > >From inside configfs it is not possible to serialize those recursive
> > > > locking with a top-level one, because mkdir() and rmdir() are already
> > > > called with inodes locked by the VFS. So using some
> > > > mutex_lock_nest_lock() is not an option.
> 
> <snip>
> 
<more snipping>

> > Right, so basically we avoid syscalls by making vfs ops do stuff..
> > lovely - still not seeing it though - regular filesystems seems to cope
> > just fine and they get to create arbitrary tree structures too.
> 
> 	It's about the default_groups and how they build up and tear
> down small bits of tree.
> 	A simple creation of a config_item, a mkdir(2), is a normal VFS
> lock set and doesn't make lockdep unhappy.  But if the new config_item
> has a default_group or two, they need locking too.  Not so much on
> mkdir(2), but on rmdir(2).
> 
So if I've understood this correctly, the dentries created upon mkdir
live until such time as they are removed at some later date, presumably
with rmdir?

When creating the tree, would it be possible to build it starting from
the bottom and working towards the point of attachment and then to not
actually attach it until the last moment? That way it would not be
visible from userland until it was linked into the existing dir and that
solves the locking issue for mkdir I think.

As you say, rmdir seems the harder problem, but again, is it possible to
separate the unlink operation from the destruction of the tree by
keeping the tree, after its been unlinked, until the last userland
reference has gone away? At least I assume that is why the locking is
there. I may be a bit off the mark, but it seems like this is quite
similar to how the VFS does umount, so maybe there are some hints in
that code which may help us solve this issue?

Steve.


