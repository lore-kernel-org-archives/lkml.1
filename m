Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbZFOU3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbZFOU3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764374AbZFOU3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:29:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35209 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755215AbZFOU3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:29:31 -0400
X-Sasl-enc: BSFdcoQoF+dQDrIH4Ynavt7H/jts7eixCBIR+zLtdiAK 1245097772
Date: Mon, 15 Jun 2009 17:29:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joerg Platte <jplatte@naasa.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30] Kernel bug with dock driver
Message-ID: <20090615202928.GA28319@khazad-dum.debian.net>
References: <200906142100.48621.jplatte@naasa.net> <20090615020226.GA30720@khazad-dum.debian.net> <200906150936.41983.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906150936.41983.jplatte@naasa.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Joerg Platte wrote:
> > If the bug cannot be reproduced in that condition, it is happening
> > because userspace is trapping the lever release event (as it should),
> > and doing something the kernel doesn't like with it (which is a bug
> > in the kernel in any case).  That might help you track down a better
> > way to reproduce the issue.
> 
> if [ -d $ULTRABAY_SYSDIR ]; then
>         sync
>         echo 1 > $ULTRABAY_SYSDIR/delete
>         logger "removed $ULTRABAY_SYSDIR"
> fi
> sync
> # Turn off power to the UltraBay:
> if [ -f /sys/devices/platform/dock.2/undock ]; then
>         echo 1 > /sys/devices/platform/dock.2/undock
>         logger "/sys/devices/platform/dock.2/undock"

There might be a race there, as you call undock but you don't really know if
the SCSI device was deleted.

> What I discovered today after modifying ultrabay_open was that in some cases 
> the script is called again directly after inserting a drive to the bay. But 
> only, if the execution of this script takes some more time (I added a sleep 2 
> after the second sync to be able to see which command might trigger the bug).

So, please try to reproduce this by sending a number of delete requests
back-to-back in a row, and also mixing delete requests with undock requests.
When you find out what causes the OOPS (and it _is_ a bug in the kernel if
any of those oops), we can try to direct the bug report to someone who can
fix the problem.

> to undock a device while it is in the process of being undocked? How should I 
> modify the udev rule to prevent another execution each time a drive is 
> inserted into the bay?

You will need locking, unfortunately.  Also, check if there is a device in
the bay.  event+device in bay == hotunplug.  event+no device in bay ==
hotplug.

That is, if the events don't already tell you (i.e. different events for
plug and unplug).  I don't recall right now if the ACPI events are
different, but I do recall the thinkpad BIOS follows the ACPI spec correctly
on this area.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
