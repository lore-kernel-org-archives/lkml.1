Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZBXN2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZBXN2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZBXN2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:28:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:33158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZBXN2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:28:09 -0500
Message-ID: <49A3F5C5.4060107@kernel.org>
Date: Tue, 24 Feb 2009 22:27:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org> <20090224124042.GA31295@elte.hu>
In-Reply-To: <20090224124042.GA31295@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 13:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> It's not an optimization, it's a pessimisation :)

Hmmm... big word.  Looking up pessimisation... Ah, okay, it's from
pessimistic.

> Please read what i wrote to you. We want the percpu static and 
> dynamic areas to be _one and the same thing_. (With just the 
> different that static allocations have a handy compile-time 
> offset shortcut - but the access is still the same.)
> 
> Right now, with your latest code we still have this:
> 
>    * Use this to get to a cpu's version of the per-cpu object
>    * dynamically allocated. Non-atomic access to the current  CPU's
>    * version should probably be combined with get_cpu()/put_cpu().
>    */
>   #define per_cpu_ptr(ptr, cpu)   SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
> 
> This slows down per_cpu_ptr() and makes the dynamic percpu case 
> a second-class citizen because most actual usages are for the 
> current CPU, still have to go via the per_cpu_offset() 
> indirection.

Heh... I suppose this is why you and I are keeping disagreeing.
Currently, __my_cpu_offset is defined as percpu_read(this_cpu_off) and
__get_cpu_var() is defined as (*SHIFT_PERCPU_PTR(&per_cpu_var(var),
__my_cpu_offset), so our static access is now basically *per_cpu_ptr().

If per_cpu_ptr() is second class citizen, get_cpu_var() is too.  :-)
So, there's nothing more indirect about per_cpu_ptr() compared to
get_cpu_var() anymore.

> We cannot do that optimization due to the NUMA and SMP 
> assymetry. If NUMA and SMP had the same linear structure, as i 
> suggested we do, we could do it.

No no no, there's no difference whatsoever.  Either I'm glossly
misunderstanding something or you're because I really cannot see any
difference between static and dynamic ones except for whether the
offset itself is static or not.

What's missing is unification of static and dynamic accessors and thus
the faster accessors - percpu_read() and friends - for dynamic ones.
This will be the next round of patches.

> Currently you rely on per_cpu_offset() indirection basically as 
> a soft-TLB entry covering all dynamic allocations. That sucks.
> 
> Ok?

IIUC, the per_cpu_offset() indirection stems from %gs addressing
restriction.  We can't teach gcc about it and so the percpu_read() and
friends.  Come on, our static percpu variable uses per_cpu_offset()
too.

If my reality seems to be disassociated from other's more than it
usually is, please feel free to enlighten me.  :-)

Thanks.

-- 
tejun
