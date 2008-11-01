Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYKAKqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYKAKqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYKAKqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:46:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:28035 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYKAKqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:46:05 -0400
Subject: pcmcia: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 11:46:06 +0100
Message-Id: <1225536366.13224.2.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index c68c5d3..5d0e60e 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -226,7 +226,7 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 	/* set proper values in socket->dev */
 	dev_set_drvdata(&socket->dev, socket);
 	socket->dev.class = &pcmcia_socket_class;
-	snprintf(socket->dev.bus_id, BUS_ID_SIZE, "pcmcia_socket%u", socket->sock);
+	dev_set_name(&socket->dev, "pcmcia_socket%u", socket->sock);
 
 	/* base address = 0, map = 0 */
 	socket->cis_mem.flags = 0;
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 7956602..7cff346 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -622,7 +622,6 @@ struct pcmcia_device * pcmcia_device_add(struct pcmcia_socket *s, unsigned int f
 {
 	struct pcmcia_device *p_dev, *tmp_dev;
 	unsigned long flags;
-	int bus_id_len;
 
 	s = pcmcia_get_socket(s);
 	if (!s)
@@ -650,12 +649,12 @@ struct pcmcia_device * pcmcia_device_add(struct pcmcia_socket *s, unsigned int f
 	/* by default don't allow DMA */
 	p_dev->dma_mask = DMA_MASK_NONE;
 	p_dev->dev.dma_mask = &p_dev->dma_mask;
-	bus_id_len = sprintf (p_dev->dev.bus_id, "%d.%d", p_dev->socket->sock, p_dev->device_no);
-
-	p_dev->devname = kmalloc(6 + bus_id_len + 1, GFP_KERNEL);
+	dev_set_name(&p_dev->dev, "%d.%d", p_dev->socket->sock, p_dev->device_no);
+	if (!dev_name(&p_dev->dev))
+		goto err_free;
+	p_dev->devname = kasprintf(GFP_KERNEL, "pcmcia%s", dev_name(&p_dev->dev));
 	if (!p_dev->devname)
 		goto err_free;
-	sprintf (p_dev->devname, "pcmcia%s", p_dev->dev.bus_id);
 	ds_dev_dbg(3, &p_dev->dev, "devname is %s\n", p_dev->devname);
 
 	spin_lock_irqsave(&pcmcia_dev_list_lock, flags);
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 17f4ecf..9ca22c7 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -71,7 +71,7 @@ static DEFINE_MUTEX(rsrc_mutex);
 ======================================================================*/
 
 static struct resource *
-make_resource(resource_size_t b, resource_size_t n, int flags, char *name)
+make_resource(resource_size_t b, resource_size_t n, int flags, const char *name)
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
@@ -624,7 +624,7 @@ static int nonstatic_adjust_io_region(struct resource *res, unsigned long r_star
 static struct resource *nonstatic_find_io_region(unsigned long base, int num,
 		   unsigned long align, struct pcmcia_socket *s)
 {
-	struct resource *res = make_resource(0, num, IORESOURCE_IO, s->dev.bus_id);
+	struct resource *res = make_resource(0, num, IORESOURCE_IO, dev_name(&s->dev));
 	struct socket_data *s_data = s->resource_data;
 	struct pcmcia_align_data data;
 	unsigned long min = base;
@@ -658,7 +658,7 @@ static struct resource *nonstatic_find_io_region(unsigned long base, int num,
 static struct resource * nonstatic_find_mem_region(u_long base, u_long num,
 		u_long align, int low, struct pcmcia_socket *s)
 {
-	struct resource *res = make_resource(0, num, IORESOURCE_MEM, s->dev.bus_id);
+	struct resource *res = make_resource(0, num, IORESOURCE_MEM, dev_name(&s->dev));
 	struct socket_data *s_data = s->resource_data;
 	struct pcmcia_align_data data;
 	unsigned long min, max;


