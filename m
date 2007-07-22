Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbXGVGud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbXGVGud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXGVGuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:50:24 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50497
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbXGVGuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:50:24 -0400
Date: Sat, 21 Jul 2007 23:49:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Power Management framework proposal
Message-ID: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm deliberatly breaking the threading on this so that people who have 
tuned out the hibernation thread can take a look at this.

below is the proposal that I made at the bottom of one of the posts on the 
hibernation thread.

the idea is that instead of approaching power management from the point of 
view of the current desktop standard (ACPI), instead this approaches it 
from the point of view of 'what does a tool need to know to do the job' no 
matter what mechanism is actually used to implement the different modes.

one thing that I didn't put in the original post is that the framework 
that I mention below should work with other types of devices besides ACPI 
ones.

CPU clock settings could fit the same API for example (with modeID=0 being 
to hot-unplug the cpu and modeID=1 to initialize the cpu)

here's the original post:

in fact, a better abstraction would be something like

report_power_modes
    which would return a series of modes (sorted only by modeID)
    modeID, %power_used_in_this_mode, %capability_in_this_mode
    (I would make mode 0 always be complete power off, and mode 1 always be 
full capacity)

report_power_mode_speed
   which would return a matrix giving how long it takes to transition from any 
mode to any other mode. this should be a relative number, not an absolute 
number since it will be different at different clock speeds.

set_operational_mode(modeID)
   which would take you from whatever mode you are in now to the requested mode.

most devices would report the simple list of modes

0,0,0
1,100,100

with a mode_speed matrix of
    0 1
    ---
0|0 1
1|1 0

it may be that there is more info needed for the powr management engine to 
decide what modes it wants to put things into, if so identify what type of info 
you need and add another column to the modes list.
for example:
   you may want to add a flag for 'does this mode allow downstream devices to 
operate?'
   you may want to make a mode for 'this mode doesn't allow any new requests, 
but continues to process pending requests' and have a flag that indicates this

currently it looks like there's no way to find out what modes are available, 
and you have to know what mode something is in currently before you can request 
it change to a different mode. both of these prevent effective power management 
without encoding intimate knowledge of the capability of the particular 
hardware in your management tool.

some of this may be discoverable via the ACPI interface (it's not talked about 
much in the devices.txt file), but the mode setting is still wrong.

note that in the example above it's accpetable for a driver to cache what mode 
it thinks the device is in, but it needs to properly set the new mode even if 
it's cached data is incorrect.

this approach would allow the transition of ALL drivers to the new mode of 
operation in one fell swoop, and then adding additional power management 
features is just adding to the existing list rather then implementing new 
functions.

David Lang
