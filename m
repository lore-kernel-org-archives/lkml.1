Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYGWOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYGWOQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYGWOQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:16:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48919 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751104AbYGWOQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:16:26 -0400
Message-ID: <48873D35.9030204@sgi.com>
Date: Wed, 23 Jul 2008 07:16:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Dave Jones <davej@codemonkey.org.uk>,
       Paul Jackson <pj@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Robert Richter <robert.richter@amd.com>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with	cpumask_of_cpu_ptr
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <200807181530.10044.rusty@rustcorp.com.au> <48809DEB.5060104@sgi.com> <200807202003.31526.rusty@rustcorp.com.au> <20080723112042.GA16420@elte.hu>
In-Reply-To: <20080723112042.GA16420@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>>> I wouldn't mind it at all, and since it's almost always calling a 
>>> function that requires a cpumask_t pointer (like the cpu_* ops or 
>>> set_cpus_allowed_ptr) then there shouldn't be too many "pointer 
>>> dereference" penalties.  I'm just always a bit hesitant to make too 
>>> many generic changes since I have only x86 and ia64 machines to test 
>>> with.
>> The simple version is just a static array of [NR_CPUS] cpumask_t's.  
>> Do that, with an override for smarter archs?
>>
>> I really REALLY prefer that over the fairly tortuous macros.
> 
> a fresh commit in -git has exposed the topology.h mess - see the hack 
> below. We now have diverging versions of topology_core_siblings() 
> semantics - that sure cannot be right. Mike?
> 
> 	Ingo
> 
> ------->
> commit 695a6b456307455a10059512208e8ed0d376ecd3
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jul 23 13:19:44 2008 +0200
> 
>     topology: work around topology_core_siblings() breakage
>     
>     work around:
>     
>     drivers/net/sfc/efx.c: In function â€˜efx_probe_interrupts':
>     drivers/net/sfc/efx.c:845: error: lvalue required as unary â€˜&' operand
>     
>     the topology API is a mess right now ...
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/net/sfc/efx.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
> index 45c72ee..1ababfa 100644
> --- a/drivers/net/sfc/efx.c
> +++ b/drivers/net/sfc/efx.c
> @@ -842,8 +842,10 @@ static void efx_probe_interrupts(struct efx_nic *efx)
>  			for_each_online_cpu(cpu) {
>  				if (!cpu_isset(cpu, core_mask)) {
>  					++efx->rss_queues;
> +#if 0
>  					cpus_or(core_mask, core_mask,
>  						topology_core_siblings(cpu));
> +#endif
>  				}
>  			}
>  		} else {

Ahh, yes, I see it now.  If you don't define topology_core_siblings then you get:

#ifndef topology_core_siblings
#define topology_core_siblings(cpu)             cpumask_of_cpu(cpu)
#endif

And of course this is no longer an lvalue.

Rusty - if you don't think there'll be objections from other arches I can put in
a generic cpumask_of_cpu_map[].

Thanks,
Mike



