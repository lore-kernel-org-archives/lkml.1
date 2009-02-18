Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZBRViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZBRViT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZBRVfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:35:34 -0500
Received: from kroah.org ([198.145.64.141]:56115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754440AbZBRVfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:33 -0500
Date: Wed, 18 Feb 2009 13:32:25 -0800
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
       alan@lxorguk.ukuu.org.uk, Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jean Delvare <jdelvare@suse.de>
Subject: [patch 07/39] SCSI: libiscsi: fix iscsi pool leak
Message-ID: <20090218213225.GH19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-libiscsi-fix-iscsi-pool-leak.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 2f5899a39dcffb404c9a3d06ad438aff3e03bf04 upstream.

I am not sure what happened. It looks like we have always leaked
the q->queue that is allocated from the kfifo_init call. nab finally
noticed that we were leaking and this patch fixes it by adding a
kfree call to iscsi_pool_free. kfifo_free is not used per kfifo_init's
instructions to use kfree.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libiscsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1899,6 +1899,7 @@ void iscsi_pool_free(struct iscsi_pool *
 		kfree(q->pool[i]);
 	if (q->pool)
 		kfree(q->pool);
+	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 

