Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYKQJH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYKQJH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYKQJHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:07:32 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:8396 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYKQJH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:07:29 -0500
Message-Id: <4921428A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 17 Nov 2008 09:08:10 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Zachary Amsden" <zach@vmware.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 49f19710512c825aaea73b9207b3a848027cda1d hints at the
current solution not being the final one, yet the advertised (for 2.6.22)
change apparently never happened. However, it seems to me that
flushing a potentially huge (it terms of time to completion) batch
asynchronously is no really good idea. Instead, I'd think that adding to
the batch should be prevented in asynchronous contexts altogether, or
things should properly nest. As a positive side effect, disabling interrupts
in the batch handling - in particular around the submission of the batch -
could also be avoided, reducing interrupt latency (perhaps significantly
in some case).

Likewise I would think that the flush out of vmalloc_sync_one() isn't
appropriate, and it should rather be avoided for the set_pmd() there to
get into the batching code altogether.

(Background to this: After adding lazy mmu mode support in our forward
ported tree, we've actually been hit by these calls out of kmap_...(), as
originally I didn't pay much attention to these and didn't care to synchronize
batch addition and flushing with asynchronous operations.)

Jan

