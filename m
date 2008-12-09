Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYLISrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYLISrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYLISqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:46:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56591 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbYLISqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:46:48 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 9 Dec 2008 19:46:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] ieee1394 fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.9291b0d04a76c14a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following update:

Nigel Cunningham (1):
      ieee1394: node manager causes up to ~3.25s delay in freezing tasks

 drivers/ieee1394/nodemgr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


commit ec9a13cdbfc8cf29502096ca69b65f07184a9b2c
Author: Nigel Cunningham <ncunningham@crca.org.au>
Date:   Tue Dec 9 22:40:20 2008 +1100

    ieee1394: node manager causes up to ~3.25s delay in freezing tasks
    
    The firewire nodemanager function "nodemgr_host_thread" contains a loop
    that calls try_to_freeze near the top of the loop, but then delays for
    up to 3.25 seconds (plus time to do work) before getting back to the top
    of the loop. When starting a cycle post-boot, this doesn't seem to bite,
    but it is causing a noticeable delay at boot time, when freezing
    processes prior to starting to read the image.
    
    The following patch adds invocation of try_to_freeze to the subloops
    that are used in the body of this function. With these additions, the
    time to freeze when starting to resume at boot time is virtually zero.
    I'm no expert on firewire, and so don't know that we shouldn't check
    the return value and jump back to the top of the loop or such like after
    being frozen, but I submit it for your consideration.
    
    Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
    
    The delay until nodemgr freezes was up to 0.25s (plus time for node
    probes) in Linux 2.6.27 and older and up to 3.25s (plus ~) since Linux
    2.6.28-rc1, hence much more noticeable.
    
    try_to_freeze() without any jump is correct.  The surrounding code in
    the respective loops will catch whether another bus reset happens during
    the freeze and handle it.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 9e39f73..d333ae2 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1685,6 +1685,7 @@ static int nodemgr_host_thread(void *data)
 		g = get_hpsb_generation(host);
 		for (i = 0; i < 4 ; i++) {
 			msleep_interruptible(63);
+			try_to_freeze();
 			if (kthread_should_stop())
 				goto exit;
 
@@ -1725,6 +1726,7 @@ static int nodemgr_host_thread(void *data)
 		/* Sleep 3 seconds */
 		for (i = 3000/200; i; i--) {
 			msleep_interruptible(200);
+			try_to_freeze();
 			if (kthread_should_stop())
 				goto exit;
 

Thanks,
-- 
Stefan Richter
-=====-==--- ==-- -=--=
http://arcgraph.de/sr/

