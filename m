Return-Path: <linux-kernel-owner+w=401wt.eu-S933917AbYDVOLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbYDVOLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763489AbYDVOKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:10:37 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41260
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161AbYDVOKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:10:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 12] get_task_mm should not succeed if mmput() is running
	and has reduced
X-Mercurial-Node: a6672bdeead0d41b2ebd6846f731d43a611645b7
Message-Id: <a6672bdeead0d41b2ebd.1208872279@duo.random>
In-Reply-To: <patchbomb.1208872276@duo.random>
Date: Tue, 22 Apr 2008 15:51:19 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1208872186 -7200
# Node ID a6672bdeead0d41b2ebd6846f731d43a611645b7
# Parent  3c804dca25b15017b22008647783d6f5f3801fa9
get_task_mm should not succeed if mmput() is running and has reduced
the mm_users count to zero. This can occur if a processor follows
a tasks pointer to an mm struct because that pointer is only cleared
after the mmput().

If get_task_mm() succeeds after mmput() reduced the mm_users to zero then
we have the lovely situation that one portion of the kernel is doing
all the teardown work for an mm while another portion is happily using
it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -442,7 +442,8 @@
 		if (task->flags & PF_BORROWED_MM)
 			mm = NULL;
 		else
-			atomic_inc(&mm->mm_users);
+			if (!atomic_inc_not_zero(&mm->mm_users))
+				mm = NULL;
 	}
 	task_unlock(task);
 	return mm;
