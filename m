Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbYFEIv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbYFEIv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYFEIvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:51:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:21247 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYFEIvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:51:18 -0400
Message-Id: <4847C54B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 05 Jun 2008 09:51:55 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: operation ordering during pgd_alloc/pgd_free
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, pgd_ctor() adds a new pgd to pgd_list solely based on
!SHARED_KERNEL_PMD. For PAE && !SHARED_KERNEL_PMD (i.e. Xen)
this doesn't seem correct, as the pgd is still empty, which will confuse
vmalloc_sync_all(). So in this case, list insertion should only happen at
the end of pgd_prepopulate_pmd().

Likewise, pgd_free() calls pgd_mop_up_pmds() *before* pgd_dtor(),
with the former zeroing pgd entries as it goes and only the latter
removing the pgd from the list. Just as above this can confuse
vmalloc_sync_all(), so here I would think that the two calls should just
be swapped. However, if they get swapped, careful inspection of the
interaction with save/restore will be needed - XenSource's Linux tree
has a comment specifically to that effect:

/*
 * After this the pgd should not be pinned for the duration of this
 * function's execution. We should never sleep and thus never race:
 *  1. User pmds will not become write-protected under our feet due
 *     to a concurrent mm_pin_all().
 *  2. The machine addresses in PGD entries will not become invalid
 *     due to a concurrent save/restore.
 */

Since that tree doesn't support preemption, this is perhaps fine, but
likely going to cause problems in the (preemptable) pv-ops code.

The issue with vmalloc_sync_all() would even go unnoticed, since the
patch to unify the pgd_list mechanism with x86-64 removed the
BUG_ON() that was meant to trigger on issues like this.

But maybe I'm missing something?

Jan

