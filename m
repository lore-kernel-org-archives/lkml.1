Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXGGCZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXGGCZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXGGCYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:24:52 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34443 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXGGCYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:24:52 -0400
Subject: Re: [1/2] 2.6.22-rc7: known regressions
From: David Woodhouse <dwmw2@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
In-Reply-To: <1183771730.2789.1.camel@shinybook.infradead.org>
References: <468A7D14.1050505@googlemail.com>
	 <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com>
	 <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>
	 <200707062033.18211.dtor@insightbb.com>
	 <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz>
	 <1183771730.2789.1.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 22:25:26 -0400
Message-Id: <1183775126.3066.5.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 21:28 -0400, David Woodhouse wrote:
> I suspect it's more likely that hci_conn_del_sysfs() is running and
> removing the object representing the ACL connection. That's what the
> input device's remove event is reporting as 'PHYSDEVPATH' on the
> occasions that it _doesn't_ oops. 

Yes, that seems to be it. It happens when we hit the idle_timeout and
the kernel tears down the connection. Adding a mdelay(5000) into
hidp_session() just before calling input_unregister_device(), and
hard-coding idle_to to 1 second, makes it nice and easy to reproduce...

Marcel? Can we deregister the input devices earlier...?

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

