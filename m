Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYDHUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYDHUoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYDHUoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:44:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33808 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752969AbYDHUoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:44:09 -0400
Message-ID: <47FBD915.7020809@sgi.com>
Date: Tue, 08 Apr 2008 13:44:05 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: modify show_shared_cpu_map in intel_cacheinfo
 v3
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>	 <20080408184301.842103000@polaris-admin.engr.sgi.com> <36ca99e90804081236ifa3eecfue3dd211f9cdcb32a@mail.gmail.com>
In-Reply-To: <36ca99e90804081236ifa3eecfue3dd211f9cdcb32a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>>  --- linux-2.6.x86.sched.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
>>  +++ linux-2.6.x86.sched/arch/x86/kernel/cpu/intel_cacheinfo.c
>>  @@ -591,20 +591,34 @@ static ssize_t show_size(struct _cpuid4_
>>         return sprintf (buf, "%luK\n", this_leaf->size / 1024);
>>   }
>>
>>  -static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>>  +static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
>>  +                                       int type, char *buf)
> I don't know if this is more efficient or better or cleaner, but how
> about to pass the function pointer (ie. cpulist_scnprintf or
> cpumap_scnprintf)? You safe at least one condition.
> 
>>  +               n = type?
>>  +                       cpulist_scnprintf(buf, len-2, *mask):
>>  +                       cpumask_scnprintf(buf, len-2, *mask);
> 
> Thanks.
> Bert

I have to subvert the cpumask interface a bit, but the resultant
code size is about 7 instructions smaller.

static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
		int (*cpumap_func)(char *, int, const cpumask_t *, int),
		char *buf)
{
	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
	int n = 0;

	if (len > 1) {
		cpumask_t *mask = &this_leaf->shared_cpu_map;
		n = cpumap_func(buf, len-2, mask, NR_CPUS);
		buf[n++] = '\n';
		buf[n] = '\0';
	}
	return n;
}

static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf)
{
	return show_shared_cpu_map_func(leaf, &__cpumask_scnprintf, buf);
}

static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf)
{
	return show_shared_cpu_map_func(leaf, &__cpulist_scnprintf, buf);
}

Btw, you were asking about how to determine NR_CPUS.  Here's one way:

root@newton:~# cat /sys/devices/system/cpu/online
0-2,4-7
root@newton:~# cat /sys/devices/system/cpu/possible
0-511
root@newton:~# cat /sys/devices/system/cpu/present
0-7
root@newton:~# cat /sys/devices/system/cpu/system
0-4095

Thanks,
Mike
