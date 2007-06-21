Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbXFUNvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbXFUNvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXFUNvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:51:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:13801 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234AbXFUNvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:51:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,448,1175497200"; 
   d="scan'208";a="259535561"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] driver core: multithreaded probing - more parallelism control
Date: Thu, 21 Jun 2007 21:51:11 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC218022B@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <467A3B9E.6040201@s5r6.in-berlin.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] driver core: multithreaded probing - more parallelism control
Thread-Index: Acez4SL1p/at0pMRRR+hOYCSzGdOXgAHYIMg
From: "Huang, Ying" <ying.huang@intel.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: "Greg K-H" <greg@kroah.com>, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Adrian Bunk" <bunk@stusta.de>, <david@lang.hm>,
       "David Miller" <davem@davemloft.net>,
       "Duncan Sands" <duncan.sands@math.u-psud.fr>,
       "Phillip Susi" <psusi@cfl.rr.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Jun 2007 13:51:13.0837 (UTC) FILETIME=[3B72D5D0:01C7B40B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de]
>> The queue number is kernel-global.
>
>Then there is an API required to allocate and deallocate exclusive
queue
>IDs.  This feels strange as a mechanism for (de-)serialization, and
>might introduce some bulk WRT code and data.

I think the queue IDs of different subsystem need not to be exclusive.
The subsystem can allocate queue IDs arbitrarily. If one queue ID is
shared between several subsystems, corresponding probing will be
serialized. This will slow down the probing unnecessarily, but there
will be no race condition.

The benefit of the mechanism is that the maximum parallelism of probing
can be control.

>Really, I don't believe there is anything else required from
subsystems'
>point of view than
>  - the possibility to keep plain serial driver matching/probing,
>  - to allow unrestricted parallelism,
>  - to mark devices whose child devices shall be matched/probed
>    serially.

Maybe.

>Should there be a subsystem which has more special demands on mixture
of
>parallelism and serialization, it can easily use private means to
>serialize certain parts of driver probes, for example with the familiar
>mechanism of mutexes.
>
>Or if need be, such a subsystem can implement its own threading model.
>The FireWire subsystem for example first fetches so-called
configuration
>ROMs from each node on a bus by means of asynchronous split
>transactions.  The ROMs are scanned for device properties and
>capabilities, and then drivers are matched/probed.  The new FireWire
>subsystem currently uses workqueue jobs to read the ROMs.  The old
>FireWire subsystem uses one kernel thread per bus.  Before the new
>FireWire subsystem was announced, I planned to let the bus kthread
spawn
>node kthreads which (1) fetch and scan ROMs and (2) match and probe
>drivers for each unit in a node.

I know nothing about FireWire. If I say something nonsense, please just
ignore it.

Whether is it possible that a new unit is inserted during probing
kthread is running. If it is possible, the probing kthread maybe ignore
the new inserted unit. So a kthread for this new unit should be created
upon inserting. And there must be some synchronization mechanism
provided. So, I think something like probing queue may be better than
raw kthread for this. And the bus scanning thread may need to exist
during system running, using the probing queue the bus scanning thread
can be created and destroyed on demanded too.

Thank you very much for your comment.

Best Regards,
Huang Ying
