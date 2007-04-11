Return-Path: <linux-kernel-owner+w=401wt.eu-S1161391AbXDKW4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161391AbXDKW4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161377AbXDKW4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:56:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55769 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161363AbXDKWze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:34 -0400
Date: Wed, 11 Apr 2007 15:52:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mark Lord <mlord@pobox.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 26/31] fix lba48 bug in libata fill_result_tf()
Message-ID: <20070411225246.GA24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-lba48-bug-in-libata-fill_result_tf.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mark Lord <liml@rtr.ca>

2.6.21 fix lba48 bug in libata fill_result_tf()

Current 2.6.21 libata does the following:

void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
{
        struct ata_ioports *ioaddr = &ap->ioaddr;

        tf->command = ata_check_status(ap);
	...
        if (tf->flags & ATA_TFLAG_LBA48) {
                iowrite8(tf->ctl | ATA_HOB, ioaddr->ctl_addr);
                tf->hob_feature = ioread8(ioaddr->error_addr);
                ...
        }
}
...
static void fill_result_tf(struct ata_queued_cmd *qc)
{
        struct ata_port *ap = qc->ap;

        ap->ops->tf_read(ap, &qc->result_tf);
        qc->result_tf.flags = qc->tf.flags;
}

Based on this, those last two statements fill_result_tf()
appear to me to be in the wrong order, in that the tf->flags
are uninitialized at the point where tf_read() is invoked.
So for lba48 commands, tf_read() won't be reading back the
full lba48 register contents..

Correct?

This patch corrects fill_result_tf() so that the flags
get copied to result_tf before they are used by tf_read().

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4742,8 +4742,8 @@ static void fill_result_tf(struct ata_qu
 {
 	struct ata_port *ap = qc->ap;
 
-	ap->ops->tf_read(ap, &qc->result_tf);
 	qc->result_tf.flags = qc->tf.flags;
+	ap->ops->tf_read(ap, &qc->result_tf);
 }
 
 /**

-- 
