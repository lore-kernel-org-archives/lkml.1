Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbYCZSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbYCZSUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYCZSUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:20:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52518 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753960AbYCZSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:20:24 -0400
Message-ID: <47EA93E5.2030500@sgi.com>
Date: Wed, 26 Mar 2008 11:20:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 06/10] x86: reduce memory and stack usage in	intel_cacheinfo
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.683748000@polaris-admin.engr.sgi.com> <20080326065023.GG18301@elte.hu> <47EA6EA3.1070609@sgi.com> <20080326171241.GC20016@elte.hu> <47EA87D8.8030305@zytor.com> <20080326173508.GI20016@elte.hu>
In-Reply-To: <20080326173508.GI20016@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Ingo Molnar wrote:
>>>> The main goal was to avoid allocating 4096 bytes when only 32 would do 
>>>> (characters needed to represent nr_cpu_ids cpus instead of NR_CPUS cpus.) 
>>>> But I'll look at cleaning it up a bit more.  It wouldn't have to be a 
>>>> function if CHUNKSZ in cpumask_scnprintf() were visible (or a 
>>>> non-changeable constant.)
>>> well, do we care about allocating 4096 bytes, as long as we also free it? 
>>> It's not like we need to clear all the bytes or something. Am i missing 
>>> something here?
>> Well, 32 bytes fits on the stack, whereas 4096 bytes requires 
>> allocating a page -- which means either taking the risk of failing or 
>> blocking.  Of course, we're doing this for output, which has the same 
>> issue.
> 
> hm, i thought this was all implemented via dynamic allocation already, 
> within the cpumask_scnprintf function. But i see it doesnt do it - i 
> guess a new call could be introduced, cpumask_scnprintf_ptr() which 
> passes in a cpumask pointer and does dynamic allocation itself?
> 
> 	Ingo

Here's a snippet of the new patch.  This works fine (I think) for
cpus on a leaf.  The sched_debug_one problem should work the same way,
hopefully ;-)

[sorry, cut and pasted so no tabs]

 static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
 {
-       char mask_str[NR_CPUS];
-       cpumask_scnprintf(mask_str, NR_CPUS, this_leaf->shared_cpu_map);
-       return sprintf(buf, "%s\n", mask_str);
+       /*
+        * cpulist_scnprintf() has the advantage of compressing
+        * consecutive cpu numbers into a single range which seems
+        * appropriate for cpus on a leaf.  This will change what is
+        * output so scripts that process the output will have to change.
+        * The good news is that the output format is compatible
+        * with cpulist_parse() [bitmap_parselist()].
+        *
+        * Have to guess at output buffer size... 128 seems reasonable
+        * to represent all cpus on a leaf in the worst case, like
+        * if all cpus are non-consecutive and large numbers.
+        */
+       return cpulist_scnprintf(buf, 128, this_leaf->shared_cpu_map);
 }

Thanks,
Mike
