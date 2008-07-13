Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYGMJxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYGMJxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYGMJxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:53:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:18249 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYGMJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Thx/kVqosF4nVYelFAEZMaa7L3XcK5B9q3EjlOA/yfOW7SKrXjLyfyc21anVw/KUrA
         gjhjnuefseRgvy00BSELvLMS5SiFJrrQiodEsWCYjAh4cjZQM6wuxtL3YQIztQI4Kjhh
         CFV45KBUNV3kWZh5bunzw3+BBT8jh6KUbEl5Y=
Message-ID: <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com>
Date: Sun, 13 Jul 2008 11:53:00 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
	 <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
	 <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>
	 <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/13 Linus Torvalds <torvalds@linux-foundation.org>:
> On Sun, 13 Jul 2008, Dmitry Adamushko wrote:
>>
>> try_to_wake_up() -> ... -> wake_idle() does not see "cpu_active_map".
>
> You're right. I missed a couple places, because that migrate code not only
> ends up using "cpu_is_offline()" instead of "!cpu_online()" (so my greps
> all failed), and because it has those online checks in multiple places.
> Grr.
>
> So it would need to change a few other "cpu_is_offline()" calls to
> "!cpu_active()" instead (in __migrate_task at a minimum).

it should have checked the result of select_task_rq() in
try_to_wake_up() or modify wake_idle() alternatively.

And let me explain one last time why I opposed your 'cpu_active_map' approach.

I do agree that there are likely ways to optimize the hotplug
machinery but I have been focused on fixing bugs in a scope of the
current framework trying to keep it intact with _minimal_ changes (as
it's probably .26 material).

The current way to synchronize with the load-balancer is to attach
NULL domains to all sched-domains upon CPU_DOWN_PREPARE and rebuild
sched-domains upon CPU_DOWN, effectively making the load-balancer
'blind' (and this way it's workable indeed). Perhaps it's an overkill
and something like being proposed by Miao or you should be
considered/tried as an alternative.

Even if we place "!cpu_active()" in all the load-balancer-related
places (btw., we can also do it with !cpu_online() / cpu_offline() as
Miao did with his initial patch) :

(1) common_cpu_mem_hotplug_unplug() -> rebuild_sched_domain() is still
called pretty "randomly" (breaking the aforementioned model). At the
very least it's an overkill;

(2) sched-domains are broken (at least while CPU_{UP,DOMS} ops. are in
progress) and in this state they are still used in a number of places.
That's just illogic;

With (2) in place, "cpu_mask_active" acts as a workaround to the
existing (broken by CPUSETS) model.
If we want "cpu_mask_active" as a primary solution, then the current
model should be altered (presumably, we don't need NULL domains any
more). Otherwise, it's kind of a strange (illogical) hybrid.


>
>                Linus
>

-- 
Best regards,
Dmitry Adamushko
