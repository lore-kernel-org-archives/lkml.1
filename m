Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYELWb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYELWb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYELWbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:31:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49397
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYELWbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:31:48 -0400
Date: Mon, 12 May 2008 15:31:43 -0700 (PDT)
Message-Id: <20080512.153143.48741227.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18472.38209.615770.265421@alkaid.it.uu.se>
References: <18465.63175.561233.228014@alkaid.it.uu.se>
	<20080512.005036.19633770.davem@davemloft.net>
	<18472.38209.615770.265421@alkaid.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Mon, 12 May 2008 21:06:41 +0200

> David Miller writes:
>  > Please also add the debugging patch below.
> 
> Right, 2.6.26-rc2 plus your debugging patch and booted with numa=debug
> prints the following:

Hmmm... my debugging patch had this:

diff --git a/lib/lmb.c b/lib/lmb.c
index 83287d3..3f55973 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
 ...
+#define DEBUG
+

which should have resulted in lmb_dump_all() printing some userful
debugging messages.  I validated that it did so on my machine with the
patch applied, but they appear nowhere in your logs :(

paginig_init() in arch/sparc64/mm/init.c calls lmb_analyze() them lmb_dump_all().

Those messages go out with KERN_DEBUG log level, maybe messages at
that level were trimmed by your log capture for some reason?

In any event I think I know the area that's cause some kind of problem.
It looks like lmb_alloc() has a case where it will reserve the wrong
amount of memory, or something like that.

You can remove the debugging patch I sent you, and try this one instead.
Please make sure KERN_DEBUG messages make it into the log :-)

diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index a9828d7..a628a99 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1353,6 +1353,8 @@ static void __init bootmem_init_one_node(int nid)
 
 	numadbg("bootmem_init_one_node(%d)\n", nid);
 
+	lmb_dump_all();
+
 	p = NODE_DATA(nid);
 
 	if (p->node_spanned_pages) {
diff --git a/lib/lmb.c b/lib/lmb.c
index 83287d3..d8c84f3 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -17,6 +17,8 @@
 
 #define LMB_ALLOC_ANYWHERE	0
 
+#define DEBUG
+
 struct lmb lmb;
 
 void lmb_dump_all(void)
@@ -29,7 +31,7 @@ void lmb_dump_all(void)
 	pr_debug("    memory.size		  = 0x%llx\n",
 	    (unsigned long long)lmb.memory.size);
 	for (i=0; i < lmb.memory.cnt ;i++) {
-		pr_debug("    memory.region[0x%x].base       = 0x%llx\n",
+		pr_debug("    memory.region[0x%lx].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.memory.region[i].base);
 		pr_debug("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.memory.region[i].size);
@@ -38,7 +40,7 @@ void lmb_dump_all(void)
 	pr_debug("    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
 	pr_debug("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
 	for (i=0; i < lmb.reserved.cnt ;i++) {
-		pr_debug("    reserved.region[0x%x].base       = 0x%llx\n",
+		pr_debug("    reserved.region[0x%lx].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.reserved.region[i].base);
 		pr_debug("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.reserved.region[i].size);
