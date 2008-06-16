Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYFPM2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYFPM2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYFPM1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:27:52 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:47578 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbYFPM1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:27:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEAKj2VUhMQW1O/2dsb2JhbACBW6tX
Date: Mon, 16 Jun 2008 08:22:49 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when
	reading across CPUs.
Message-ID: <20080616122249.GB18561@Krystal>
References: <20080613040958.4f52ee29@linux360.ro> <1213417601.8237.37.camel@charm-linux> <20080614181103.17617db1@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080614181103.17617db1@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:20:19 up 11 days, 17:01,  2 users,  load average: 0.11, 0.36,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Fri, 13 Jun 2008 23:26:41 -0500
> Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Alternatively, you could get rid of the problem by making sure CPU0
> > never reads CPU1's data, by having the userspace reader use per-cpu
> > threads and using sched_setaffinity() to pin each thread to a given
> > cpu. See for example, the blktrace code, which does this.
> 
> Yes, and performance-wise this is better. Though I'm not sure setting
> affinity is 100% safe. Will the thread be migrated soon enough, so we
> don't read cross-CPU? The point is I'm not sure how hard this is
> enforced.
> 
> However, I suggest this patch should go in, for two reasons:
> 1. It provides expected behavior in any such situation.
> 2. It adds (almost) no overhead when used in conjuction with setting CPU
> affinity. When the writer acquires the spinlock, it does not busy-wait,
> so the spinlock just disables IRQs (relay_write()).
>  

Hi Eduard,

Two objections against this. First, taking a spinlock _is_ slow in SMP
because it involves synchronized atomic operations.

Second, Adding a spinlock to the relay write side is bad since it
opens the door to deadly embrace between a trap handler and normal
kernel code both running tracing code.

Unless really-really needed, which does not seem to be the case, I would
strongly recommend not merging this patch.

Mathieu


> > Actually, in a few days or so I'm planning on releasing the first cut
> > of a library that makes this and all the rest of the nice blktrace
> > userspace code available to other tracing applications, not just
> > blktrace.  Hopefully it would be something that you'd be able to use
> > for kmemtrace as well; in that case, you'd just use the library and
> > not have to worry about these details.
> 
> Sounds good. Thanks for letting me know.
> 
> 
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
