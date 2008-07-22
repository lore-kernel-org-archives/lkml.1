Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYGVQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYGVQzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYGVQzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:55:25 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:1362 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYGVQzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:55:25 -0400
Subject: memory hotplug: hot-remove fails on lowest chunk in ZONE_MOVABLE
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 18:55:19 +0200
Message-Id: <1216745719.4871.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been testing memory hotplug on s390, on a system that starts w/o
memory in ZONE_MOVABLE at first, and then some memory chunks will be
added to ZONE_MOVABLE via memory hot-add. Now I observe the following
problem:

Memory hot-remove of the lowest memory chunk in ZONE_MOVABLE will fail
because of some reserved pages at the beginning of each zone
(MIGRATE_RESERVED).

During memory hot-add, setup_per_zone_pages_min() will be called from
online_pages() to redistribute/recalculate the reserved page blocks.
This will mark some page blocks at the beginning of each zone as
MIGRATE_RESERVE. Now, the memory chunk containing these blocks cannot
be set offline again, because only MIGRATE_MOVABLE pages can be isolated
(offline_pages -> start_isolate_page_range).

So you cannot remove all the memory chunks that have been added via
memory hotplug. I'm not sure if I am missing something here, or if this
really is a bug. Any thoughts?

Thanks,
Gerald


