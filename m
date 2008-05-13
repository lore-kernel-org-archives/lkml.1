Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYEMUZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYEMUZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760495AbYEMUQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:35 -0400
Received: from mail.suse.de ([195.135.220.2]:38533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbYEMUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:33 -0400
Date: Tue, 13 May 2008 13:12:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 32/37] SCSI: libiscsi regression in 2.6.25: fix nop timer
	handling
Message-ID: <20080513201245.GG31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-libiscsi-regression-in-2.6.25-fix-nop-timer-handling.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mike Christie <michaelc@cs.wisc.edu>

commit 4cf1043593db6a337f10e006c23c69e5fc93e722 upstream

The following patch fixes a bug in the iscsi nop processing.
The target sends iscsi nops to ping the initiator and the
initiator has to send nops to reply and can send nops to
ping the target.

In 2.6.25 we moved the nop processing to the kernel to handle
problems when the userspace daemon is not up, but the target
is pinging us, and to handle when scsi commands timeout, but
the transport may be the cause (we can send a nop to check
the transport). When we added this code we added a bug where
if the transport timer wakes at the exact same time we are supposed to check
for a nop timeout we drop the session instead of checking the transport.

This patch checks if a iscsi ping is outstanding and if the ping has
timed out, to determine if we need to signal a connection problem.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libiscsi.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1353,19 +1353,20 @@ static void iscsi_check_transport_timeou
 {
 	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
-	unsigned long timeout, next_timeout = 0, last_recv;
+	unsigned long recv_timeout, next_timeout = 0, last_recv;
 
 	spin_lock(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN)
 		goto done;
 
-	timeout = conn->recv_timeout;
-	if (!timeout)
+	recv_timeout = conn->recv_timeout;
+	if (!recv_timeout)
 		goto done;
 
-	timeout *= HZ;
+	recv_timeout *= HZ;
 	last_recv = conn->last_recv;
-	if (time_before_eq(last_recv + timeout + (conn->ping_timeout * HZ),
+	if (conn->ping_mtask &&
+	    time_before_eq(conn->last_ping + (conn->ping_timeout * HZ),
 			   jiffies)) {
 		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
 				  "expired, last rx %lu, last ping %lu, "
@@ -1376,15 +1377,15 @@ static void iscsi_check_transport_timeou
 		return;
 	}
 
-	if (time_before_eq(last_recv + timeout, jiffies)) {
+	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
 		if (time_before_eq(conn->last_ping, last_recv)) {
 			/* send a ping to try to provoke some traffic */
 			debug_scsi("Sending nopout as ping on conn %p\n", conn);
 			iscsi_send_nopout(conn, NULL);
 		}
-		next_timeout = last_recv + timeout + (conn->ping_timeout * HZ);
+		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
 	} else
-		next_timeout = last_recv + timeout;
+		next_timeout = last_recv + recv_timeout;
 
 	debug_scsi("Setting next tmo %lu\n", next_timeout);
 	mod_timer(&conn->transport_timer, next_timeout);

-- 
