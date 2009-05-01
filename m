Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbZEAFgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbZEAFgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZEAFf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:35:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZEAFf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:35:57 -0400
Date: Fri, 1 May 2009 07:35:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements,
	faster than Bkl based scheme
Message-ID: <20090501053540.GC5983@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> This reiserfs patchset applies against latest tip:core/kill-the-BKL
> It adds various explicit write lock releases on specific sleeping sections.
> 
> A performance test with dbench on UP with 100 processus during 100 seconds
> gives the following results:
> 
> Locking		  Throughput 
> 
> Bkl:              11.2587 MB/s
> Write lock/Mutex: 12.5713 MB/s
> 
> So the new locking scheme makes it 11% faster than with the bkl.

Wow, nice!

> It's not possible to compare it on the kill-the-BKL tree because the Bkl
> is not anymore a Bkl inside but a plain Mutex.
> 
> Instead, you can apply the following equivalent patch against -rc3 to test it:
> http://www.kernel.org/pub/linux/kernel/people/frederic/reiserfs-kill-the-bkl-full.patch
> 
> Of course it might eat your data, make you cows produce black milk, bring coffee
> to your children at 3:00 am, turn the teletubbies song in your mind for
> seven years long and so...
> 
> Frederic.
> 
> The following changes since commit a3a2b793d18bc068b79508e96eba33ae2326f759:
>   Alessio Igor Bogani (1):
>         remove the BKL: remove "BKL auto-drop" assumption from ext3_remount()
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git bkl
> 
> Frederic Weisbecker (6):
>       kill-the-BKL/reiserfs: release write lock on fs_changed()
>       kill-the-BKL/reiserfs: release the write lock before rescheduling on do_journal_end()
>       kill-the-BKL/reiserfs: release write lock while rescheduling on prepare_for_delete_or_cut()
>       kill-the-BKL/reiserfs: release the write lock inside get_neighbors()
>       kill-the-BKL/reiserfs: release the write lock inside reiserfs_read_bitmap_block()
>       kill-the-BKL/reiserfs: release the write lock on flush_commit_list()
> 
>  fs/reiserfs/bitmap.c        |    2 ++
>  fs/reiserfs/fix_node.c      |    4 ++++
>  fs/reiserfs/journal.c       |    9 +++++++--
>  fs/reiserfs/stree.c         |    2 ++
>  include/linux/reiserfs_fs.h |    8 +++++++-
>  5 files changed, 22 insertions(+), 3 deletions(-)

I've pulled it and have also merged -rc4 into the kill-the-BKL tree, 
which can picked up from here:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL

So for comparative benchmarking, vanilla v2.6.30-rc4 (which has the 
BKL) can be compared against latest kill-the-BKL.

	Ingo
