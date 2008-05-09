Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbYEIP3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbYEIP3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762006AbYEIP2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:28:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49975 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbYEIP2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:28:41 -0400
Message-ID: <48246DA3.9080307@garzik.org>
Date: Fri, 09 May 2008 11:28:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Port control interface (was Re: [PATCH] ata: ahci: power off unused
 ports)
References: <20080508161008.59361de5@appleyard> <48246872.8000502@rtr.ca>
In-Reply-To: <48246872.8000502@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> And a more general note:  I still believe we should have a follow-up
> feature to this one, to enable polling for newly inserted drives.
> 
> That would allow powering down idle ports to save money/planet/whatever,
> but still with hotplug capability.  The polling interval should be
> tunable in /sys, with a default of, say, once every couple of seconds.
> 
> Thanks for working on this stuff.


In the grand open source tradition of "pass the buck", I've long been 
hoping that someone would take a few days, sit down, and hammer out the 
policy side of this.

We -don't- want to do hotplug-active all the time -- the current default 
in all drivers that support device hotplug -- because it needlessly 
keeps parts active that are unused 99.9% of the time [when they are empty].

Admins need a generic way to control SATA ports and links from 
userspace.  Within that, admins need to be able to set a link's hotplug 
state among three choices:  hotplug-active [when supported], 
hotplug-poll, and hotplug-never.  And of course, hotplug-poll's interval 
should be tunable.

And of course this control interface needs to be usable on SAS/SATA 
cards that will be common in the future (broadsas, mvsas are early 
examples).


This is why I look askance at an AHCI BIOS flag.  That's merely a hint, 
and potentially unreliable one at that.  It could just be describing 
what the BIOS writer felt were the ports that _should_ be hotpluggable 
-- i.e. not even describing what is _possible_ but someone's definition 
of "reasonable."  The BIOS flag might even be filled with fuzz (AHCI's 
BIOS-written registers have occasionally been shipped into the field 
uninitialized).

A better solution involves taking the BIOS flag and using that to set a 
default policy that an admin can easily override using the 
above-mentioned control interface.

Because in some cases, that BIOS flag might do the wrong thing, and we 
need to give the admin an ability to undo the damage.

	Jeff



