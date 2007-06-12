Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXFLObO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXFLObO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXFLObE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:31:04 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:48607 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbXFLObB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:31:01 -0400
Message-ID: <466EAE21.7090407@s5r6.in-berlin.de>
Date: Tue, 12 Jun 2007 16:30:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] driver core: multithreaded device matching with	dependency
References: <9D7649D18729DE4BB2BD7B494F7FEDC2041319@pdsmsx415.ccr.corp.intel.com>	 <466AD638.9030409@s5r6.in-berlin.de> <1181643157.2779.23.camel@caritas-dev.intel.com>
In-Reply-To: <1181643157.2779.23.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> The summary of dependency rule is as follow:
> 
> 1. A flag as follow is added to struct device.
>      unsigned multithreaded_probe:1;
> If it is set, the devices sub-tree with this device as root will be
> probed parallelized with other devices sub-tree. If it is clear, the
> device belongs to the devices sub-tree of the parent of the device, and
> should be probed serially with other devices in the devices sub-tree.
> The root devices (without parent) is assumed to have this flag set (in
> spite of the actual value). With this flag, the PCI subsystem can be
> probed serially, while IEEE 1394 subsystem can be probed parallelized
> among different device node, but serially among different unit in a
> node.
> 
> 2. A field as follow is added to struct device.
>      struct device *depend;
> The device will not start probing unless the probing of the device
> pointed by depend has been finished. This is used to control some random
> dependency between devices.
> 
> 3. The probing of the device will not be started, unless the probing of
> the parent of the device has been finished.
> 
> I revised my patch to reflect the rule above, so resend it.

Looks good, except for two points, IMO:

  - I'd still like to see kerneldoc comments in your patch for each new
    API element.  You did so already for the new exported functions, but
    you didn't provide kerneldoc for the new members of struct device
    which are API elements.

    Of course, the whole struct device is /not/ quite well documented at
    the moment, but that doesn't mean that new extensions should make
    matters even worse.

  - Your rules 1 and 3 are simple and useful.  Rule 2 is in itself
    simple too, but the maintenance of the dependency tree which is
    built from the .depend pointers comes at a cost.  (Devices come and
    go all the time; the .depend pointers must always be valid.  How is
    this accomplished?)

    Consider to reduce your patch to rule 1 and 3, and throw out rule 2.
    If a subsystem has a more complicated requirement which cannot be
    satisfied by rule 1 and 3, it can either just restrict itself to
    dumb single-threaded device-driver matching, or it can pretend to be
    fully capable of parallel device-driver matching and ensure the
    necessary serialization by own internal mutexes.

There is so much unskilled labor in driver hacking land (I'm merely
speaking for myself of course) that something like the driver core
/really/ needs well-working, easy to understand, and well-documented APIs.

PS:  By a well-documented struct definition I mean:
   - Public members have a type and name which indicate the meaning of
     the member, and there is a comment on permissible or required
     write/read accesses to the member.
   - Private members are undocumented or even better yet explicitly
     marked as private.
If the access methods to public members turn out too difficult and
fragile, make the members private and provide documented public accessors.
-- 
Stefan Richter
-=====-=-=== -==- -==--
http://arcgraph.de/sr/
