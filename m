Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0CJRb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:31:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0CJRby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:31:54 -0500
Date: Wed, 10 Mar 2010 18:30:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
Message-ID: <20100310173018.GA1294@redhat.com>
References: <20100309180615.GA11681@redhat.com> <1268239242.5279.46.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1268239242.5279.46.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 03/10, Peter Zijlstra wrote:
>
> On Tue, 2010-03-09 at 19:06 +0100, Oleg Nesterov wrote:
> > In particular, see http://marc.info/?l=linux-kernel&m=125261083613103
>
> /me puts it on the to-review stack.

Great, thanks. In fact, you already acked it before ;)

> > But now I have another question. Since 5da9a0fb673a0ea0a093862f95f6b89b3390c31e
> > cpuset_cpus_allowed_locked() is called without callback_mutex held by
> > try_to_wake_up().
> >
> > And, without callback_mutex held, isn't it possible to race with, say,
> > update_cpumask() which changes cpuset->cpus_allowed? Yes, update_tasks_cpumask()
> > should fixup task->cpus_allowed later. But isn't it possible (at least
> > in theory) that try_to_wake_up() gets, say, all-zeroes in task->cpus_allowed
> > after select_fallback_rq()->cpuset_cpus_allowed_locked() if we race with
> > update_cpumask()->cpumask_copy() ?
>
> Hurmm,.. good point,.. yes I think that might be possible.
> p->cpus_allowed is synchronized properly, but cs->cpus_allowed is not,
> bugger.
>
> I guess the quick fix is to really bail and always use cpu_online_mask
> in select_fallback_rq().

Yes, but this breaks cpusets.

Peter, please see the attached mbox with the last discussion and patches.
Of course, the changes in sched.c need the trivial fixups. I'll resend
if you think these changes make sense.

Oleg.

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cpuset_lock.m"

>From oleg@redhat.com Thu Sep 10 21:21:53 2009
Date: Thu, 10 Sep 2009 21:21:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] resend, cpuset/hotplug fixes
Message-ID: <20090910192153.GA584@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Status: RO
Content-Length: 418
Lines: 18

(my apologies to those who see this twice).


The 1st patch is preparation. 2-3 fix different problems, the 3rd one
depends on 2nd.

These patches change the code which I don't really understand, please
review.


As for the 3rd patch, it replaces

	cpu_hotplug-dont-affect-current-tasks-affinity.patch

in -mm tree. Imho the new patch is more simple and clean, but of course
this is subjective and I am biased.

Oleg.

>From rjw@sisk.pl Thu Sep 10 22:18:12 2009
Return-Path: rjw@sisk.pl
Received: from zmta03.collab.prod.int.phx2.redhat.com (LHLO
 zmta03.collab.prod.int.phx2.redhat.com) (10.5.5.33) by
 mail03.corp.redhat.com with LMTP; Thu, 10 Sep 2009 16:18:12 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 7F5804EFEA
	for <onestero@redhat.com>; Thu, 10 Sep 2009 16:18:12 -0400 (EDT)
Received: from zmta03.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta03.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qaWdRotOC5ni for <onestero@redhat.com>;
	Thu, 10 Sep 2009 16:18:12 -0400 (EDT)
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 5E2C54ECE0
	for <onestero@mail.corp.redhat.com>; Thu, 10 Sep 2009 16:18:12 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com [10.5.110.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8AKICgD004491
	for <oleg@redhat.com>; Thu, 10 Sep 2009 16:18:12 -0400
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8AKI0Os006158
	for <oleg@redhat.com>; Thu, 10 Sep 2009 16:18:00 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ogre.sisk.pl (Postfix) with ESMTP id 9952A153A4B;
	Thu, 10 Sep 2009 19:13:58 +0200 (CEST)
Received: from ogre.sisk.pl ([127.0.0.1])
 by localhost (ogre.sisk.pl [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 11412-02; Thu, 10 Sep 2009 19:13:40 +0200 (CEST)
Received: from tosh.localnet (220-bem-13.acn.waw.pl [82.210.184.220])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ogre.sisk.pl (Postfix) with ESMTP id 978731565F3;
	Thu, 10 Sep 2009 19:13:40 +0200 (CEST)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
Date: Thu, 10 Sep 2009 22:18:40 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Gautham Shenoy <ego@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
References: <20090910192153.GA584@redhat.com>
In-Reply-To: <20090910192153.GA584@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102218.40143.rjw@sisk.pl>
X-Virus-Scanned: amavisd-new at ogre.sisk.pl using MkS_Vir for Linux
X-RedHat-Spam-Score: -1.76  (AWL)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.18
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.10
Status: RO
Content-Length: 587
Lines: 25

Hi Oleg,

On Thursday 10 September 2009, Oleg Nesterov wrote:
> (my apologies to those who see this twice).
> 
> 
> The 1st patch is preparation. 2-3 fix different problems, the 3rd one
> depends on 2nd.
> 
> These patches change the code which I don't really understand, please
> review.
> 
> 
> As for the 3rd patch, it replaces
> 
> 	cpu_hotplug-dont-affect-current-tasks-affinity.patch
> 
> in -mm tree. Imho the new patch is more simple and clean, but of course
> this is subjective and I am biased.

The patches look good to me FWIW.

Thanks a lot for taking care of this!

Rafael

>From peterz@infradead.org Thu Sep 10 22:53:49 2009
Return-Path: peterz@infradead.org
Received: from zmta01.collab.prod.int.phx2.redhat.com (LHLO
 zmta01.collab.prod.int.phx2.redhat.com) (10.5.5.31) by
 mail03.corp.redhat.com with LMTP; Thu, 10 Sep 2009 16:53:49 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 1F30B93204
	for <onestero@redhat.com>; Thu, 10 Sep 2009 16:53:49 -0400 (EDT)
Received: from zmta01.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta01.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gFIPqn3u1aAu for <onestero@redhat.com>;
	Thu, 10 Sep 2009 16:53:49 -0400 (EDT)
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id E9B23931F0
	for <onestero@mail.corp.redhat.com>; Thu, 10 Sep 2009 16:53:48 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com [10.5.110.13])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8AKrmCb015358
	for <oleg@redhat.com>; Thu, 10 Sep 2009 16:53:48 -0400
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8AKrapm024526
	for <oleg@redhat.com>; Thu, 10 Sep 2009 16:53:37 -0400
Received: from e53227.upc-e.chello.nl ([213.93.53.227] helo=dyad.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Mlqdp-0002Ae-NV; Thu, 10 Sep 2009 20:53:17 +0000
Received: from [127.0.0.1] (dyad [192.168.0.60])
	by dyad.programming.kicks-ass.net (Postfix) with ESMTP id AEE2D10BC1;
	Thu, 10 Sep 2009 22:52:58 +0200 (CEST)
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gautham Shenoy <ego@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <20090910192153.GA584@redhat.com>
References: <20090910192153.GA584@redhat.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 22:53:16 +0200
Message-Id: <1252615996.7205.99.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: -3.861  (AWL,RCVD_IN_DNSWL_MED)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.18
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.13
Status: RO
Content-Length: 605
Lines: 24

On Thu, 2009-09-10 at 21:21 +0200, Oleg Nesterov wrote:
> (my apologies to those who see this twice).
> 
> 
> The 1st patch is preparation. 2-3 fix different problems, the 3rd one
> depends on 2nd.
> 
> These patches change the code which I don't really understand, please
> review.
> 
> 
> As for the 3rd patch, it replaces
> 
> 	cpu_hotplug-dont-affect-current-tasks-affinity.patch
> 
> in -mm tree. Imho the new patch is more simple and clean, but of course
> this is subjective and I am biased.

Look good to me.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo, will you stick them in -tip?


>From laijs@cn.fujitsu.com Fri Sep 11 09:16:19 2009
Return-Path: laijs@cn.fujitsu.com
Received: from zmta02.collab.prod.int.phx2.redhat.com (LHLO
 zmta02.collab.prod.int.phx2.redhat.com) (10.5.5.32) by
 mail03.corp.redhat.com with LMTP; Fri, 11 Sep 2009 03:16:19 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 30EAB9F0AB
	for <onestero@redhat.com>; Fri, 11 Sep 2009 03:16:19 -0400 (EDT)
Received: from zmta02.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta02.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZX5DzK0QQztm for <onestero@redhat.com>;
	Fri, 11 Sep 2009 03:16:19 -0400 (EDT)
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 0C8CB9F0A8
	for <onestero@mail.corp.redhat.com>; Fri, 11 Sep 2009 03:16:19 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com [10.5.110.13])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7GGZF022108
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:16:16 -0400
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84] (may be forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7G5iI000653
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:16:06 -0400
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 6B82A170117;
	Fri, 11 Sep 2009 15:16:05 +0800 (CST)
Received: from fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id n8B7Ftuc014949;
	Fri, 11 Sep 2009 15:15:56 +0800
Received: from [127.0.0.1] (unknown [10.167.141.204])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id A8E49D4211;
	Fri, 11 Sep 2009 15:16:49 +0800 (CST)
Message-ID: <4AA9F902.4030306@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 15:15:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Gautham Shenoy <ego@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
References: <20090910192153.GA584@redhat.com> <1252615996.7205.99.camel@laptop>
In-Reply-To: <1252615996.7205.99.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: -1.95  (AWL,RDNS_NONE)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.21
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.13
Status: RO
X-Status: A
Content-Length: 1960
Lines: 67

Peter Zijlstra wrote:
> On Thu, 2009-09-10 at 21:21 +0200, Oleg Nesterov wrote:
>> (my apologies to those who see this twice).
>>
>>
>> The 1st patch is preparation. 2-3 fix different problems, the 3rd one
>> depends on 2nd.
>>
>> These patches change the code which I don't really understand, please
>> review.
>>
>>
>> As for the 3rd patch, it replaces
>>
>> 	cpu_hotplug-dont-affect-current-tasks-affinity.patch
>>
>> in -mm tree. Imho the new patch is more simple and clean, but of course
>> this is subjective and I am biased.
> 
> Look good to me.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Ingo, will you stick them in -tip?
> 
>

Sorry. I was taken ill for weeks and forgot to follow these discussions.
Especially I should say sorry to Oleg.

I have different concept. cpuset_cpus_allowed() is not called at atomic
context nor non-preemptable context nor other critical context.
So it should be allowed to use mutexs. That's what I think.

There is a bug when migration_call() requires a mutex
before migration has been finished when cpu offline as Oleg described.

Bug this bug is only happened when cpu offline. cpu offline is rare and
is slowpath. I think we should fix cpu offline and ensure it requires
the mutex safely.

Oleg's patch moves all dirty things into CPUSET subsystem and makes
cpuset_cpus_allowed() does not require any mutex and increases CPUSET's
coupling. I don't feel it's good.

Anyway, Oleg's patch works good.

> > cpuset_cpus_allowed() is not only  used for CPU offline.
> > >
> > > sched_setaffinity() also uses it.
> 
> Sure. And it must take get_online_cpus() to avoid the races with hotplug.

Oleg hasn't answered that
"is it safe when pdflush() calls cpuset_cpus_allowed()?".
A patch may be needed to ensure pdflush() calls cpuset_cpus_allowed() safely.

One other minor thing:
Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
spinlock in RT is also mutex. Likely I'm wrong.

- Lai






>From peterz@infradead.org Fri Sep 11 09:34:21 2009
Return-Path: peterz@infradead.org
Received: from zmta03.collab.prod.int.phx2.redhat.com (LHLO
 zmta03.collab.prod.int.phx2.redhat.com) (10.5.5.33) by
 mail03.corp.redhat.com with LMTP; Fri, 11 Sep 2009 03:34:21 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 326F44F21D
	for <onestero@redhat.com>; Fri, 11 Sep 2009 03:34:21 -0400 (EDT)
Received: from zmta03.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta03.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i9ZqrkFsc3sA for <onestero@redhat.com>;
	Fri, 11 Sep 2009 03:34:21 -0400 (EDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 1C3D04F208
	for <onestero@mail.corp.redhat.com>; Fri, 11 Sep 2009 03:34:21 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com [10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7YKn1020621
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:34:21 -0400
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7Y9aM006841
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:34:09 -0400
Received: from e53227.upc-e.chello.nl ([213.93.53.227] helo=dyad.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Mm0dQ-0003Lq-II; Fri, 11 Sep 2009 07:33:32 +0000
Received: from [127.0.0.1] (dyad [192.168.0.60])
	by dyad.programming.kicks-ass.net (Postfix) with ESMTP id 2C3DC10BC1;
	Fri, 11 Sep 2009 09:33:12 +0200 (CEST)
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4AA9F902.4030306@cn.fujitsu.com>
References: <20090910192153.GA584@redhat.com>
	 <1252615996.7205.99.camel@laptop>  <4AA9F902.4030306@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 09:33:30 +0200
Message-Id: <1252654410.7126.1.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: -4  (RCVD_IN_DNSWL_MED)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.11
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.14
Status: RO
Content-Length: 443
Lines: 10

On Fri, 2009-09-11 at 15:15 +0800, Lai Jiangshan wrote:
> One other minor thing:
> Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
> spinlock in RT is also mutex. Likely I'm wrong.

But they have priority-inheritance, hence you cannot create a deadlock
through preemption. If the kstopmachine thread blocks on a mutex, the
owner gets boosted to kstopmachine's prio and runs to completion, after
that kstopmachine continues.


>From laijs@cn.fujitsu.com Fri Sep 11 09:54:21 2009
Return-Path: laijs@cn.fujitsu.com
Received: from zmta02.collab.prod.int.phx2.redhat.com (LHLO
 zmta02.collab.prod.int.phx2.redhat.com) (10.5.5.32) by
 mail03.corp.redhat.com with LMTP; Fri, 11 Sep 2009 03:54:21 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 5B0039F10D
	for <onestero@redhat.com>; Fri, 11 Sep 2009 03:54:21 -0400 (EDT)
Received: from zmta02.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta02.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id brrBUOKlTyIh for <onestero@redhat.com>;
	Fri, 11 Sep 2009 03:54:21 -0400 (EDT)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 3EAAB9F10C
	for <onestero@mail.corp.redhat.com>; Fri, 11 Sep 2009 03:54:21 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com [10.5.110.7])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7sKFG018408
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:54:21 -0400
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84] (may be forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7sAeM012961
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:54:11 -0400
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 45BC217008E;
	Fri, 11 Sep 2009 15:54:10 +0800 (CST)
Received: from fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id n8B7s0Jd017049;
	Fri, 11 Sep 2009 15:54:01 +0800
Received: from [127.0.0.1] (unknown [10.167.141.204])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id 0E5D329283A;
	Fri, 11 Sep 2009 15:54:55 +0800 (CST)
Message-ID: <4AAA01F4.3050502@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 15:53:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
References: <20090910192153.GA584@redhat.com>	 <1252615996.7205.99.camel@laptop>  <4AA9F902.4030306@cn.fujitsu.com> <1252654410.7126.1.camel@laptop>
In-Reply-To: <1252654410.7126.1.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: -1.95  (AWL,RDNS_NONE)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.16
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.7
Status: RO
Content-Length: 656
Lines: 17

Peter Zijlstra wrote:
> On Fri, 2009-09-11 at 15:15 +0800, Lai Jiangshan wrote:
>> One other minor thing:
>> Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
>> spinlock in RT is also mutex. Likely I'm wrong.
> 
> But they have priority-inheritance, hence you cannot create a deadlock
> through preemption. If the kstopmachine thread blocks on a mutex, the
> owner gets boosted to kstopmachine's prio and runs to completion, after
> that kstopmachine continues.
> 

The deadlock is because the owner is at the dead cpu, It's not because
the owner's prio is low. priority-inheritance can't help it.

I think we need to use a raw spinlock.


>From peterz@infradead.org Fri Sep 11 09:58:14 2009
Return-Path: peterz@infradead.org
Received: from zmta03.collab.prod.int.phx2.redhat.com (LHLO
 zmta03.collab.prod.int.phx2.redhat.com) (10.5.5.33) by
 mail03.corp.redhat.com with LMTP; Fri, 11 Sep 2009 03:58:14 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 415DE4F273
	for <onestero@redhat.com>; Fri, 11 Sep 2009 03:58:14 -0400 (EDT)
Received: from zmta03.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta03.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1ItvJhvUybo for <onestero@redhat.com>;
	Fri, 11 Sep 2009 03:58:14 -0400 (EDT)
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 253AD4F26D
	for <onestero@mail.corp.redhat.com>; Fri, 11 Sep 2009 03:58:14 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com [10.5.110.13])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7wDGu013620
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:58:13 -0400
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7w2j7006307
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:58:02 -0400
Received: from e53227.upc-e.chello.nl ([213.93.53.227] helo=dyad.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Mm10z-0003qX-Bd; Fri, 11 Sep 2009 07:57:53 +0000
Received: from [127.0.0.1] (dyad [192.168.0.60])
	by dyad.programming.kicks-ass.net (Postfix) with ESMTP id C90F910BC1;
	Fri, 11 Sep 2009 09:57:33 +0200 (CEST)
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4AAA01F4.3050502@cn.fujitsu.com>
References: <20090910192153.GA584@redhat.com>
	 <1252615996.7205.99.camel@laptop>  <4AA9F902.4030306@cn.fujitsu.com>
	 <1252654410.7126.1.camel@laptop>  <4AAA01F4.3050502@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 09:57:52 +0200
Message-Id: <1252655872.7126.5.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: -3.873  (AWL,RCVD_IN_DNSWL_MED)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.17
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.13
Status: RO
Content-Length: 772
Lines: 20

On Fri, 2009-09-11 at 15:53 +0800, Lai Jiangshan wrote:
> Peter Zijlstra wrote:
> > On Fri, 2009-09-11 at 15:15 +0800, Lai Jiangshan wrote:
> >> One other minor thing:
> >> Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
> >> spinlock in RT is also mutex. Likely I'm wrong.
> > 
> > But they have priority-inheritance, hence you cannot create a deadlock
> > through preemption. If the kstopmachine thread blocks on a mutex, the
> > owner gets boosted to kstopmachine's prio and runs to completion, after
> > that kstopmachine continues.
> > 
> 
> The deadlock is because the owner is at the dead cpu, It's not because
> the owner's prio is low. priority-inheritance can't help it.
> 
> I think we need to use a raw spinlock.

Not in mainline you don't.


>From peterz@infradead.org Fri Sep 11 09:38:03 2009
Return-Path: peterz@infradead.org
Received: from zmta02.collab.prod.int.phx2.redhat.com (LHLO
 zmta02.collab.prod.int.phx2.redhat.com) (10.5.5.32) by
 mail03.corp.redhat.com with LMTP; Fri, 11 Sep 2009 03:38:03 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 2DDEC9F0D5
	for <onestero@redhat.com>; Fri, 11 Sep 2009 03:38:03 -0400 (EDT)
Received: from zmta02.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta02.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rKhL4CfUL++X for <onestero@redhat.com>;
	Fri, 11 Sep 2009 03:38:03 -0400 (EDT)
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 101949F0CE
	for <onestero@mail.corp.redhat.com>; Fri, 11 Sep 2009 03:38:03 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com [10.5.110.14])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7c20g029106
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:38:02 -0400
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7boPv007422
	for <oleg@redhat.com>; Fri, 11 Sep 2009 03:37:51 -0400
Received: from e53227.upc-e.chello.nl ([213.93.53.227] helo=dyad.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Mm0hQ-0003RX-Bo; Fri, 11 Sep 2009 07:37:40 +0000
Received: from [127.0.0.1] (dyad [192.168.0.60])
	by dyad.programming.kicks-ass.net (Postfix) with ESMTP id B3D4210BC1;
	Fri, 11 Sep 2009 09:37:20 +0200 (CEST)
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4AA9F902.4030306@cn.fujitsu.com>
References: <20090910192153.GA584@redhat.com>
	 <1252615996.7205.99.camel@laptop>  <4AA9F902.4030306@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 09:37:39 +0200
Message-Id: <1252654659.7126.2.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RedHat-Spam-Score: -4  (RCVD_IN_DNSWL_MED)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.18
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.14
Status: RO
Content-Length: 323
Lines: 8

On Fri, 2009-09-11 at 15:15 +0800, Lai Jiangshan wrote:
> 
> I have different concept. cpuset_cpus_allowed() is not called at atomic
> context nor non-preemptable context nor other critical context.
> So it should be allowed to use mutexs. That's what I think.

It hardly does any work at all, so why bother with a mutex?


>From oleg@redhat.com Fri Sep 11 20:03:04 2009
Date: Fri, 11 Sep 2009 20:03:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
Message-ID: <20090911180304.GA3477@redhat.com>
References: <20090910192153.GA584@redhat.com> <1252615996.7205.99.camel@laptop> <4AA9F902.4030306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA9F902.4030306@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Status: RO
Content-Length: 2454
Lines: 65

On 09/11, Lai Jiangshan wrote:
>
> I have different concept. cpuset_cpus_allowed() is not called at atomic
> context nor non-preemptable context nor other critical context.
> So it should be allowed to use mutexs. That's what I think.

Well, it is called from non-preemptable context: move_task_off_dead_cpu().
That is why before this patch we had cpuset_cpus_allowed_lock(). And this
imho adds unneeded complications.

And I can't understand why sched_setaffinity() path should take the
global mutex instead of per-cpuset spinlock.

> There is a bug when migration_call() requires a mutex
> before migration has been finished when cpu offline as Oleg described.
>
> Bug this bug is only happened when cpu offline. cpu offline is rare and
> is slowpath. I think we should fix cpu offline and ensure it requires
> the mutex safely.

This is subjective, but I can't agree. I think we should fix cpusets
instead. We should try to avoid the dependencies between different
subsystems as much as possible.

> Oleg's patch moves all dirty things into CPUSET subsystem and makes
> cpuset_cpus_allowed() does not require any mutex and increases CPUSET's
> coupling. I don't feel it's good.

Again, subjective... But I can't understand "increases CPUSET's coupling".

>From my pov, this patch cleanups and simplifies the code. This was the
main motivation, the bugfix is just the "side effect". I don't understand
how this subtle cpuset_lock() can make things better. I can't understand
why we need the global lock to calc cpus_allowed.

> > > cpuset_cpus_allowed() is not only  used for CPU offline.
> > > >
> > > > sched_setaffinity() also uses it.
> >
> > Sure. And it must take get_online_cpus() to avoid the races with hotplug.
>
> Oleg hasn't answered that
> "is it safe when pdflush() calls cpuset_cpus_allowed()?".

Because I didn't see such a question ;) perhaps I missed it previously...

> A patch may be needed to ensure pdflush() calls cpuset_cpus_allowed() safely.

What is wrong with pdflush()->cpuset_cpus_allowed() ? Why this is not safe?

This

	cpuset_cpus_allowed(current, cpus_allowed);
	set_cpus_allowed_ptr(current, cpus_allowed);

looks equally racy, with or without the patch. But this is a bit off-topic,
mm/pdflush.c has gone away.

> One other minor thing:
> Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
> spinlock in RT is also mutex. Likely I'm wrong.

Yes, probably -rt need raw_lock (as you pointed out).

Oleg.

>From oleg@redhat.com Thu Sep 10 21:22:16 2009
Date: Thu, 10 Sep 2009 21:22:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cpusets: introduce cpuset->cpumask_lock
Message-ID: <20090910192216.GA603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Status: RO
Content-Length: 2231
Lines: 64

Preparation for the next patch.

Introduce cpuset->cpumask_lock. From now ->cpus_allowed of the "active"
cpuset is always changed under this spinlock_t.

A separate patch to simplify the review/fixing, in case I missed some
places where ->cpus_allowed is updated.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/cpuset.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- CPUHP/kernel/cpuset.c~1_ADD_CPUMASK_LOCK	2009-09-10 19:35:16.000000000 +0200
+++ CPUHP/kernel/cpuset.c	2009-09-10 20:06:39.000000000 +0200
@@ -92,6 +92,7 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
+	spinlock_t cpumask_lock;	/* protects ->cpus_allowed */
 	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
@@ -891,7 +892,9 @@ static int update_cpumask(struct cpuset 
 	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
+	spin_lock(&cs->cpumask_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	spin_unlock(&cs->cpumask_lock);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1781,6 +1784,8 @@ static struct cgroup_subsys_state *cpuse
 	cs = kmalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&cs->cpumask_lock);
 	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
 		kfree(cs);
 		return ERR_PTR(-ENOMEM);
@@ -1981,8 +1986,10 @@ static void scan_for_empty_cpusets(struc
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
+		spin_lock(&cp->cpumask_lock);
 		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
 			    cpu_online_mask);
+		spin_unlock(&cp->cpumask_lock);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 		mutex_unlock(&callback_mutex);
@@ -2030,7 +2037,9 @@ static int cpuset_track_online_cpus(stru
 
 	cgroup_lock();
 	mutex_lock(&callback_mutex);
+	spin_lock(&top_cpuset.cpumask_lock);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
+	spin_unlock(&top_cpuset.cpumask_lock);
 	mutex_unlock(&callback_mutex);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);

>From oleg@redhat.com Thu Sep 10 21:22:21 2009
Date: Thu, 10 Sep 2009 21:22:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cpusets: rework guarantee_online_cpus() to fix
	deadlock with cpu_down()
Message-ID: <20090910192221.GA610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Status: RO
Content-Length: 6814
Lines: 209

Suppose that task T bound to CPU takes callback_mutex. If cpu_down(CPU)
happens before T drops callback_mutex we have a deadlock.

stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
cpuset_lock() and hangs forever because CPU is already dead and thus
T can't be scheduled.

To simplify the testing, I added schedule_timeout_interruptible(3*HZ)
to cpuset_sprintf_cpulist() under mutex_lock(callback_mutex). Then,

	mkdir -p /dev/cpuset
	mount -t cgroup -ocpuset cpuset /dev/cpuset
	mkdir -p /dev/cpuset/XXX
	taskset -p 2 $$
	cat /dev/cpuset/XXX/cpuset.cpus

and, on another console,

	echo 0 >> /sys/devices/system/cpu/cpu1/online

Before this patch cpuset/hotplug subsytems deadlock, after this patch
everething is OK.

Since the previous patch we can access cs->cpus_allowed safely either
under the global callback_mutex or cs->cpumask_lock.

This patch:

	- kills cpuset_lock() and cpuset_cpus_allowed_locked()

	- converts move_task_off_dead_cpu() to use cpuset_cpus_allowed()

Then we change guarantee_online_cpus(),

	- take cs->cpumask_lock instead of callback_mutex

	- do NOT scan cs->parent cpusets. If there are no online CPUs in
	  cs->cpus_allowed, we use cpu_online_mask. This is only possible
	  when we are called by cpu_down() hooks, in that case
	  cpuset_track_online_cpus(CPU_DEAD) will fix things later.

In particular, this all means sched_setaffinity() takes the per cpuset
spinlock instead of global callback_mutex, and hotplug can forget about
complications added by cpusets.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cpuset.h |   13 -----------
 kernel/sched.c         |    4 ---
 kernel/cpuset.c        |   56 ++++++++++---------------------------------------
 3 files changed, 13 insertions(+), 60 deletions(-)

--- CPUHP/include/linux/cpuset.h~2_KILL_CPUSET_LOCK	2009-09-10 18:48:25.000000000 +0200
+++ CPUHP/include/linux/cpuset.h	2009-09-10 20:27:29.000000000 +0200
@@ -21,8 +21,6 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern void cpuset_cpus_allowed_locked(struct task_struct *p,
-				       struct cpumask *mask);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -69,9 +67,6 @@ struct seq_file;
 extern void cpuset_task_status_allowed(struct seq_file *m,
 					struct task_struct *task);
 
-extern void cpuset_lock(void);
-extern void cpuset_unlock(void);
-
 extern int cpuset_mem_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
@@ -105,11 +100,6 @@ static inline void cpuset_cpus_allowed(s
 {
 	cpumask_copy(mask, cpu_possible_mask);
 }
-static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
-					      struct cpumask *mask)
-{
-	cpumask_copy(mask, cpu_possible_mask);
-}
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
@@ -157,9 +147,6 @@ static inline void cpuset_task_status_al
 {
 }
 
-static inline void cpuset_lock(void) {}
-static inline void cpuset_unlock(void) {}
-
 static inline int cpuset_mem_spread_node(void)
 {
 	return 0;
--- CPUHP/kernel/sched.c~2_KILL_CPUSET_LOCK	2009-09-10 18:48:25.000000000 +0200
+++ CPUHP/kernel/sched.c	2009-09-10 20:27:29.000000000 +0200
@@ -7136,7 +7136,7 @@ again:
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu >= nr_cpu_ids) {
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		cpuset_cpus_allowed(p, &p->cpus_allowed);
 		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
 
 		/*
@@ -7550,7 +7550,6 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -7565,7 +7564,6 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		spin_unlock_irq(&rq->lock);
-		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);
--- CPUHP/kernel/cpuset.c~2_KILL_CPUSET_LOCK	2009-09-10 20:06:39.000000000 +0200
+++ CPUHP/kernel/cpuset.c	2009-09-10 20:28:11.000000000 +0200
@@ -268,16 +268,23 @@ static struct file_system_type cpuset_fs
  * Call with callback_mutex held.
  */
 
-static void guarantee_online_cpus(const struct cpuset *cs,
-				  struct cpumask *pmask)
+static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
 {
-	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
-		cs = cs->parent;
 	if (cs)
+		spin_lock(&cs->cpumask_lock);
+	/*
+	 * cs->cpus_allowed must include online CPUs, or we are called
+	 * from cpu_down() hooks. In that case use cpu_online_mask
+	 * temporary until scan_for_empty_cpusets() moves us to ->parent
+	 * cpuset.
+	 */
+	if (cs && cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
 		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
 	else
 		cpumask_copy(pmask, cpu_online_mask);
-	BUG_ON(!cpumask_intersects(pmask, cpu_online_mask));
+
+	if (cs)
+		spin_unlock(&cs->cpumask_lock);
 }
 
 /*
@@ -2106,20 +2113,8 @@ void __init cpuset_init_smp(void)
  * subset of cpu_online_map, even if this means going outside the
  * tasks cpuset.
  **/
-
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
-	mutex_lock(&callback_mutex);
-	cpuset_cpus_allowed_locked(tsk, pmask);
-	mutex_unlock(&callback_mutex);
-}
-
-/**
- * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
- * Must be called with callback_mutex held.
- **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
-{
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), pmask);
 	task_unlock(tsk);
@@ -2311,33 +2306,6 @@ int __cpuset_node_allowed_hardwall(int n
 }
 
 /**
- * cpuset_lock - lock out any changes to cpuset structures
- *
- * The out of memory (oom) code needs to mutex_lock cpusets
- * from being changed while it scans the tasklist looking for a
- * task in an overlapping cpuset.  Expose callback_mutex via this
- * cpuset_lock() routine, so the oom code can lock it, before
- * locking the task list.  The tasklist_lock is a spinlock, so
- * must be taken inside callback_mutex.
- */
-
-void cpuset_lock(void)
-{
-	mutex_lock(&callback_mutex);
-}
-
-/**
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a page
  *
  * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for

>From oleg@redhat.com Thu Sep 10 21:22:25 2009
Date: Thu, 10 Sep 2009 21:22:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cpu hotplug: don't play with current->cpus_allowed
Message-ID: <20090910192225.GA618@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Status: RO
Content-Length: 4324
Lines: 128

(replaces cpu_hotplug-dont-affect-current-tasks-affinity.patch)

_cpu_down() changes the current task's affinity and then recovers it at
the end. The problems are well known: we can't restore old_allowed if it
was bound to the now-dead-cpu, and we can race with the userspace which
can change cpu-affinity during unplug.

_cpu_down() should not play with current->cpus_allowed at all. Instead,
take_cpu_down() can migrate the caller of _cpu_down() after __cpu_disable()
removes the dying cpu from cpu_online_mask.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 +-
 kernel/cpu.c          |   19 ++++++-------------
 3 files changed, 8 insertions(+), 14 deletions(-)

--- CPUHP/include/linux/sched.h~3_CPU_DOWN_AFFINITY	2009-08-01 04:28:56.000000000 +0200
+++ CPUHP/include/linux/sched.h	2009-09-10 20:54:00.000000000 +0200
@@ -1794,6 +1794,7 @@ extern void sched_clock_idle_sleep_event
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
+extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
--- CPUHP/kernel/sched.c~3_CPU_DOWN_AFFINITY	2009-09-10 20:27:29.000000000 +0200
+++ CPUHP/kernel/sched.c	2009-09-10 20:54:00.000000000 +0200
@@ -7118,7 +7118,7 @@ static int __migrate_task_irq(struct tas
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
-static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	int dest_cpu;
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));
--- CPUHP/kernel/cpu.c~3_CPU_DOWN_AFFINITY	2009-08-01 04:28:56.000000000 +0200
+++ CPUHP/kernel/cpu.c	2009-09-10 20:54:00.000000000 +0200
@@ -163,6 +163,7 @@ static inline void check_for_tasks(int c
 }
 
 struct take_cpu_down_param {
+	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -171,6 +172,7 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -181,6 +183,8 @@ static int __ref take_cpu_down(void *_pa
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
 				param->hcpu);
 
+	if (task_cpu(param->caller) == cpu)
+		move_task_off_dead_cpu(cpu, param->caller);
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
@@ -191,10 +195,10 @@ static int __ref take_cpu_down(void *_pa
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_var_t old_allowed;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
+		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -205,9 +209,6 @@ static int __ref _cpu_down(unsigned int 
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
-
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
@@ -221,11 +222,6 @@ static int __ref _cpu_down(unsigned int 
 		goto out_release;
 	}
 
-	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current,
-			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
-
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
@@ -233,7 +229,7 @@ static int __ref _cpu_down(unsigned int 
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -251,8 +247,6 @@ static int __ref _cpu_down(unsigned int 
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -260,7 +254,6 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
 	return err;
 }
 


--9jxsPFA5p3P2qPhR--

