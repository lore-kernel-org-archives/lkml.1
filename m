Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZANSmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZANSmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZANSlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:41:51 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:21700 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZANSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:41:49 -0500
Subject: Re: [GIT PULL] adaptive spinning mutexes
From: Chris Mason <chris.mason@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20090114183319.GA18630@elte.hu>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114183319.GA18630@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 13:40:46 -0500
Message-Id: <1231958447.8269.30.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.496E31B4.01E4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 19:33 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Full series, including changelogs available at:
> > 
> >  http://programming.kicks-ass.net/kernel-patches/mutex-adaptive-spin/
> > 
> > and should shortly appear in a git tree near Ingo :-)
> 
> Linus,
> 
> Please pull the adaptive-mutexes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git adaptive-mutexes-for-linus
> 

I was going to put this into the btrfs tree, but since you have a branch
just for adaptive mutexes, is it easier to put there?

From: Chris Mason <chris.mason@oracle.com>

Btrfs: stop spinning on mutex_trylock and let the adaptive code spin for us

Mutexes now spin internally and the btrfs spin is no longer required for
performance.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 39bae77..40ba8e8 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -37,16 +37,6 @@
 
 int btrfs_tree_lock(struct extent_buffer *eb)
 {
-	int i;
-
-	if (mutex_trylock(&eb->mutex))
-		return 0;
-	for (i = 0; i < 512; i++) {
-		cpu_relax();
-		if (mutex_trylock(&eb->mutex))
-			return 0;
-	}
-	cpu_relax();
 	mutex_lock_nested(&eb->mutex, BTRFS_MAX_LEVEL - btrfs_header_level(eb));
 	return 0;
 }


