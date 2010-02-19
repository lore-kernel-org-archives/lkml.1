Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0BSRO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:14:57 -0500
Received: from kroah.org ([198.145.64.141]:57443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab0BSRAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:25 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:37 2010
Message-Id: <20100219163237.583272962@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [26/93] cciss: Make cciss_seq_show handle holes in the h->drv[] array
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

commit 531c2dc70d339c5dfa8c3eb628c3459dc6f3a075 upstream.

It is possible (and expected) for there to be holes in the h->drv[]
array, that is, some elements may be NULL pointers.  cciss_seq_show
needs to be made aware of this possibility to avoid an Oops.

To reproduce the Oops which this fixes:

1) Create two "arrays" in the Array Configuratino Utility and
   several logical drives on each array.
2) cat /proc/driver/cciss/cciss* in an infinite loop
3) delete some of the logical drives in the first "array."

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cciss.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -339,6 +339,9 @@ static int cciss_seq_show(struct seq_fil
 	if (*pos > h->highest_lun)
 		return 0;
 
+	if (drv == NULL) /* it's possible for h->drv[] to have holes. */
+		return 0;
+
 	if (drv->heads == 0)
 		return 0;
 


