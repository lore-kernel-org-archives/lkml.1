Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbZHEG4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbZHEG4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZHEG4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:56:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59145 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbZHEG4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:56:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 5 Aug 2009 15:55:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] oom: move oom_adj to signal_struct
Message-Id: <20090805155500.b4692b27.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090805153701.b4f4385e.minchan.kim@barrios-desktop>
References: <20090805110107.5B97.A69D9226@jp.fujitsu.com>
	<20090805114004.459a7deb.minchan.kim@barrios-desktop>
	<20090805114650.5BA1.A69D9226@jp.fujitsu.com>
	<20090805145516.b2129f81.minchan.kim@barrios-desktop>
	<20090805150323.2624a68f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090805153701.b4f4385e.minchan.kim@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 15:37:01 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:
> Hmm. I can't understand why it is troublesome. 
> I think it's related to moving oom_adj to singal_struct. 
> Unfortunately, I can't understand why we have to put oom_adj 
> in singal_struct?
> 
> That's why I have a question to Kosaki a while ago. 
> I can't understand it still. :-(
> 
> Could you elaborate it ?
> 

Current code is as following
==
  do_each_thread(g,p) {
	......
	p = badness();

	record p of highest badness.
  }
  p = higest badness thread.

  Scan all threads which shares mm_struct of p. and check oom_adj
  
==	
Assume a process which has 20000 threads. And 1 of thread has OOM_DISABLE.

Then, at worst, this scan will needs
	(1+2+3+....+20000) * (20000-1) scan. (when ignoring other processes)
even with your patch.

This means the kernel wastes enough long time that Cluster-Management-Software can
detetct this as livelock, and do reboot/cluster-fail-over.

Fixing livelock is not the last goal. I (we) would like to reduct stall time
to reasonable level. If we move oom_adj to signal_struct or mm_struct, scan-cost
will be only 20000. No retry at all.

And, if we can use for_each_process() rather than do_each_thread(),
scan-cost will be 1.

(BTW, "signal" struct is bad name I think, it should be "process" struct ;)


Thanks,
-Kame

