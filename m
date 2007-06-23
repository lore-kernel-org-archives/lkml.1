Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbXFWLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbXFWLPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbXFWLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:15:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:63922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbXFWLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:15:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 6/6] Convert tasklets to work queues
Date: Sat, 23 Jun 2007 13:15:26 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org> <20070622040137.414439610@goodmis.org>
In-Reply-To: <20070622040137.414439610@goodmis.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231315.27426.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ExyvKyAPUPyhDOz+/2ayd6iPbprhdqD2QR+v
 Pq3I+wv4odGKL04b3Wl5U9a7K4U178GGu2EmcyAeOXiZD8gfJz
 13Mvb7Q0T+t7gk/7xWBew==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007, Steven Rostedt wrote:
> This patch creates an alternative for drivers from using tasklets.
> It creates a "work_tasklet". When configured to use work_tasklets
> instead of tasklets, instead of creating tasklets, a work queue
> is made in its place.  The API is still the same, and the drivers
> don't know that a work queue is being used.
> 

Perhaps the API can be slimmed down in the process, because half
of the tasklet interface functions are hardly used at all.

> +#define DECLARE_TASKLET(name, func, data)				\
> +	struct tasklet_struct name = {					\
> +		__WORK_INITIALIZER((name).work, work_tasklet_exec),	\
> +		LIST_HEAD_INIT((name).list),				\
> +		0,							\
> +		ATOMIC_INIT(0),						\
> +		func,							\
> +		data,							\
> +		#name							\
> +	}

18 users of this macro. Maybe too much for the start, but if we convert
all of them to use either tasklet_init or use work queues directly,
the macro can go away.

> +#define DECLARE_TASKLET_DISABLED(name, func, data)			\
> +	struct tasklet_struct name = {					\
> +		__WORK_INITIALIZER((name).work, work_tasklet_exec),	\
> +		LIST_HEAD_INIT((name).list),				\
> +		0,							\
> +		ATOMIC_INIT(1),						\
> +		func,							\
> +		data,							\
> + 		#name							\
> +	}

this one is easier, there are only four users in total: three input
drivers, and tipc.

> +void tasklet_schedule(struct tasklet_struct *t);
> +#define tasklet_hi_schedule tasklet_schedule
> +extern fastcall void tasklet_enable(struct tasklet_struct *t);
> +#define tasklet_hi_enable tasklet_enable

there are 34 files using tasklet_hi_* functions. In theory, these
could be converted to the non-hi version with a simple search and
replace, if it's clear that there is not much point in keeping them.

The most common use of tasklet_hi is in the alsa drivers. If it
actually makes a difference for them already, maybe there should
be an alsa softirq instead of moving them all over to work queues.

> +void tasklet_disable_nosync(struct tasklet_struct *t);

only has two users, bcm43xx and sc92031. If both are
converted to workqueue, the interface removed can be
removed.

> +extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);

only one user in total, rcupdate.c. You already take care of that,
it seems the declaration is just a leftover.

	Arnd <><
