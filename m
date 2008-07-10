Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbYGJRlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbYGJRlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbYGJRlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:41:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38306 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758067AbYGJRlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:41:08 -0400
Message-ID: <487649B2.3000405@sgi.com>
Date: Thu, 10 Jul 2008 10:41:06 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487641D6.5060206@goop.org>
In-Reply-To: <487641D6.5060206@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>> One thing to remember is the eventual goal is implementing the cpu_alloc
>> functions which I think we've agreed has to be "growable".  This means
>> that
>> the addresses will need to be virtual to allow the same offsets for
>> all cpus.
>> The patchset I have uses 2Mb pages.  This "little" twist might figure
>> into the
>> implementation issues that are being discussed.
> 
> You want to virtually map the percpu area?  How and when would it get
> extended?
> 
>    J


CPU_ALLOC(), or some such means.  This is to replace the percpu allocator
in modules.c:

    Subject: cpu alloc: The allocator

    The per cpu allocator allows dynamic allocation of memory on all
    processors simultaneously. A bitmap is used to track used areas.
    The allocator implements tight packing to reduce the cache footprint
    and increase speed since cacheline contention is typically not a concern
    for memory mainly used by a single cpu. Small objects will fill up gaps
    left by larger allocations that required alignments.

    The size of the cpu_alloc area can be changed via make menuconfig.

    Signed-off-by: Christoph Lameter <clameter@sgi.com>

and:

    Subject: cpu alloc: Use cpu allocator instead of the builtin modules per cpu allocator

    Remove the builtin per cpu allocator from modules.c and use cpu_alloc instead.

    The patch also removes PERCPU_ENOUGH_ROOM. The size of the cpu_alloc area is
    determined by CONFIG_CPU_AREA_SIZE. PERCPU_ENOUGH_ROOMs default was 8k.
    CONFIG_CPU_AREA_SIZE defaults to 32k. Thus we have more space to load modules.

    Signed-off-by: Christoph Lameter <clameter@sgi.com>

The discussion that followed was very emphatic that the size of the space should
not be fixed, but instead be dynamically growable.  Since the offset needs to be
fixed for each cpu, then virtual (I think) is the only way to go.  The use of a
2MB page just conserves map entries.  (Of course, if we just reserved 2MB in the
first place it might not need to be virtual...?  But the concern was for systems
with hundreds of (say) network interfaces using even more than 2MB.)

Thanks,
Mike
