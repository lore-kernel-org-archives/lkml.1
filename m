Return-Path: <linux-kernel-owner+w=401wt.eu-S966273AbXFHPRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966273AbXFHPRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967481AbXFHPQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:16:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:29445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968644AbXFHPQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,400,1175497200"; 
   d="scan'208";a="254766841"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] driver core: multithreaded device matching with dependency
Date: Fri, 8 Jun 2007 23:16:15 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC20412B6@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <466963D4.6010008@s5r6.in-berlin.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] driver core: multithreaded device matching with dependency
Thread-Index: Acep1xQ2oFzvRhsBRZCNroc3umrH6QAAHx4g
From: "Huang, Ying" <ying.huang@intel.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
X-OriginalArrivalTime: 08 Jun 2007 15:16:15.0779 (UTC) FILETIME=[F512A730:01C7A9DF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>A bad API.  Subsystems and the driver core will both traverse the trees
>(usually just lists) which can be built from the depend pointers, and
>the trees grow and shrink dynamically.  Perhaps it would be simpler if
>the subsystem would just use a mutex per group of devices which have to
>be serialized.

Yes, this is a bad API. I have a new idea. The /sys/devices is a tree,
which is linked by dev->klist_children, any sub-tree of /sys/devices
tree can be a parallel unit, which can be indicated by a flag of struct
device of root node of sub-tree. In a sub-tree being a parallel unit,
all probing is serialized, while the probing of different sub-trees is
parallelized. The find_next_device_to_check will not traverse through
devices_subsys.list, but traverse through dev->klist_children. In the
IEEE 1394 case, the "node" can be a parallel unit (sub-tree) by set the
corresponding flag in struct device of "node", and the "unit" under
"node" will be probed serially. In general, subsystems can set the flag
in any struct device if necessary, even the root struct device of
subsystem, which means all devices in the subsystem must be probed
serially.

I will work out a new patch based on this new idea.

>*However*, IMO parallelized probing should be implemented in the
>subsystems themselves in the first place, _not in the driver core_.
>
>The subsystems know where parallelism is possible and safe and
>effective, the driver core doesn't.

I totally agree that the parallelized probing should be controlled by
the subsystems. By if the mechanism can be provided by driver core
effectively, the solution will be ideal.

Best Regards,
Huang Ying
