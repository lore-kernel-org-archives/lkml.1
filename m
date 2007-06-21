Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbXFUItx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbXFUItx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXFUIto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:49:44 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56154 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXFUItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:49:43 -0400
Message-ID: <467A3B9E.6040201@s5r6.in-berlin.de>
Date: Thu, 21 Jun 2007 10:49:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Greg K-H <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, "david@lang.hm" <david@lang.hm>,
       David Miller <davem@davemloft.net>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
 control
References: <1182373258.30574.30.camel@caritas-dev.intel.com>	 <46794343.3080204@s5r6.in-berlin.de> <1182418711.12959.3.camel@caritas-dev.intel.com>
In-Reply-To: <1182418711.12959.3.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>> Is the queue number kernel-global or per subsystem?
> 
> The queue number is kernel-global.

Then there is an API required to allocate and deallocate exclusive queue
IDs.  This feels strange as a mechanism for (de-)serialization, and
might introduce some bulk WRT code and data.

Really, I don't believe there is anything else required from subsystems'
point of view than
  - the possibility to keep plain serial driver matching/probing,
  - to allow unrestricted parallelism,
  - to mark devices whose child devices shall be matched/probed
    serially.

Should there be a subsystem which has more special demands on mixture of
parallelism and serialization, it can easily use private means to
serialize certain parts of driver probes, for example with the familiar
mechanism of mutexes.

Or if need be, such a subsystem can implement its own threading model.
The FireWire subsystem for example first fetches so-called configuration
ROMs from each node on a bus by means of asynchronous split
transactions.  The ROMs are scanned for device properties and
capabilities, and then drivers are matched/probed.  The new FireWire
subsystem currently uses workqueue jobs to read the ROMs.  The old
FireWire subsystem uses one kernel thread per bus.  Before the new
FireWire subsystem was announced, I planned to let the bus kthread spawn
node kthreads which (1) fetch and scan ROMs and (2) match and probe
drivers for each unit in a node.

If the old FireWire subsystem had a future, I would most certainly not
use your mechanism but implement what you described.  I am not sure
about the new FireWire subsystem; there isn't much practical experience
with it yet.
-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/
