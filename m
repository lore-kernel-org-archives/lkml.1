Return-Path: <linux-kernel-owner+w=401wt.eu-S934371AbZJNAA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371AbZJNAA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761337AbZJNAA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:00:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:49311 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbZJNAA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:00:58 -0400
Subject: New percpu & ppc64 perfs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 10:59:18 +1100
Message-Id: <1255478358.2347.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun !

So I found (and fixed, though the patch isn't upstream yet) the problem
that was causing the new percpu to hang when accessing the top of our
vmalloc space.

However, I have some concerns about that choice of location for the
percpu datas.

Basically, our MMU divides the address space into "segments" (of 256M or
1T depending on your processor capabilities) and those segments are SW
loaded into a relatively small (64 entries) SLB buffer.

Thus, by moving the per-cpu to the end of the vmalloc space, you
essentially make it use a different segment from the rest of the vmalloc
space, which will overall degrade performances by increasing pressure on
the SLB.

It would be nicer if we could provide an arch function to provide a
"preferred" location for the per-cpu data.

I can easily cook up a patch but wanted to discuss that with you first.
Any reason why we would keep it within vmalloc space for example ? IE. I
could move VMALLOC_END to below the per-cpu reserved areas, or are they
subject to expansion past boot time ?

Also, how big can they be ? Ie, will the top of the first 256M segment
good enough or that will risk blowing out of space ? In general,
machines with 256M segments won't have more than 64 or maybe 128 CPUs I
believe. Bigger machines will have CPUs that support 1T segments.

Cheers,
Ben.
 

