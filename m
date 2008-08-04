Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYHDWBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYHDWBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYHDWAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:00:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:40627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYHDWAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:00:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,306,1215414000"; 
   d="scan'208";a="323069289"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Nishanth Aravamudan <nacc@us.ibm.com>,
       "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 4 Aug 2008 15:00:47 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj2at7Jtigh5owSRxKVSd3V/B4bJQABsMcgAAK4RqA=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
 <57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd bet resonable sums of money that we are (once again) accessing
> per-cpu variables in code before ia64 has a chance to initialize
> things so that they can actually work. :-(

I tried this simple hack to check ... per-cpu variables are
not usable until cpu_init() sets up the "ar.k3" register on
ia64.  So this hack checks to see if it is set before calling
cpu_clock():

--- a/kernel/printk.c   2008-08-01 10:20:47.000000000 -0700
+++ b/kernel/printk.c   2008-08-04 14:49:18.000000000 -0700
@@ -34,6 +34,7 @@
 #include <linux/syscalls.h>

 #include <asm/uaccess.h>
+#include <asm/kregs.h>

 /*
  * Architectures can override it:
@@ -737,7 +738,10 @@
                                unsigned long long t;
                                unsigned long nanosec_rem;

-                               t = cpu_clock(printk_cpu);
+                               if (ia64_get_kr(IA64_KR_PER_CPU_DATA))
+                                       t = cpu_clock(printk_cpu);
+                               else
+                                       t = 0;
                                nanosec_rem = do_div(t, 1000000000);
                                tlen = sprintf(tbuf, "[%5lu.%06lu] ",
                                                (unsigned long) t,

With this hack the kernel boots (with CONFIG_PRINTK_TIME=y).

This is effectively how the code used to operate before the architecture
hooks were cleaned away by:

commit b842271fbb9c8b5fd0e1c3e1895a3b67ba5bcc54
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jan 25 21:07:59 2008 +0100

    sched: remove printk_clock()

    printk_clock() is obsolete - it has been replaced with cpu_clock().

-Tony
