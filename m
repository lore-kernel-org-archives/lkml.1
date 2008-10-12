Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYJLO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYJLO4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 10:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYJLO4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 10:56:08 -0400
Received: from aun.it.uu.se ([130.238.12.36]:44502 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYJLO4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 10:56:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18674.4081.839329.116533@harpo.it.uu.se>
Date: Sun, 12 Oct 2008 16:55:45 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <htejun@gmail.com>
Cc: Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
In-Reply-To: <48EBFE9B.9070503@gmail.com>
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
	<48EBFE9B.9070503@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo writes:
 > (cc'ing linux-ide and Mikael Pettersson)
 > 
 > Christian Mueller wrote:
 > > The messages I saw on the screen.
 > 
 > If the drive doesn't wake up and times out the smart command while
 > suspended (which probably is a bug in the firmware but it also can be
 > the controller's fault), then after the timeout, the driver should kick
 > in and reset the drive which will wake up the device and retry the
 > command.  It's not the prettiest picture but it's still gonna work.  In
 > Linda's case, it looks like the controller (sata_promise) went bonkers
 > on hardreset and requires power cycle to get back to working state.
 > That's why I asked Linda to try another controller.
 > 
 > Anyways, if you're seeing a similar problem, the driver or controller
 > probably can't do proper reset after timeout and I can't really help
 > with SAS driver on FreeBSD.  :-P
 > 
 > Mikael, the original thread is the following.
 > 
 >   http://article.gmane.org/gmane.linux.utilities.smartmontools/5842
 > 
 > Any ideas why hardreset doesn't work after SMART command timed out?

I've looked at the above posting and tried to reproduce the problem.

Linda wrote that "smartctl -n standby -A <device>" sometimes wakes
the device up, even though it shouldn't. On my Promise test box
(FC6 user-space with kernel 2.6.27 and smartmontools-5.37-1.2.fc6,
I put my test disks in standby with "hdparm -y /dev/sdb", and then
ran numerous "smartctl -n standby -A /dev/sdb -d ata" commands.
smartctl always noticed the standby state and never woke any disk.

I then dropped the "-n standby" to observe the wakeup behaviour.
On one disk (Seagate Barracuda 7200.9) the wakeups were completely
reliable with no signs of timeouts or libata EH activity.
On another disk (Hitachi Deskstar HDS722525VLSA80) the first one or
two times I ran "smartctl -A /dev/sdb -d ata" when the disk was in
standby it would wake up ok, but the next time it would suffer from
timeouts, failed COMRESETs, and eventually libata would disable the port.
When reloading sata_promise that port would fail detection but other
ports would be ok.

So I suspect two issues:
- smartctl -n standby waking Linda's disks from standby is probably
  a disk firmware issue or a smartctl issue. I see no evidence that
  sata_promise is to blame for that.
- hardreset in sata_promise seems broken. I'll take a closer look
  at that in about a week's time (I'll be busy with other work the
  next couple of days).

/Mikael
