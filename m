Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbXKCXGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbXKCXGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbXKCXGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:06:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbXKCXG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:06:29 -0400
Date: Sat, 3 Nov 2007 19:06:00 -0400
From: Rik van Riel <riel@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/10] add swapped in pages to the inactive list
Message-ID: <20071103190600.4b47c9c0@bree.surriel.com>
In-Reply-To: <20071103184229.3f20e2f0@bree.surriel.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Swapin_readahead can read in a lot of data that the processes in
memory never need.  Adding swap cache pages to the inactive list
prevents them from putting too much pressure on the working set.

This has the potential to help the programs that are already in
memory, but it could also be a disadvantage to processes that
are trying to get swapped in.

In short, this patch needs testing.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.23-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.23-mm1.orig/mm/swap_state.c
+++ linux-2.6.23-mm1/mm/swap_state.c
@@ -370,7 +370,7 @@ struct page *read_swap_cache_async(swp_e
 			/*
 			 * Initiate read into locked page and return.
 			 */
-			lru_cache_add_active_anon(new_page);
+			lru_cache_add_anon(new_page);
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
