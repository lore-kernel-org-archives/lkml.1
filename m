Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0BSRDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:03:10 -0500
Received: from kroah.org ([198.145.64.141]:57869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0BSRBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:20 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:57 2010
Message-Id: <20100219163256.867138981@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [92/93] dm log: userspace fix overhead_size calcuations
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan Brassow <jbrassow@redhat.com>

commit ebfd32bba9b518d684009d9d21a56742337ca1b3 upstream.

This patch fixes two bugs that revolve around the miscalculation and
misuse of the variable 'overhead_size'.  'overhead_size' is the size of
the various header structures used during communication.

The first bug is the use of 'sizeof' with the pointer of a structure
instead of the structure itself - resulting in the wrong size being
computed.  This is then used in a check to see if the payload
(data_size) would be to large for the preallocated structure.  Since the
bug produces a smaller value for the overhead, it was possible for the
structure to be breached.  (Although the current users of the code do
not currently send enough data to trigger this bug.)

The second bug is that the 'overhead_size' value is used to compute how
much of the preallocated space should be cleared before populating it
with fresh data.  This should have simply been 'sizeof(struct cn_msg)'
not overhead_size.  The fact that 'overhead_size' was computed
incorrectly made this problem "less bad" - leaving only a pointer's
worth of space at the end uncleared.  Thus, this bug was never producing
a bad result, but still needs to be fixed - especially now that the
value is computed correctly.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-log-userspace-transfer.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -172,11 +172,15 @@ int dm_consult_userspace(const char *uui
 {
 	int r = 0;
 	size_t dummy = 0;
-	int overhead_size =
-		sizeof(struct dm_ulog_request *) + sizeof(struct cn_msg);
+	int overhead_size = sizeof(struct dm_ulog_request) + sizeof(struct cn_msg);
 	struct dm_ulog_request *tfr = prealloced_ulog_tfr;
 	struct receiving_pkg pkg;
 
+	/*
+	 * Given the space needed to hold the 'struct cn_msg' and
+	 * 'struct dm_ulog_request' - do we have enough payload
+	 * space remaining?
+	 */
 	if (data_size > (DM_ULOG_PREALLOCED_SIZE - overhead_size)) {
 		DMINFO("Size of tfr exceeds preallocated size");
 		return -EINVAL;
@@ -191,7 +195,7 @@ resend:
 	 */
 	mutex_lock(&dm_ulog_lock);
 
-	memset(tfr, 0, DM_ULOG_PREALLOCED_SIZE - overhead_size);
+	memset(tfr, 0, DM_ULOG_PREALLOCED_SIZE - sizeof(struct cn_msg));
 	memcpy(tfr->uuid, uuid, DM_UUID_LEN);
 	tfr->luid = luid;
 	tfr->seq = dm_ulog_seq++;


