Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYHVOB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYHVOB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYHVOBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:01:50 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39597 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYHVOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:01:49 -0400
Message-ID: <48AEC678.8060008@s5r6.in-berlin.de>
Date: Fri, 22 Aug 2008 16:00:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@kernel.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
In-Reply-To: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:
> I'd really like to blame the device model that prevent me from writing a
> perfect driver for such multi-function devices, otherwise I'd like to
> blame the semiconductor manufacturers to come up with such devices making
> us write ugly drivers. But I couldn't:
> 
>    1. the PMIC design is nature, if I were the PMIC designer, with so many
>       analog circuitry already built-in, I would also add ADC, Touch, Audio
>       PWM, and many others to make them squeeze into the tiny chip. (No,
>       not including using I2C bus, which I'd prefer to avoid)
> 
>    2. There's no fundamental flaw in the device model (sorry for the title),
>       of course, after weeks of reviewing the underlying code.
> 
> So probably, we are writing drivers in an incorrect way, that we have
> ignored for the following reasons:
> 
>    1. Most Linux developers are working on the PC world, which usually don't
>       have to care about the multi-function devices, one PCI card, one PCI
>       device, and one PCI device one function, we have a PCI driver to handle
>       that, in that PCI driver, implement the function we need, that's all.
> 
>    2. Even if there are multiple sub-devices, they are probably of the same
>       functionality, and creating an array is easy, managing them in a whole
>       in the driver is really not a big deal.
> 
>    3. We don't strictly distinguish between a physical device and a virtual
>       device, a physical device driver and a virtual device driver. E.g. a
>       virtual device could be a "net_device", "mtd_device", "led_classdev",
>       and many others

I didn't read and understand all of your post.  Nevertheless I dare to
comment on these last 3 points here, because they don't fully match what
we already have been dealing with for a long time now.  For example,
SCSI (including newer transport types over serial buses or networks)
deals with target devices which have children called logical units.
Logical units of the same target can have very different functionality
(= implement different command sets) while there is still a dependency
of the logical units on the target which provides them.  Other example:
 USB presumably deals with multi-function devices with some inner
structure and dependency too.  (I don't know details.)

Ditto FireWire:  There are "nodes" on a bus, and each node can have 0..n
"units".  The units can implement various different protocols.  During
the presence of a node on the bus, units on it can come and go at any
time.  (Our drivers handle this in a simplified manner though.)  The
ieee1394 driver stack and its future replacement, the firewire stack,
instantiate a struct device for each node, and a struct device for each
unit.  There are appropriate parent-child relationships between them.
(Furthermore, node devices are children of the respective bus controller
device.)

All these devices have the same bus_type.  The older ieee1394 core
distinguishes between node devices and unit devices by means of
different class devices.  The newer, leaner firewire core distinguishes
between them by means of different device_type.

There are high-level drivers which are bound to unit devices, but not to
node devices.  These drivers have the necessary knowledge of the
hierarchy though because their business with a unit device typically
also involves some dealings with the parent and grandparent.

(Types of the new stack:  struct fw_device and struct fw_unit in
drivers/firewire/fw-device.[hc],
types of the old stack:  struct node_entry and struct unit_directory in
drivers/ieee1394/nodemgr.[hc])

Anyway; there are several approaches to multi-function devices possible.
Wherever you go, the goal should be to keep it simple.  (The ieee1394
stack is not a good example for this; the firewire stack is better in
this regard.)  It typically makes a lot of sense to create struct device
based objects _not_ based on which boundaries the silicon draws, but
which functionality is there.  E.g. if you can operate the various
functions of a hardware by means of separate drivers that don't
interfere a lot with each other (a core layer may control such
interferences), then separate struct device embedding objects for each
functionality are a good idea.

And you may not even have to resort to the term "virtual" when talking
about devices or device types or bus types if you structure it all
nicely and reasonably simple.
-- 
Stefan Richter
-=====-==--- =--- =-==-
http://arcgraph.de/sr/
