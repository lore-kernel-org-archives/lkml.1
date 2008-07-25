Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYGYVFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYGYVFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYGYVFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:05:14 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47100 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751935AbYGYVFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:05:13 -0400
Message-ID: <488A4007.2000002@sgi.com>
Date: Fri, 25 Jul 2008 14:05:11 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com> <m1r6a4c5im.fsf@frodo.ebiederm.org> <4873FD00.1060101@goop.org> <488A3236.5070404@sgi.com> <488A33BC.3040406@goop.org> <488A38E4.7000206@sgi.com> <488A3AEE.4040302@goop.org>
In-Reply-To: <488A3AEE.4040302@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I'll just post what I have now (compiles and boots cleanly)...  and then
we can discuss these more extensively.

Thanks,
Mike

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>> Is this for the boot cpu (0), or for all cpus?  For the boot cpu, I have
>> this now in arch/x86/kernel/setup_percpu.c:
>>
>> +#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
>> +
>> +/* Initialize percpu offset for boot cpu (0) */
>> +unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
>> +       [0] = (unsigned long)__per_cpu_load
>> +};
>> +#else
>>  unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
>> +#endif
>>
>> So this should apply as well to the xen startup?
>>   
> 
> If it's just a static initialization, then it should be fine.  But some
> equivalent of your head_64.S changes are needed to actually set things up?
> 
> 
>>> xen_cpu_up() needs to do whatever initialization needed for a new cpu's
>>> percpu area (presumably whatever do_boot_cpu() does).
>>>
>>>     
>>
>> Does the startup include executing
>> arch/x86/kernel/head_64.S:startup_64() ?
>> I see arch/x86/xen/xen-head.S:startup_xen() so I'm guessing not?
>>   
> 
> No, it doesn't.  It bypasses all that startup code.  Aside from the few
> instructions in xen-head.S, xen_start_kernel() is the first thing to get
> run.
> 
> But when bringing up a secondary cpu, where does the new percpu memory
> actually get allocated?
> 
>> For the real startup, I do the following two things.  But I'm not
>> comfortable
>> enough with xen to think I'll get it right putting this in xen-head.S.
>>   
> 
> Yes, it needn't be in the asm code.  I'll work out what to do.  Looks
> like I just need to do an appropriate wrmsr(MSR_GS_BASE, ).
> 
>    J

