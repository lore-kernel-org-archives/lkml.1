Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZAOGUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZAOGUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZAOGUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:20:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42409 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZAOGUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:20:43 -0500
Date: Thu, 15 Jan 2009 15:19:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 2/4] memcg: use CSS ID in memcg
Message-Id: <20090115151936.9836878f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090112121424.GC27129@balbir.in.ibm.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108183003.accef865.kamezawa.hiroyu@jp.fujitsu.com>
	<20090112121424.GC27129@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 17:44:24 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
					   get_swappiness(next_mem));
> > +	struct mem_cgroup *victim;
> > +	unsigned long start_age;
> > +	int ret, total = 0;
> > +	/*
> > +	 * Reclaim memory from cgroups under root_mem in round robin.
> > +	 */
> > +	start_age = root_mem->scan_age;
> > +
> > +	while (time_after((start_age + 2UL), root_mem->scan_age)) {
> 
> This is confusing, why do we use time_after with scan_age. scan_age
> seems to be incremented every time we scan and has no relationship
> with time. 

time_after() is useful macro for checking counter which can go MAX-1->MAX->0->1>...


> The second thing is what happens if time_after() always
> returns 0, if we've been aggressively scanning? 
That never happens.

> The logic needs some  commenting, why the magic number 2?
> 
memcg->scan_age is update when 
 - the memcg is root of hierarchy.
 - we reclaim memory from memcg.

So, memcg->scan_age is update by 2 means, all memcg under hierarchy is accessed
by reclaim routine.

example) Consider hierarhy like this.
 
          xxx(ID=8)
             /yyy (ID=4)
             /zzz (ID=9)
             /www (ID=3)

In this case, scan will be done in following order

  .....->3->4->8->9->3->4->8->9->...
(start point is determined by last_scanned_child)

everytime we visit "8", 8's scan_age is updated.

So, if we see "8"  2 times, all other groups 4,9,3 is all accessed for freeing
memory. (by me or other threads.)


-Kame

