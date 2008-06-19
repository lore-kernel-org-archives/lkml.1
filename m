Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYFSVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYFSVd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYFSVcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:38109 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbYFSVcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:10 -0400
Date: Thu, 19 Jun 2008 14:29:58 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 08/15] scsi_host regression: fix scsi host leak
Message-ID: <20080619212958.GI20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi_host-regression-fix-scsi-host-leak.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mike Christie <michaelc@cs.wisc.edu>

The patch is upstream as commit 3ed7897242b7efe977f3a8d06d4e5a4ebe28b10e

A different backport is necessary because of the class_device to device
conversion post 2.6.25.


commit 9c7701088a61cc0cf8a6e1c68d1e74e3cc2ee0b7
Author: Dave Young <hidave.darkstar@gmail.com>
Date:   Tue Jan 22 14:01:34 2008 +0800

    scsi: use class iteration api

Isn't a correct replacement for the original hand rolled host
lookup. The problem is that class_find_child would get a reference to
the host's class device which is never released.  Since the host class
device holds a reference to the host gendev, the host can never be
freed.

In 2.6.25 we started using class_find_device, and this function also
gets a reference to the device, so we end up with an extra ref
and the host will not get released.

This patch adds a class_put_device to balance the class_find_device()
get. I kept the scsi_host_get in scsi_host_lookup, because the target
layer is using scsi_host_lookup and it looks like it needs the SHOST_DEL
check.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/scsi/hosts.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -455,9 +455,10 @@ struct Scsi_Host *scsi_host_lookup(unsig
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
 
 	cdev = class_find_child(&shost_class, &hostnum, __scsi_host_match);
-	if (cdev)
+	if (cdev) {
 		shost = scsi_host_get(class_to_shost(cdev));
-
+		class_device_put(cdev);
+	}
 	return shost;
 }
 EXPORT_SYMBOL(scsi_host_lookup);

-- 
