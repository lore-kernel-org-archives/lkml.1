Return-Path: <linux-kernel-owner+w=401wt.eu-S1161468AbXEDS15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161468AbXEDS15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161481AbXEDS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:27:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47578 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161468AbXEDS1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:27:55 -0400
Date: Fri, 4 May 2007 11:27:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: RE: Regression with SLUB on Netperf and Volanomark
In-Reply-To: <1178298897.23795.195.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705041118490.24283@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
  <Pine.LNX.4.64.0705031937560.16542@schroedinger.engr.sgi.com>
 <1178298897.23795.195.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If I optimize now for the case that we do not share the cpu cache between 
different cpus then performance way drop for the case in which we share 
the cache (hyperthreading).

If we do not share the cache then processors essentially needs to have 
their own lists of partial caches in which they keep cache hot objects. 
(something mini NUMA like). Any writes to shared objects will cause
cacheline eviction on the other which is not good.

If they do share the cpu cache then they need to have a shared list of 
partial slabs.

Not sure where to go here. Increasing the per cpu slab size may hold off 
the issue up to a certain cpu cache size. For that we would need to 
identify which slabs create the performance issue.

One easy way to check that this is indeed the case: Enable fake NUMA. You 
will then have separate queues for each processor since they are on 
different "nodes". Create two fake nodes. Run one thread in each node and 
see if this fixes it.
