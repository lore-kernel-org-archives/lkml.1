Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbXGGS6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbXGGS6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXGGS57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:57:59 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55752 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXGGS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:57:58 -0400
Subject: [PATCH] Fix use-after-free oops in Bluetooth HID.
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
In-Reply-To: <alpine.LFD.0.999.0707071135090.31544@woody.linux-foundation.org>
References: <468A7D14.1050505@googlemail.com>
	 <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com>
	 <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>
	 <200707062033.18211.dtor@insightbb.com>
	 <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz>
	 <1183771730.2789.1.camel@shinybook.infradead.org>
	 <1183775126.3066.5.camel@shinybook.infradead.org>
	 <1183832913.6351.130.camel@aeonflux.holtmann.net>
	 <alpine.LFD.0.999.0707071135090.31544@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 14:58:39 -0400
Message-Id: <1183834720.3066.83.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When cleaning up HIDP sessions, we currently close the ACL connection
before deregistering the input device. Closing the ACL connection
schedules a workqueue to remove the associated objects from sysfs, but
the input device still refers to them -- and if the workqueue happens to
run before the input device removal, the kernel will oops when trying to
look up PHYSDEVPATH for the removed input device.

Fix this by deregistering the input device before closing the
connections.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

--- net/bluetooth/hidp/core.c~	2007-07-06 21:34:25.000000000 -0400
+++ net/bluetooth/hidp/core.c	2007-07-06 22:06:48.000000000 -0400
@@ -581,15 +581,6 @@ static int hidp_session(void *arg)
 
 	hidp_del_timer(session);
 
-	fput(session->intr_sock->file);
-
-	wait_event_timeout(*(ctrl_sk->sk_sleep),
-		(ctrl_sk->sk_state == BT_CLOSED), msecs_to_jiffies(500));
-
-	fput(session->ctrl_sock->file);
-
-	__hidp_unlink_session(session);
-
 	if (session->input) {
 		input_unregister_device(session->input);
 		session->input = NULL;
@@ -601,6 +592,15 @@ static int hidp_session(void *arg)
 		hid_free_device(session->hid);
 	}
 
+	fput(session->intr_sock->file);
+
+	wait_event_timeout(*(ctrl_sk->sk_sleep),
+		(ctrl_sk->sk_state == BT_CLOSED), msecs_to_jiffies(500));
+
+	fput(session->ctrl_sock->file);
+
+	__hidp_unlink_session(session);
+
 	up_write(&hidp_session_sem);
 
 	kfree(session);


-- 
dwmw2

