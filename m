Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbXLNSVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbXLNSVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXLNSVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:21:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:20154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbXLNSVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:21:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="341262375"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating memory
Date: Fri, 14 Dec 2007 10:19:58 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC1A4949@orsmsx424.amr.corp.intel.com>
In-Reply-To: <7575980D7C4188408E8BDB171DA164B73A875EC00C@G3W1111.americas.hpqcorp.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating memory
Thread-Index: Acg9mUUMdTafVzrMTvSV0jj3/Kue7QAMQ8LQACnTR+AAAnNDsA==
References: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net> <1FE6DD409037234FAB833C420AA843EC1A3F5B@orsmsx424.amr.corp.intel.com> <7575980D7C4188408E8BDB171DA164B73A875EC00C@G3W1111.americas.hpqcorp.net>
From: "Luck, Tony" <tony.luck@intel.com>
To: "de Dinechin, Christophe (Integrity VM)" 
	<christophe.de-dinechin@hp.com>,
       <linux-ia64@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, "Picco, Robert W." <robert.picco@hp.com>
X-OriginalArrivalTime: 14 Dec 2007 18:19:59.0443 (UTC) FILETIME=[EFC30A30:01C83E7D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As you can see, the global purge rates can be pretty respectable
> under this kind of load. I chose -j50 to generate enough processes
> to stress my own system, you may need more with 4G. Check with
> xosview or similar that the buffer cache fills up memory but
> is kept relatively small by user-space memory pressure (at
> around 5-10% for my own testing).

My 4G of memory was indeed the problem ... in two ways:
  1) I didn't install "Everything" on this machine.  So the
     'find /usr -type f | xargs cat' was only juggling with
     just over 2G of files, which all fit in the page cache!
  2) I'd assumed you had used -j50 because you were running
     on some humungous superdome system with that many cpus.
     I was only using -j16 ... which probably fit into the
     remaining available memory.

So I moved the 'find' to /home (which has >7G of files), increased
the -j factor, and just to make really sure ran a little program
that did a malloc() & mlock() of 2G of memory.

I've been running for about 20 minutes and already see just over half
a million cases where your patch avoided flush_tlb_all() (at the
moment it is managing to do so in every case).

Do you know what the call sequence looks like for the few cases
where your patch doesn't manage to avoid (you mentioned just 170
times out of several million in the patch submission)?

-Tony

