Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZERW3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZERW3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 18:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZERW3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 18:29:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbZERW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 18:29:37 -0400
Date: Mon, 18 May 2009 15:29:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>
cc: Martin Knoblauch <spamtrap@knobisoft.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from
 drivers/char/random.c
In-Reply-To: <20090518203420.GF2658@calx>
Message-ID: <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain>
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Matt Mackall wrote:

> On Mon, May 18, 2009 at 06:29:13AM -0700, Martin Knoblauch wrote:
> > 
> > CC Maintainer.
> 
> Bizarre. I bet Linus has an opinion about your compiler.

I have opinions about a lot of things ;)

> > > drivers/char/random.c: In function `get_random_int':
> > > drivers/char/random.c:1672: error: unrecognizable insn:
> > > (insn 202 148 150 0 /scratch/build/linux-2.6.30-rc6-git3/arch/x86/include/asm/tsc.h:23 (set (reg:SI 0 ax [91])
> > >         (subreg:SI (plus:DI (plus:DI (reg:DI 0 ax [88])
> > >                     (subreg:DI (reg:SI 6 bp) 0))
> > >                 (const_int -4 [0xfffffffffffffffc])) 0)) -1 (nil)
> > >     (nil))
> > > drivers/char/random.c:1672: internal compiler error: in extract_insn, at recog.c:2083

Oh wow. We seldom hit these things. Internal gcc compiler errors do 
happen, but it tends to be _very_ rare. And it's almost always some subtle 
use of inline asm that gets gcc's knickers all twisted up. Often due to 
the double register usage of 64-bit long long arithmetic.

That error report seems to be a bit confused about exactly what triggered 
it: it points to both "get_cycles()" (arch/x86/include/asm/tsc.h:23) and 
to the get_cpu_var() asm code (drivers/char/random.c:1672).

Martin - Is this a 32-bit compile? In particular, does the problem go away 
if you remove the " + get_cycles() "  part (which is three lines down from 
what that error case reports, but with code movement and combining, who 
can tell which one it is?)

Usually the only way to get gcc to calm down when it gets into a tizzy 
like this is to rewrite the thing in some way that gcc has a harder time 
screwing up. In particular, asking gcc to handle a 64-bit value (inside 
get_cycles()) while it's busy doing a lot of other things may have just 
fused the compilers poor little brain.

So the fix _may_ be as simple as just something like the appended. It 
doesn't change anything, but it rewrites things so that it doesn't do that 
"rdtsc" while a lot of other things are also "in flight" at the same time.

		Linus

---
 drivers/char/random.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b2ced39..68120e5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1669,11 +1669,14 @@ DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
 unsigned int get_random_int(void)
 {
 	struct keydata *keyptr;
-	__u32 *hash = get_cpu_var(get_random_int_hash);
+	__u32 *hash, garbage;
 	int ret;
 
+	garbage = get_cycles() + (long)&ret;
+	hash = get_cpu_var(get_random_int_hash);
+
 	keyptr = get_keyptr();
-	hash[0] += current->pid + jiffies + get_cycles() + (int)(long)&ret;
+	hash[0] += current->pid + jiffies + garbage;
 
 	ret = half_md4_transform(hash, keyptr->secret);
 	put_cpu_var(get_random_int_hash);
