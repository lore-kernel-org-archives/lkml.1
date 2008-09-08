Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYIHUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYIHUMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYIHUMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:12:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752421AbYIHUME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:12:04 -0400
Message-ID: <48C5870F.6050509@sgi.com>
Date: Mon, 08 Sep 2008 13:11:59 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nickpiggin@yahoo.com.au, mingo@elte.hu, akpm@linux-foundation.org,
       steiner@sgi.com, jes@sgi.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for smp_call_function_mask
References: <20080906132944.GC4910@elte.hu>	<48C2C810.3070809@sgi.com>	<200809082030.41987.nickpiggin@yahoo.com.au> <20080908.125153.263452187.davem@davemloft.net>
In-Reply-To: <20080908.125153.263452187.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Mon, 8 Sep 2008 20:30:41 +1000
> 
>> Is that being tried? Setting it to 8192 or even higher during QA seems
>> like a good idea to me.
> 
> This is a great idea, especially since it will make it even more
> painfully obvious that essentially any function local cpumask_t
> variable is a bug.

Yes, that's what I have done in the past ... but putting it into the QA
testing would really trigger those stack overflow problems... ;-)

> 
> Really, it seems sensible to do something like:
> 
> 1) Make cpumask_t a pointer.
> 
> 2) Add cpumask_data_t which is what cpumask_t is now.  This gets
>    used when for the actual storage, and will only get applied to
>    datastructures that are dynamically allocated.  For example, for
>    the cpu_vm_mask in mm_struct.
> 
> 3) Type make and fix build failures until they are all gone.

I was wondering if we'd need to be able to default a cpumask_t pointer
argument to be a const and then use a different method for those cases
where it shouldn't be?  This would strengthen the compiler type checking
of functions calls.

For example:

	proto(cpumask_t mask)

would imply that *mask is a const, whereas

	proto(cpumask_var mask)

would indicate it to be non-const?

But then we couldn't use "cpumask_t" as a local declarator... So perhaps
we need something completely different for declaring cpumask arguments?

(I'm trying to figure out how to structure this with the least amount of
source editing.)

Thanks!
Mike


