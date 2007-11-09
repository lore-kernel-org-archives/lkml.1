Return-Path: <linux-kernel-owner+w=401wt.eu-S1764609AbXKIXsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764609AbXKIXsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbXKIXsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:48:15 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57239 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbXKIXsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:48:14 -0500
Message-id: <15624318902788326176.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 8/13] Char: nozomi, tty cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:48:14 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, tty cleanup

- init and deinit tty driver at module load/unload. When the OS (user)
  loads the driver the hardware usually is ready to driver.
- merge (unify) MAX_PORT, NTTY_TTY_MINORS into NOZOMI_MAX_PORTS
- remove struct nozomi_devices, it was used only as list entries

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d0b01ce89a7b18ba37ea6192eea6a98cdc01d62e
tree a61f0a99633772b863130ec1e8a2be25891b3578
parent 9f9d7197e901ea00771812b7e903b14b95f54e40
author Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:12:53 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:12:53 +0100

 drivers/char/nozomi.c |  336 ++++++++++++++++---------------------------------
 1 files changed, 112 insertions(+), 224 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 49e16c7..4a3ab38 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -172,9 +172,6 @@ static int debug;
 #define NOZOMI_NAME_TTY		"nozomi_tty"
 #define DRIVER_DESC		"Nozomi driver"
 
-#define NTTY_TTY_MAJOR		241
-#define NTTY_TTY_MINORS		MAX_PORT
-#define NTTY_TTY_MAXMINORS	256
 #define NTTY_FIFO_BUFFER_SIZE	8192
 
 /* Must be power of 2 */
@@ -225,8 +222,9 @@ static int debug;
 #define CTRL_DTR	0x0001
 #define CTRL_RTS	0x0002
 
-#define MAX_PORT		4
-#define NOZOMI_MAX_PORTS	5
+#define NOZOMI_MAX_PORTS	4
+#define NOZOMI_MAX_CARDS	(256 / NOZOMI_MAX_PORTS)
+#define NOZOMI_MAX_MINORS	(NOZOMI_MAX_PORTS * NOZOMI_MAX_CARDS)
 
 /*    Type definitions */
 
@@ -430,10 +428,9 @@ struct nozomi {
 	struct port port[NOZOMI_MAX_PORTS];
 	u8 *send_buf;
 
-	struct tty_driver *tty_driver;
-
 	spinlock_t spin_mutex;	/* secures access to registers and tty */
 
+	unsigned int index_start;
 	u32 open_ttys;
 };
 
@@ -443,9 +440,6 @@ struct buffer {
 	u8 *data;
 } __attribute__ ((packed));
 
-/*    Function declarations */
-static int ntty_tty_init(struct nozomi *dc);
-
 /*    Global variables */
 static struct pci_device_id nozomi_pci_tbl[] = {
 	{PCI_DEVICE(VENDOR1, DEVICE1)},
@@ -454,80 +448,22 @@ static struct pci_device_id nozomi_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, nozomi_pci_tbl);
 
-/* Representing the pci device of interest */
-struct nozomi_devices {
-	struct list_head list;
-	struct nozomi *my_dev;
-	int index_start;
-};
-static atomic_t cards_found = ATOMIC_INIT(0);
-static LIST_HEAD(my_devices);
+static struct nozomi *ndevs[NOZOMI_MAX_CARDS];
+static struct tty_driver *ntty_driver;
 
 /*
  * find card by tty_index
  */
-static struct nozomi *get_dc_by_index(s32 index)
-{
-	struct list_head *p;
-	struct nozomi_devices *curdev;
-	int devidx;
-
-	if (likely(atomic_read(&cards_found) == 1)) {
-		curdev = list_first_entry(&my_devices,
-					struct nozomi_devices, list);
-		return curdev->my_dev;
-	} else {
-		devidx = index - (index % NTTY_TTY_MINORS);
 
-		list_for_each(p, &my_devices) {
-			curdev = list_entry(p, struct nozomi_devices, list);
-			if (curdev->index_start == devidx)
-				return curdev->my_dev;
-		}
-	}
-
-	printk(KERN_ALERT "Fatal error: could not find device" \
-		" for tty-index %d\n", index);
-
-	return NULL;
-}
-
-static struct port *get_port_by_tty(const struct tty_struct *tty)
+static inline struct nozomi *get_dc_by_tty(const struct tty_struct *tty)
 {
-	struct nozomi *ndev = get_dc_by_index(tty->index);
-	return ndev ? &ndev->port[tty->index % NTTY_TTY_MINORS] : NULL;
+	return ndevs[tty->index / NOZOMI_MAX_PORTS];
 }
 
-static struct nozomi *get_dc_by_tty(const struct tty_struct *tty)
+static inline struct port *get_port_by_tty(const struct tty_struct *tty)
 {
-	return get_dc_by_index(tty->index);
-}
-
-static int get_free_index(void)
-{
-	struct list_head *p;
-	struct nozomi_devices *curdev;
-	u8 busy;
-	int new_index;
-
-	for (new_index = 0; new_index < NTTY_TTY_MAXMINORS; new_index += 4) {
-		busy = 0;
-		list_for_each(p, &my_devices) {
-			curdev = list_entry(p, struct nozomi_devices, list);
-			if (curdev->index_start == new_index) {
-				++busy;
-				break;
-			}
-		}
-
-		if (!busy)
-			break;
-	}
-
-	if (new_index >= NTTY_TTY_MAXMINORS)
-		return -ENODEV;
-
-	return new_index;
+	struct nozomi *ndev = get_dc_by_tty(tty);
+	return ndev ? &ndev->port[tty->index % NOZOMI_MAX_PORTS] : NULL;
 }
 
 /*
@@ -822,7 +758,7 @@ static int nozomi_read_config_table(struct nozomi *dc)
 
 		dump_table(dc);
 
-		for (i = PORT_MDM; i < MAX_PORT; i++) {
+		for (i = PORT_MDM; i < NOZOMI_MAX_PORTS; i++) {
 			dc->port[i].fifo_ul =
 			    kfifo_alloc(FIFO_BUFFER_SIZE_UL, GFP_ATOMIC, NULL);
 			memset(&dc->port[i].ctrl_dl, 0, sizeof(struct ctrl_dl));
@@ -1234,7 +1170,7 @@ static int send_flow_control(struct nozomi *dc)
 	u32 i, more_flow_control_to_be_updated = 0;
 	u16 *ctrl;
 
-	for (i = PORT_MDM; i < MAX_PORT; i++) {
+	for (i = PORT_MDM; i < NOZOMI_MAX_PORTS; i++) {
 		if (dc->port[i].update_flow_control) {
 			if (more_flow_control_to_be_updated) {
 				/* We have more flow control to be updated */
@@ -1353,15 +1289,9 @@ static int handle_data_ul(struct nozomi *dc, enum port_type port, u16 read_iir)
 
 static irqreturn_t interrupt_handler(int irq, void *dev_id)
 {
-	struct nozomi_devices *ndev = dev_id;
-	struct nozomi *dc;
+	struct nozomi *dc = dev_id;
 	u16 read_iir;
 
-	if (!ndev)
-		return IRQ_NONE;
-
-	dc = ndev->my_dev;
-
 	spin_lock(&dc->spin_mutex);
 	read_iir = readw(dc->reg_iir);
 
@@ -1503,27 +1433,25 @@ static void nozomi_setup_private_data(struct nozomi *dc)
 	dc->port[PORT_APP1].token_dl = APP1_DL;
 	dc->port[PORT_APP2].token_dl = APP2_DL;
 
-	for (i = 0; i < MAX_PORT; i++)
+	for (i = 0; i < NOZOMI_MAX_PORTS; i++)
 		init_waitqueue_head(&dc->port[i].tty_wait);
 }
 
 static ssize_t card_type_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct nozomi_devices *deventry = pci_get_drvdata(pdev);
+	struct nozomi *dc = pci_get_drvdata(to_pci_dev(dev));
 
-	return sprintf(buf, "%d\n", deventry->my_dev->card_type);
+	return sprintf(buf, "%d\n", dc->card_type);
 }
 static DEVICE_ATTR(card_type, 0444, card_type_show, NULL);
 
 static ssize_t open_ttys_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct nozomi_devices *deventry = pci_get_drvdata(pdev);
+	struct nozomi *dc = pci_get_drvdata(to_pci_dev(dev));
 
-	return sprintf(buf, "%u\n", deventry->my_dev->open_ttys);
+	return sprintf(buf, "%u\n", dc->open_ttys);
 }
 static DEVICE_ATTR(open_ttys, 0444, open_ttys_show, NULL);
 
@@ -1548,35 +1476,36 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 				      const struct pci_device_id *ent)
 {
 	resource_size_t start;
-	int ret = -ENOMEM;
 	struct nozomi *dc = NULL;
-	struct nozomi_devices *newdev = NULL;
-	struct nozomi_devices *first = NULL;
-	int new_index;
-	int i;
+	unsigned int i, ndev_idx;
+	int ret;
 
-	atomic_inc(&cards_found);
-	dev_dbg(&pdev->dev, "Init, cards_found: %d\n",
-		atomic_read(&cards_found));
+	dev_dbg(&pdev->dev, "Init\n");
+
+	for (ndev_idx = 0; ndev_idx < ARRAY_SIZE(ndevs); ndev_idx++)
+		if (!ndevs[ndev_idx])
+			break;
+
+	if (ndev_idx >= ARRAY_SIZE(ndevs)) {
+		dev_err(&pdev->dev, "no free tty range for this card\n");
+		ret = -EIO;
+		goto err;
+	}
 
 	dc = kzalloc(sizeof(struct nozomi), GFP_KERNEL);
 	if (unlikely(!dc)) {
 		dev_err(&pdev->dev, "Could not allocate memory\n");
-		goto err_free;
-	}
-	newdev = kzalloc(sizeof(struct nozomi_devices), GFP_KERNEL);
-	if (unlikely(!newdev)) {
-		dev_err(&pdev->dev, "Could not allocate memory\n");
+		ret = -ENOMEM;
 		goto err_free;
 	}
 
 	dc->pdev = pdev;
-	newdev->my_dev = dc;
 
 	/* Find out what card type it is */
 	nozomi_get_card_type(dc);
 
-	if (pci_enable_device(dc->pdev)) {
+	ret = pci_enable_device(dc->pdev);
+	if (ret) {
 		dev_err(&pdev->dev, "Failed to enable PCI Device\n");
 		goto err_free;
 	}
@@ -1618,7 +1547,7 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	writew(dc->last_ier, dc->reg_ier);
 
 	ret = request_irq(pdev->irq, &interrupt_handler, IRQF_SHARED,
-			NOZOMI_NAME, newdev);
+			NOZOMI_NAME, dc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "can't request irq\n");
 		goto err_free_sbuf;
@@ -1626,53 +1555,26 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 
 	DBG1("base_addr: %p", dc->base_addr);
 
-	new_index = get_free_index();
-	if (new_index < 0) {
-		dev_err(&pdev->dev, "already reached maximum card count.\n");
-		ret = -EIO;
-		goto err_free_irq;
-	}
-
 	make_sysfs_files(dc);
 
-	if (atomic_read(&cards_found) == 1) {
-		ret = ntty_tty_init(dc);
-		if (ret) {
-			dev_err(&pdev->dev, "can't alloc ntty\n");
-			goto err_sysfs;
-		}
-	} else {
-		first = list_first_entry(&my_devices, struct nozomi_devices,
-									list);
-		dc->tty_driver = first->my_dev->tty_driver;
-	}
-
-	for (i = 0; i < NTTY_TTY_MINORS; i++) {
+	dc->index_start = ndev_idx * NOZOMI_MAX_PORTS;
+	ndevs[ndev_idx] = dc;
+	for (i = 0; i < NOZOMI_MAX_PORTS; i++) {
 		init_MUTEX(&dc->port[i].tty_sem);
 		dc->port[i].tty_open_count = 0;
 		dc->port[i].tty = NULL;
-		tty_register_device(dc->tty_driver, new_index + i,
-							&dc->pdev->dev);
+		tty_register_device(ntty_driver, dc->index_start + i,
+							&pdev->dev);
 	}
-	newdev->index_start = new_index;
 
 	/* Enable  RESET interrupt. */
 	dc->last_ier = RESET;
 	writew(dc->last_ier, dc->reg_ier);
 
-	list_add_tail(&newdev->list, &my_devices);
-
-	pci_set_drvdata(pdev, newdev);
+	pci_set_drvdata(pdev, dc);
 
 	return 0;
 
-err_sysfs:
-	remove_sysfs_files(dc);
-err_free_irq:
-	free_irq(pdev->irq, newdev);
-	for (i = PORT_MDM; i < MAX_PORT; i++)	/* allocated in isr, might be */
-		if (dc->port[i].fifo_ul)	/* filled yet */
-			kfifo_free(dc->port[i].fifo_ul);
 err_free_sbuf:
 	kfree(dc->send_buf);
 	iounmap(dc->base_addr);
@@ -1682,40 +1584,25 @@ err_disable_device:
 	pci_disable_device(pdev);
 err_free:
 	kfree(dc);
-	kfree(newdev);
-	atomic_dec(&cards_found);
+err:
 	return ret;
 }
 
-static void __devexit tty_exit(struct nozomi_devices *ndev)
+static void __devexit tty_exit(struct nozomi *dc)
 {
-	struct nozomi *dc = ndev->my_dev;
-	int i, ret;
+	unsigned int i;
 
 	DBG1(" ");
 
-	flush_scheduled_work();
-
-	for (i = 0; i < NTTY_TTY_MINORS; ++i)
-		if (dc->port[i].tty && \
-				list_empty(&dc->port[i].tty->hangup_work.entry))
+	for (i = 0; i < NOZOMI_MAX_PORTS; i++)
+		if (dc->port[i].tty)
 			tty_hangup(dc->port[i].tty);
 
 	while (dc->open_ttys)
 		msleep(1);
 
-	for (i = ndev->index_start; i < ndev->index_start + NTTY_TTY_MINORS; \
-									++i)
-		tty_unregister_device(dc->tty_driver, i);
-
-	/* only unregister ttydriver if its the last card available */
-	if (atomic_read(&cards_found) == 1) {
-		ret = tty_unregister_driver(dc->tty_driver);
-		if (ret)
-			printk(KERN_ERR "Unable to unregister the tty driver !"
-							" (%d)\n", ret);
-		put_tty_driver(dc->tty_driver);
-	}
+	for (i = dc->index_start; i < dc->index_start + NOZOMI_MAX_PORTS; ++i)
+ 		tty_unregister_device(ntty_driver, i);
 }
 
 /* Deallocate memory for one device */
@@ -1723,14 +1610,13 @@ static void __devexit nozomi_card_exit(struct pci_dev *pdev)
 {
 	int i;
 	struct ctrl_ul ctrl;
-	struct nozomi_devices *deventry = pci_get_drvdata(pdev);
-	struct nozomi *dc = deventry->my_dev;
+	struct nozomi *dc = pci_get_drvdata(pdev);
 
 	/* Disable all interrupts */
 	dc->last_ier = 0;
 	writew(dc->last_ier, dc->reg_ier);
 
-	tty_exit(deventry);
+	tty_exit(dc);
 
 	/* Send 0x0001, command card to resend the reset token.  */
 	/* This is to get the reset when the module is reloaded. */
@@ -1744,13 +1630,11 @@ static void __devexit nozomi_card_exit(struct pci_dev *pdev)
 	write_mem32(dc->port[PORT_CTRL].ul_addr[0], (u32 *)&ctrl, 2);
 	writew(CTRL_UL, dc->reg_fcr);	/* push the token to the card. */
 
-	list_del(&deventry->list);
-
 	remove_sysfs_files(dc);
 
-	free_irq(pdev->irq, deventry);
+	free_irq(pdev->irq, dc);
 
-	for (i = PORT_MDM; i < MAX_PORT; i++)
+	for (i = 0; i < NOZOMI_MAX_PORTS; i++)
 		if (dc->port[i].fifo_ul)
 			kfifo_free(dc->port[i].fifo_ul);
 
@@ -1762,32 +1646,29 @@ static void __devexit nozomi_card_exit(struct pci_dev *pdev)
 
 	pci_disable_device(pdev);
 
-	kfree(dc);
-	kfree(deventry);
+	ndevs[dc->index_start / NOZOMI_MAX_PORTS] = NULL;
 
-	atomic_dec(&cards_found);
+	kfree(dc);
 }
 
-static void set_rts(int index, int rts)
+static void set_rts(struct tty_struct *tty, int rts)
 {
-	struct nozomi *dc = get_dc_by_index(index);
-	struct port *port = &dc->port[index % MAX_PORT];
+	struct port *port = get_port_by_tty(tty);
 
 	port->ctrl_ul.RTS = rts;
 	port->update_flow_control = 1;
-	enable_transmit_ul(PORT_CTRL, dc);
+	enable_transmit_ul(PORT_CTRL, get_dc_by_tty(tty));
 }
 
-static void set_dtr(int index, int dtr)
+static void set_dtr(struct tty_struct *tty, int dtr)
 {
-	struct nozomi *dc = get_dc_by_index(index);
-	struct port *port = &dc->port[index % MAX_PORT];
+	struct port *port = get_port_by_tty(tty);
 
-	DBG1("SETTING DTR index: %d, dtr: %d", index, dtr);
+	DBG1("SETTING DTR index: %d, dtr: %d", tty->index, dtr);
 
 	port->ctrl_ul.DTR = dtr;
 	port->update_flow_control = 1;
-	enable_transmit_ul(PORT_CTRL, dc);
+	enable_transmit_ul(PORT_CTRL, get_dc_by_tty(tty));
 }
 
 /*
@@ -1906,13 +1787,13 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	if (port == &(dc->port[PORT_MDM])) {
 		if (port->ctrl_dl.CTS) {
 			DBG4("Enable interrupt");
-			enable_transmit_ul(tty->index % MAX_PORT, dc);
+			enable_transmit_ul(tty->index % NOZOMI_MAX_PORTS, dc);
 		} else {
 			dev_err(&dc->pdev->dev,
 				"CTS not active on modem port?\n");
 		}
 	} else {
-		enable_transmit_ul(tty->index % MAX_PORT, dc);
+		enable_transmit_ul(tty->index % NOZOMI_MAX_PORTS, dc);
 	}
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 
@@ -1968,14 +1849,14 @@ static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear)
 {
 	if (set & TIOCM_RTS)
-		set_rts(tty->index, 1);
+		set_rts(tty, 1);
 	else if (clear & TIOCM_RTS)
-		set_rts(tty->index, 0);
+		set_rts(tty, 0);
 
 	if (set & TIOCM_DTR)
-		set_dtr(tty->index, 1);
+		set_dtr(tty, 1);
 	else if (clear & TIOCM_DTR)
-		set_dtr(tty->index, 0);
+		set_dtr(tty, 0);
 
 	return 0;
 }
@@ -2054,8 +1935,8 @@ static void ntty_unthrottle(struct tty_struct *tty)
 
 	DBG1("UNTHROTTLE");
 	spin_lock_irqsave(&dc->spin_mutex, flags);
-	enable_transmit_dl(tty->index % MAX_PORT, dc);
-	set_rts(tty->index, 1);
+	enable_transmit_dl(tty->index % NOZOMI_MAX_PORTS, dc);
+	set_rts(tty, 1);
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 }
 
@@ -2070,7 +1951,7 @@ static void ntty_throttle(struct tty_struct *tty)
 
 	DBG1("THROTTLE");
 	spin_lock_irqsave(&dc->spin_mutex, flags);
-	set_rts(tty->index, 0);
+	set_rts(tty, 0);
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 }
 
@@ -2119,39 +2000,6 @@ static struct tty_operations tty_ops = {
 	.tiocmset = ntty_tiocmset,
 };
 
-/* Initializes the tty */
-static int ntty_tty_init(struct nozomi *dc)
-{
-	struct tty_driver *td;
-	int rval;
-
-	dc->tty_driver = alloc_tty_driver(NTTY_TTY_MAXMINORS);
-	if (!dc->tty_driver)
-		return -ENOMEM;
-	td = dc->tty_driver;
-	td->owner = THIS_MODULE;
-	td->driver_name = NOZOMI_NAME_TTY;
-	td->name = "noz";
-	td->major = NTTY_TTY_MAJOR;
-	td->type = TTY_DRIVER_TYPE_SERIAL;
-	td->subtype = SERIAL_TYPE_NORMAL;
-	td->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
-	td->init_termios = tty_std_termios;
-	td->init_termios.c_cflag = B115200 | CS8 | CREAD | HUPCL | CLOCAL;
-	td->init_termios.c_ispeed = 115200;
-	td->init_termios.c_ospeed = 115200;
-	tty_set_operations(dc->tty_driver, &tty_ops);
-
-	rval = tty_register_driver(td);
-	if (rval) {
-		dev_err(&dc->pdev->dev, "failed to register ntty tty driver\n");
-		return rval;
-	}
-
-	dev_info(&dc->pdev->dev, DRIVER_DESC " " NOZOMI_NAME_TTY "\n");
-	return rval;
-}
-
 /* Module initialization */
 static struct pci_driver nozomi_driver = {
 	.name = NOZOMI_NAME,
@@ -2162,14 +2010,54 @@ static struct pci_driver nozomi_driver = {
 
 static __init int nozomi_init(void)
 {
+	int ret;
+
 	printk(KERN_INFO "Initializing %s\n", VERSION_STRING);
-	return pci_register_driver(&nozomi_driver);
+
+	ntty_driver = alloc_tty_driver(NOZOMI_MAX_MINORS);
+	if (!ntty_driver)
+		return -ENOMEM;
+
+	ntty_driver->owner = THIS_MODULE;
+	ntty_driver->driver_name = NOZOMI_NAME_TTY;
+	ntty_driver->name = "noz";
+	ntty_driver->major = 0;
+	ntty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	ntty_driver->subtype = SERIAL_TYPE_NORMAL;
+	ntty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	ntty_driver->init_termios = tty_std_termios;
+	ntty_driver->init_termios.c_cflag = B115200 | CS8 | CREAD | HUPCL |
+		CLOCAL;
+	ntty_driver->init_termios.c_ispeed = 115200;
+	ntty_driver->init_termios.c_ospeed = 115200;
+	tty_set_operations(ntty_driver, &tty_ops);
+
+	ret = tty_register_driver(ntty_driver);
+	if (ret) {
+		printk(KERN_ERR "Nozomi: failed to register ntty driver\n");
+		goto free_tty;
+	}
+
+	ret = pci_register_driver(&nozomi_driver);
+	if (ret) {
+		printk(KERN_ERR "Nozomi: can't register pci driver\n");
+		goto unr_tty;
+	}
+
+	return 0;
+unr_tty:
+	tty_unregister_driver(ntty_driver);
+free_tty:
+	put_tty_driver(ntty_driver);
+	return ret;
 }
 
 static __exit void nozomi_exit(void)
 {
 	printk(KERN_INFO "Unloading %s\n", DRIVER_DESC);
 	pci_unregister_driver(&nozomi_driver);
+	tty_unregister_driver(ntty_driver);
+	put_tty_driver(ntty_driver);
 }
 
 module_init(nozomi_init);
