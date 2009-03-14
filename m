Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZCNAea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZCNAea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZCNATR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:17 -0400
Received: from kroah.org ([198.145.64.141]:47076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752574AbZCNATE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:45 2009
Message-Id: <20090314000745.652851893@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:52 -0700
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
       Robert Hancock <hancockrwd@gmail.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 44/96] libata: make sure port is thawed when skipping resets
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=libata-make-sure-port-is-thawed-when-skipping-resets.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d6515e6ff4ad3db4bd5ef2dd4e1026a7aca2482e upstream.

When SCR access is available and the link is offline, softreset is
skipped as it only wastes time and some controllers don't respond very
well.  However, the skip path forgot to thaw the port, which not only
blocks further event notification from the port but also causes
repeated EH invocations on the same event on drivers which rely on
->thaw() to clear events if the IRQ is shared with another device or
port.

This problem has always been there but is uncovered by recent sata_nv
nf2/3 change which dropped hardreset support while maintaining SCR
access.  nf2/3 doesn't clear hotplug event mask from the interrupt
handler but relies on ->thaw() to clear them.  When the hardreset was
there, the reset action was never skipped and the port was always
thawed but, with the hardreset gone, ->prereset() determines that
there's no need for softreset and both ->softreset() and ->thaw() are
skipped.  This leads to stuck hotplug event in the IRQ status register
triggering hotplug event whenever IRQ is delieverd on the same IRQ.
As the controller shares the same IRQ for both ports, this happens on
every IO if one port is occpupied and the other isn't.

This patch fixes the problem by making sure that the port is thawed on
reset-skip path.

bko#11615 reports this problem.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>
Reported-by: Dan Andresan <danyer@gmail.com>
Reported-by: Arne Woerner <arne_woerner@yahoo.com>
Reported-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2272,11 +2272,14 @@ int ata_eh_reset(struct ata_link *link, 
 		}
 
 		/* prereset() might have cleared ATA_EH_RESET.  If so,
-		 * bang classes and return.
+		 * bang classes, thaw and return.
 		 */
 		if (reset && !(ehc->i.action & ATA_EH_RESET)) {
 			ata_link_for_each_dev(dev, link)
 				classes[dev->devno] = ATA_DEV_NONE;
+			if ((ap->pflags & ATA_PFLAG_FROZEN) &&
+			    ata_is_host_link(link))
+				ata_eh_thaw_port(ap);
 			rc = 0;
 			goto out;
 		}


