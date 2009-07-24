Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZGXDBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZGXDBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZGXDBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:01:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:10366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZGXDBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:01:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,259,1246863600"; 
   d="scan'208";a="432912215"
Subject: [PATCH V2 0/4] introduce device async actions mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, dtor@mail.ru,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 24 Jul 2009 11:01:54 +0800
Message-Id: <1248404514.2670.107.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hi,

this is the patch set I made to speed up the device
suspend/resume/shutdown process.

A new mechanism called Device Async Actions is introduced
in this patch set.

The basic idea is that,
if the suspend/resume/shutdown process of a device group, including
a root device and its child devices, are independent of other devices,
we create an async domain for this device group,
and make them suspend/resume/shutdown asynchronously.    

Note that this mechanism is not designed for all the devices.
Generally speaking, if we want to suspend/resume/shutdown a device
asynchronously, we should
1. find out a suitable device async group that contains this device.
2. get the root device in the device async group.
3. root device registers an async domain for this device async group,
   with the proper async action type.

I tried to make it more generic but failed.
Because currently the dependency are pulled from the device tree, i.e.
﻿parent devices will not be suspended until all of their children have
been suspended and children devices will not be resumed before the
parents.

But some hardware breaks this rule.
e.g. 
00:1a.0 USB Controller: Intel Corporation 82801H USB UHCI Controller
00:1a.1 USB Controller: Intel Corporation 82801H USB UHCI Controller
00:1a.7 USB Controller: Intel Corporation 82801H USB2 EHCI Controller
these pci devices are siblings, but 00:1a.7 must be resumed after
00:1a.0, said by Alan Stern, while we can not get this dependency
from device tree.

Currently, in order to make sure that it won't bring any side effects,
I only convert the ACPI battery and i8042 to use this framework, which
reduces the S3 kernel time (kernel suspend and kernel resume time) from
7.0s to less than 6.5s.
And it also reduces 0.4s shutdown time in my test.

Any comments are welcome. :)

thanks,
rui

