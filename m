Return-Path: <linux-kernel-owner+w=401wt.eu-S1765233AbYDBVxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765233AbYDBVxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763482AbYDBVqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:46:21 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33685
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763483AbYDBVqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:46:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 8 of 8] This patch adds a lock ordering rule to avoid a
	potential deadlock when
X-Mercurial-Node: f3f119118b0abd9c4624263ef388dc7230d937fe
Message-Id: <f3f119118b0abd9c4624.1207171809@duo.random>
In-Reply-To: <patchbomb.1207171801@duo.random>
Date: Wed, 02 Apr 2008 23:30:09 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: akpm@linux-foundation.org
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1207159059 -7200
# Node ID f3f119118b0abd9c4624263ef388dc7230d937fe
# Parent  31fc23193bd039cc595fba1ca149a9715f7d0fb2
This patch adds a lock ordering rule to avoid a potential deadlock when
multiple mmap_sems need to be locked.

Signed-off-by: Dean Nelson <dcn@sgi.com>

diff --git a/mm/filemap.c b/mm/filemap.c
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -79,6 +79,9 @@
  *
  *  ->i_mutex			(generic_file_buffered_write)
  *    ->mmap_sem		(fault_in_pages_readable->do_page_fault)
+ *
+ *    When taking multiple mmap_sems, one should lock the lowest-addressed
+ *    one first proceeding on up to the highest-addressed one.
  *
  *  ->i_mutex
  *    ->i_alloc_sem             (various)
