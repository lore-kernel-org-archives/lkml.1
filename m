Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZDMBGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZDMBGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZDMBGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:06:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49990 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZDMBF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:05:59 -0400
Date: Mon, 13 Apr 2009 10:04:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, Nick Piggin <npiggin@suse.de>
Subject: Re: How movable is zone movable?
Message-Id: <20090413100421.bf80cf99.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200904121129.09851.edt@aei.ca>
References: <200904121129.09851.edt@aei.ca>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009 11:29:09 -0400
Ed Tomlinson <edt@aei.ca> wrote:

> Hi,
> 
> How dependable should zone movable be?  After a boot kvm is able to get enough hugepages to 
> back the session.  After a day or two it becomes a lot less predictable.  Sometimes it will swap out for 30 seconds
> and then succeed other times it will fail.  Interestingly, it sometimes works if I cancel the kvm session after
> it tells me it cannot allocate the hugepages and immediatly restart.  It there some way to determine what
> is not respecting zone moveable?  Or is zone moveable just a suggestion and not expected to really be 
> moveable?
> 
> I have the following set in sysctl.conf
> 
> # huge_pages with movablecore set to 3G
> kernel.shmmax = 8589934592
> vm.nr_hugepages = 128
> vm.nr_overcommit_hugepages = 1408
> vm.hugepages_treat_as_movable = 1
> vm.hugetlb_shm_group = 1005
> 
> This is with any recient kernel release (2.6.28 and later)
> 

At first, "Movable" means that it's only includes anon/file-cache, they are migratable by page
migration (memory hotremove) and considered to be easy to be freed. 
Unfortunately, "move/migrate memory" for memory recalim is not implemented yet. So, at allocating
hugepages, all necessary memory should be freed (swapped out).

Plz see /proc/meminfo before trying to allocate hugepages.
%cat /proc/meminfo
Then, ACTIVE+INACTIVE is current usage of "Movable" pages. (AnonPages means pages needs swap to be freed.)
(or plz see /proc/zoneinfo)

If ACTIVE+INACTIVE is near to 3G in your system, some amount of memory will be swapped out
at huge page allocation.

One tricky way to gain big unused chunk of memory is memory offline->online. This will use
page migration. (But I don't think it's tested widely.)


Thanks,
-Kame

