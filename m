Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYDHP7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYDHP7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYDHP5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:57:10 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:42932
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYDHP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:57:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 9 of 9] This patch adds a lock ordering rule to avoid a
	potential deadlock when
X-Mercurial-Node: bd55023b22769ecb14b26c2347947f7d6d63bcea
Message-Id: <bd55023b22769ecb14b2.1207669452@duo.random>
In-Reply-To: <patchbomb.1207669443@duo.random>
Date: Tue, 08 Apr 2008 17:44:12 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, Nick Piggin <npiggin@suse.de>,
       Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1207666972 -7200
# Node ID bd55023b22769ecb14b26c2347947f7d6d63bcea
# Parent  3b14e26a4e0491f00bb989be04d8b7e0755ed2d7
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
