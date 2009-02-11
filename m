Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbZBKAmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbZBKAmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZBKA2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:45 -0500
Received: from kroah.org ([198.145.64.141]:51487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757827AbZBKA2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:43 -0500
Date: Tue, 10 Feb 2009 16:25:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 41/56] md: Dont try to set an array to read-auto if it is
	already in that state.
Message-ID: <20090211002540.GP14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-don-t-try-to-set-an-array-to-read-auto-if-it-is-already-in-that-state.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

commit 80268ee9270ebe4847365a7426de91d179e870d0 upstream.

'read-auto' is a variant of 'readonly' which will switch to writable
on the first write attempt.

Calling do_md_stop to set the array readonly when it is already readonly
returns an error.  So make sure not to do that.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2742,9 +2742,9 @@ array_state_store(mddev_t *mddev, const 
 		break;
 	case read_auto:
 		if (mddev->pers) {
-			if (mddev->ro != 1)
+			if (mddev->ro == 0)
 				err = do_md_stop(mddev, 1, 0);
-			else
+			else if (mddev->ro == 1)
 				err = restart_array(mddev);
 			if (err == 0) {
 				mddev->ro = 2;

