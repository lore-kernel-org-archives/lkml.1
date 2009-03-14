Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZCNB0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZCNB0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZCNBUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:05 -0400
Received: from kroah.org ([198.145.64.141]:34901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751466AbZCNBT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:34 2009
Message-Id: <20090314011034.029554443@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:55 -0700
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 018/114] SCSI: sd: revive sd_index_lock
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=scsi-sd-revive-sd_index_lock.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 4034cc68157bfa0b6622efe368488d3d3e20f4e6 upstream.

Commit f27bac2761cab5a2e212dea602d22457a9aa6943 which converted sd to
use ida instead of idr incorrectly removed sd_index_lock around id
allocation and free.  idr/ida do have internal locks but they protect
their free object lists not the allocation itself.  The caller is
responsible for that.  This missing synchronization led to the same id
being assigned to multiple devices leading to oops.

Reported and tracked down by Stuart Hayes of Dell.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -106,6 +106,7 @@ static void scsi_disk_release(struct dev
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
+static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -1847,7 +1848,9 @@ static int sd_probe(struct device *dev)
 		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
 			goto out_put;
 
+		spin_lock(&sd_index_lock);
 		error = ida_get_new(&sd_index_ida, &index);
+		spin_unlock(&sd_index_lock);
 	} while (error == -EAGAIN);
 
 	if (error)
@@ -1910,7 +1913,9 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
+	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, index);
+	spin_unlock(&sd_index_lock);
  out_put:
 	put_disk(gd);
  out_free:
@@ -1960,7 +1965,9 @@ static void scsi_disk_release(struct dev
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
+	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, sdkp->index);
+	spin_unlock(&sd_index_lock);
 
 	disk->private_data = NULL;
 	put_disk(disk);


