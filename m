Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYCCCnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYCCCnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 21:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYCCCmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 21:42:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:14767 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbYCCCmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 21:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=w8yfp2gzdjEVwbiKuOofs4ifzLoUA2zSLJ047gbpOfaCJTd43jTHKb4Wb4yIe5Rs+ZiFFiLSFQsXmI+tMUSuJqgYkocXcy6OQypMWtpXfJxkqcSncd5ORMNqYirN5M/fI3d7mS0Keorh28Q7hZgGCOjHwMTcRSkfZMcYtMghsZo=
Date: Mon, 3 Mar 2008 10:48:45 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: tglx@linutronix.de, davem@davemloft.net, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] l2cap info_timer delete fix in hci_conn_del
Message-ID: <20080303024845.GA3197@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the l2cap info_timer is active the info_state will be set to
L2CAP_INFO_FEAT_MASK_REQ_SENT, and it will be unset after the timer
is deleted or timeout triggered.

Here in hci_conn_del only call del_timer_sync when the info_state
is set to L2CAP_INFO_FEAT_MASK_REQ_SENT.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
net/bluetooth/l2cap.c |    3 ++-
1 file changed, 2 insertions(+), 1 deletion(-)

diff -upr linux/net/bluetooth/l2cap.c linux.new/net/bluetooth/l2cap.c
--- linux/net/bluetooth/l2cap.c	2008-03-03 10:35:03.000000000 +0800
+++ linux.new/net/bluetooth/l2cap.c	2008-03-03 10:36:34.000000000 +0800
@@ -417,7 +417,8 @@ static void l2cap_conn_del(struct hci_co
 		l2cap_sock_kill(sk);
 	}
 
-	del_timer_sync(&conn->info_timer);
+	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
+		del_timer_sync(&conn->info_timer);
 
 	hcon->l2cap_data = NULL;
 	kfree(conn);
