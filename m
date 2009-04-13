Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZDMUSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZDMUSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZDMURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:17:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35492 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZDMURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:17:49 -0400
Date: Mon, 13 Apr 2009 22:13:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>
Cc: Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] slow_work_execute() needs mb() before
	test_bit(SLOW_WORK_PENDING)
Message-ID: <20090413201306.GA16653@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slow_work_execute:

	clear_bit_unlock(SLOW_WORK_EXECUTING, &work->flags);

	if (test_bit(SLOW_WORK_PENDING, &work->flags) {

clear_bit_unlock() implies release semantics, iow we have a one-way barrier
before clear_bit(). But we need the mb() semantics after clear_bit(), before
we test SLOW_WORK_PENDING. Otherwise we can miss SLOW_WORK_ENQ_DEFERRED if
we race slow_work_enqueue().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.30/kernel/slow-work.c~2_BITS_MB	2009-04-13 19:40:20.000000000 +0200
+++ 6.30/kernel/slow-work.c	2009-04-13 21:19:33.000000000 +0200
@@ -198,7 +198,8 @@ static bool slow_work_execute(void)
 
 	if (very_slow)
 		atomic_dec(&vslow_work_executing_count);
-	clear_bit_unlock(SLOW_WORK_EXECUTING, &work->flags);
+	clear_bit(SLOW_WORK_EXECUTING, &work->flags);
+	smp_mb__after_clear_bit();
 
 	/* if someone tried to enqueue the item whilst we were executing it,
 	 * then it'll be left unenqueued to avoid multiple threads trying to

