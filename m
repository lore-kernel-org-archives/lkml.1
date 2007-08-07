Return-Path: <linux-kernel-owner+w=401wt.eu-S965172AbXHGU5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172AbXHGU5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762539AbXHGUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:49:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56200 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935078AbXHGUtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:49:31 -0400
Date: Tue, 7 Aug 2007 13:44:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Petr Vandrovec <petr@vandrovec.name>, Jeff Garzik <jeff@garzik.org>
Subject: [2.6.22.2 review 23/84] Fix reported task file values in sense data
Message-ID: <20070807204449.GX23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-reported-task-file-values-in-sense-data.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Vandrovec <petr@vandrovec.name>

ata_tf_read was setting HOB bit when lba48 command was submitted, but
was not clearing it before reading "normal" data.  As it is only place
which sets HOB bit in control register, and register reads should not
be affected by other bits, let's just clear it when we are done with
reading upper bytes so non-48bit commands do not have to touch ctl
at all.

pata_scc suffered from same problem...

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |    2 ++
 drivers/ata/pata_scc.c   |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -211,6 +211,8 @@ void ata_tf_read(struct ata_port *ap, st
 		tf->hob_lbal = ioread8(ioaddr->lbal_addr);
 		tf->hob_lbam = ioread8(ioaddr->lbam_addr);
 		tf->hob_lbah = ioread8(ioaddr->lbah_addr);
+		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
 	}
 }
 
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -352,6 +352,8 @@ static void scc_tf_read (struct ata_port
 		tf->hob_lbal = in_be32(ioaddr->lbal_addr);
 		tf->hob_lbam = in_be32(ioaddr->lbam_addr);
 		tf->hob_lbah = in_be32(ioaddr->lbah_addr);
+		out_be32(ioaddr->ctl_addr, tf->ctl);
+		ap->last_ctl = tf->ctl;
 	}
 }
 

-- 
