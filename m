Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbXJSUKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbXJSUKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXJSUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:10:47 -0400
Received: from lixom.net ([66.141.50.11]:43657 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbXJSUKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:10:46 -0400
Date: Fri, 19 Oct 2007 15:17:20 -0500
From: Olof Johansson <olof@lixom.net>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] pcmcia: Convert io_req_t to use unsigned int
Message-ID: <20071019201720.GA13234@lixom.net>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org> <20070921221516.GA7926@lixom.net> <20070921233936.2aeb2504@the-village.bc.nu> <20070922062551.GE10625@parisc-linux.org> <20070922091303.GA12525@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922091303.GA12525@lst.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PCMCIA] Convert some internal-only ioaddr_t to unsigned int

Convert the io_req_t members to unsigned int, to allow use on machines
with more than 16 bits worth of IO ports (i.e. secondary busses on
ppc64, etc).

There was only a couple of places in drivers where a change was needed. I
left printk formats alone (there are lots of %04x-style formats in there),
mostly to not change the format on the platforms that only have 16-bit
io addresses, but also because the padding doesn't really add all that
much value most of the time.

I found only one sprintf of an address, and upsized the string accordingly
(I doubt anyone will have anywhere near INT_MAX as irq value, but at
least there's room for it now).

Signed-off-by: Olof Johansson <olof@lixom.net>

---

On Sat, Sep 22, 2007 at 11:13:03AM +0200, Christoph Hellwig wrote:
> On Sat, Sep 22, 2007 at 12:25:51AM -0600, Matthew Wilcox wrote:
> > > What about the formatting and field widths ?
> > > 
> > > ulong would probably be a lot saner than kio_addr_t and yet more type
> > > obfuscation.
> > 
> > I don't think anyone uses ioports > 32bit.  Certainly i386 takes an int
> > port as parameter to {in,out}[bwl] (and it really only uses 16-bits).
> > parisc uses 24 bits.  I don't know what the various ppcs do, but pci
> > bars can only be 32-bit for ioports.  So my opinion is that ioports
> > should be uint, not ulong.
> 
> The kernel seems to mostly use int, sometimes uint.  I never quite got
> why pcmcia had to have it's own strange typedef for them.

Ok, so let's switch to unsigned int. Only exception I made was to stick
to u_int in the struct itself to keep it common with the style in the
rest of it.

This also resulted in a much smaller diff, since I didn't have to change
any printk formats (see above about 0-padding).


-Olof


Index: k.org/drivers/char/pcmcia/cm4000_cs.c
===================================================================
--- k.org.orig/drivers/char/pcmcia/cm4000_cs.c
+++ k.org/drivers/char/pcmcia/cm4000_cs.c
@@ -308,7 +308,7 @@ static unsigned int calc_baudv(unsigned 
 	return (wcrcf / wbrcf);
 }
 
-static unsigned short io_read_num_rec_bytes(ioaddr_t iobase, unsigned short *s)
+static unsigned short io_read_num_rec_bytes(unsigned int iobase, unsigned short *s)
 {
 	unsigned short tmp;
 
@@ -426,7 +426,7 @@ static struct card_fixup card_fixups[] =
 static void set_cardparameter(struct cm4000_dev *dev)
 {
 	int i;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	u_int8_t stopbits = 0x02; /* ISO default */
 
 	DEBUGP(3, dev, "-> set_cardparameter\n");
@@ -459,7 +459,7 @@ static int set_protocol(struct cm4000_de
 	unsigned short num_bytes_read;
 	unsigned char pts_reply[4];
 	ssize_t rc;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 
 	rc = 0;
 
@@ -610,7 +610,7 @@ exit_setprotocol:
 	return rc;
 }
 
-static int io_detect_cm4000(ioaddr_t iobase, struct cm4000_dev *dev)
+static int io_detect_cm4000(unsigned int iobase, struct cm4000_dev *dev)
 {
 
 	/* note: statemachine is assumed to be reset */
@@ -671,7 +671,7 @@ static void terminate_monitor(struct cm4
 static void monitor_card(unsigned long p)
 {
 	struct cm4000_dev *dev = (struct cm4000_dev *) p;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	unsigned short s;
 	struct ptsreq ptsreq;
 	int i, atrc;
@@ -933,7 +933,7 @@ static ssize_t cmm_read(struct file *fil
 			loff_t *ppos)
 {
 	struct cm4000_dev *dev = filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	ssize_t rc;
 	int i, j, k;
 
@@ -1054,7 +1054,7 @@ static ssize_t cmm_write(struct file *fi
 			 size_t count, loff_t *ppos)
 {
 	struct cm4000_dev *dev = (struct cm4000_dev *) filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	unsigned short s;
 	unsigned char tmp;
 	unsigned char infolen;
@@ -1408,7 +1408,7 @@ static int cmm_ioctl(struct inode *inode
 		     unsigned long arg)
 {
 	struct cm4000_dev *dev = filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	unsigned int iobase = dev->p_dev->io.BasePort1;
 	struct pcmcia_device *link;
 	int size;
 	int rc;
Index: k.org/drivers/pcmcia/pcmcia_resource.c
===================================================================
--- k.org.orig/drivers/pcmcia/pcmcia_resource.c
+++ k.org/drivers/pcmcia/pcmcia_resource.c
@@ -65,23 +65,23 @@ extern int ds_pc_debug;
  * Special stuff for managing IO windows, because they are scarce
  */
 
-static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
-			  ioaddr_t num, u_int lines)
+static int alloc_io_space(struct pcmcia_socket *s, u_int attr,
+			  unsigned int *base, unsigned int num, u_int lines)
 {
 	int i;
-	kio_addr_t try, align;
+	unsigned int try, align;
 
 	align = (*base) ? (lines ? 1<<lines : 0) : 1;
 	if (align && (align < num)) {
 		if (*base) {
-			ds_dbg(s, 0, "odd IO request: num %#x align %#lx\n",
+			ds_dbg(s, 0, "odd IO request: num %#x align %#x\n",
 			       num, align);
 			align = 0;
 		} else
 			while (align && (align < num)) align <<= 1;
 	}
 	if (*base & ~(align-1)) {
-		ds_dbg(s, 0, "odd IO request: base %#x align %#lx\n",
+		ds_dbg(s, 0, "odd IO request: base %#x align %#x\n",
 		       *base, align);
 		align = 0;
 	}
@@ -132,8 +132,8 @@ static int alloc_io_space(struct pcmcia_
 } /* alloc_io_space */
 
 
-static void release_io_space(struct pcmcia_socket *s, ioaddr_t base,
-			     ioaddr_t num)
+static void release_io_space(struct pcmcia_socket *s, unsigned int base,
+			     unsigned int num)
 {
 	int i;
 
Index: k.org/include/pcmcia/cs.h
===================================================================
--- k.org.orig/include/pcmcia/cs.h
+++ k.org/include/pcmcia/cs.h
@@ -147,11 +147,11 @@ typedef struct config_req_t {
 
 /* For RequestIO and ReleaseIO */
 typedef struct io_req_t {
-    ioaddr_t	BasePort1;
-    ioaddr_t	NumPorts1;
+    u_int	BasePort1;
+    u_int	NumPorts1;
     u_int	Attributes1;
-    ioaddr_t	BasePort2;
-    ioaddr_t	NumPorts2;
+    u_int	BasePort2;
+    u_int	NumPorts2;
     u_int	Attributes2;
     u_int	IOAddrLines;
 } io_req_t;
Index: k.org/drivers/scsi/pcmcia/fdomain_stub.c
===================================================================
--- k.org.orig/drivers/scsi/pcmcia/fdomain_stub.c
+++ k.org/drivers/scsi/pcmcia/fdomain_stub.c
@@ -130,7 +130,7 @@ static int fdomain_config(struct pcmcia_
     cisparse_t parse;
     int i, last_ret, last_fn;
     u_char tuple_data[64];
-    char str[16];
+    char str[22];
     struct Scsi_Host *host;
 
     DEBUG(0, "fdomain_config(0x%p)\n", link);
