Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYJGAox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYJGAox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYJGAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:42:55 -0400
Received: from ns1.suse.de ([195.135.220.2]:46606 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225AbYJGAmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:42:54 -0400
Date: Mon, 6 Oct 2008 17:37:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 12/71] SCSI: qla2xxx: Defer enablement of RISC interrupts
	until ISP initialization completes.
Message-ID: <20081007003759.GM3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-qla2xxx-defer-enablement-of-risc-interrupts-until-isp-initialization-completes.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 048feec5548c0582ee96148c61b87cccbcb5f9be upstream

Josip Rodin noted
(http://article.gmane.org/gmane.linux.ports.sparc/10152) the
driver oopsing during registration of an rport to the
FC-transport layer with a backtrace indicating a dereferencing of
an shost->shost_data equal to NULL.  David Miller identified a
small window in driver logic where this could happen:

    > Look at how the driver registers the IRQ handler before the host has
    > been registered with the SCSI layer.
    >
    > That leads to a window of time where the shost hasn't been setup
    > fully, yet ISRs can come in and trigger DPC thread events, such as
    > loop resyncs, which expect the transport area to be setup.
    >
    > But it won't be setup, because scsi_add_host() hasn't finished yet.
    >
    > Note that in Josip's crash log, we don't even see the
    >
    >         qla_printk(KERN_INFO, ha, "\n"
    >             " QLogic Fibre Channel HBA Driver: %s\n"
    >             "  QLogic %s - %s\n"
    >             "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
    >  ...
    >
    > message yet.
    >
    > Which means that the crash occurs between qla2x00_request_irqs()
    > and printing that message.

Close this window by enabling RISC interrupts after the host has
been registered with the SCSI midlayer.

Reported-by: Josip Rodin <joy@entuzijast.net>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_isr.c |    1 -
 drivers/scsi/qla2xxx/qla_os.c  |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1838,7 +1838,6 @@ clear_risc_ints:
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
 	}
 	spin_unlock_irq(&ha->hardware_lock);
-	ha->isp_ops->enable_intrs(ha);
 
 fail:
 	return ret;
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1740,6 +1740,8 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	if (ret)
 		goto probe_failed;
 
+	ha->isp_ops->enable_intrs(ha);
+
 	scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(ha);

-- 
