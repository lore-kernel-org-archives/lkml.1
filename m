Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbYDJWjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbYDJWjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbYDJWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:38:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbYDJWiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:38:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Linus Torvalds's message of  Thursday, 10 April 2008 14:51:11 -0700 <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org>
References: <20080410155940.GA11721@redhat.com>
	<alpine.LFD.1.00.0804100906470.3143@woody.linux-foundation.org>
	<20080410165244.GV20478@devserv.devel.redhat.com>
	<alpine.LFD.1.00.0804101009420.3143@woody.linux-foundation.org>
	<alpine.LFD.1.00.0804101415450.3143@woody.linux-foundation.org>
	<20080410214114.GY20478@devserv.devel.redhat.com>
	<alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org>
Subject: [PATCH 2/2] asmlinkage_protect sys_io_getevents
X-Shopping-List: (1) Abstinent contraceptives
   (2) Patriotic mutant mountains
   (3) Slanty-wise yies
Message-Id: <20080410223845.EC4B826F992@magilla.localdomain>
Date: Thu, 10 Apr 2008 15:38:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use asmlinkage_protect in sys_io_getevents, because GCC for i386 with
CONFIG_FRAME_POINTER=n can decide to clobber an argument word on the
stack, i.e. the user struct pt_regs.  Here the problem is not a tail
call, but just the compiler's use of the stack when it inlines and
optimizes the body of the called function.  This seems to avoid it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/aio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6af9219..60a4cd4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1790,6 +1790,7 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
 		put_ioctx(ioctx);
 	}
 
+	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
 	return ret;
 }
 
