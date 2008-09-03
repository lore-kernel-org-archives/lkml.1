Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbYICSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbYICSoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYICSoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:44:09 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:54506 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbYICSoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:44:07 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 4/4] capture pages freed during direct reclaim for allocation by the reclaimer
Date: Wed,  3 Sep 2008 19:44:12 +0100
Message-Id: <1220467452-15794-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220467452-15794-1-git-send-email-apw@shadowen.org>
References: <1220467452-15794-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a process enters direct reclaim it will expend effort identifying
and releasing pages in the hope of obtaining a page.  However as these
pages are released asynchronously there is every possibility that the
pages will have been consumed by other allocators before the reclaimer
gets a look in.  This is particularly problematic where the reclaimer is
attempting to allocate a higher order page.  It is highly likely that
a parallel allocation will consume lower order constituent pages as we
release them preventing them coelescing into the higher order page the
reclaimer desires.

This patch set attempts to address this for allocations above
ALLOC_COSTLY_ORDER by temporarily collecting the pages we are releasing
onto a local free list.  Instead of freeing them to the main buddy lists,
pages are collected and coelesced on this per direct reclaimer free list.
Pages which are freed by other processes are also considered, where they
coelesce with a page already under capture they will be moved to the
capture list.  When pressure has been applied to a zone we then consult
the capture list and if there is an appropriatly sized page available
it is taken immediatly and the remainder returned to the free pool.
Capture is only enabled when the reclaimer's allocation order exceeds
ALLOC_COSTLY_ORDER as free pages below this order should naturally occur
in large numbers following regular reclaim.

Thanks go to Mel Gorman for numerous discussions during the development
of this patch and for his repeated reviews.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
