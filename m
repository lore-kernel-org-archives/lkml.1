Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbYGKN7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbYGKN7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761915AbYGKNz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:55:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46385 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761909AbYGKNz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:55:26 -0400
Message-ID: <4877664C.3070803@sgi.com>
Date: Fri, 11 Jul 2008 06:55:24 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
       andi@firstfloor.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 19/26] x64, x2apic/intr-remap: introcude self IPI to genapic
 routines
References: <20080710181634.764954000@linux-os.sc.intel.com>	<20080710182238.631011000@linux-os.sc.intel.com>	<m1mykpfh56.fsf@frodo.ebiederm.org> <4876C572.3070803@sgi.com> <m1k5ftaxkf.fsf@frodo.ebiederm.org>
In-Reply-To: <m1k5ftaxkf.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
>> On a similar subject I would really like to change the send_IPI_mask to pass a
>> pointer to the cpumask_t arg:
>>
>>         void (*send_IPI_mask)(cpumask_t mask, int vector);
>>
>>
>> This bloats the stack by 512 bytes and seemingly is called by some fairly
>> nested routines.  Any opinions?
> 
> It sounds like a pain.  Especially since we would need to dereference
> cpumask_t when we use it.  Does any remember if there was a plan for
> dealing with cpumask_t when the number of cpus got large?
> 
> If we pass in a pointer to constant data semantically we should be fine.
> 
> Mostly I am wondering if three isn't a cleaner solution hidden away somewhere.
> 
> Eric

This is similar to the set_cpus_allowed_ptr which is the alternative for
passing the cpumask as a pointer.  When I did this way back when, the general
consensus was that the extra dereference was just a bit of noise in low use
functions.  

This case is different in that there is an API (via genapic).  I could always
add a new entry for send_IPI_mask_ptr, or I could change the existing interface
to be like the current cpumask operators, passing a pointer to the cpumask args
"silently".  This has an advantage in that we could "not" pass the pointer if
say, NR_CPUS <= sizeof(LONG).  But I'd have to change references of the form
(genapic->send_IPI_mask).

And there are cases where the cpumask arg is cpumask_of_cpu() meaning there's
only one bit of interest which really wastes stack space.  And with the (real
soon now) next iteration to 16k cpus, pushing 2k on the stack, we will feel
the pain... ;-)

Thanks,
Mike
