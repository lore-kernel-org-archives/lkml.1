Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbXFMXgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbXFMXgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbXFMXgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:36:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:45230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbXFMXgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:36:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,418,1175497200"; 
   d="scan'208";a="254162321"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch 0/3] no MAX_ARG_PAGES -v2
Date: Wed, 13 Jun 2007 16:36:13 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01AF860A@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070613100334.635756997@chello.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/3] no MAX_ARG_PAGES -v2
Thread-Index: AcetpRClBXdtfnCWSiiPAMmYhBCF1QAbEbQQ
From: "Luck, Tony" <tony.luck@intel.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, <linux-kernel@vger.kernel.org>,
       <parisc-linux@lists.parisc-linux.org>, <linux-mm@kvack.org>,
       <linux-arch@vger.kernel.org>
Cc: "Ollie Wild" <aaw@google.com>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 13 Jun 2007 23:36:14.0142 (UTC) FILETIME=[A18E55E0:01C7AE13]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch-set aims at removing the current limit on argv+env space aka.
> MAX_ARG_PAGES.

Running with this patch shows that /bin/bash has some unpleasant
O(n^2) performance issues with long argument lists.  I made a
1Mbyte file full of pathnames, then timed the execution of:

$ /bin/echo `cat megabyte` | wc
$ /bin/echo `cat megabyte megabyte` | wc
   etc. ...

System time was pretty much linear as the arglist grew
(and only got up to 0.144 seconds at 5Mbytes).

But user time ~= real time (in seconds) looks like:

1 5.318
2 18.871
3 40.620
4 70.819
5 108.911

Above 5Mbytes, I started seeing problems.  The line/word/char
counts from "wc" started being "0 0 0".  Not sure if this is
a problem in "wc" dealing with a single line >5MBytes, or some
other problem (possibly I was exceeding the per-process stack
limit which is only 8MB on that machine).

-Tony
