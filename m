Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZGCM1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZGCM1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZGCM1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:27:04 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:59777 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZGCM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:27:02 -0400
Message-ID: <4A4DF8F9.9030503@gmail.com>
Date: Fri, 03 Jul 2009 14:26:33 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: atomic64_t: _cmpxchg() & _read() optimizations
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain> <20090703120159.GB7161@elte.hu>
In-Reply-To: <20090703120159.GB7161@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 03 Jul 2009 14:26:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Thu, 2 Jul 2009, Eric Dumazet wrote:
>>> Using a fixed initial value (instead of __atomic64_read()) is even faster, 
>>> it apparently permits cpu to use an appropriate bus transaction.
>> Yeah, I guess it does a "read-for-write-ownership" and allows the 
>> thing to be done as a single cache transaction.
>>
>> If we read it first, it will first get the cacheline for 
>> shared-read, and then the cmpxchg8b will need to turn it from 
>> shared to exclusive.
>>
>> Of course, the _optimal_ situation would be if the cmpxchg8b 
>> didn't actually do the write at all when the value matches (and 
>> all cores could just keep it shared), but I guess that's not going 
>> to happen.
>>
>> Too bad there is no pure 8-byte read op. Using MMX has too many 
>> downsides.
>>
>> Btw, your numbers imply that for the atomic64_add_return(), we 
>> really would be much better off not reading the original value at 
>> all. Again, in that case, we really do want the 
>> "read-for-write-ownership" cache transaction, not a read.
> 
> Something like the patch below?
> 
> Please review it carefully, as the perfcounter exposure to the 
> conditional-arithmetics atomic64_t APIs is very low:
> 
>   earth4:~/tip> for N in $(git grep atomic64_ | grep perf_ |
>     sed 's/(/ /g'); do echo $N; done | grep ^atomic64_ | sort | uniq -c | sort -n
> 
>       1 atomic64_add_negative
>       1 atomic64_inc_return
>       2 atomic64_xchg
>       3 atomic64_cmpxchg
>       3 atomic64_sub
>       7 atomic64_t
>      11 atomic64_add
>      21 atomic64_set
>      22 atomic64_read
> 
> So while i have tested it on a 32-bit box, it's only lightly tested 
> (and possibly broken) due to the low exposure of the API.
> 
> Thanks,
> 
> 	Ingo
> 
> ----------------------->
> Subject: x86: atomic64_t: Improve atomic64_add_return()
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri Jul 03 12:39:07 CEST 2009
> 
> Linus noted (based on Eric Dumazet's numbers) that we would
> probably be better off not trying an atomic_read() in
> atomic64_add_return() but intead intentionally let the first
> cmpxchg8b fail - to get a cache-friendly 'give me ownership
> of this cacheline' transaction. That can then be followed
> by the real cmpxchg8b which sets the value local to the CPU.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> LKML-Reference: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/lib/atomic64_32.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/lib/atomic64_32.c
> ===================================================================
> --- linux.orig/arch/x86/lib/atomic64_32.c
> +++ linux/arch/x86/lib/atomic64_32.c
> @@ -76,13 +76,22 @@ u64 atomic64_read(atomic64_t *ptr)
>   */
>  u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
>  {
> -	u64 old_val, new_val;
> +	/*
> +	 * Try first with a (probably incorrect) assumption about
> +	 * what we have there. We'll do two loops most likely,
> +	 * but we'll get an ownership MESI transaction straight away
> +	 * instead of a read transaction followed by a
> +	 * flush-for-ownership transaction:
> +	 */
> +	u64 old_val, new_val, real_val = 1ULL << 32;
>  
>  	do {
> -		old_val = atomic_read(ptr);
> +		old_val = real_val;
>  		new_val = old_val + delta;
>  
> -	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
> +		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
> +
> +	} while (real_val != old_val);
>  
>  	return new_val;
>  }

Seems cool, I am going to apply it and test it too.

I cooked following patch, to address _cmpxchg() and _read().

[PATCH] x86: atomic64_t: _cmpxchg() & _read() optimizations

atomic64_cmpxchg() can use existing optimized __cmpxchg64() function,
no need to redefine another cmpxchg8b() variant (BTW this variant had
aliasing problems)

As suggested by Linus, atomic64_read() doesnt have to loop.

We can implement it with a single cmpxchg8b instruction, and avoid
initial reading of the value so that cpu can use a "read-for-write-ownership"
bus transaction.

We do not call __cmpxchg64() here because ebx/ecx values are not changed,
lowering register pressure for the compiler.

This saves 1008 bytes of code on vmlinux (CONFIG_PERF_COUNTERS=y)

Performance results (with a user mode program doing 10.000.000 atomic64_read()
on 2x4 cpus, all fighting on same atomic64_t location)

before :

 Performance counter stats for './atomic64_slow':

   62897.582084  task-clock-msecs         #      7.670 CPUs
            186  context-switches         #      0.000 M/sec
              4  CPU-migrations           #      0.000 M/sec
            132  page-faults              #      0.000 M/sec
   188218718344  cycles                   #   2992.463 M/sec
     1017372948  instructions             #      0.005 IPC
      132425024  cache-references         #      2.105 M/sec
      109006338  cache-misses             #      1.733 M/sec

    8.200718697  seconds time elapsed

(2352 cycles per atomic64_read())

after :
 Performance counter stats for './atomic64_fast':

   10912.935654  task-clock-msecs         #      6.663 CPUs
             41  context-switches         #      0.000 M/sec
              4  CPU-migrations           #      0.000 M/sec
            132  page-faults              #      0.000 M/sec
    32657177400  cycles                   #   2992.520 M/sec
      838338807  instructions             #      0.026 IPC
       41855076  cache-references         #      3.835 M/sec
       36402586  cache-misses             #      3.336 M/sec

    1.637767671  seconds time elapsed

(408 cycles per atomic64_read())

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/include/asm/atomic_32.h |   35 +++++++++--------------------
 1 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 2503d4e..14c9e9c 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -265,29 +265,10 @@ typedef struct {
 #define __atomic64_read(ptr)		((ptr)->counter)
 
 static inline unsigned long long
-cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
-{
-	asm volatile(
-
-		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
-
-		     :		"=A" (old)
-
-		     : [ptr]	"D" (ptr),
-				"A" (old),
-				"b" (ll_low(new)),
-				"c" (ll_high(new))
-
-		     : "memory");
-
-	return old;
-}
-
-static inline unsigned long long
 atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
 		 unsigned long long new_val)
 {
-	return cmpxchg8b(&ptr->counter, old_val, new_val);
+	return __cmpxchg64(&ptr->counter, old_val, new_val);
 }
 
 /**
@@ -333,9 +314,17 @@ static inline unsigned long long atomic64_read(atomic64_t *ptr)
 {
 	unsigned long long curr_val;
 
-	do {
-		curr_val = __atomic64_read(ptr);
-	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
+	/*
+	 * "+A" constraint to make sure gcc wont use eax or edx
+	 * as a base or offset register for address computation
+	 */
+	asm volatile(
+		"mov\t%%ebx, %%eax\n\t"
+		"mov\t%%ecx, %%edx\n\t"
+		LOCK_PREFIX "cmpxchg8b %1\n"
+			: "+A" (curr_val)
+			: "m" (*__xg(ptr))
+		);
 
 	return curr_val;
 }

