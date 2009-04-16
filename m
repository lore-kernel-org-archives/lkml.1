Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZDPHmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZDPHmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZDPHmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:42:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33760 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZDPHmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:42:09 -0400
Date: Thu, 16 Apr 2009 16:40:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
 controller (v2)
Message-Id: <20090416164036.03d7347a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090416110246.c3fef293.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090415120510.GX7082@balbir.in.ibm.com>
	<20090416095303.b4106e9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416015955.GB7082@balbir.in.ibm.com>
	<20090416110246.c3fef293.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 11:02:46 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 16 Apr 2009 07:29:55 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Thanks, I could have almost sworn I had it.. but I clearly don't
> > 
> > Here is the fixed version
> > 
> > Feature: Add file RSS tracking per memory cgroup
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Changelog v3 -> v2
> > 1. Add corresponding put_cpu() for every get_cpu()
> > 
> > Changelog v2 -> v1
> > 
> > 1. Rename file_rss to mapped_file
> > 2. Add hooks into mem_cgroup_move_account for updating MAPPED_FILE statistics
> > 3. Use a better name for the statistics routine.
> > 
> > 
> > We currently don't track file RSS, the RSS we report is actually anon RSS.
> > All the file mapped pages, come in through the page cache and get accounted
> > there. This patch adds support for accounting file RSS pages. It should
> > 
> > 1. Help improve the metrics reported by the memory resource controller
> > 2. Will form the basis for a future shared memory accounting heuristic
> >    that has been proposed by Kamezawa.
> > 
> > Unfortunately, we cannot rename the existing "rss" keyword used in memory.stat
> > to "anon_rss". We however, add "mapped_file" data and hope to educate the end
> > user through documentation.
> > 
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Nice feature :) Thanks.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I'll test this today.
> 
Sorry, some troubles found. Ignore above Ack. 3points now.

1. get_cpu should be after (*)
==mem_cgroup_update_mapped_file_stat()
+	int cpu = get_cpu();
+
+	if (!page_is_file_cache(page))
+		return;
+
+	if (unlikely(!mm))
+		mm = &init_mm;
+
+	mem = try_get_mem_cgroup_from_mm(mm);
+	if (!mem)
+		return;
+ ----------------------------------------(*)
+	stat = &mem->stat;
+	cpustat = &stat->cpustat[cpu];
+
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
+	put_cpu();
+}
==

2. In above, "mem" shouldn't be got from "mm"....please get "mem" from page_cgroup.
(Because it's file cache, pc->mem_cgroup is not NULL always.)

I saw this very easily.
==
Cache: 4096
mapped_file: 20480
==

3. at force_empty().
==
+
+	cpu = get_cpu();
+	/* Update mapped_file data for mem_cgroup "from" */
+	stat = &from->stat;
+	cpustat = &stat->cpustat[cpu];
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, -1);
+
+	/* Update mapped_file data for mem_cgroup "to" */
+	stat = &to->stat;
+	cpustat = &stat->cpustat[cpu];
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, 1);
+	put_cpu();

This just breaks counter when page is not mapped. please check page_mapped().

like this:
==
    if (page_is_file_cache(page) && page_mapped(page)) {
	modify counter.
    }
==

and call lock_page_cgroup() in  mem_cgroup_update_mapped_file_stat().

This will be slow, but optimization will be very tricky and need some amount of time.


-Kame



