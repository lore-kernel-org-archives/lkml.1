Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbZJFQK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbZJFQK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbZJFQK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:10:27 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:45167 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbZJFQK1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:10:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACIGy0pMROOX/2dsb2JhbACBUdINhCoE
Date: Tue, 6 Oct 2009 12:09:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 2/4] tree rcu: Add debug RCU head option
Message-ID: <20091006160948.GB15904@Krystal>
References: <20091006143727.868480435@polymtl.ca> <20091006144038.140258698@polymtl.ca> <4ACB684A.6060107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4ACB684A.6060107@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:08:43 up 49 days,  2:58,  2 users,  load average: 0.69, 0.38,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet (eric.dumazet@gmail.com) wrote:
> Mathieu Desnoyers a écrit :
> > Poisoning the rcu_head callback list. Only for rcu tree for now.
> > 
> > Helps finding racy users of call_rcu(), which results in hangs because list
> > entries are overwritten and/or skipped. Using the lower bit to poison because
> > include/net/dst.h __pad_to_align_refcnt complains when struct rcu_head grows.
> > 
> 
> I see :)
> 

I don't know if there is an easy fix for __pad_to_align_refcnt ?

> > --- linux-2.6-lttng.orig/include/linux/rcupdate.h	2009-10-06 10:35:15.000000000 -0400
> > +++ linux-2.6-lttng/include/linux/rcupdate.h	2009-10-06 10:35:18.000000000 -0400
> > @@ -45,6 +45,8 @@
> >   * struct rcu_head - callback structure for use with RCU
> >   * @next: next update requests in a list
> >   * @func: actual update function to call after the grace period.
> > + *
> > + * Debug mode assumes func pointer value is word-aligned.
> 
> Ouch, I guess you never tried CONFIG_CC_OPTIMIZE_FOR_SIZE=y ?
> 

oops. Well, simple fix would be : depends on !CC_OPTIMIZE_FOR_SIZE

It's a debug option after all... but I'd prefer growing the structure
with a supplementary field if possible.

Mathieu

> random extract from "nm -v vmlinux"
> 
> c0415e58 T in4_pton
> c0415f66 T in6_pton
> c04161f0 T in_aton
> c0416240 T net_ratelimit
> c0416250 t linkwatch_add_event
> c0416281 t linkwatch_schedule_work
> c0416301 T linkwatch_fire_event
> c0416368 t __linkwatch_run_queue
> c04164d2 t linkwatch_event
> c04164f4 T linkwatch_run_queue
> c0416500 T sk_chk_filter
> c0416703 t sk_filter_rcu_release
> c041671d T sk_detach_filter
> c041676a T sk_attach_filter
> c0416862 T sk_run_filter
> c0416f5d T sk_filter
> c0416fc4 t __flow_cache_shrink
> 
> gcc -v
> Using built-in specs.
> Target: i686-pc-linux-gnu
> Configured with: ../gcc-4.4.1/configure --enable-languages=c,c++ --prefix=/usr
> Thread model: posix
> gcc version 4.4.1 (GCC)
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
