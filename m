Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYLBKa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYLBKa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYLBKaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:30:12 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:49229 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYLBKaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:30:10 -0500
From: Nicolas Palix <npalix@diku.dk>
To: wli@holomorphy.com
Subject: [PATCH linux-next] sparc: Add missing of_node_put
Date: Tue, 2 Dec 2008 11:30:06 +0100
User-Agent: KMail/1.9.10
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Nicolas Palix <npalix@diku.dk>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3900
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200812021130.06197.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


of_node_put is needed before discarding a value received from
of_find_node_by_name, eg in error handling code or when the device
node is no longer used.

The semantic match that catches the bug is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression struct device_node *n;
position p1, p2;
struct device_node *n1;
statement S;
identifier f;
expression E;
expression *ptr != NULL;
@@

n@p1 = of_find_node_by_name(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f(n,...)
    when != E = n
    when any
    when strict
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
  of_node_put(n);
|
  n1 = f(n,...)
|
  E = n
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s of_find_node_by_name %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 arch/sparc/kernel/sun4c_irq.c |    2 ++
 arch/sparc/kernel/sun4d_irq.c |    1 +
 arch/sparc/kernel/sun4m_irq.c |    2 ++
 3 files changed, 5 insertions(+)

diff --git a/arch/sparc/kernel/sun4c_irq.c b/arch/sparc/kernel/sun4c_irq.c
index 5dc8a57..326b8b1 100644
--- a/arch/sparc/kernel/sun4c_irq.c
+++ b/arch/sparc/kernel/sun4c_irq.c
@@ -160,6 +160,7 @@ static void __init sun4c_init_timers(irq_handler_t counter_fn)
 	sun4c_timers = (void __iomem *) (unsigned long) addr[0];
 
 	irq = of_get_property(dp, "intr", NULL);
+	of_node_put(dp);
 	if (!irq) {
 		prom_printf("sun4c_init_timers: No intr property\n");
 		prom_halt();
@@ -200,6 +201,7 @@ void __init sun4c_init_IRQ(void)
 	}
 
 	addr = of_get_property(dp, "address", NULL);
+	of_node_put(dp);
 	if (!addr) {
 		prom_printf("sun4c_init_IRQ: No address property\n");
 		prom_halt();
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index d3cb76c..63bc805 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -508,6 +508,7 @@ static void __init sun4d_init_timers(irq_handler_t counter_fn)
 	 * bootbus.
 	 */
 	reg = of_get_property(dp, "reg", NULL);
+	of_node_put(dp);
 	if (!reg) {
 		prom_printf("sun4d_init_timers: No reg property\n");
 		prom_halt();
diff --git a/arch/sparc/kernel/sun4m_irq.c b/arch/sparc/kernel/sun4m_irq.c
index f103171..a1335c1 100644
--- a/arch/sparc/kernel/sun4m_irq.c
+++ b/arch/sparc/kernel/sun4m_irq.c
@@ -374,6 +374,7 @@ static void __init sun4m_init_timers(irq_handler_t counter_fn)
 	}
 
 	addr = of_get_property(dp, "address", &len);
+	of_node_put(dp);
 	if (!addr) {
 		printk(KERN_ERR "sun4m_init_timers: No 'address' prop.\n");
 		return;
@@ -437,6 +438,7 @@ void __init sun4m_init_IRQ(void)
 	}
 
 	addr = of_get_property(dp, "address", &len);
+	of_node_put(dp);
 	if (!addr) {
 		printk(KERN_ERR "sun4m_init_IRQ: No 'address' prop.\n");
 		return;
