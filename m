Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYKGLc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYKGLc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYKGLcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:32:20 -0500
Received: from ozlabs.org ([203.10.76.45]:40261 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYKGLcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:32:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Date: Fri, 7 Nov 2008 22:32:02 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <20081107084016.GF4435@elte.hu> <20081107005229.53d6f2e3.akpm@linux-foundation.org>
In-Reply-To: <20081107005229.53d6f2e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811072232.03323.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2008 19:52:29 Andrew Morton wrote:
> So I can happily compile and run
>
> 	cpumask_first("hello, world");
>
> with CONFIG_SMP=n?

Good point.  It was based on the existing "first_cpu", but it's not a practice
we should encourage.

Hmm, the implementation of these UP versions is wrong in corner cases, too. 
Obviously it doesn't currently matter the way they are used, but a nasty trap
for the future.

Here's the addition, I've queued it for linux-next (which will next come out
after the weekend).

diff -u b/include/linux/cpumask.h b/include/linux/cpumask.h
--- b/include/linux/cpumask.h	Fri Nov 07 00:15:12 2008 +1100
+++ b/include/linux/cpumask.h	Fri Nov 07 22:28:33 2008 +1100
@@ -564,12 +564,36 @@
 }
 
 #if NR_CPUS == 1
-/* Uniprocesor. */
-#define cpumask_first(src)		({ (void)(src); 0; })
-#define cpumask_next(n, src)		({ (void)(src); 1; })
-#define cpumask_next_zero(n, src)	({ (void)(src); 1; })
-#define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
-#define cpumask_any_but(mask, cpu)	({ (void)(mask); (void)(cpu); 0; })
+/* Uniprocessor.  Assume all masks are "1". */
+static inline unsigned int cpumask_first(const struct cpumask *srcp)
+{
+	return 0;
+}
+
+/* Valid inputs for n are -1 and 0. */
+static inline unsigned int cpumask_next(int n, const struct cpumask *srcp)
+{
+	return n+1;
+}
+
+static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
+{
+	return n+1;
+}
+
+static inline unsigned int cpumask_next_and(int n,
+					    const struct cpumask *srcp,
+					    const struct cpumask *andp)
+{
+	return n+1;
+}
+
+/* cpu must be a valid cpu, ie 0, so there's no other choice. */
+static inline unsigned int cpumask_any_but(const struct cpumask *mask,
+					   unsigned int cpu)
+{
+	return 1;
+}
 
 #define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
diff -u b/lib/cpumask.c b/lib/cpumask.c
--- b/lib/cpumask.c	Fri Nov 07 00:15:12 2008 +1100
+++ b/lib/cpumask.c	Fri Nov 07 22:28:33 2008 +1100
@@ -67,6 +67,7 @@
 {
 	unsigned int i;
 
+	cpumask_check(cpu);
 	for_each_cpu(i, mask)
 		if (i != cpu)
 			break;



