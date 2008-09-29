Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbYI2RLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYI2RLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYI2RLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:11:06 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:44650 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYI2RLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:11:04 -0400
Subject: setup_per_zone_pages_min(): zone->lock vs. zone->lru_lock
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 19:10:57 +0200
Message-Id: <1222708257.4723.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is zone->lru_lock really the right lock to take in setup_per_zone_pages_min()?
All other functions in mm/page_alloc.c take zone->lock instead, for working
with page->lru free-list or PageBuddy().

setup_per_zone_pages_min() eventually calls move_freepages(), which is also
manipulating the page->lru free-list and checking for PageBuddy(). Both
should be protected by zone->lock instead of zone->lru_lock, if I understood
that right, or else there could be a race with the other functions in
mm/page_alloc.c.

We ran into a list corruption bug in free_pages_bulk() once, during memory
hotplug stress test, but cannot reproduce it easily. So I cannot verify if
using zone->lock instead of zone->lru_lock would fix it, but to me it looks
like this may be the problem.

Any thoughts?

BTW, I also wonder if a spin_lock_irq() would be enough, instead of
spin_lock_irqsave(), because this function should never be called from
interrupt context, right?

Thanks,
Gerald


