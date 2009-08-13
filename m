Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZHMLPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZHMLPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZHMLPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:15:00 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:51965 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZHMLO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=esb0w/6T9QPIF418WIpELCYlCsBeWUhFpbbShrKwSZaWqdEQh/hvlvh9t9SVTINOvd
         0fZ8TniUXwJUbEPInWB/UJwnjo5A252JNpXYoFbebT9rWYXRL+q+OBGU9yw5wbglVAdw
         xJhD7SmWUaIpvPqloR4sCM2iXeHKWzEU9oM5U=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090813095640.GB28446@elte.hu>
References: <7c86c4470908111504i3a1e83b9k140fdaa717584a30@mail.gmail.com>
	 <20090813095640.GB28446@elte.hu>
Date: Thu, 13 Aug 2009 13:14:59 +0200
Message-ID: <7c86c4470908130414xafa4441v5e58fad38e24863e@mail.gmail.com>
Subject: Re: perf_counters issue remapped count
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:56 AM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> Hi,
>>
>> I am trying to use the remapped counter feature
>> on Intel Core. It does not work as expected.
>
> it would be highly useful if you posted the .c files you used to
> test it.
>
Here it is. It assumes you have enabled PCE in CR4 on all your CPUs.
I used BRANCH to ensure it would not use a fixed counter given the
hdr->index is wrong for those.

#include <sys/types.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <sys/mman.h>
#include <err.h>

#include <perf_counter.h>

#ifdef __x86_64__
#define DECLARE_ARGS(val, low, high)    unsigned low, high
#define EAX_EDX_VAL(val, low, high)     ((low) | ((uint64_t )(high) << 32))
#define EAX_EDX_ARGS(val, low, high)    "a" (low), "d" (high)
#define EAX_EDX_RET(val, low, high)     "=a" (low), "=d" (high)
#else
#define DECLARE_ARGS(val, low, high)    unsigned long long val
#define EAX_EDX_VAL(val, low, high)     (val)
#define EAX_EDX_ARGS(val, low, high)    "A" (val)
#define EAX_EDX_RET(val, low, high)     "=A" (val)
#endif

#define barrier() __asm__ __volatile__("": : :"memory")

static inline unsigned long long rdpmc(int counter)
{
       unsigned low, high;

       asm volatile("rdpmc" : EAX_EDX_RET(val, low, high) : "c" (counter));
       return EAX_EDX_VAL(val, low, high);
}

static volatile int quit;
void sig_handler(int n)
{
       quit = 1;
}

/*
 * our test code (function cannot be made static otherwise it is optimized away)
 */
unsigned long
fib(unsigned long n)
{
       if (n == 0)
               return 0;
       if (n == 1)
               return 2;
       return fib(n-1)+fib(n-2);
}

int
main(int argc, char **argv)
{
       struct perf_counter_mmap_page *hdr;
       struct perf_counter_attr hw;
       char *name;
       uint64_t values[3];
       int ret, fd, src;
       unsigned int seq;

       memset(&hw, 0, sizeof(hw));

       /* make sure we do not use a fixed counter event */
       name = "PERF_COUNT_HW_BRANCH_INSTRUCTIONS";
       hw.type = PERF_TYPE_HARDWARE;
       hw.config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS;
       hw.read_format =
PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING;
       hw.disabled = 0;

       fd = perf_counter_open(&hw, 0, -1, -1, 0);
       if (fd == -1)
               err(1, "cannot open event");

       hdr = mmap(NULL, getpagesize(), PROT_READ, MAP_SHARED, fd, 0);
       if (hdr == MAP_FAILED)
               err(1, "cannot mmap page");

       signal(SIGALRM, sig_handler);

       ioctl(fd, PERF_COUNTER_IOC_ENABLE, 0);

       alarm(10);

       for(;quit == 0;) {
               uint64_t offset = 0;
               unsigned long loop;

               /* generate branches */
               fib(10);

               loop = 0;
               do {
                       loop++;
                       seq = hdr->lock;
                       barrier();
                       if (hdr->index > 0) {
                               values[0] = rdpmc(hdr->index-1);
                               offset = hdr->offset;
                               values[0] += offset;
                               values[1] = hdr->time_enabled;
                               values[2] = hdr->time_running;
                               src = 0;
                       } else {
                               ret = read(fd, values, sizeof(values));
                               src =1;
                               break;
                       }
                       barrier();
               } while (hdr->lock != seq);

               if (values[2])
                       values[0]= (uint64_t)((double)values[0] *
values[1]/values[2]);

               printf("%20"PRIx64" %s %s offset=0x%"PRIx64" src=%s loop=%lu\n",
                       values[0],
                       name,
                       values[1] != values[2] ? "(scaled)" : "",
                       offset, src ? "read" : "rdpmc",
                       loop);
       }
       ioctl(fd, PERF_COUNTER_IOC_DISABLE, 0);
       close(fd);
       return 0;
}
