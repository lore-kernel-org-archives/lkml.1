Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYLCWQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYLCWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYLCWQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:16:21 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49662 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYLCWQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:16:20 -0500
Subject: Re: [PATCH] memory hotplug: run lru_add_drain_all() on each cpu
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: gerald.schaefer@de.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, npiggin@suse.de
In-Reply-To: <1228339524.6598.11.camel@t60p>
References: <1228339524.6598.11.camel@t60p>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 14:16:07 -0800
Message-Id: <1228342567.13111.11.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 22:25 +0100, Gerald Schaefer wrote:
> offline_pages() calls lru_add_drain_all() followed by drain_all_pages().
> While drain_all_pages() works on each cpu, lru_add_drain_all() only runs
> on the current cpu for architectures w/o CONFIG_NUMA.

I'm a bit confused why this is.  Is this because the LRUs are per-zone
and we expected !CONFIG_NUMA systems to only have LRUs sitting on the
same (only) node as the current CPU?

This doesn't make any sense, though.  The pagevecs that
drain_cpu_pagevecs() actually empties out are per-cpu.

> This let us run
> into the BUG_ON(!PageBuddy(page)) in __offline_isolated_pages() during
> memory hotplug stress test on s390. The page in question was still on the
> pcp list, because of a race with lru_add_drain_all() and drain_all_pages()
> on different cpus.
> 
> This is fixed with this patch by adding CONFIG_MEMORY_HOTREMOVE to the
> lru_add_drain_all() #ifdef, to let it run on each cpu.

This doesn't seem right to me.  CONFIG_MEMORY_HOTREMOVE doesn't change
the layout of the LRUs, unlike NUMA or UNEVICTABLE_LRU.  So, I think
this bug is more due to the hotremove code mis-expecting behavior out of
lru_add_drain_all().

Why does this not affect the other lru_add_drain_all() users?

-- Dave

