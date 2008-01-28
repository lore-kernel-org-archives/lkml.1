Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYA1Sy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYA1Sy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYA1SyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:54:17 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59586 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYA1SyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:54:17 -0500
Message-ID: <479E24D6.4060006@s5r6.in-berlin.de>
Date: Mon, 28 Jan 2008 19:54:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?Kristian_H=F8?= =?ISO-8859-1?Q?gsberg?= 
	<krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: fix "kobject_add failed for fw* with
 -EEXIST"
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de> <200801281148.54017.jwilson@redhat.com>
In-Reply-To: <200801281148.54017.jwilson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> We may have another issue there though, as when this happened to me, the md 
> layer apparently never noticed (after ~6 hours) that one of the array members 
> had disappeared -- not sure if that's firewire's fault or md's though... This 
> will presumably avoid this situation entirely, but worth noting that there 
> may still be somewhere we need to better communicate status to an upper 
> layer.

I don't know how md ticks, so I have no idea what might have happened there.

Somewhat related:  What if
  - we lose connection to disk "A", represented by scsi_device "a",
  - the SCSI core sets "a" offline,
  - we gain connection to disk "A" again (i.e. it only shortly
    disappeared from the bus from firewire-core's and -sbp2's point
    of view),
  - and firewire-sbp2 adds it as scsi_device "b", even before SCSI
    core got rid of "a"?
No big problem for stand-alone volumes (unless it happens when the
volume is in use), but maybe trouble for md managed volumes.

To smooth such issues out, my longer term goal was to allow brief
periods of disconnection in (firewire-)sbp2.  I.e. the SCSI core
wouldn't notice that "A"/"a" went away, it would only notice that "a"
wasn't accessible for a short time.  I think the Fibre Channel drivers
already support this.  The ieee1394 driver even has a "limbo" for
devices which went away, in order to remember them until they come back,
but sbp2 doesn't use this feature.  (Nobody did the work to enhance sbp2
to utilize the feature.)

BTW, if you unplug and replug a FireWire disk under Mac OS X fairly
quickly, OS X will pretend that nothing happened and let the user
continue using the disk if he hadn't "ejected" it before the brief
connection loss.

Anyhow, we have a few more urgent problems to solve in firewire-sbp2's
reconnection handling before we can think about such extras.
-- 
Stefan Richter
-=====-==--- ---= ===--
http://arcgraph.de/sr/
