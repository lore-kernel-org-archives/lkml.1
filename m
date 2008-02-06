Return-Path: <linux-kernel-owner+w=401wt.eu-S1763752AbYBFNps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763752AbYBFNps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762886AbYBFNpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:45:19 -0500
Received: from styx.suse.cz ([82.119.242.94]:44709 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762835AbYBFNpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:45:17 -0500
Date: Wed, 6 Feb 2008 14:45:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] brk: check the lower bound properly
In-Reply-To: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0802061441010.30955@jikos.suse.cz>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

brk: check the lower bound properly

There is a check in sys_brk(), that tries to make sure that we do not
underflow the area that is dedicated to brk heap.

The check is however wrong, as it assumes that brk area starts immediately
after the end of the code (+bss), which is wrong for example in
environments with randomized brk start. The proper way is to check whether
the address is not below the start_brk address.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Acked-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/mm/mmap.c b/mm/mmap.c
index 8295577..1c3b48f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -241,7 +241,7 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 
 	down_write(&mm->mmap_sem);
 
-	if (brk < mm->end_code)
+	if (brk < mm->start_brk)
 		goto out;
 
 	/*
