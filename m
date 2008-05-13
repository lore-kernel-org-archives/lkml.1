Return-Path: <linux-kernel-owner+w=401wt.eu-S1763306AbYEMUZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763306AbYEMUZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932311AbYEMUQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:38877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbYEMUQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:39 -0400
Date: Tue, 13 May 2008 13:12:47 -0700
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
Subject: [patch 33/37] SCSI: libiscsi regression in 2.6.25: fix setting of
	recv timer
Message-ID: <20080513201247.GH31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-libiscsi-regression-in-2.6.25-fix-setting-of-recv-timer.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mike Christie <michaelc@cs.wisc.edu>

commit c8611f975403dd20e6503aff8aded5dcb718f75b upstream

If the ping tmo is longer than the recv tmo then we could miss a window
where we were supposed to check the recv tmo. This happens because
the ping code will set the next timeout for the ping timeout, and if the
ping executes quickly there will be a long chunk of time before the
timer wakes up again.

This patch has the ping processing code kick off a recv
tmo check when getting a nop in response to our ping.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libiscsi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -635,7 +635,9 @@ static int __iscsi_complete_pdu(struct i
 				if (iscsi_recv_pdu(conn->cls_conn, hdr, data,
 						   datalen))
 					rc = ISCSI_ERR_CONN_FAILED;
-			}
+			} else
+				mod_timer(&conn->transport_timer,
+					  jiffies + conn->recv_timeout);
 			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		default:
@@ -1378,11 +1380,9 @@ static void iscsi_check_transport_timeou
 	}
 
 	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
-		if (time_before_eq(conn->last_ping, last_recv)) {
-			/* send a ping to try to provoke some traffic */
-			debug_scsi("Sending nopout as ping on conn %p\n", conn);
-			iscsi_send_nopout(conn, NULL);
-		}
+		/* send a ping to try to provoke some traffic */
+		debug_scsi("Sending nopout as ping on conn %p\n", conn);
+		iscsi_send_nopout(conn, NULL);
 		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
 	} else
 		next_timeout = last_recv + recv_timeout;

-- 
