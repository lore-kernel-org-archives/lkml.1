Return-Path: <linux-kernel-owner+w=401wt.eu-S935188AbZLKXmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188AbZLKXmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934997AbZLKXl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:41:57 -0500
Received: from kroah.org ([198.145.64.141]:50431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762821AbZLKX2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/58] jsm: adding EEH handlers
Date: Fri, 11 Dec 2009 15:27:52 -0800
Message-Id: <1260574122-10676-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>

Adding EEH handlers for the serial jsm driver. This patch adds
the PCI error handlers and also register them to be called when
a error is detected.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Acked-by: Scott Kilau <scottk@digi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/jsm/jsm_driver.c |   46 +++++++++++++++++++++++++++++++++++++++
 drivers/serial/jsm/jsm_tty.c    |    2 +-
 2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index 48326f7..108c3e0 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -48,6 +48,17 @@ struct uart_driver jsm_uart_driver = {
 	.nr		= NR_PORTS,
 };
 
+static pci_ers_result_t jsm_io_error_detected(struct pci_dev *pdev,
+                                       pci_channel_state_t state);
+static pci_ers_result_t jsm_io_slot_reset(struct pci_dev *pdev);
+static void jsm_io_resume(struct pci_dev *pdev);
+
+static struct pci_error_handlers jsm_err_handler = {
+	.error_detected = jsm_io_error_detected,
+	.slot_reset = jsm_io_slot_reset,
+	.resume = jsm_io_resume,
+};
+
 int jsm_debug;
 module_param(jsm_debug, int, 0);
 MODULE_PARM_DESC(jsm_debug, "Driver debugging level");
@@ -164,6 +175,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 	}
 
 	pci_set_drvdata(pdev, brd);
+	pci_save_state(pdev);
 
 	return 0;
  out_free_irq:
@@ -222,8 +234,42 @@ static struct pci_driver jsm_driver = {
 	.id_table	= jsm_pci_tbl,
 	.probe		= jsm_probe_one,
 	.remove		= __devexit_p(jsm_remove_one),
+	.err_handler    = &jsm_err_handler,
 };
 
+static pci_ers_result_t jsm_io_error_detected(struct pci_dev *pdev,
+					pci_channel_state_t state)
+{
+	struct jsm_board *brd = pci_get_drvdata(pdev);
+
+	jsm_remove_uart_port(brd);
+
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+static pci_ers_result_t jsm_io_slot_reset(struct pci_dev *pdev)
+{
+	int rc;
+
+	rc = pci_enable_device(pdev);
+
+	if (rc)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	pci_set_master(pdev);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static void jsm_io_resume(struct pci_dev *pdev)
+{
+	struct jsm_board *brd = pci_get_drvdata(pdev);
+
+	pci_restore_state(pdev);
+
+	jsm_uart_port_init(brd);
+}
+
 static int __init jsm_init_module(void)
 {
 	int rc;
diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 1bcad59..cd95e21 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -430,7 +430,7 @@ int __devinit jsm_tty_init(struct jsm_board *brd)
 	return 0;
 }
 
-int __devinit jsm_uart_port_init(struct jsm_board *brd)
+int jsm_uart_port_init(struct jsm_board *brd)
 {
 	int i;
 	unsigned int line;
-- 
1.6.5.5

