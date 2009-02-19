Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZBSGG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZBSGG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZBSGGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:06:17 -0500
Received: from phunq.net ([64.81.85.152]:59027 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751265AbZBSGGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:06:16 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 Report: Tux3 boots up as root
Date: Wed, 18 Feb 2009 22:06:13 -0800
User-Agent: KMail/1.9.5
Cc: linux-fsdeve@vger.kernel.org, tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182206.14483.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday at 17:59 Japan Standard Time, Hirofumi Ogawa booted Linux to a 
Tux3 root filesystem for the first time in recorded history.  This 
notable feat was repeated by me today, without any help from a separate 
boot partition.

I toasted this auspicious occasion with a tall glass of Sake in honor of 
Hirofumi, who has done the vast majority of the kernel port, and lately 
has taken on a good chunk of the main design work as well.

Tux3 will be formally presented at Scale 7X, in Los Angeles this Sunday:

   http://scale7x.socallinuxexpo.org/conference-info/schedules

Thanks to the recent hard work, Tux3 will be able to attend this event 
in person as root on my trusty Shuttle.

Tux3 is still not ready to store real data though.  It still does not 
have crash recovery, although work is proceding well in that direction.  
Fsck would be nice too.  And of course we want versioning, the reason 
Tux3 came to be a project in the first place.  There are a few other 
issues as well.  Our plan remains the same:

   1) Get atomic commit and recovery working

   2) Present Tux3 for review

   3) Implement versioning during the review cycle

This way, we can get a few more eyeballs on the design as some of the 
formative elements solidify.  And ideally a few more hands to help pull 
the oars as well.

Creating a bootable filesystem was done by copying an existing bootable 
partition to an empty Tux3 filesystem.  We found that Tux3 does this 
job just a little more slowly than Ext2, which pleases us very much 
because Ext2 is a very quick filesystem for this kind of load.  It took 
Tux3 8 minutes, 33 seconds to copy /usr, while Ext2 did the job in 8 
minutes flat.  Not a huge difference, and can be entirely accounted for 
by the fact that Tux3 currently creates two extra blocks for every 
file, a btree root node and a btree index leaf.  The vast majority of 
files do not need that, and could be referenced as a single extent 
directly from the inode.  We have not done that optimization yet, and 
we will not do it for some time, because what we really need to 
concentrate on right now is exercising the corner cases of full btrees.  
So we will keep those extra blocks for now and optimize other things.

One of the interesting bits is the work that has been proceding on cache 
optimization, where we effectively create a snapshot of the dirty 
blocks of an inode and transfer the blocks to disk while other tasks 
continue to write to the inode in parallel.  This is the "fork" 
operation I talked about earlier, and compared it to a palour trick.  
But it isn't a trick any more, it is by all appearances, a practical 
technique that implements the idea I first heard of from Matt Dillon of 
dividing the filesystem into a front end and a back end, that run 
asynchronously.  Just a way to get a little more throughput, a little 
more smoothly.  Matt has had this working in Hammer for some time now, 
it is about time we saw such a thing on Linux.  More on that later.  
(For anybody who does not know who Matt Dillon is, he was also 
responsible for the reverse map design that inspired the development of 
the Linux 2.6 vm.)

So far, Tux3 has been exceptionally stable for me.  We had a couple of 
issues last night that showed up on my system and had somehow managed 
to sneak past fsx-linux over there in Tokyo.  Hirofumi found and fixed 
both of them (a memory leak and a missing SMP lock) before I even had a 
chance to get a debugger connected.  Then support had to be added for 
device nodes, by adding a new Tux3 inode attribute.  When this was 
done, Tux3 booted up happily.  We don't support fsync yet (this is part 
of the atomic commit/recovery work) and some software tends to get 
annoyed about that, so I taught fsync how to lie a little, and then 
apt-get was happy to install new software onto my Tux3 root filesystem.  
I then proceded to boot to KDE, instal xchat, and connect to #tux3 on 
irc.oftc.net.  So far, so good, the machine is still up and running.  
The old adage applies: no news is good news.

I will provide details for booting Tux3 as root shortly.

Regards,

Daniel
