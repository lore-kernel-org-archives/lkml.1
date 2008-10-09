Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbYJIVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbYJIVwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbYJIVv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:51:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:27664 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbYJIVvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kgh8Dgv9kvyfOsBr/PSyefizzUPL+3jpBmQIusmf4nz66CXX31EknBmSly1IoDAX/w
         xEybunwtpa3AXkyXu3BWWel3ObI4PltiYaWQzGLiiZR1FKVvQOF8ZP+Wo2sWXBsuRnKD
         GhY/dhyaGhGWJIDfdnga4o5duSVbWCFnQbTLY=
Date: Thu, 9 Oct 2008 23:51:58 +0200
From: dcg <diegocalleja@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
 arch
Message-ID: <20081009235158.7d328aa0@diego-desktop>
In-Reply-To: <1223448711.1378.16.camel@lappy.programming.kicks-ass.net>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
	<20081007105056.16d9e785.akpm@linux-foundation.org>
	<1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
	<200810081335.44576.nickpiggin@yahoo.com.au>
	<6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
	<1223448711.1378.16.camel@lappy.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 08 Oct 2008 08:51:51 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> escribió:

> either dup() the fd or open() the file twice. There is absolutely no
> valid reason to have two threads read from the same fd without
> synchronising their access to it - never.

In case this is the final consensus, I think that a topic that is brought
to the list every few months and even generates (aparently not neccesary)
patches is a hint that there should be somewhere a commentary (*) like
this:

(*) I don't know if what I wrote is 100% correct.


Signed-off-by: Diego Calleja García <diegocg@gmail.com>

Index: 2.6/include/linux/fs.h
===================================================================
--- 2.6.orig/include/linux/fs.h	2008-10-09 00:06:50.000000000 +0200
+++ 2.6/include/linux/fs.h	2008-10-09 00:29:03.000000000 +0200
@@ -821,6 +821,18 @@
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	mode_t			f_mode;
+	/*
+	 * Linux does NOT guarantee atomic reading/writing to file->f_pos in
+	 * multithread apps running in 32 bit machines. There're several
+	 * reasons for this behaviour:
+	 *  - Specifications don't say it must be implemented that way.
+	 *  - This behaviour is part of the Linux semantics.
+	 *  - Any application that does multithreaded access to file->f_pos
+	 *    should be doing its own locking: the processes should synchronize
+	 *    themselves when accessing a file descriptor. If an application
+	 *    doesn't do that, its file descriptor handling is buggy anyway and
+	 *    must be fixed to access file->f_pos properly.
+	 */
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
 	unsigned int		f_uid, f_gid;

