Return-Path: <linux-kernel-owner+w=401wt.eu-S1765145AbYHDVjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765145AbYHDVjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765639AbYHDVhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:37:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:54796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765631AbYHDVhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:37:31 -0400
Date: Mon, 4 Aug 2008 14:30:20 -0700
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
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 11/25] SCSI: ch: fix ch_remove oops
Message-ID: <20080804213020.GK8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-ch-fix-ch_remove-oops.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 3d164fb09bb5cb8a223eddf634fc0d355714fcfe upstream.

The following commit causes ch_remove oops:

commit 24b42566c3fcbb5a9011d1446783d0f5844ccd45
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Fri May 16 17:55:12 2008 -0700

    SCSI: fix race in device_create

    There is a race from when a device is created with device_create() and
    then the drvdata is set with a call to dev_set_drvdata() in which a
    sysfs file could be open, yet the drvdata will be NULL, causing all
    sorts of bad things to happen.

    This patch fixes the problem by using the new function,
    device_create_drvdata().  It fixes the problem in all of the scsi
    drivers that need it.

    Cc: Kay Sievers <kay.sievers@vrfy.org>
    Cc: Doug Gilbert <dgilbert@interlog.com>
    Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

The problem is ch_probe stores ch's private data at a wrong place.

We need to store it at scsi_device->sdev_gendev but the above patch
stores it at device struct that device_create_drvdata returns. So we
hit an oops when ch_remove accesses
scsi_device->sdev_gendev->driver_data, which is NULL.

Actually, there wasn't a race because ch doesn't create sysfs files
with device struct that device_create returns. This patch puts back
dev_set_drvdata() to set ch's private data properly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -926,6 +926,7 @@ static int ch_probe(struct device *dev)
 	if (init)
 		ch_init_elem(ch);
 
+	dev_set_drvdata(dev, ch);
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 
 	return 0;

-- 
