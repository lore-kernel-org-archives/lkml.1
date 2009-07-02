Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZGBWJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZGBWJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZGBWJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:09:00 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:51559 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZGBWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:09:00 -0400
Message-ID: <4A4D2FDA.3000509@gmail.com>
Date: Fri, 03 Jul 2009 00:08:26 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, mingo@elte.hu,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: atomic64_t should be 8 bytes aligned
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 03 Jul 2009 00:08:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Thu, 2 Jul 2009, Eric Dumazet wrote:
>> Using a fixed initial value (instead of __atomic64_read()) is even faster, 
>> it apparently permits cpu to use an appropriate bus transaction.
> 
> Yeah, I guess it does a "read-for-write-ownership" and allows the thing to 
> be done as a single cache transaction.
> 
> If we read it first, it will first get the cacheline for shared-read, and 
> then the cmpxchg8b will need to turn it from shared to exclusive.
> 
> Of course, the _optimal_ situation would be if the cmpxchg8b didn't 
> actually do the write at all when the value matches (and all cores could 
> just keep it shared), but I guess that's not going to happen.
> 
> Too bad there is no pure 8-byte read op. Using MMX has too many downsides.
> 
> Btw, your numbers imply that for the atomic64_add_return(), we really 
> would be much better off not reading the original value at all. Again, in 
> that case, we really do want the "read-for-write-ownership" cache 
> transaction, not a read.
> 

I forgot to mention that if atomic64_t uses to cache lines, my test
program is 10x slower.

So we probably need an __attribute__((aligned(8)) on atomic64_t definition
as well, since alignof(atomic64_t) is 4, not 8 (!!!)

#include <stdio.h>

typedef struct {
        unsigned long long counter;
} atomic64_t;

typedef struct {
        unsigned long long __attribute__((aligned(8))) counter;
} atomic64_ta;

struct {
        int a;
        atomic64_t counter;
} s __attribute__((aligned(64)));

struct {
        int a;
        atomic64_ta counter;
} sa __attribute__((aligned(64)));

int main()
{
        printf("alignof(atomic64_t)=%d\n", __alignof__(atomic64_t));
        printf("alignof(atomic64_ta)=%d\n", __alignof__(atomic64_t));
        printf("alignof(unsigned long long)=%d\n", __alignof__(unsigned long long));
        printf("&s.counter=%p\n", &s.counter);
        printf("&sa.counter=%p\n", &sa.counter);
        return 0;
}

$ gcc -O2 -o test test.c ; ./test
alignof(atomic64_t)=4
alignof(atomic64_ta)=4
alignof(unsigned long long)=8
&s.counter=0x80496c4
&sa.counter=0x8049708
$ gcc -v
Using built-in specs.
Target: i686-pc-linux-gnu
Configured with: ../gcc-4.3.3/configure --enable-languages=c,c++ --prefix=/usr
Thread model: posix
gcc version 4.3.3 (GCC)


[PATCH] x86: atomic64_t should be 8 bytes aligned

LOCKED instructions on two cache lines are painful.
Make sure an atomic64_t is 8bytes aligned.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 2503d4e..1927a56 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -250,7 +250,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 /* An 64bit atomic type */
 
 typedef struct {
-	unsigned long long counter;
+	unsigned long long __attribute__((__aligned__(8))) counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(val)	{ (val) }
