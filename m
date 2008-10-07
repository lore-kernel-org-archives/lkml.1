Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbYJGAjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbYJGAjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYJGAjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:39:05 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:35154 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbYJGAjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:39:04 -0400
Message-ID: <48EAAF2E.4060407@tlinx.org>
Date: Mon, 06 Oct 2008 17:37:02 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com>
In-Reply-To: <48E6DE07.70706@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, this is my "latest" theory about why my SATA disks have been acting
strange.

Normally I have the drives set to go into standby after 30 minutes of
inactivity. This "can" work -- unless (and this may be obvious to some
people, but it's not entirely intuitive) ...unless you query the drive's
temperature with smartctl periodically.

So..._using_ the "-n standby" on  smartctl  doesn't have an effect unless
the drive is already on standby -- but if it is *not* on standby, then
it counts as drive activity and resets the "goto sleep timer".  This
isn't  the worst problem -- more of an annoyance.  I didn't try to keep
track of all the drives' temperatures until I started having the 2nd
problem which is decidedly "nastier"...

Second problem -- if a drive is in standby, then if  smartctl  or
smartd  try to run the short or long self-tests, the kernel starts
issuing time-out errors, and the drive is eventually, _logically_
removed from the system.  It never comes back from standby.

If I *access* the drive (do an 'ls' of a directory on the drive that
isn't in the cache buffers), then after a ~20 second pause, the drive
has spun up and all is good.  But, for some reason, the "smart" test
functionality isn't causing the drive to wake up.  Instead the kernel
views the drive as OTL (OutToLunch) and removes it from the device
table.  This is, IMO, the more serious problem and is a regression
compared to PATA disk functionality.

The bit of periodically checking temps resetting the activity timer --
that isn't something I normally was trying to do -- I only started that
to try to debug why the drives were going offline (didn't know if temps
were related, among other reasons).  But in the process of checking the
temps, I was also (I am guessing about the functionality based on
observation) resetting the inactivity timer.

So the real problem is why issuing a smart command isn't re-starting
the drive -- or bringing it back from standby.  Whereas a "normal" disk
read seems to bring it back to normal functioning just fine (and can
then do the smart-test).

Does this give anyone ideas about where the problem might be?  Also
sorta explains why my hangs have been infrequent, because I've been
periodically polling the temps of all the drives -- and only when I stop
the polling would the drive timeout, then die the next morning when
smartd tried to run a short test between 1 and 2 am.



