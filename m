Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYGTKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYGTKEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 06:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYGTKEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 06:04:22 -0400
Received: from ozlabs.org ([203.10.76.45]:53978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbYGTKEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 06:04:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with cpumask_of_cpu_ptr
Date: Sun, 20 Jul 2008 20:03:30 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <200807181530.10044.rusty@rustcorp.com.au> <48809DEB.5060104@sgi.com>
In-Reply-To: <48809DEB.5060104@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807202003.31526.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2008 23:43:07 Mike Travis wrote:
> Rusty Russell wrote:
> > On Wednesday 16 July 2008 07:14:30 Mike Travis wrote:
> >>   * This patch replaces the dangerous lvalue version of cpumask_of_cpu
> >>     with new cpumask_of_cpu_ptr macros.  These are patterned after the
> >>     node_to_cpumask_ptr macros.
> >
> > Hi Mike,
> >
> >    Should we just put cpumask_of_cpu_map[] in generic code and then have
> > cpumask_of_cpu() always return a cpumask_t pointer?  These macros which
> > declare things which may be one of two types is a real penalty for code
> > readability.
> >
> > Thanks,
> > Rusty.
>
> Hi,
>
> I wouldn't mind it at all, and since it's almost always calling a function
> that requires a cpumask_t pointer (like the cpu_* ops or
> set_cpus_allowed_ptr) then there shouldn't be too many "pointer
> dereference" penalties.  I'm just always a bit hesitant to make too many
> generic changes since I have only x86 and ia64 machines to test with.

The simple version is just a static array of [NR_CPUS] cpumask_t's.  Do that, 
with an override for smarter archs?

I really REALLY prefer that over the fairly tortuous macros.

> Another thought I had is perhaps cpumask.h should define something that
> indicates a "huge NR_CPUS count" that is used globally to trigger things
> like kmalloc of cpumask variables, instead of declaring them on the
> stack...?  Or (as has been discussed in the past), maybe a new cpumask_t
> type will be needed?

AFAICT the final answer has to be a get_cpu_mask()/put_cpu_mask(), which 
sleeps and doesn't nest (so we can use a pool allocator).  Of course, that 
kind of analysis is non-trivial, so I suggest that's not for this merge 
window...

Want me to try something and see if it boots?
Rusty.
