Return-Path: <linux-kernel-owner+w=401wt.eu-S965014AbYEBPRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbYEBPRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934907AbYEBPNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:13:20 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:48803
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934706AbYEBPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:13:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 11] mmap sems
X-Mercurial-Node: b4bf6df98bc00bfbef9423b0dd31cfdba63a5eeb
Message-Id: <b4bf6df98bc00bfbef94.1209740714@duo.random>
In-Reply-To: <patchbomb.1209740703@duo.random>
Date: Fri, 02 May 2008 17:05:14 +0200
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
# Date 1209740229 -7200
# Node ID b4bf6df98bc00bfbef9423b0dd31cfdba63a5eeb
# Parent  4f462fb3dff614cd7d971219c3feaef0b43359c1
mmap sems

This patch adds a lock ordering rule to avoid a potential deadlock when
multiple mmap_sems need to be locked.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

diff --git a/mm/filemap.c b/mm/filemap.c
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -79,6 +79,9 @@ generic_file_direct_IO(int rw, struct ki
  *
  *  ->i_mutex			(generic_file_buffered_write)
  *    ->mmap_sem		(fault_in_pages_readable->do_page_fault)
+ *
+ *    When taking multiple mmap_sems, one should lock the lowest-addressed
+ *    one first proceeding on up to the highest-addressed one.
  *
  *  ->i_mutex
  *    ->i_alloc_sem             (various)
