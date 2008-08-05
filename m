Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYHEPAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYHEPAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbYHEO7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:59:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:19685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbYHEO7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,310,1215414000"; 
   d="scan'208";a="604207162"
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Nishanth Aravamudan <nacc@us.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Tue, 5 Aug 2008 07:59:48 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj22S9ylbsOjZkKTS+yfjG1t2OkoQAMWgDQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA308329447@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
 <1217926585.3589.113.camel@twins>
In-Reply-To: <1217926585.3589.113.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+u64 sched_clock_cpu(int cpu)
+{
+       if (unlikely(!sched_clock_running))
+               return 0;
+
+       return sched_clock();
+}

This looks like it will solve the issue on the boot cpu.  It
leaves a potential hole as we bring up other cpus if[1] there
are any printk() calls before they get to cpu_init() to
initialize ar.kr3.  This code path is all under arch/ia64
though ... so if we shoot ourselves in the foot, it will be
our own fault.

-Tony

[1] Currently there is just one Dprintk() call in this path
at the start of start_secondary() ... I could put it inside
#ifndef CONFIG_PRINTK_TIME so as not to surprise anyone that
enabled it.
