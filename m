Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYJJFmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYJJFmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYJJFmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:42:13 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:42289 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYJJFmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:42:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAEOI7khMQWq+/2dsb2JhbACBcrwbgWo
Date: Fri, 10 Oct 2008 01:42:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: bit-field is not thread-safe nor smp-safe
Message-ID: <20081010054210.GA19481@Krystal>
References: <48EEC6AD.4010606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48EEC6AD.4010606@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:30:24 up 127 days, 10:10,  9 users,  load average: 0.33, 0.41,
	0.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> bit-field is not thread-safe nor smp-safe.
> 
> struct marker_entry.rcu_pending is not protected by any lock
> in rcu-callback free_old_closure().
> so we must turn it into a safe type.
> 

All struct marker_entry.rcu_pending accesses are done with the
markers_mutex held, except the one done in free_old_closure(). Normally,
there should be a 
        if (entry->rcu_pending)
           rcu_barrier_sched();

At the beginning of each markers_mutex section (just after get_marker())
to make sure any pending callback is executed at that point before any
of rcu_pending or ptype are touched.

I just noticed that the "markers: fix unchecked format" patch has a race
with respect to this. I'll post a patch in a jiffy.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
