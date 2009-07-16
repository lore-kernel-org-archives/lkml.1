Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZGPCEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZGPCEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZGPCEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:04:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:46730 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998AbZGPCEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,408,1243839600"; 
   d="scan'208";a="165533925"
Subject: Re: [PATCH 2/8] introduce the device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
In-Reply-To: <20090715060006.71c2e2b6@infradead.org>
References: <1247643516.26272.77.camel@rzhang-dt>
	 <20090715060006.71c2e2b6@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 16 Jul 2009 10:05:10 +0800
Message-Id: <1247709910.26272.159.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 21:00 +0800, Arjan van de Ven wrote:
> On Wed, 15 Jul 2009 15:38:36 +0800
> Zhang Rui <rui.zhang@intel.com> wrote:
> 
> > Introduce the device async action mechanism.
> > 
> > In order to speed up Linux suspend/resume/shutdown process,
> > we introduce the device async action mechanism that allow devices
> > to suspend/resume/shutdown asynchronously.
> > 
> > The basic idea is that,
> > if the suspend/resume/shutdown process of a device set,
> > including a root device and its child devices, are independent of
> > other devices, we create an async domain for this device set,
> > and make them suspend/resume/shutdown asynchronously.
> 
> Hi,
> 
> I have some concerns about having an async domain per device(group)
> rather than having one async domain for all of this, 

﻿we create an async domain ONLY if we are sure that the device group is
independent with the other devices.

and IMO, using multiple async domains brings real device async actions.
For example, in S3 resume case, there are two device groups:
device group1: device1, device2, device3
device group2: device4, device5, device6

If they share the global domain, we may get:﻿
device group1: device1(cookie 1), device2(cookie 4), device3(cookie 5)
device group2: device4(cookie 2), device5(cookie 3), device6(cookie 6)

this is not real asynchronous resume because
device3 needs to call async_synchronize_cookie(5) before resume itself.
which means that device4 and device5 must be resumed before device3.

But if multiple async domain is used, we get:
﻿device group1: device1(cookie 1), device2(cookie 2), device3(cookie 3)
device group2: device4(cookie 1), device5(cookie 2), device6(cookie 3)

device group1 and group2 can be resumed asynchronously.


Another example, in my previous test,
1. sata controller. takes 0.4s to resume.
2. usb, including uchi and ehci controller takes 1.4s to resume
3. ACPI battery takes 0.3s to resume.
3. all the other devices take 0.2s to resume.

sata, usb and ACPI battery are independent device groups.
If we use multiple async domains, we can reduce the total device resume
time from 2.3s to a little more than 1.4s because there are a lot of
sleep in usb resume process.
But if we share the global async domain, the total resume time can only
be reduced to about 2.1s because sata, usb and ACPI battery are actually
resumed synchronously.


> I would
> strongly suggest going to one global domain, so that it becomes
> more practical to just wait for all async actions like this...
> which you need to do during suspend for sure.
> 
We can use multiple async domains, even in the suspend case, on the
premise of the device group being independent of ANY other devices.
For example, this is what I get after patch 8/8 is applied.
BTW: actions 1 stands for suspend here.
[  498.891337] device event8 actions 1 started
[  498.891339] device event8 actions 1 done
[  498.891344] device mouse3 actions 1 started
[  498.891345] device mouse3 actions 1 done
[  498.891349] device input17 actions 1 started
[  498.891350] device input17 actions 1 done
[  498.891354] device event7 actions 1 started
[  498.891355] device event7 actions 1 done
[  498.891359] device mouse2 actions 1 started
[  498.891360] device mouse2 actions 1 done
[  498.891364] device input16 actions 1 started
[  498.891365] device input16 actions 1 done
[  498.992052] device serio4 actions 1 started
[  498.992054] device serio4 actions 1 done
[  498.992058] device serio3 actions 1 started
[  498.992060] device serio3 actions 1 done
[  498.992064] device serio2 actions 1 started
[  499.411877] device serio2 actions 1 done
[  499.454733] device serio1 actions 1 started
[  499.454734] device serio1 actions 1 done
[  499.454739] device event1 actions 1 started
[  499.454740] device event1 actions 1 done
[  499.454744] device input1 actions 1 started
[  499.454746] device input1 actions 1 done
[  499.454750] device serio0 actions 1 started
[  499.456052] device i8042 actions 1 started
[  499.556054] device serio0 actions 1 done
[  499.556748] device i8042 actions 1 done

thanks,
rui

