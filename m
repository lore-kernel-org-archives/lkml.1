Return-Path: <linux-kernel-owner+w=401wt.eu-S965860AbXHGVUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbXHGVUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXHGU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59786 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935683AbXHGUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:55:49 -0400
Date: Tue, 7 Aug 2007 13:48:15 -0700
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
       Stelian Pop <stelian@popies.net>, Len Brown <lenb@kernel.org>,
       Andrei Paskevich <andrei@capet.iut-fbleau.fr>,
       Mattia Dongili <malattia@linux.it>
Subject: [2.6.22.2 review 63/84] sony-laptop: fix bug in event handling
Message-ID: <20070807204815.GM23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sony-laptop-fix-bug-in-event-handling.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattia Dongili <malattia@linux.it>

The rewritten event reading code from sonypi was absolutely wrong,
this patche makes things functional for type2 and type1 models.

Cc: Andrei Paskevich <andrei@capet.iut-fbleau.fr>
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sony-laptop.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -908,7 +908,9 @@ static struct acpi_driver sony_nc_driver
 #define SONYPI_DEVICE_TYPE2	0x00000002
 #define SONYPI_DEVICE_TYPE3	0x00000004
 
-#define SONY_PIC_EV_MASK	0xff
+#define SONYPI_TYPE1_OFFSET	0x04
+#define SONYPI_TYPE2_OFFSET	0x12
+#define SONYPI_TYPE3_OFFSET	0x12
 
 struct sony_pic_ioport {
 	struct acpi_resource_io	io;
@@ -922,6 +924,7 @@ struct sony_pic_irq {
 
 struct sony_pic_dev {
 	int			model;
+	u16			evport_offset;
 	u8			camera_power;
 	u8			bluetooth_power;
 	u8			wwan_power;
@@ -1998,20 +2001,17 @@ end:
 static irqreturn_t sony_pic_irq(int irq, void *dev_id)
 {
 	int i, j;
-	u32 port_val = 0;
 	u8 ev = 0;
 	u8 data_mask = 0;
 	u8 device_event = 0;
 
 	struct sony_pic_dev *dev = (struct sony_pic_dev *) dev_id;
 
-	acpi_os_read_port(dev->cur_ioport->io.minimum, &port_val,
-			dev->cur_ioport->io.address_length);
-	ev = port_val & SONY_PIC_EV_MASK;
-	data_mask = 0xff & (port_val >> (dev->cur_ioport->io.address_length - 8));
+	ev = inb_p(dev->cur_ioport->io.minimum);
+	data_mask = inb_p(dev->cur_ioport->io.minimum + dev->evport_offset);
 
-	dprintk("event (0x%.8x [%.2x] [%.2x]) at port 0x%.4x\n",
-			port_val, ev, data_mask, dev->cur_ioport->io.minimum);
+	dprintk("event ([%.2x] [%.2x]) at port 0x%.4x(+0x%.2x)\n",
+			ev, data_mask, dev->cur_ioport->io.minimum, dev->evport_offset);
 
 	if (ev == 0x00 || ev == 0xff)
 		return IRQ_HANDLED;
@@ -2102,6 +2102,20 @@ static int sony_pic_add(struct acpi_devi
 	spic_dev.model = sony_pic_detect_device_type();
 	mutex_init(&spic_dev.lock);
 
+	/* model specific characteristics */
+	switch(spic_dev.model) {
+		case SONYPI_DEVICE_TYPE1:
+			spic_dev.evport_offset = SONYPI_TYPE1_OFFSET;
+			break;
+		case SONYPI_DEVICE_TYPE3:
+			spic_dev.evport_offset = SONYPI_TYPE3_OFFSET;
+			break;
+		case SONYPI_DEVICE_TYPE2:
+		default:
+			spic_dev.evport_offset = SONYPI_TYPE2_OFFSET;
+			break;
+	}
+
 	/* read _PRS resources */
 	result = sony_pic_possible_resources(device);
 	if (result) {

-- 
