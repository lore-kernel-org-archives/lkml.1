Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZA2CLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZA2CLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZA2CLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:11:07 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60188 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZA2CLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:11:03 -0500
Message-ID: <4981102C.2000400@linux.vnet.ibm.com>
Date: Wed, 28 Jan 2009 18:10:52 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
References: <20090121185021.GA8852@elte.hu>
In-Reply-To: <20090121185021.GA8852@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> We are pleased to announce version 6 of our performance counters subsystem 
> implementation. The shortlog, diffstat and the combo patch can be found 
> below. The combo patch against latest -git (2.6.29-rc2) can be also found 
> at:
> 
>    http://people.redhat.com/mingo/perfcounters/perfcounters-v6-v2.6.29-rc2.patch
> 
> It's also available in tip/master at:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> There are many changes in the v6 release:
> 
>  - PowerPC performance counters support from Paul Mackerras, for POWER6
>    and for the PPC970 family.
> 
>  - ioctl API to disable/enable individual counters and groups without
>    closing their fd. This can be useful for libraries, ad-hoc 
>    instrumentation and PAPI support.
> 
>  - 'pinned' and 'exclusive' counter attributes - for those
>    applications that want to influence counter scheduling explicitly.
> 
>  - The 'perfstat' utility (ex 'timec') has been updated:
> 
>       http://people.redhat.com/mingo/perfcounters/perfstat.c
> 
>  - 'kerneltop' (easy-to-use text mode NMI profiler) has been updated:
>    
>       http://people.redhat.com/mingo/perfcounters/kerneltop.c
> 
>  - Merged to latest mainline
> 
>  - Various fixes and other updates
> 
> 	Ingo

I'm not sure if this is the right place to propose such a thing, but I 
think it would be very valuable to have a standardized user-side library 
to accompany this addition to the kernel.

In particular, as a starting place for the discussion, I'd like to see 
functions in it that are very similar to a subset of what is currently 
in libpfm.  Specifically, I'd like to see the following functions (with 
the names changed to pcl_* perhaps):

extern pfm_err_t pfm_find_event(const char *str, unsigned int *idx);
extern pfm_err_t pfm_find_event_bycode(int code, unsigned int *idx);
extern pfm_err_t pfm_find_event_bycode_next(int code, unsigned int start,
                                             unsigned int *next);
extern pfm_err_t pfm_find_event_mask(unsigned int event_idx, const char 
*str,
                                      unsigned int *mask_idx);
extern pfm_err_t pfm_find_full_event(const char *str, pfmlib_event_t *e);

extern pfm_err_t pfm_get_max_event_name_len(size_t *len);

extern pfm_err_t pfm_get_num_events(unsigned int *count);
extern pfm_err_t pfm_get_num_event_masks(unsigned int event_idx,
                                          unsigned int *count);
extern pfm_err_t pfm_get_event_name(unsigned int idx, char *name,
                                     size_t maxlen);
extern pfm_err_t pfm_get_full_event_name(pfmlib_event_t *e, char *name,
                                          size_t maxlen);
extern pfm_err_t pfm_get_event_code(unsigned int idx, int *code);
extern pfm_err_t pfm_get_event_mask_code(unsigned int idx,
                                          unsigned int mask_idx,
                                          unsigned int *code);
extern pfm_err_t pfm_get_event_description(unsigned int idx, char **str);
extern pfm_err_t pfm_get_event_code_counter(unsigned int idx, unsigned 
int cnt,
                                             int *code);
extern pfm_err_t pfm_get_event_mask_name(unsigned int event_idx,
                                          unsigned int mask_idx,
                                          char *name, size_t maxlen);
extern pfm_err_t pfm_get_event_mask_description(unsigned int event_idx,
                                                 unsigned int mask_idx,
                                                 char **desc);


Now, since it's not clear right now how unit masks are going to be 
handled in your proposal, I'm not sure the that *_event_mask_* functions 
are applicable, but I think something that fills that function will be 
needed.

Architectures that have need for additional functionality should be free 
to add arch-specific functions.

Full descriptions of these functions can be found in the man pages of 
the libpfm documentation.

Any thoughts on this?  Do you already have a user library structure in mind?

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

