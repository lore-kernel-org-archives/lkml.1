Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZELVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZELVWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZELVWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:22:03 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44524 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZELVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Ce0nxA3ecL/5h5GHNSxxha5mQiCu3C7Vc1uaZ54e/IQYr+wKQivR06B6VR917U9pXw
         7HvAKsWUHH2sD//q3CAj5kjEbI2sQTgWIIBrggLLQiXHBQVA6+IQLKsKFUps7MJ9rcjp
         5dPCB6WDKjdLJP8IqTnIKFSteHBv6SU6VccgA=
MIME-Version: 1.0
Date: Wed, 13 May 2009 01:22:00 +0400
Message-ID: <f74141980905121422p140d1649jcfb3d94aacd42f02@mail.gmail.com>
Subject: jsm: two or more 4/8-port boards can not initialize ports properly
From: "Alexander Y. Fomichev" <git.user@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G' day

The patch bellow fix for me problem with jsm_uart_port_init
which still thinking it works for 2-ports borads only.
drivers/serial/jsm/jsm_tty.c +462
brd->channels[i]->uart_port.line = brd->channels[i]->ch_portnum +
brd->boardnum * 2;

                         ^^^^^^^^^^^^^^^^^^^^^^
so for line numbers of the second and further boards
may/will be assigned values with the same range.
in my case of two digi neo-8 -- 6 ports of 8 failed to be
added for the second board.

[    1.331294] serial 0000:04:09.0: PCI INT A -> GSI 51 (level, low) -> IRQ 51
[    1.338337] serial 0000:04:09.0: PCI INT A disabled
[    1.343313] serial 0000:03:09.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
[    1.350345] serial 0000:03:09.0: PCI INT A disabled
[    1.355482] jsm 0000:04:09.0: PCI INT A -> GSI 51 (level, low) -> IRQ 51
[    1.362279] IRQ 51/JSM: IRQF_DISABLED is not guaranteed on shared IRQs
[    1.368905] ttyn0 at MMIO 0x0 (irq = 51) is a jsm
[    1.374079] Added device
[    1.376771] ttyn1 at MMIO 0x0 (irq = 51) is a jsm
[    1.381796] Added device
[    1.384485] ttyn2 at MMIO 0x0 (irq = 51) is a jsm
[    1.389502] Added device
[    1.392191] ttyn3 at MMIO 0x0 (irq = 51) is a jsm
[    1.397200] Added device
[    1.399886] ttyn4 at MMIO 0x0 (irq = 51) is a jsm
[    1.404886] Added device
[    1.407573] ttyn5 at MMIO 0x0 (irq = 51) is a jsm
[    1.412578] Added device
[    1.415260] ttyn6 at MMIO 0x0 (irq = 51) is a jsm
[    1.420267] Added device
[    1.422947] ttyn7 at MMIO 0x0 (irq = 51) is a jsm
[    1.427955] Added device
[    1.430642] jsm 0000:04:09.0: board 1: Digi Neo (rev 9), irq 51
[    1.436660] jsm 0000:03:09.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
[    1.443446] IRQ 27/JSM: IRQF_DISABLED is not guaranteed on shared IRQs
[    1.450077] Added device failed
[    1.453286] Added device failed
[    1.456492] Added device failed
[    1.459691] Added device failed
[    1.462899] Added device failed
[    1.466105] Added device failed
[    1.469314] ttyn8 at MMIO 0x0 (irq = 27) is a jsm
[    1.474377] Added device
[    1.477074] ttyn9 at MMIO 0x0 (irq = 27) is a jsm
[    1.482101] Added device
[    1.484793] jsm 0000:03:09.0: board 2: Digi Neo (rev 2), irq 27

---------------------------------------------------------------------------------------------------
diff -urNp a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h  2009-05-12 17:29:02.117674090 +0400
+++ b/drivers/serial/jsm/jsm.h  2009-05-12 17:51:35.197811282 +0400
@@ -61,6 +61,7 @@ enum {
        if ((DBG_##nlevel & jsm_debug))                 \
        dev_printk(KERN_##klevel, pdev->dev, fmt, ## args)

+#define MAXBOARDS      32
 #define MAXPORTS       8
 #define MAX_STOPS_SENT 5

@@ -94,6 +95,7 @@ enum {

 struct jsm_board;
 struct jsm_channel;
+extern struct jsm_board *jsm_boards[];

 /************************************************************************
  * Per board operations structure                                      *
diff -urNp a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c   2009-05-12 17:29:02.117674090 +0400
+++ b/drivers/serial/jsm/jsm_driver.c   2009-05-12 17:55:42.597168409 +0400
@@ -52,6 +52,8 @@ int jsm_debug;
 module_param(jsm_debug, int, 0);
 MODULE_PARM_DESC(jsm_debug, "Driver debugging level");

+struct jsm_board *jsm_boards[MAXBOARDS];
+
 static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct
pci_device_id *ent)
 {
        int rc = 0;
@@ -80,6 +82,7 @@ static int __devinit jsm_probe_one(struc

        /* store the info for the board we've found */
        brd->boardnum = adapter_count++;
+       jsm_boards[brd->boardnum] = brd;
        brd->pci_dev = pdev;
        if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
                brd->maxports = 4;
@@ -171,6 +174,7 @@ static int __devinit jsm_probe_one(struc
  out_iounmap:
        iounmap(brd->re_map_membase);
  out_kfree_brd:
+       jsm_boards[brd->boardnum] = NULL;
        kfree(brd);
  out_release_regions:
        pci_release_regions(pdev);
@@ -203,6 +207,7 @@ static void __devexit jsm_remove_one(str
        pci_release_regions(pdev);
        pci_disable_device(pdev);
        kfree(brd->flipbuf);
+       jsm_boards[brd->boardnum] = NULL;
        kfree(brd);
 }

diff -urNp a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c      2009-05-12 17:28:51.849172254 +0400
+++ b/drivers/serial/jsm/jsm_tty.c      2009-05-12 17:59:49.287494614 +0400
@@ -432,8 +432,9 @@ int __devinit jsm_tty_init(struct jsm_bo

 int __devinit jsm_uart_port_init(struct jsm_board *brd)
 {
-       int i;
+       int i, j;
        struct jsm_channel *ch;
+       u32 jsm_ports = 0;

        if (!brd)
                return -ENXIO;
@@ -446,6 +447,10 @@ int __devinit jsm_uart_port_init(struct

        brd->nasync = brd->maxports;

+       for (j = 0; j < brd->boardnum; j++)
+               if (jsm_boards[j])
+                       jsm_ports += jsm_boards[j]->maxports;
+
        /* Set up channel variables */
        for (i = 0; i < brd->nasync; i++, ch = brd->channels[i]) {

@@ -459,7 +464,7 @@ int __devinit jsm_uart_port_init(struct
                brd->channels[i]->uart_port.membase = brd->re_map_membase;
                brd->channels[i]->uart_port.fifosize = 16;
                brd->channels[i]->uart_port.ops = &jsm_ops;
-               brd->channels[i]->uart_port.line =
brd->channels[i]->ch_portnum + brd->boardnum * 2;
+               brd->channels[i]->uart_port.line =
brd->channels[i]->ch_portnum + jsm_ports;
                if (uart_add_one_port (&jsm_uart_driver,
&brd->channels[i]->uart_port))
                        printk(KERN_INFO "Added device failed\n");
