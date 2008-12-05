Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbYLENIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbYLENIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYLENIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:08:36 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:36560 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYLENIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:08:35 -0500
Subject: Re: [PATCH] memory hotplug: run lru_add_drain_all() on each cpu
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, npiggin@suse.de
In-Reply-To: <1228342567.13111.11.camel@nimitz>
References: <1228339524.6598.11.camel@t60p>
	 <1228342567.13111.11.camel@nimitz>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 14:08:20 +0100
Message-Id: <1228482500.8392.15.camel@t60p>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 14:16 -0800, Dave Hansen wrote:
> I'm a bit confused why this is.  Is this because the LRUs are per-zone
> and we expected !CONFIG_NUMA systems to only have LRUs sitting on the
> same (only) node as the current CPU?
> 
> This doesn't make any sense, though.  The pagevecs that
> drain_cpu_pagevecs() actually empties out are per-cpu.

Right, the pagevecs are per-cpu, independent from any CONFIG_NUMA
settings, and this is exactly why I would expect that lru_add_drain_all()
works on all cpus, as opposed to lru_add_drain() which works only on
the current cpu.

> This doesn't seem right to me.  CONFIG_MEMORY_HOTREMOVE doesn't change
> the layout of the LRUs, unlike NUMA or UNEVICTABLE_LRU.  So, I think
> this bug is more due to the hotremove code mis-expecting behavior out of
> lru_add_drain_all().
> 
> Why does this not affect the other lru_add_drain_all() users?

Good question, there are only a few other users and most of them were
added just recently with the unevictable lru patches. The only exception
is migrate_prep(), but this is only called from sys_move_pages(), which
is not implemented w/o CONFIG_NUMA afaik.

As explained above, the per-cpu pagevec layout should be independent
from NUMA or UNEVICTABLE_LRU, so I guess the right thing to do here
is completely remove the #ifdef as in the patch from Kosaki Motohiro
(or at least replace it with a CONFIG_SMP as suggested by Kamezawa
Hiroyuki).

Thanks,
Gerald


