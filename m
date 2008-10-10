Return-Path: <linux-kernel-owner+w=401wt.eu-S1763132AbYJJTSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763132AbYJJTSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763538AbYJJTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:18:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:41071 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763118AbYJJTSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=mgba9ovkdgW17RzuYAWLmxEj4Get+DOH8jlV1LLxAO9Tln/kX3nhFG2EzH+CxNzond
         Px845Odho1Xp1YgZrGc216gnGWcQ8P9IjcS627fqNToypc09R4VauiJr2i1eCnP49nEo
         K3E/GaKMcHQOweuDmoufAFsX8N7k0lokk4eD0=
Date: Fri, 10 Oct 2008 21:17:59 +0200
From: dcg <diegocalleja@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] Document file->f_pos as thread-unsafe
Message-ID: <20081010211759.630dfb6b@diego-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 10 Oct 2008 13:25:15 +1100, Nick Piggin <nickpiggin@yahoo.com.au> escribió:

> Note that I don't think we'd want to explicitly guarantee that it is atomic
> on 64-bit machines either. It does happen to be, but I don't think we want
> anybody to rely on that...

Easily fixable. Performance testing of this new version didn't find
regressions.




Document that it is not safe to play with file->f_pos from multiple processes
if they aren't synchronizing themselves.

Signed-off-by: Diego Calleja <diegocg@gmail.com>

Index: 2.6/include/linux/fs.h
===================================================================
--- 2.6.orig/include/linux/fs.h	2008-10-10 21:07:29.000000000 +0200
+++ 2.6/include/linux/fs.h	2008-10-10 21:08:25.000000000 +0200
@@ -821,6 +821,17 @@
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	mode_t			f_mode;
+	/*
+	 * Linux does NOT guarantee atomic reading/writing to file->f_pos in
+	 * multithreaded apps. There're several reasons for this behaviour:
+	 *  - Specifications don't say it must be implemented that way.
+	 *  - This behaviour is part of the Linux semantics.
+	 *  - Any application that does multithreaded access to file->f_pos
+	 *    should be doing its own locking: the processes should synchronize
+	 *    themselves when accessing a file descriptor. If an application
+	 *    doesn't do that, its file descriptor handling is buggy anyway and
+	 *    must be fixed to do its accesses to file->f_pos properly.
+	 */
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
 	unsigned int		f_uid, f_gid;

