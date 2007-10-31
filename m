Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXJaNzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXJaNzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbXJaNze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:55:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:13628 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334AbXJaNzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:55:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=dREX/GTGCTIdk0adf4eU5cJ2u31jEkq0V8UsHR2XUbl/+UtmBML2JyeUYCJYHBY1d9IxcriaeCSCPt0c2geVrS0sKyFWAH6bt5Vr14qADOSl7Dt6w6cw92cnlP56KIjaxBUePo8lHGuqB8Z8d1bOV9LKRgkGUeK5AbdPIOGeI50=
Message-ID: <47288950.3030907@googlemail.com>
Date: Wed, 31 Oct 2007 14:55:28 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: libata-core.c compile warnings with !CONFIG_PM
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi , 

I see this warnings on current git head with !CONFIG_PM :

...

drivers/ata/libata-core.c:768: warning: 'ata_lpm_enable' defined but not used
drivers/ata/libata-core.c:784: warning: 'ata_lpm_disable' defined but not used

...

So far I see ata_lpm_enable() is only used in ata_host_suspend(), ata_lpm_disable() only
in ata_host_resume() which have already #ifdef CONFIG_PM around.

Possible fix is to do the same for ata_lpm_enable() , ata_lpm_disable() and for ata_dev_disable_pm()
which is only used in ata_lpm_enable()


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 drivers/ata/libata-core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 63035d7..7c78810 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -747,6 +747,7 @@ enable_pm_out:
  *	Locking: Caller.
  *	Returns: void
  */
+#ifdef CONFIG_PM
 static void ata_dev_disable_pm(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
@@ -755,6 +756,7 @@ static void ata_dev_disable_pm(struct ata_device *dev)
 	if (ap->ops->disable_pm)
 		ap->ops->disable_pm(ap);
 }
+#endif
 
 void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
 {
@@ -764,6 +766,7 @@ void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
 	ata_port_schedule_eh(ap);
 }
 
+#ifdef CONFIG_PM
 static void ata_lpm_enable(struct ata_host *host)
 {
 	struct ata_link *link;
@@ -789,7 +792,7 @@ static void ata_lpm_disable(struct ata_host *host)
 		ata_lpm_schedule(ap, ap->pm_policy);
 	}
 }
-
+#endif
 
 /**
  *	ata_devchk - PATA device presence detection



