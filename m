Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYGRNnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYGRNnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbYGRNnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:43:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49573 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756631AbYGRNnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:43:13 -0400
Message-ID: <48809DEB.5060104@sgi.com>
Date: Fri, 18 Jul 2008 06:43:07 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with cpumask_of_cpu_ptr
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <20080715211429.629983000@polaris-admin.engr.sgi.com> <200807181530.10044.rusty@rustcorp.com.au>
In-Reply-To: <200807181530.10044.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 16 July 2008 07:14:30 Mike Travis wrote:
>>   * This patch replaces the dangerous lvalue version of cpumask_of_cpu
>>     with new cpumask_of_cpu_ptr macros.  These are patterned after the
>>     node_to_cpumask_ptr macros.
> 
> Hi Mike,
> 
>    Should we just put cpumask_of_cpu_map[] in generic code and then have 
> cpumask_of_cpu() always return a cpumask_t pointer?  These macros which 
> declare things which may be one of two types is a real penalty for code 
> readability.
> 
> Thanks,
> Rusty.

Hi,

I wouldn't mind it at all, and since it's almost always calling a function
that requires a cpumask_t pointer (like the cpu_* ops or set_cpus_allowed_ptr)
then there shouldn't be too many "pointer dereference" penalties.  I'm just
always a bit hesitant to make too many generic changes since I have only x86
and ia64 machines to test with.

But there's a few of these new "fake" pointer macros (well, at least two... ;-),
so we'll either need more of these types of macros, or we have to consider using
pointers for almost all cpumask_t args.  The next jump to 16k cpus will use
2k bytes of stack space for each cpumask_t arg, instead of the current "measly"
512 bytes.

Another thought I had is perhaps cpumask.h should define something that indicates
a "huge NR_CPUS count" that is used globally to trigger things like kmalloc of
cpumask variables, instead of declaring them on the stack...?  Or (as has been
discussed in the past), maybe a new cpumask_t type will be needed?

Thanks,
Mike

