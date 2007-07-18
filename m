Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXGRF0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXGRF0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXGRF0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:26:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:1504 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbXGRF0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:26:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,549,1175497200"; 
   d="scan'208";a="269690065"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Roland Dreier'" <rdreier@cisco.com>, "Or Gerlitz" <or.gerlitz@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
Subject: RE: [ofa-general] Further 2.6.23 merge plans...
Date: Tue, 17 Jul 2007 22:26:35 -0700
Message-ID: <000001c7c8fc$360eec90$5dcc180a@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <adaabtuo0n9.fsf@cisco.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
thread-index: AcfI6w03tJG9X2MRSCCizIHNt08IHgABLIbw
X-OriginalArrivalTime: 18 Jul 2007 05:26:36.0185 (UTC) FILETIME=[35B70890:01C7C8FC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I think this is an important question.  If we merge the local SA
>stuff, then are we creating a problem for dealing with QoS?

Yes - I do believe that merging PR caching and QoS together will be difficult.
I don't think the problems are insurmountable, but I can't say that I have a
definite solution for how to deal with this. 

My current thoughts are that the purpose of the cache is to increase SA
scalability on large clusters.  We've seen issues running MPI, trying to
establish all-to-all connections, on our 256 node cluster.  (With 4 processes
per node, this results in about 500,000+ PR queries hitting the SA.)  The SA was
swamped with work, and it wasn't trying to enforce QoS requirements across the
cluster.

I just don't see how an SA that is already having trouble scaling to this number
of nodes will be able to perform the additional task of providing QoS across the
cluster.  It may be that, at least initially, an administrator may need to
select between enabling PR caching or QoS.

>Are we going to have to revert the local SA stuff once the QoS stuff is
>available?

In the best case, the local SA will need enhancements added to the base support.
In the worst case, a user would have to choose between QoS or PR caching.  If
all users choose QoS, then it would make sense to remove the local SA. 

>Or is there at least a sketch of a plan on how to handle this?

This is only a rough idea, and it depends on how the QoS is implemented.  The
idea is to create a local QoS module on each node.  The local QoS modules would
be programmed with basic QoS information.  For example, which types of queries
to handle locally, versus which ones to forward to the SA.  Locally handled
queries would return PRs based on some QoS mapping table.  (I haven't looked
into any details of this.)

Ideally, local QoS modules would be programmed by a QoS master.  This would
require a new vendor-specific protocol, but would allow for a simple distributed
QoS manager.

We will have a better idea of the issues and possible solutions once the QoS
spec is released, and we can hold discussions on it.  I will be working more
details on QoS enhancements starting in the next couple of weeks. 

- Sean
