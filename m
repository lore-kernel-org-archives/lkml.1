Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZIKPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZIKPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZIKPf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:35:59 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:33719 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZIKPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:35:59 -0400
Message-ID: <4AAA6E5E.9000900@linux.vnet.ibm.com>
Date: Fri, 11 Sep 2009 12:35:58 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wen Xiong <wenxiong@us.ibm.com>, scottk@digi.com
CC: alan@lxorguk.ukuu.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: jsm: Adding EEH handlers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding EEH handlers for the serial jsm driver. This patch adds
the PCI error handlers and also register them to be called when 
a error is detected.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index b3604aa..b37d2e2 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -48,6 +48,20 @@ struct uart_driver jsm_uart_driver = {
 	.nr		= NR_PORTS,
 };
 
+static pci_ers_result_t jsm_io_error_detected(struct pci_dev *pdev,
+					pci_channel_state_t state);
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
@@ -164,6 +178,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 	}
 
 	pci_set_drvdata(pdev, brd);
+	pci_save_state(pdev);
 
 	return 0;
  out_free_irq:
@@ -222,8 +237,39 @@ static struct pci_driver jsm_driver = {
 	.id_table	= jsm_pci_tbl,
 	.probe		= jsm_probe_one,
 	.remove		= __devexit_p(jsm_remove_one),
+	.err_handler	= &jsm_err_handler,
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
+	pci_enable_device(pdev);
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
index 00f4577..e70f2c1 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -432,7 +432,7 @@ int __devinit jsm_tty_init(struct jsm_board *brd)
 	return 0;
 }
 
-int __devinit jsm_uart_port_init(struct jsm_board *brd)
+int jsm_uart_port_init(struct jsm_board *brd)
 {
 	int i;
 	unsigned int line;
