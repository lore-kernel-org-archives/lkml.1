Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbXIZVGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbXIZVGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbXIZVFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:05:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:55291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762497AbXIZVFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:05:35 -0400
Date: Wed, 26 Sep 2007 23:05:33 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: "Bernhard Walle (in kexec list)" <kexec@lists.infradead.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/7] Extended crashkernel command line
Message-ID: <20070926210533.GA1299@suse.de>
Mail-Followup-To: Oleg Verych <olecom@flower.upol.cz>,
	"Bernhard Walle (in kexec list)" <kexec@lists.infradead.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20070925182257.900701776@strauss.suse.de> <20070925182258.175348676@strauss.suse.de> <E1IaHPU-00089b-Bc@flower> <20070926161602.GA26909@suse.de> <20070926181843.GB24301@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926181843.GB24301@flower.upol.cz>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Verych <olecom@flower.upol.cz> [2007-09-26 20:18]:
> > 
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -1172,33 +1172,50 @@ static int __init parse_crashkernel_mem(
> >  	do {
> >  		unsigned long long start = 0, end = ULLONG_MAX;
> >  		unsigned long long size = -1;
> 
> no need in assigning values here, unless you plan to use them in case
> of `return -EINVAL', but i can not see that,

What about this (and yes, I tested with some wrong strings with Qemu):

----

This patch improves error handling in parse_crashkernel_mem() by comparing
the return pointer of memparse() with the input pointer and also replaces
all printk(KERN_WARNING msg) with pr_warning(msg).


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 kernel/kexec.c |   54 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 15 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1167,44 +1167,59 @@ static int __init parse_crashkernel_mem(
 					unsigned long long	*crash_size,
 					unsigned long long	*crash_base)
 {
-	char *cur = cmdline;
+	char *cur = cmdline, *tmp;
 
 	/* for each entry of the comma-separated list */
 	do {
-		unsigned long long start = 0, end = ULLONG_MAX;
-		unsigned long long size = -1;
+		unsigned long long start, end = ULLONG_MAX, size;
 
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
-		if (size < 0) {
-			printk(KERN_WARNING "crashkernel: invalid size\n");
+		size = memparse(cur, &tmp);
+		if (cur == tmp) {
+			pr_warning("Memory value expected\n");
+			return -EINVAL;
+		}
+		cur = tmp;
+		if (size >= system_ram) {
+			pr_warning("crashkernel: invalid size\n");
 			return -EINVAL;
 		}
 
 		/* match ? */
-		if (system_ram >= start  && system_ram <= end) {
+		if (system_ram >= start && system_ram <= end) {
 			*crash_size = size;
 			break;
 		}
@@ -1213,8 +1228,15 @@ static int __init parse_crashkernel_mem(
 	if (*crash_size > 0) {
 		while (*cur != ' ' && *cur != '@')
 			cur++;
-		if (*cur == '@')
-			*crash_base = memparse(cur+1, &cur);
+		if (*cur == '@') {
+			cur++;
+			*crash_base = memparse(cur, &tmp);
+			if (cur == tmp) {
+				pr_warning("Memory value expected "
+						"after '@'\n");
+				return -EINVAL;
+			}
+		}
 	}
 
 	return 0;
@@ -1234,8 +1256,10 @@ static int __init parse_crashkernel_simp
 	char *cur = cmdline;
 
 	*crash_size = memparse(cmdline, &cur);
-	if (cmdline == cur)
+	if (cmdline == cur) {
+		pr_warning("crashkernel: memory value expected\n");
 		return -EINVAL;
+	}
 
 	if (*cur == '@')
 		*crash_base = memparse(cur+1, &cur);
