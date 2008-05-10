Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYEJPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYEJPcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYEJPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 11:32:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37488 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYEJPcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 11:32:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 10 May 2008 17:31:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Hack to fix not working spindown over Firewire
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Tino Keitel <tino.keitel@gmx.de>
In-Reply-To: <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
Message-ID: <tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de>
 <20080507180042.GA32629@dose.home.local>
 <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> 1) FireWire to IDE or to SATA chipset
> 2) start bit is honored:
>    "sg_start --stop" stops the motor and "sg_start" restarts it
> 3) power condition field is honored:
>    "sg_start --pc=3" stops the motor and "sg_start --pc=1 restarts it
> 4) peripheral device type claimed by the firmware
> 5) vendor and model of the enclosure
> 
> 
> 1)           2)     3)     4)    5)
> bridge       start  pc     PDT   enclosure
> --------------------------------------------------------------
> INIC-2430    yes    yes    SBC   AVLAB 2.5" Drive Kit
> INIC-2430    yes    yes    SBC   IOI FWB-IDE01AB, 1 HDD
> INIC-2430    yes    yes    SBC   IOI FWB-IDE01AB, 2 HDDs, JBOD
> 
> OXFW911      yes    yes    RBC   MacPower Icecube
> OXUF922      yes    yes    RBC   MacPower Icecube 800+
> OXFW912      yes    yes    RBC   MacPower Igloo
> OXFW912      yes    yes    RBC   VulcanTech DualDrive 2nd gen.
> OXUF924DSB   yes    yes    SBC   MacPower Taurus, 1 HDD
> OXUF924DSB   no     no     SBC   MacPower Taurus, 2 HDDs, JBOD
> 
> PL-3507      no     no     RBC   MacPower Prefect II ¹

  PL-3507      no     yes    RBC   Mapower MAP-KC21C1 ²

> TSB42AA9     no     yes    SBC   DViCO MomoBay CX-1
> TSB42AA9A    yes    yes    RBC   DViCO MomoBay FX-3A

  EFI firmware no     no     RBC   Apple Mac mini x86 in target mode ³


¹) As mentioned, with firmware from MacPower.

²) Same firmware_revision as with Tino's disk, i.e. apparently firmware
   from Prolific.  Same findings as Tino's:
   "sg_start --stop" is accepted but does not stop the motor.
   "sg_start --pc=3" or "=2" stop the motor.
   "sg_start --pc=1" or a read command restarts the motor.
   "sg_start" does not restart the motor.

³) "sg_start --stop" is accepted but does not stop the motor.
   "sg_start --pc=3" or "=1" fails with "invalid field in cdb".
   This is of course against the spec, because RBC includes power
   condition.

Moreover, when OS X shuts down, it apparently sends START STOP UNIT
without power condition to FireWire disks.  Therefore we also should
rather _not_ use power condition per default.

I will send a patch which uses the power condition field only for
PL-3507 and DViCO CX-1.
-- 
Stefan Richter
-=====-==--- -=-= -=-=-
http://arcgraph.de/sr/

