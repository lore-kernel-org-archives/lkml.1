Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbYDOVn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbYDOVn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759334AbYDOVnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:43:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40742 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758583AbYDOVnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:43:15 -0400
Message-ID: <48052170.6070609@sgi.com>
Date: Tue, 15 Apr 2008 14:43:12 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
References: <20080415202805.GA26880@elte.hu> <20080415203405.GA27958@elte.hu> <20080415204208.GA30432@elte.hu> <Pine.LNX.4.64.0804151344340.1785@schroedinger.engr.sgi.com> <20080415205820.GC31645@elte.hu> <Pine.LNX.4.64.0804151405120.3252@schroedinger.engr.sgi.com> <20080415211953.GA4243@elte.hu> <Pine.LNX.4.64.0804151420430.3252@schroedinger.engr.sgi.com> <20080415212301.GA5428@elte.hu> <Pine.LNX.4.64.0804151423460.3252@schroedinger.engr.sgi.com> <20080415212833.GA6180@elte.hu>
In-Reply-To: <20080415212833.GA6180@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Christoph Lameter <clameter@sgi.com> wrote:
> 
>> On Tue, 15 Apr 2008, Ingo Molnar wrote:
>>
>>>> static DEFINE_PER_CPU(char, dummy)[10000];
>>> what's the guarantee that it's at the end of the section? I'd like 
>>> to pad the per cpu areas at their end. (doubling their size is a 
>>> good way to achieve that)
>> No guarantee. Its up to the linker. Sorry. We could add a new 
>> percpu.last section but that requires a number of changes to linking.
> 
> ah. Then the patch below should do the trick, right?
> 
> 	Ingo
> 
> ------------->
> Subject: larger: percpu
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue Apr 15 23:13:18 CEST 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/vmlinux_32.lds.S |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/arch/x86/kernel/vmlinux_32.lds.S
> ===================================================================
> --- linux.orig/arch/x86/kernel/vmlinux_32.lds.S
> +++ linux/arch/x86/kernel/vmlinux_32.lds.S
> @@ -186,6 +186,7 @@ SECTIONS
>  	__per_cpu_start = .;
>  	*(.data.percpu)
>  	*(.data.percpu.shared_aligned)
> +	. = . + 65536;
>  	__per_cpu_end = .;
>    }
>    . = ALIGN(PAGE_SIZE);

Or you could try this:

--- linux-2.6.x86.sched-last-0415.orig/include/linux/percpu.h
+++ linux-2.6.x86.sched-last-0415/include/linux/percpu.h
@@ -38,10 +38,7 @@

 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
-#ifdef CONFIG_MODULES
-#define PERCPU_MODULE_RESERVE  8192
-#else
-#define PERCPU_MODULE_RESERVE  0
+#define PERCPU_MODULE_RESERVE  65536
 #endif

 #define PERCPU_ENOUGH_ROOM                                             \
