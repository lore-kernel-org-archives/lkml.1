Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbYD2TAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbYD2TAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYD2S7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:59:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34884 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbYD2S7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:59:51 -0400
Subject: [RFC][PATCH 4/5] must hold lock_super() to set initial mount writer
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       trond.myklebust@fys.uio.no, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2008 11:59:48 -0700
References: <20080429185943.3BA6A050@kernel>
In-Reply-To: <20080429185943.3BA6A050@kernel>
Message-Id: <20080429185948.F5D2E512@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need lock_mnt_writers() during a remount in order
to keep mnt->__mnt_writers from changing so that we
get a consistent look at if a sb currently has anyone
writing to it.

But, we need to lock writers out for an extended
period, even during the ->remount_fs() operation.
That's because we do conclusively make the fs
r/o until *after* the ->remount_fs().
lock_mnt_writers() is an awfully blunt instrument
for this since it will lock out *ALL* new writers
on the entire system.  That's bad because that
remount might take a bit.

So, we introduce a new semantic.  Before a new
cpu_writer is established to a mount, it must
lock_super().  This is already a slow path because
the old cpu_writer->count must be coalesced into
mnt->__mnt_writers.  The fast path where (mnt ==
cpu_writer->mnt) is unaffected.


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/namespace.c~must-hold-lock_super-to-set-initial-mnt_writer fs/namespace.c
--- linux-2.6.git/fs/namespace.c~must-hold-lock_super-to-set-initial-mnt_writer	2008-04-29 11:56:41.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2008-04-29 11:56:41.000000000 -0700
@@ -225,8 +225,20 @@ static inline void use_cpu_writer_for_mo
 {
 	if (cpu_writer->mnt == mnt)
 		return;
+	/*
+	 * This is a slow path taken the first time that
+	 * a particular cpu_writer is used for a given
+	 * mount.  It lets someone (like remount) clear
+	 * all the cpu_writer->mnts by lock_mnt_writers(),
+	 * take lock_super(), and guarantee that no one
+	 * else can get through here and acquire a new
+	 * mnt_want_write() until after they
+	 * unlock_super().
+	 */
+	lock_super(mnt->mnt_sb);
 	__clear_mnt_count(cpu_writer);
 	cpu_writer->mnt = mnt;
+	unlock_super(mnt->mnt_sb);
 }
 
 /*
_
