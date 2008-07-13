Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbYGMSNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbYGMSNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYGMSNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:13:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:27841 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYGMSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Mv0+dDGyddfrHnlTfwvqgDV4l7o6rktfENtUH43BWNtXgRJrPz8+8tEIsFFTtARat3
         bYlnQhOEvpM7cRtvssrHK2d3piCI1IJPAXzAgAtKowO3dcNIVQzTqZDbmTgHNuhwmlI+
         fj1IYZlJi/ozvnoQQz+CdtiLyd/pJV8LRg5Es=
Message-ID: <b647ffbd0807131113o7103215u823e71fb4aa92e17@mail.gmail.com>
Date: Sun, 13 Jul 2008 20:13:16 +0200
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
In-Reply-To: <alpine.LFD.1.10.0807131041240.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
	 <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
	 <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>
	 <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org>
	 <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com>
	 <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807131041240.2959@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/13 Linus Torvalds <torvalds@linux-foundation.org>:
>
> On Sun, 13 Jul 2008, Linus Torvalds wrote:
>>
>> The thing is, we should fix the top level code to never even _consider_ an
>> invalid CPU as a target, and that in turn should mean that all the other
>> code should be able to just totally ignore CPU hotplug events.
>
> IOW, I think we should totally remove the whole "update_sched_domains()"
> thing too. Any logic that needs it is broken. We shouldn't detach the
> scheduler domains in DOWN_PREPARE (much less UP_PREPARE), we should just
> leave them damn well alone.
>
> As the comment says, "The domains and groups cannot be updated in place
> without racing with the balancing code". The thing is, we shouldn't even
> try. The correct way to handle all this is to make the balancing code use
> the domains regardless, but protect against CPU's going down with
> _another_ data structure that is much easier to update.
>
> Namely something like 'cpu_active_map'.
>
> Then we just get rid of all the crap in update_sched_domains() entirely,
> and then we can make the cpusets code do the *sane* thing, which is to
> rebuild the scheduler domains only when the CPU up/down has completed.
>
> So instead of this illogical and crazy mess:
>
>        +       switch (phase) {
>        +       case CPU_UP_CANCELED:
>        +       case CPU_UP_CANCELED_FROZEN:
>        +       case CPU_DOWN_FAILED:
>        +       case CPU_DOWN_FAILED_FROZEN:
>        +       case CPU_ONLINE:
>        +       case CPU_ONLINE_FROZEN:
>        +       case CPU_DEAD:
>        +       case CPU_DEAD_FROZEN:
>        +               common_cpu_mem_hotplug_unplug(1);
>
> it should just say
>
>        +       switch (phase) {
>        +       case CPU_ONLINE:
>        +       case CPU_ONLINE_FROZEN:
>        +       case CPU_DEAD:
>        +       case CPU_DEAD_FROZEN:
>        +               common_cpu_mem_hotplug_unplug(1);
>
> because it only makes sense to rebuild the scheduler domains when the
> thing SUCCEEDS.
>
> See? By having a sane design, the code is not just more robust and easy to
> follow, you can also simplify it and make it more logical.

Yes, I agree. And I did _not_ say that the current design is sane. My
impression about changes acceptable during a late release cycle was
utterly CRAPPY (indeed, it's always better to immediately fix a
problem the right way, not just add another patch and pray it doesn't
break somewhere else).


>
>                        Linus
>

-- 
Best regards,
Dmitry Adamushko
