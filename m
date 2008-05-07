Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbYEGOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbYEGOii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbYEGOho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:37:44 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59672
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518AbYEGOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:37:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 11] get_task_mm
X-Mercurial-Node: c5badbefeee07518d9d1acca13e94c981420317c
Message-Id: <c5badbefeee07518d9d1.1210170952@duo.random>
In-Reply-To: <patchbomb.1210170950@duo.random>
Date: Wed, 07 May 2008 16:35:52 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1210115127 -7200
# Node ID c5badbefeee07518d9d1acca13e94c981420317c
# Parent  e20917dcc8284b6a07cfcced13dda4cbca850a9c
get_task_mm

get_task_mm should not succeed if mmput() is running and has reduced
the mm_users count to zero. This can occur if a processor follows
a tasks pointer to an mm struct because that pointer is only cleared
after the mmput().

If get_task_mm() succeeds after mmput() reduced the mm_users to zero then
we have the lovely situation that one portion of the kernel is doing
all the teardown work for an mm while another portion is happily using
it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -465,7 +465,8 @@ struct mm_struct *get_task_mm(struct tas
 		if (task->flags & PF_BORROWED_MM)
 			mm = NULL;
 		else
-			atomic_inc(&mm->mm_users);
+			if (!atomic_inc_not_zero(&mm->mm_users))
+				mm = NULL;
 	}
 	task_unlock(task);
 	return mm;
