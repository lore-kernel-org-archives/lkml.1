Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYJNUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYJNUOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYJNUN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:13:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57490
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbYJNUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:13:56 -0400
Date: Tue, 14 Oct 2008 13:13:31 -0700 (PDT)
Message-Id: <20081014.131331.115267742.davem@davemloft.net>
To: khali@linux-fr.org
Cc: torvalds@linux-foundation.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] i2c updates for 2.6.28, round 1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081014215137.2d039afb@hyperion.delvare>
References: <20081014180333.55d9004a@hyperion.delvare>
	<20081014.114609.74110219.davem@davemloft.net>
	<20081014215137.2d039afb@hyperion.delvare>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Tue_Oct_14_13_13_31_2008_425)--"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Jean Delvare <khali@linux-fr.org>
Date: Tue, 14 Oct 2008 21:51:37 +0200

> Except for one i2c-i801 patch which depends on a pci_ids update, all I
> have in my queue was part of this pull request. So, no, I don't have
> your bus addressing nor sparc I2C driver bits. Honestly, I can't even
> remember getting such patches from you. Do you have some reference I
> can search for? If not, please send the patches to the i2c list again.

Here are URLs to the I2C list patch postings I made, you were CC:'d on
every single one of them:

http://lists.lm-sensors.org/pipermail/i2c/2008-August/004714.html
http://lists.lm-sensors.org/pipermail/i2c/2008-August/004716.html
http://lists.lm-sensors.org/pipermail/i2c/2008-August/004717.html
http://lists.lm-sensors.org/pipermail/i2c/2008-August/004713.html
http://lists.lm-sensors.org/pipermail/i2c/2008-August/004715.html
http://lists.lm-sensors.org/pipermail/i2c/2008-August/004719.html
http://lists.lm-sensors.org/pipermail/i2c/2008-August/004718.html

And I include each posting here as an attachment as well.

Please apply.

----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="1.txt"

Date: Thu, 21 Aug 2008 02:43:13 -0700 (PDT)
Message-Id: <20080821.024313.48896997.davem@davemloft.net>
To: i2c@lm-sensors.org
CC: khali@linux-fr.org
Subject: [PATCH 0/6]: Infrastructure for Sparc PCF I2C support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This series of patches implements versious pieces of infrastructure that
I need for a pcf8584 based I2C bus driver I've written.  It uses the
PCF algo code and works quite well for the few I2C devices I've tested
so far.

Once I work out some details with the powerpc folks wrt. sparc support
for the drivers/of/of_i2c.c code, I can post the i2c-sunpcf.c driver
itself for inclusion.

The first patch fixes the PCF callbacks so that the ->waitforpin()
method can get at the bus driver private information.  The only other
user of the PCF algo layer is an ISA driver, i2c-elektor, which only
supports a single device so this interface limitation was not noticed.

The second patch addresses a synchronization issue that exists on
sparc64 systems with I2C busses.  Often the system firwmare shares the
I2C bus with the running kernel, in order to implement writes to the
EEPROM on the motherboard.  Thus, when firmware properties are set,
that call into the firmware can program the same I2C bus.  In my
Sun pcf8584 driver I will take a mutex which is also taken by the firmware
call in question, to ensure that two entities don't try to program the
I2C bus at the same time.  From PCF algo's perspective, these are just
two hooks called around the entirety of pcf_xfer().

The third patch is a simple type fix in a debugging message of PCF algo.

The fourth patch allows a PCF algo bus driver to request that support
for SMBUS quick support not be advertised.  This will disable automatic
probing sequences done by some I2C client drivers.  We absolutely do not
want this on sparc systems, where the openfirmware device tree tells us
exactly where all I2C bus devices are located.

The fifth patch adds "bus" addressing to the I2C layer.  Some variants
of the Sun pcf8584 controllers support an auxiliary register that
allows selecting a completely different I2C bus segment.  In the openfirmware
device tree, I2C client device addresses indicate which bus the device
is on.  I strove to implement this in the simplest way possible, with
full transparent backwards and forwards compatibility, for both I2C
userspace and existing drivers.

The sixth and final patch adds bus addressing support to the PCF algo
code.

Signed-off-by: David S. Miller <davem@davemloft.net>

----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="2.txt"

Date: Thu, 21 Aug 2008 02:43:19 -0700 (PDT)
Message-Id: <20080821.024319.22788780.davem@davemloft.net>
To: i2c@lm-sensors.org
CC: khali@linux-fr.org
Subject: [PATCH 1/6]: i2c-pcf: Pass adapter data into ->waitforpin() method.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


i2c-pcf: Pass adapter data into ->waitforpin() method.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
index 1e328d1..a8a5b6d 100644
--- a/drivers/i2c/algos/i2c-algo-pcf.c
+++ b/drivers/i2c/algos/i2c-algo-pcf.c
@@ -135,7 +135,7 @@ static int wait_for_pin(struct i2c_algo_pcf_data *adap, int *status) {
 	*status = get_pcf(adap, 1);
 #ifndef STUB_I2C
 	while (timeout-- && (*status & I2C_PCF_PIN)) {
-		adap->waitforpin();
+		adap->waitforpin(adap->data);
 		*status = get_pcf(adap, 1);
 	}
 	if (*status & I2C_PCF_LAB) {
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index 7f38c01..05f7d09 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -104,7 +104,7 @@ static int pcf_isa_getclock(void *data)
 	return (clock);
 }
 
-static void pcf_isa_waitforpin(void) {
+static void pcf_isa_waitforpin(void *data) {
 	DEFINE_WAIT(wait);
 	int timeout = 2;
 	unsigned long flags;
diff --git a/include/linux/i2c-algo-pcf.h b/include/linux/i2c-algo-pcf.h
index 0177d28..5de8a31 100644
--- a/include/linux/i2c-algo-pcf.h
+++ b/include/linux/i2c-algo-pcf.h
@@ -31,7 +31,7 @@ struct i2c_algo_pcf_data {
 	int  (*getpcf) (void *data, int ctl);
 	int  (*getown) (void *data);
 	int  (*getclock) (void *data);
-	void (*waitforpin) (void);
+	void (*waitforpin) (void *data);
 
 	/* Multi-master lost arbitration back-off delay (msecs)
 	 * This should be set by the bus adapter or knowledgable client
-- 
1.5.6.5.GIT


----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="3.txt"

Date: Thu, 21 Aug 2008 02:43:22 -0700 (PDT)
Message-Id: <20080821.024322.35962617.davem@davemloft.net>
To: i2c@lm-sensors.org
CC: khali@linux-fr.org
Subject: [PATCH 2/6]: i2c-pcf: Add adapter hooks around xfer begin and end.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


i2c-pcf: Add adapter hooks around xfer begin and end.

Some I2C bus implementations need to synchronize with external
entities, such as system firmware, which might also be programming the
same I2C bus.

In order to facilitate this add ->xfer_begin() and ->xfer_end() hooks
which are invoked around pcf_xfer().

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
index a8a5b6d..b57bc9a 100644
--- a/drivers/i2c/algos/i2c-algo-pcf.c
+++ b/drivers/i2c/algos/i2c-algo-pcf.c
@@ -331,13 +331,15 @@ static int pcf_xfer(struct i2c_adapter *i2c_adap,
 	int i;
 	int ret=0, timeout, status;
     
+	adap->xfer_begin(adap->data);
 
 	/* Check for bus busy */
 	timeout = wait_for_bb(adap);
 	if (timeout) {
 		DEB2(printk(KERN_ERR "i2c-algo-pcf.o: "
 		            "Timeout waiting for BB in pcf_xfer\n");)
-		return -EIO;
+		i = -EIO;
+		goto out;
 	}
 	
 	for (i = 0;ret >= 0 && i < num; i++) {
@@ -359,12 +361,14 @@ static int pcf_xfer(struct i2c_adapter *i2c_adap,
 		if (timeout) {
 			if (timeout == -EINTR) {
 				/* arbitration lost */
-				return (-EINTR);
+				i = -EINTR;
+				goto out;
 			}
 			i2c_stop(adap);
 			DEB2(printk(KERN_ERR "i2c-algo-pcf.o: Timeout waiting "
 				    "for PIN(1) in pcf_xfer\n");)
-			return (-EREMOTEIO);
+			i = -EREMOTEIO;
+			goto out;
 		}
     
 #ifndef STUB_I2C
@@ -372,7 +376,8 @@ static int pcf_xfer(struct i2c_adapter *i2c_adap,
 		if (status & I2C_PCF_LRB) {
 			i2c_stop(adap);
 			DEB2(printk(KERN_ERR "i2c-algo-pcf.o: No LRB(1) in pcf_xfer\n");)
-			return (-EREMOTEIO);
+			i = -EREMOTEIO;
+			goto out;
 		}
 #endif
     
@@ -404,6 +409,8 @@ static int pcf_xfer(struct i2c_adapter *i2c_adap,
 		}
 	}
 
+out:
+	adap->xfer_end(adap->data);
 	return (i);
 }
 
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index 05f7d09..37bb528 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -186,6 +186,14 @@ static int pcf_isa_init(void)
 	return 0;
 }
 
+static void pcf_isa_xfer_begin(void *data)
+{
+}
+
+static void pcf_isa_xfer_end(void *data)
+{
+}
+
 /* ------------------------------------------------------------------------
  * Encapsulate the above functions in the correct operations structure.
  * This is only done when more than one hardware adapter is supported.
@@ -196,6 +204,8 @@ static struct i2c_algo_pcf_data pcf_isa_data = {
 	.getown	    = pcf_isa_getown,
 	.getclock   = pcf_isa_getclock,
 	.waitforpin = pcf_isa_waitforpin,
+	.xfer_begin = pcf_isa_xfer_begin,
+	.xfer_end   = pcf_isa_xfer_end,
 };
 
 static struct i2c_adapter pcf_isa_ops = {
diff --git a/include/linux/i2c-algo-pcf.h b/include/linux/i2c-algo-pcf.h
index 5de8a31..78c62ed 100644
--- a/include/linux/i2c-algo-pcf.h
+++ b/include/linux/i2c-algo-pcf.h
@@ -33,6 +33,9 @@ struct i2c_algo_pcf_data {
 	int  (*getclock) (void *data);
 	void (*waitforpin) (void *data);
 
+	void (*xfer_begin)(void *data);
+	void (*xfer_end)(void *data);
+
 	/* Multi-master lost arbitration back-off delay (msecs)
 	 * This should be set by the bus adapter or knowledgable client
 	 * if bus is multi-mastered, else zero
-- 
1.5.6.5.GIT


----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="4.txt"

Date: Thu, 21 Aug 2008 02:43:25 -0700 (PDT)
Message-Id: <20080821.024325.109887684.davem@davemloft.net>
To: i2c@lm-sensors.org
CC: khali@linux-fr.org
Subject: [PATCH 3/6]: i2c-pcf: Fix typo in debugging log message.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


i2c-pcf: Fix typo in debugging log message.

deteted --> detected

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
index b57bc9a..c171ee6 100644
--- a/drivers/i2c/algos/i2c-algo-pcf.c
+++ b/drivers/i2c/algos/i2c-algo-pcf.c
@@ -208,7 +208,7 @@ static int pcf_init_8584 (struct i2c_algo_pcf_data *adap)
 		return -ENXIO;
 	}
 	
-	printk(KERN_DEBUG "i2c-algo-pcf.o: deteted and initialized PCF8584.\n");
+	printk(KERN_DEBUG "i2c-algo-pcf.o: detected and initialized PCF8584.\n");
 
 	return 0;
 }
-- 
1.5.6.5.GIT


----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="5.txt"

Date: Thu, 21 Aug 2008 02:43:27 -0700 (PDT)
Message-Id: <20080821.024327.144744678.davem@davemloft.net>
To: i2c@lm-sensors.org
CC: khali@linux-fr.org
Subject: [PATCH 4/6]: i2c-pcf: Add a way for bus driver to ask for no smbus
 quick mode support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


i2c-pcf: Add a way for bus driver to ask for no smbus quick mode support.

Some PCF bus implementations have precise knowledge of the i2c
devices sitting on the bus, using things such as firmware device
trees, and do not want any of the auto I2C device probing to
occur.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
index c171ee6..b8e34b0 100644
--- a/drivers/i2c/algos/i2c-algo-pcf.c
+++ b/drivers/i2c/algos/i2c-algo-pcf.c
@@ -416,8 +416,9 @@ out:
 
 static u32 pcf_func(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | 
-	       I2C_FUNC_PROTOCOL_MANGLING;
+	struct i2c_algo_pcf_data *pcf_adap = adap->algo_data;
+
+	return pcf_adap->func_flags;
 }
 
 /* -----exported algorithm data: -------------------------------------	*/
@@ -430,13 +431,18 @@ static const struct i2c_algorithm pcf_algo = {
 /* 
  * registering functions to load algorithms at runtime 
  */
-int i2c_pcf_add_bus(struct i2c_adapter *adap)
+int i2c_pcf_add_bus(struct i2c_adapter *adap, int support_smbus_quick)
 {
 	struct i2c_algo_pcf_data *pcf_adap = adap->algo_data;
 	int rval;
 
 	DEB2(dev_dbg(&adap->dev, "hw routines registered.\n"));
 
+	pcf_adap->func_flags = (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | 
+				I2C_FUNC_PROTOCOL_MANGLING);
+	if (!support_smbus_quick)
+		pcf_adap->func_flags &= ~I2C_FUNC_SMBUS_QUICK;
+
 	/* register new adapter to i2c module... */
 	adap->algo = &pcf_algo;
 	adap->timeout = 100;
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index 37bb528..2be6b5b 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -281,7 +281,7 @@ static int __devinit elektor_probe(struct device *dev, unsigned int id)
 	if (pcf_isa_init())
 		return -ENODEV;
 	pcf_isa_ops.dev.parent = dev;
-	if (i2c_pcf_add_bus(&pcf_isa_ops) < 0)
+	if (i2c_pcf_add_bus(&pcf_isa_ops, 1) < 0)
 		goto fail;
 
 	dev_info(dev, "found device at %#x\n", base);
diff --git a/include/linux/i2c-algo-pcf.h b/include/linux/i2c-algo-pcf.h
index 78c62ed..388776a 100644
--- a/include/linux/i2c-algo-pcf.h
+++ b/include/linux/i2c-algo-pcf.h
@@ -36,6 +36,8 @@ struct i2c_algo_pcf_data {
 	void (*xfer_begin)(void *data);
 	void (*xfer_end)(void *data);
 
+	u32 func_flags;
+
 	/* Multi-master lost arbitration back-off delay (msecs)
 	 * This should be set by the bus adapter or knowledgable client
 	 * if bus is multi-mastered, else zero
@@ -43,6 +45,6 @@ struct i2c_algo_pcf_data {
 	unsigned long lab_mdelay;
 };
 
-int i2c_pcf_add_bus(struct i2c_adapter *);
+int i2c_pcf_add_bus(struct i2c_adapter *adap, int support_smbus_quick);
 
 #endif /* _LINUX_I2C_ALGO_PCF_H */
-- 
1.5.6.5.GIT


----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="6.txt"

Date: Thu, 21 Aug 2008 02:43:30 -0700 (PDT)
Message-Id: <20080821.024330.51639001.davem@davemloft.net>
To: i2c@lm-sensors.org
CC: khali@linux-fr.org
Subject: [PATCH 5/6]: i2c: Add bus addressing support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


i2c: Add bus addressing support.

Some I2C bus controllers support the driving of multiple I2C bus
segments (think PCI domains).

For example, the pcf8584 variants on some sparc64 boxes can do this.
They have an auxiliary 8-bit register that specifies the I2C bus each
I2C operation acts upon.  In the openfirmware device tree, the I2C
client devices are described using an 8-bit bus address and a 10-bit
I2C device address.

In practice only really small numbers are used for the I2C bus
numbers, such as "0" and "1".  So we don't need to really represent
the full 8-bits.

Adding this support is a little bit tricky, because we can't just add
a "bus" member to struct i2c_client, struct i2c_msg, etc. because
some of these structures are exported to userspace for the sake of the
i2c-dev driver interface.

Since we encode the I2C addresses in a 16-bit quantity, we steal the
top 6 bits for the bus number.

This works out because all current code will generate addresses with
those top 6-bits clear.

We add a new functionality bit, I2C_FUNC_BUS_ADDRESSING, that the
algorithm provider uses to indicate that it can support bus addressing.

If we see a non-zero bus address, we make sure the adapter can support
it.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 550853f..3c0b5af 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -807,6 +807,10 @@ static int __i2c_check_addr(struct device *dev, void *addrp)
 
 static int i2c_check_addr(struct i2c_adapter *adapter, int addr)
 {
+	if (I2C_ADDR_GET_BUS(addr) != 0 &&
+	    !i2c_check_functionality(adapter, I2C_FUNC_BUS_ADDRESSING))
+		return -EOPNOTSUPP;
+
 	return device_for_each_child(&adapter->dev, &addr, __i2c_check_addr);
 }
 
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 08be0d2..c93561e 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -169,6 +169,31 @@ struct i2c_driver {
 };
 #define to_i2c_driver(d) container_of(d, struct i2c_driver, driver)
 
+/* In order to add bus addressing to the I2C layer without changing
+ * the layout of structures such as i2c_msg (for the sake of
+ * userspace), we encode the bus number into the top 6 bits of the
+ * address value.
+ *
+ * This allows existing userspace and drivers to keep working (the bus
+ * will be zero), and bus addressing support can be gradually added.
+ *
+ * Algorithm providers must indicate they support bus addressing via
+ * i2c_algorithm->functionality().  If they don't, the I2C layer will
+ * reject any attempt to attach, probe, or detect a device with a bus
+ * number other than zero.
+ */
+#define I2C_ADDR_ADDR_MASK	0x03ff
+#define I2C_ADDR_ADDR_SHIFT	0
+#define I2C_ADDR_BUS_MASK	0xfc00
+#define I2C_ADDR_BUS_SHIFT	10
+#define I2C_ADDR_GET_ADDR(addr) \
+	(((addr) & I2C_ADDR_ADDR_MASK) >> I2C_ADDR_ADDR_SHIFT)
+#define I2C_ADDR_GET_BUS(addr) \
+	(((addr) & I2C_ADDR_BUS_MASK) >> I2C_ADDR_BUS_SHIFT)
+#define I2C_ADDR_ENCODE(bus, addr) \
+	(((bus) << I2C_ADDR_BUS_SHIFT) | \
+	 ((addr) << I2C_ADDR_ADDR_SHIFT))
+
 /**
  * struct i2c_client - represent an I2C slave device
  * @flags: I2C_CLIENT_TEN indicates the device uses a ten bit chip address;
@@ -531,6 +556,7 @@ struct i2c_msg {
 #define I2C_FUNC_SMBUS_WRITE_I2C_BLOCK	0x08000000 /* w/ 1-byte reg. addr. */
 #define I2C_FUNC_SMBUS_READ_I2C_BLOCK_2	 0x10000000 /* I2C-like block xfer  */
 #define I2C_FUNC_SMBUS_WRITE_I2C_BLOCK_2 0x20000000 /* w/ 2-byte reg. addr. */
+#define I2C_FUNC_BUS_ADDRESSING		0x40000000
 
 #define I2C_FUNC_SMBUS_BYTE (I2C_FUNC_SMBUS_READ_BYTE | \
                              I2C_FUNC_SMBUS_WRITE_BYTE)
-- 
1.5.6.5.GIT


----Next_Part(Tue_Oct_14_13_13_31_2008_425)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="7.txt"

Date: Thu, 21 Aug 2008 02:43:33 -0700 (PDT)
Message-Id: <20080821.024333.137538181.davem@davemloft.net>
To: i2c@lm-sensors.org
CC: khali@linux-fr.org
Subject: [PATCH 6/6]: i2c-pcf: Add bus addressing support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


i2c-pcf: Add bus addressing support.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
index b8e34b0..8031e92 100644
--- a/drivers/i2c/algos/i2c-algo-pcf.c
+++ b/drivers/i2c/algos/i2c-algo-pcf.c
@@ -312,7 +312,7 @@ static int pcf_doAddress(struct i2c_algo_pcf_data *adap,
 	unsigned short flags = msg->flags;
 	unsigned char addr;
 
-	addr = msg->addr << 1;
+	addr = I2C_ADDR_GET_ADDR(msg->addr) << 1;
 	if (flags & I2C_M_RD)
 		addr |= 1;
 	if (flags & I2C_M_REV_DIR_ADDR)
@@ -342,6 +342,18 @@ static int pcf_xfer(struct i2c_adapter *i2c_adap,
 		goto out;
 	}
 	
+	/* We must set the I2C bus after waiting for bus-busy, otherwise
+	 * STOP bits from previous transfers will not propagate and the
+	 * bus will hang.
+	 *
+	 * Currently we assume that we will not switch busses during a
+	 * single xfer request.  If that were possible we'd have to add
+	 * complicated START/STOP logic below, and extra wait_for_bb()
+	 * calls.
+	 */
+	if (adap->set_bus && num)
+		adap->set_bus(adap->data, I2C_ADDR_GET_BUS(msgs[0].addr));
+
 	for (i = 0;ret >= 0 && i < num; i++) {
 		pmsg = &msgs[i];
 
@@ -431,7 +443,7 @@ static const struct i2c_algorithm pcf_algo = {
 /* 
  * registering functions to load algorithms at runtime 
  */
-int i2c_pcf_add_bus(struct i2c_adapter *adap, int support_smbus_quick)
+int i2c_pcf_add_bus(struct i2c_adapter *adap, int flags)
 {
 	struct i2c_algo_pcf_data *pcf_adap = adap->algo_data;
 	int rval;
@@ -440,8 +452,10 @@ int i2c_pcf_add_bus(struct i2c_adapter *adap, int support_smbus_quick)
 
 	pcf_adap->func_flags = (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | 
 				I2C_FUNC_PROTOCOL_MANGLING);
-	if (!support_smbus_quick)
+	if (!(flags & I2C_PCF_SUPPORT_SMBUS_QUICK))
 		pcf_adap->func_flags &= ~I2C_FUNC_SMBUS_QUICK;
+	if (flags & I2C_PCF_SUPPORT_BUS_ADDRESSING)
+		pcf_adap->func_flags |= I2C_FUNC_BUS_ADDRESSING;
 
 	/* register new adapter to i2c module... */
 	adap->algo = &pcf_algo;
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index 2be6b5b..d200b3a 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -281,7 +281,7 @@ static int __devinit elektor_probe(struct device *dev, unsigned int id)
 	if (pcf_isa_init())
 		return -ENODEV;
 	pcf_isa_ops.dev.parent = dev;
-	if (i2c_pcf_add_bus(&pcf_isa_ops, 1) < 0)
+	if (i2c_pcf_add_bus(&pcf_isa_ops, I2C_PCF_SUPPORT_SMBUS_QUICK) < 0)
 		goto fail;
 
 	dev_info(dev, "found device at %#x\n", base);
diff --git a/include/linux/i2c-algo-pcf.h b/include/linux/i2c-algo-pcf.h
index 388776a..bb68d07 100644
--- a/include/linux/i2c-algo-pcf.h
+++ b/include/linux/i2c-algo-pcf.h
@@ -36,6 +36,8 @@ struct i2c_algo_pcf_data {
 	void (*xfer_begin)(void *data);
 	void (*xfer_end)(void *data);
 
+	void (*set_bus)(void *data, int addr);
+
 	u32 func_flags;
 
 	/* Multi-master lost arbitration back-off delay (msecs)
@@ -45,6 +47,9 @@ struct i2c_algo_pcf_data {
 	unsigned long lab_mdelay;
 };
 
-int i2c_pcf_add_bus(struct i2c_adapter *adap, int support_smbus_quick);
+int i2c_pcf_add_bus(struct i2c_adapter *adap, int flags);
+
+#define I2C_PCF_SUPPORT_SMBUS_QUICK		0x00000001
+#define I2C_PCF_SUPPORT_BUS_ADDRESSING		0x00000002
 
 #endif /* _LINUX_I2C_ALGO_PCF_H */
-- 
1.5.6.5.GIT


----Next_Part(Tue_Oct_14_13_13_31_2008_425)----
