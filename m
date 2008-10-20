Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYJTLAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYJTLAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYJTLAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:00:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYJTLAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:00:40 -0400
Date: Mon, 20 Oct 2008 13:00:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
Message-ID: <20081020110018.GA24579@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org> <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop> <20081020090502.GB31710@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020090502.GB31710@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > No, you don't pass it a phys_addr_t or a resource_size_t, you pass 
> > it a struct resource *
> 
> oops ... i only looked at:
> 
> +       char sym[4*sizeof(resource_size_t) + 8];
> 
> and assumed that it was a resource_size_t printout format :-/
> 
> while printing out ranges is useful too, it's by far not the only 
> source of ugliness all around resource_size_t.

so how about something like the two patches below (ontop of Linus's 
patch): the first patch introduces a "small" resource pointer printout 
format: %pr - the little brother of %pR.

The output format is [0x00001234] - minimum width is 8.

The second patch takes advantage of it in ioremap.c.

Not tested yet but should work. One thing that would be nice is to 
extend it to phys_addr_t as well. Right now there's no guarantee that 
sizeof(resource_size_t) == sizeof(phys_addr_t).

What do you think? Passing it by reference makes it somewhat ugly [and 
restricts it to lvalues], but that's the safest we can get at the moment 
i guess, as it guarantees followup vararg parameter correctness, because 
gcc does not check these extensions.

Worst-case we get gibberish output if it's used incorrectly - but we 
dont get a kernel security hole if a %s follows it in the format string 
and an attacker can control some of the parameters, etc.

	Ingo

---------------->
>From bec931cb306f0901b9e2017c845d5ad6016574e4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 20 Oct 2008 12:39:17 +0200
Subject: [PATCH] vsprintf: implement %pr to print resource_size_t

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/vsprintf.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a013bbc..ddcaa6e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -581,6 +581,21 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
 	return string(buf, end, sym, field_width, precision, flags);
 }
 
+static char *resource_size_string(char *buf, char *end, resource_size_t *val, int field_width, int precision, int flags)
+{
+	/* room for the actual number, the one "0x", [, ] and the final zero */
+	char sym[2*sizeof(resource_size_t) + 5];
+	char *p = sym, *pend = sym + sizeof(sym);
+	int size = 8;
+
+	*p++ = '[';
+	p = number(p, pend, *val, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	*p++ = ']';
+	*p = 0;
+
+	return string(buf, end, sym, field_width, precision, flags);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -592,6 +607,8 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
  * - 'S' For symbolic direct pointers
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
+ * - 'r' For a resource_size_t pointer, it prints the resource
+ *       addresses (in %pR format)
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -607,6 +624,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
 	case 'R':
 		return resource_string(buf, end, ptr, field_width, precision, flags);
+	case 'r':
+		return resource_size_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
@@ -627,6 +646,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
  * %pS output the name of a text symbol
  * %pF output the name of a function pointer
  * %pR output the address range in a struct resource
+ * %pr output the address in a pointer to a resource_size_t type
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing

>From cfbd2eec241a53bc5c1b95bb68f269036e3e92a4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 20 Oct 2008 09:08:57 +0200
Subject: [PATCH] x86, ioremap: use %pr in printk

use the new %pr IO resource pointer/address/size printk type conversion
specifier.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ae71e11..4725c7a 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -207,8 +207,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return NULL;
 
 	if (!phys_addr_valid(phys_addr)) {
-		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
-		       (unsigned long long)phys_addr);
+		printk(KERN_WARNING "ioremap: invalid physical address %pr\n",
+		       &phys_addr);
 		WARN_ON_ONCE(1);
 		return NULL;
 	}
@@ -267,9 +267,9 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		    (prot_val == _PAGE_CACHE_WC &&
 		     new_prot_val == _PAGE_CACHE_WB)) {
 			pr_debug(
-		"ioremap error for 0x%llx-0x%llx, requested 0x%lx, got 0x%lx\n",
-				(unsigned long long)phys_addr,
-				(unsigned long long)(phys_addr + size),
+		"ioremap error for %pr [%lx], requested 0x%lx, got 0x%lx\n",
+				&phys_addr,
+				size,
 				prot_val, new_prot_val);
 			free_memtype(phys_addr, phys_addr + size);
 			return NULL;
