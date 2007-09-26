Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbXIZQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbXIZQQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXIZQQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:16:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:39010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbXIZQQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:16:06 -0400
Date: Wed, 26 Sep 2007 18:16:02 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       kexec@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: [patch 1/7] Extended crashkernel command line
Message-ID: <20070926161602.GA26909@suse.de>
Mail-Followup-To: Oleg Verych <olecom@flower.upol.cz>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	kexec@lists.infradead.org, akpm@linux-foundation.org
References: <20070925182257.900701776@strauss.suse.de> <20070925182258.175348676@strauss.suse.de> <E1IaHPU-00089b-Bc@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaHPU-00089b-Bc@flower>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Verych <olecom@flower.upol.cz> [2007-09-25 22:53]:
> 
> > + *
> > + * The function returns 0 on success and -EINVAL on failure.
> > + */
> > +static int __init parse_crashkernel_mem(char 			*cmdline,
> > +					unsigned long long	system_ram,
> > +					unsigned long long	*crash_size,
> > +					unsigned long long	*crash_base)
> > +{
> > +	char *cur = cmdline;
> > +
> > +	/* for each entry of the comma-separated list */
> > +	do {
> > +		unsigned long long start = 0, end = ULLONG_MAX;
> > +		unsigned long long size = -1;
> 
> memparse(), as a wrapper for somple_strtoll(), always have a return value
> (zero by default).
> <http://article.gmane.org/gmane.linux.kernel/583426>

Ok, that's fixed now, see patch below.

> And why not to make overall result reliable? This is kernel after all.
> 
> I.e. if there's valid `crashkernel=' option, but some parsing errors, why
> not to apply some heuristics with warning in syslog, if user have some
> conf, bootloader (random) errors, but feature still works?

I'm against guessing. The user has to specify a parameter which is
right according to syntax.

However, I plan to make a patch that the kernel can detect a sensible
offset automatically for i386 and x86_64 as it's done in ia64. Since
both architectures have a relocatable kernel now, that makes perfectly
sense. But that's another patch.

---

This patches improves error handling in parse_crashkernel_mem() by comparing
the return pointer of memparse() with the input pointer and also replaces
all printk(KERN_WARNING msg) with pr_warning(msg).


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 kernel/kexec.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1172,33 +1172,50 @@ static int __init parse_crashkernel_mem(
 	do {
 		unsigned long long start = 0, end = ULLONG_MAX;
 		unsigned long long size = -1;
+		char *tmp;
 
 		/* get the start of the range */
-		start = memparse(cur, &cur);
+		start = memparse(cur, &tmp);
+		if (cur == tmp) {
+			pr_warning("crashkernel: Memory value expected\n");
+			return -EINVAL;
+		}
+		cur = tmp;
 		if (*cur != '-') {
-			printk(KERN_WARNING "crashkernel: '-' expected\n");
+			pr_warning("crashkernel: '-' expected\n");
 			return -EINVAL;
 		}
 		cur++;
 
 		/* if no ':' is here, than we read the end */
 		if (*cur != ':') {
-			end = memparse(cur, &cur);
+			end = memparse(cur, &tmp);
+			if (cur == tmp) {
+				pr_warning("crashkernel: Memory "
+						"value expected\n");
+				return -EINVAL;
+			}
+			cur = tmp;
 			if (end <= start) {
-				printk(KERN_WARNING "crashkernel: end <= start\n");
+				pr_warning("crashkernel: end <= start\n");
 				return -EINVAL;
 			}
 		}
 
 		if (*cur != ':') {
-			printk(KERN_WARNING "crashkernel: ':' expected\n");
+			pr_warning("crashkernel: ':' expected\n");
 			return -EINVAL;
 		}
 		cur++;
 
-		size = memparse(cur, &cur);
+		size = memparse(cur, &tmp);
+		if (cur == tmp) {
+			pr_warning("Memory value expected\n");
+			return -EINVAL;
+		}
+		cur = tmp;
 		if (size < 0) {
-			printk(KERN_WARNING "crashkernel: invalid size\n");
+			pr_warning("crashkernel: invalid size\n");
 			return -EINVAL;
 		}
 
