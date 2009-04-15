Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZDOXOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZDOXOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZDOXN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:13:56 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:49731 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZDOXNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:13:54 -0400
Subject: Re: [tree] latest kill-the-BKL tree, v12
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20090415230736.GA22710@elte.hu>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
	 <20090414045109.GA26908@orion> <20090414090146.GH27003@elte.hu>
	 <a4423d670904151558r4252c7eamd115793fb36a9163@mail.gmail.com>
	 <20090415230736.GA22710@elte.hu>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 19:13:45 -0400
Message-Id: <1239837225.6005.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8AF3CF32CBE9AD4D7D86A37D766BA1123EF98BA4
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 159 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 01:07 +0200, Ingo Molnar wrote:
> * Alexander Beregalov <a.beregalov@gmail.com> wrote:
> 
> > 2009/4/14 Ingo Molnar <mingo@elte.hu>:
> > >
> > > * Alexander Beregalov <a.beregalov@gmail.com> wrote:
> > >
> > >> On Tue, Apr 14, 2009 at 05:34:22AM +0200, Frederic Weisbecker wrote:
> > >> > Ingo,
> > >> >
> > >> > This small patchset fixes some deadlocks I've faced after trying
> > >> > some pressures with dbench on a reiserfs partition.
> > >> >
> > >> > There is still some work pending such as adding some checks to ensure we
> > >> > _always_ release the lock before sleeping, as you suggested.
> > >> > Also I have to fix a lockdep warning reported by Alessio Igor Bogani.
> > >> > And also some optimizations....
> > >> >
> > >> > Thanks,
> > >> > Frederic.
> > >> >
> > >> > Frederic Weisbecker (3):
> > >> >   kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
> > >> >   kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
> > >> >   kill-the-BKL/reiserfs: only acquire the write lock once in
> > >> >     reiserfs_dirty_inode
> > >> >
> > >> >  fs/reiserfs/inode.c         |   10 +++++++---
> > >> >  fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
> > >> >  fs/reiserfs/super.c         |   15 +++++++++------
> > >> >  include/linux/reiserfs_fs.h |    2 ++
> > >> >  4 files changed, 44 insertions(+), 9 deletions(-)
> > >> >
> > >>
> > >> Hi
> > >>
> > >> The same test - dbench on reiserfs on loop on sparc64.
> > >>
> > >> [ INFO: possible circular locking dependency detected ]
> > >> 2.6.30-rc1-00457-gb21597d-dirty #2
> > >
> > > I'm wondering ... your version hash suggests you used vanilla
> > > upstream as a base for your test. There's a string of other fixes
> > > from Frederic in tip:core/kill-the-BKL branch, have you picked them
> > > all up when you did your testing?
> > >
> > > The most coherent way to test this would be to pick up the latest
> > > core/kill-the-BKL git tree from:
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL
> > >
> > 
> > I did not know about this branch, now I am testing it and there is 
> > no more problem with that testcase (dbench).
> > 
> > I will continue testing.
> 
> thanks for testing it! It seems reiserfs with Frederic's changes 
> appears to be more stable now on your system.
> 
> I saw your NFS circular locking kill-the-BKL problem report on LKML 
> - also attached below.
> 
> Hopefully someone on the Cc: list with NFS experience can point out 
> the BKL assumption that is causing this.

I have no idea what Alexander is seeing. There should be no BKL
dependencies at all left in the RPC client code. Most of the NFS client
code is clean too, with only the posix lock code, and the NFSv4 callback
server remaining...

Cheers
  Trond

