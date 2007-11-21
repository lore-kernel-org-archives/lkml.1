Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbXKULk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbXKULk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXKULkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:40:20 -0500
Received: from ns1.suse.de ([195.135.220.2]:50797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbXKULkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:40:19 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Date: Wed, 21 Nov 2007 12:40:12 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com> <200711201345.39580.ak@suse.de> <029E5BE7F699594398CA44E3DDF55444F718D9@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444F718D9@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211240.12826.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 12:02:38 Metzger, Markus T wrote:


Your patch seems to be still word wrapped.

> 
> It seems we're avoiding to declare a structured data type and instead 
> prefer to describe the type indirectly.
> We gain the flexibility to work with different data layouts.
> We loose language support for working with structured types.

There is nothing that guarantees you that your structured types
match what the hardware generates anyways. So it doesn't make much difference --
your type system is already holey.
 
> What we would really want here are templates.

No, that would lead to bloated code again.


> I think that the absence of an explicit type declaration makes the code
> harder to understand and makes it easier to get it wrong when adding a
> new processor.

There are not that many new processors so that shouldn't be a huge issue.
 
> The code is not robust wrt small mistakes in the data layout spec. It
> might check that the field we're writing to is at least as big as the
> value we're writing; the same for reads. We would end up replacing
> static
> type checking with dynamic type checking.

Neither is the current code -- you could as well get the types wrong
(unless you auto generate them from RTL or something) 


> I would prefer to work with explicit type declarations, even if this 
> means a small increase in code size. It looks like the hardware settled
> on 64bit pointers everywhere, so I would not expect much more variation
> in DS. BTS has an unused field, which might go away some day.
> 
> What do you think?

The i386 ifdefs should really go away, except around the 32bit record
structure definitions. 

The noflags variant should be probably data driven too.


>  
> +	case PTRACE_BTS_ALLOCATE_BUFFER:
> +		ret = ptrace_bts_allocate_bts(child, data);
> +		break;
> +
> +	case PTRACE_BTS_GET_BUFFER_SIZE:
> +		ret = ptrace_bts_get_buffer_size(child);
> +		break;
> +
> +	case PTRACE_BTS_GET_INDEX:
> +		ret = ptrace_bts_get_index(child);
> +		break;
> +
> +	case PTRACE_BTS_READ_RECORD:
> +		ret = ptrace_bts_read_record
> +			(child, data,
> +			 (struct ptrace_bts_record __user *) addr);
> +		break;
> +
> +	case PTRACE_BTS_CONFIG:
> +		ptrace_bts_config(child, data);
> +		ret = 0;
> +		break;
> +
> +	case PTRACE_BTS_STATUS:
> +		ret = ptrace_bts_status(child);
> +		break;
> +

Regarding your interface (can you please write those manpages to get a
full rationable)? 

I'm not sure it's a good idea to have a READ_RECORD -- better would 
be likely a batched interface. Probably it would
be cleaner to combine get_index and read_record into a higher
level interface that works like normal read() -- gives you data 
not read before for multiple records. 

Also not sure why you have separate config and allocate_buffer steps.
They could be easily combined, couldn't they? 


> +/*
> + * Maximal BTS size in number of records
> + */
> +#define PTRACE_BTS_MAX_BTS_SIZE 4000

This should be likely some sort of sysctl. Or perhaps just use user supplied
buffers limited by the mlock ulimit (that would allow zero copy). Ok
it means the high level read interface proposed above wouldn't work.
Perhaps the high level interface is better, although zero copy would
be more efficient. Not 100% sure what is better.


> +
> +
> +struct ptrace_bts_configuration ptrace_bts_cfg;
> +
> +/*
> + * Configure trace hardware to enable tracing
> + * Return 0, on success; -Eerrno, otherwise.
> + */
> +static int ptrace_bts_enable(void)
> +{
> +	unsigned long long debugctl_msr = 0;
> +
> +	if (!ptrace_bts_cfg.debugctrl_mask)
> +		return -EOPNOTSUPP;
> +
> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
> +	debugctl_msr |= ptrace_bts_cfg.debugctrl_mask;
> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);

I still think you should cache the DEBUGCTLMSR. If you worry
about other people changing it provide a general accessor.

-Andi
