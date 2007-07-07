Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbXGGGIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbXGGGIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 02:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXGGGIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 02:08:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:53129 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXGGGIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 02:08:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,510,1175497200"; 
   d="scan'208";a="247490393"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 10/10] *Tests* Scheduler profiling - Use immediate values
Date: Fri, 6 Jul 2007 23:08:05 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB5419485015CCB91@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070707015009.GA10775@Krystal>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 10/10] *Tests* Scheduler profiling - Use immediate values
Thread-Index: AcfAOSgWjISXMOuiRBebK/a79dT+tgAH1xsw
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Jul 2007 06:08:06.0938 (UTC) FILETIME=[2FC687A0:01C7C05D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

> 	cycles_per_iter = 0.0;
> 	for (i=0; i<NR_TESTS; i++) {
> 		time1 = get_cycles();
> 		for (j = 0; j < NR_ITER; j++) {
> 			testval = &array[random() % ARRAY_SIZE];
> 		}
> 		time2 = get_cycles();
> 		cycles_per_iter += (time2 - time1)/(double)NR_ITER;
> 	}
> 	cycles_per_iter /= (double)NR_TESTS;
> 	printf("Just getting the pointer, doing noting with it, cycles
per
> iteration (mean) : %g\n", cycles_per_iter);
> 

Some comments on the code:

1. random() is counted in cycle_per_iter, which can skew the results.
You could pre-compute the random addresses and store them in an array.
Then, during the actual timing, walk the array:

index = 0;
for (i = 0; i < ARRAY_SIZE; i++)
      index = *(int *)(array + index * CACHE_LINE_SIZE);

2. You may want to flush the cache before the timing starts.

3. You want to access memory at the cache-line granularity to avoid
addresses falling into the same line (and thus unwanted hits).

If you do these, I expect you'll get a higher memory latency.

  tong
