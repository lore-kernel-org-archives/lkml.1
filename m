Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYLILj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYLILj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYLILjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:39:47 -0500
Received: from mail.crca.org.au ([67.207.131.56]:55416 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbYLILjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:39:46 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: [PATCH] Firewire node manager causes up to ~3.25s delay in
 freezing tasks.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: krh@redhat.com, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Tue, 09 Dec 2008 22:40:20 +1100
Message-Id: <1228822820.6681.22.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

(Okay, having learnt that ieee1394 != bluetooth, I'll try again :>)

The firewire nodemanager function "nodemgr_host_thread" contains a loop
that calls try_to_freeze near the top of the loop, but then delays for
up to 3.25 seconds (plus time to do work) before getting back to the top
of the loop. When starting a cycle post-boot, this doesn't seem to bite,
but it is causing a noticeable delay at boot time, when freezing
processes prior to starting to read the image.

The following patch adds invocation of try_to_freeze to the subloops
that are used in the body of this function. With these additions, the
time to freeze when starting to resume at boot time is virtually zero.
I'm no expert on bluetooth, and so don't know that we shouldn't check
the return value and jump back to the top of the loop or such like after
being frozen, but I submit it for your consideration.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

 nodemgr.c |    2 ++
 1 file changed, 2 insertions(+)
diff -ruNp 710-nodemanager-freezing.patch-old/drivers/ieee1394/nodemgr.c 710-nodemanager-freezing.patch-new/drivers/ieee1394/nodemgr.c
--- 710-nodemanager-freezing.patch-old/drivers/ieee1394/nodemgr.c	2008-12-06 08:42:08.000000000 +1100
+++ 710-nodemanager-freezing.patch-new/drivers/ieee1394/nodemgr.c	2008-12-09 18:49:26.000000000 +1100
@@ -1685,6 +1685,7 @@ static int nodemgr_host_thread(void *dat
 		g = get_hpsb_generation(host);
 		for (i = 0; i < 4 ; i++) {
 			msleep_interruptible(63);
+			try_to_freeze();
 			if (kthread_should_stop())
 				goto exit;
 
@@ -1725,6 +1726,7 @@ static int nodemgr_host_thread(void *dat
 		/* Sleep 3 seconds */
 		for (i = 3000/200; i; i--) {
 			msleep_interruptible(200);
+			try_to_freeze();
 			if (kthread_should_stop())
 				goto exit;
 


