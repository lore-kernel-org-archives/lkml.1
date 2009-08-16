Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZHPVBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZHPVBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZHPVBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:01:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55188 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbZHPVBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:01:46 -0400
Date: Sun, 16 Aug 2009 23:01:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Martin-=C9ric?= Racine <q-funk@iki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13941] x86 Geode issue
Message-ID: <20090816210134.GA14972@elte.hu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <200908131654.45227.rjw@sisk.pl> <11fae7c70908130800q7b4a5293t5c373613d736d74@mail.gmail.com> <200908132034.34951.rjw@sisk.pl> <11fae7c70908161217p33830075p783880315a31b2e5@mail.gmail.com> <20090816205706.GB3463@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090816205706.GB3463@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Martin-Éric Racine <q-funk@iki.fi> wrote:
> 
> > On Thu, Aug 13, 2009 at 9:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > > On Thursday 13 August 2009, Martin-Éric Racine wrote:
> > >> On Thu, Aug 13, 2009 at 5:54 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > >> > On Thursday 13 August 2009, Martin-Éric Racine wrote:
> > >> >> 2009/8/13 Martin-Éric Racine <q-funk@iki.fi>:
> > >> >> > On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
> > >> >> >> * Martin-Éric Racine <q-funk@iki.fi> wrote:
> > >> >> >>> Yes, this bug is still valid.
> > >> >> >>>
> > >> >> >>> Ubuntu kernel team member Leann Ogasawara and I are slowly
> > >> >> >>> bisecting our way through the changes that took place since 2.6.30
> > >> >> >>> to find the commit that introduced this regression. Please stay
> > >> >> >>> tuned.
> > >> >> >>
> > >> >> >> hm, the only outright Geode related commit was:
> > >> >> >>
> > >> >> >>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
> > >> >> >>
> > >> >> >> the jpg at:
> > >> >> >>
> > >> >> >>  http://launchpadlibrarian.net/28892781/00002.jpg
> > >> >> >>
> > >> >> >> is very out of focus - but what i could decypher suggests a
> > >> >> >> pagefault crash in the VFS code, in generic_delete_inode().
> > >> >>
> > >> >> This one might be a bit better:
> > >> >>
> > >> >> http://launchpadlibrarian.net/30267494/2.6.31-5.24.jpg
> > >
> > > Hmm.  This looks like a sysfs oops to my untrained eye.
> > 
> > The bisect I did with Leann Ogasawara has narrowed the kernel panic
> > down to the following:
> > 
> > commit f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date: Mon Jun 8 19:50:45 2009 -0400
> > 
> >     add caching of ACLs in struct inode
> > 
> >     No helpers, no conversions yet.
> > 
> >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Weird. If the functions do what their name suggests, i.e. if 
> inode_init_always() is an always called constructor and if 
> destroy_inode() is an unconditional destructor then this patch 
> should have no functional effect on the VFS side.
> 
> It increases the size of struct inode, so if you have some old 
> module (built to an older version of fs.h) still around it might 
> corrupt your inode data structure.
> 
> Or the size change might trigger some dormant bug. It might move a 
> critical inode right into the path of a pre-existing (but not 
> visibly crash-triggering) data corruption.
> 
> The possibilities on the 'weird bug' front are endless - the 
> crash/oops itself should be turned into text, posted here and 
> analyzed.

Btw., before you invest any time into the 'weird crash' theory, i'd 
suggest to double check the bisection result:

  f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0    crashes
  f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0~1  boots fine

You can save yourself from a lot of head scratching that way - the 
bisection result looks weird. (albeit plausible - a VFS crash points 
to a VFS commit.)

_Maybe_ the bisection is just off a little bit (there was a 
bisection mistake in the last few steps), and the real buggy commit 
is one of the nearby ones:

1cbd20d: switch xfs to generic acl caching helpers
073aaa1: helpers for acl caching + switch to those
06b16e9: switch shmem to inode->i_acl
281eede: switch reiserfs to inode->i_acl
7a77b15: switch reiserfs to usual conventions for caching ACLs
e68888b: reiserfs: minimal fix for ACL caching
d441b1c: switch nilfs2 to inode->i_acl
5affd88: switch btrfs to inode->i_acl
290c263: switch jffs2 to inode->i_acl
05fc079: switch jfs to inode->i_acl
d4bfe2f: switch ext4 to inode->i_acl
6582a0e: switch ext3 to inode->i_acl
5e78b43: switch ext2 to inode->i_acl
f19d4a8: add caching of ACLs in struct inode
3e63cbb: fs: Add new pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
01c0319: cleanup __writeback_single_inode
f21f622: ... and the same for vfsmount id/mount group id
c63e09e: Make allocation of anon devices cheaper
7e325d3: update Documentation/filesystems/Locking
f6cc746: devpts: remove module-related code
3b22edc: VFS: Switch init_mount_tree() to use the new create_mnt_ns() helper
654f562: vfs: fix nd->root leak in do_filp_open()
b5450d9: reiserfs: remove stray unlock_super in reiserfs_resize
c912e7a: ALSA: hda - Fix support for Samsung P50 with AD1986A codec

	Ingo
