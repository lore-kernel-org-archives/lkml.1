Return-Path: <linux-kernel-owner+w=401wt.eu-S1161006AbXCHXY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006AbXCHXY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161132AbXCHXY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:24:27 -0500
Received: from mother.pmc-sierra.com ([216.241.224.12]:51157 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161131AbXCHXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:24:24 -0500
From: Marc St-Jean <stjeanma@pmc-sierra.com>
Date: Thu, 8 Mar 2007 17:24:13 -0600
Message-Id: <200703082324.l28NODOl023442@pasqua.pmc-sierra.bc.ca>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: PMC MSP71xx TWI driver
Cc: linux-mips@linux-mips.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] drivers: PMC MSP71xx TWI driver

Patch to add TWI driver for the PMC-Sierra MSP71xx devices.

This patch references some platform support files previously
submitted to the linux-mips@linux-mips.org list.

Thanks,
Marc

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
---
Re-posting patch with recommended changes:
-Cleanup on style and formatting for comments, macros, etc.
-Moved some driver private data structures from .h to .c.
-Removed casting of RHS void *.
-Changed priv_data.lock from a semaphore to a mutex.

 drivers/i2c/algos/Kconfig           |    9 
 drivers/i2c/algos/Makefile          |    1 
 drivers/i2c/algos/i2c-algo-pmctwi.c |  197 ++++++++++++++++
 drivers/i2c/busses/Kconfig          |    7 
 drivers/i2c/busses/Makefile         |    1 
 drivers/i2c/busses/i2c-pmcmsp.c     |  419 ++++++++++++++++++++++++++++++++++++
 include/linux/i2c-algo-pmctwi.h     |  135 +++++++++++
 7 files changed, 768 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
index af02034..794f7bb 100644
--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -49,5 +49,12 @@ config I2C_ALGO_SGI
 	  Supports the SGI interfaces like the ones found on SGI Indy VINO
 	  or SGI O2 MACE.
 
-endmenu
+config I2C_ALGO_PMCTWI
+	tristate "I2C PMC TWI interfaces"
+	depends on I2C && PMC_MSP
+	help
+	  Implements the PMC TWI SoC algorithm for various implementations.
 
+	  Be sure to select the proper bus for your platform below.
+
+endmenu
diff --git a/drivers/i2c/algos/Makefile b/drivers/i2c/algos/Makefile
index cac1051..2645d00 100644
--- a/drivers/i2c/algos/Makefile
+++ b/drivers/i2c/algos/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_I2C_ALGOBIT)	+= i2c-algo-bit.o
 obj-$(CONFIG_I2C_ALGOPCF)	+= i2c-algo-pcf.o
 obj-$(CONFIG_I2C_ALGOPCA)	+= i2c-algo-pca.o
 obj-$(CONFIG_I2C_ALGO_SGI)	+= i2c-algo-sgi.o
+obj-$(CONFIG_I2C_ALGO_PMCTWI)	+= i2c-algo-pmctwi.o
 
 ifeq ($(CONFIG_I2C_DEBUG_ALGO),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/i2c/algos/i2c-algo-pmctwi.c b/drivers/i2c/algos/i2c-algo-pmctwi.c
new file mode 100644
index 0000000..160f0e9
--- /dev/null
+++ b/drivers/i2c/algos/i2c-algo-pmctwi.c
@@ -0,0 +1,197 @@
+/*
+ * Device-independent algorithm for using PMC-TWI SoC busses.
+ *
+ * See drivers/i2c/busses/i2c-pmcmsp.c for an example implementation.
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-pmctwi.h>
+
+/* 
+ * Sends an i2c command out on the adapter
+ * Return -1 on error.
+ */
+static int pmctwi_master_xfer(struct i2c_adapter *adap,
+				struct i2c_msg *m, int num)
+{
+	struct pmctwi_data *busops = adap->algo_data;
+	int i, ret = 0, dual, probe;
+	struct i2c_msg *cmsg, *nmsg;
+	u8 detect_buffer[] = { 0 };
+
+	for (i = 0; i < num; i++) {
+		struct pmctwi_cmd cmd;
+		struct pmctwi_cfg oldcfg, newcfg;
+
+		probe = 0;
+		dual = 0;
+		cmsg = m + i;
+		nmsg = NULL;
+
+		if ((num - i) >= 2) {
+			/* Check for a dual write-then-read command */
+			nmsg = cmsg + 1;
+			dual = !((cmsg->flags & I2C_M_RD)) &&
+			       (nmsg->flags & I2C_M_RD) &&
+			       (cmsg->addr == nmsg->addr);
+		}
+
+		if (dual)
+			dev_dbg(&adap->dev, "Doing ops %d&%d of %d\n",
+				(i + 1), (i + 2), num);
+		else
+			dev_dbg(&adap->dev, "Doing op %d of %d\n",
+				(i + 1), num);
+
+		if (dual) {
+			cmd.type = PMCTWI_CMD_WRITE_READ;
+			cmd.write_len = cmsg->len;
+			cmd.write_data = (u8*)cmsg->buf;
+			cmd.read_len = nmsg->len;
+			cmd.read_data = (u8*)nmsg->buf;
+		} else if (cmsg->flags & I2C_M_RD) {
+			cmd.type = PMCTWI_CMD_READ;
+			cmd.read_len = cmsg->len;
+			cmd.read_data = (u8*)cmsg->buf;
+			cmd.write_len = 0;
+			cmd.write_data = NULL;
+		} else {
+			cmd.type = PMCTWI_CMD_WRITE;
+			cmd.read_len = 0;
+			cmd.read_data = NULL;
+			cmd.write_len = cmsg->len;
+			cmd.write_data = (u8*)cmsg->buf;
+		}
+
+		if (cmsg->len == 0) {
+			if (cmsg->flags & I2C_M_RD) {
+				dev_dbg(&adap->dev,
+					"Read of 0 bytes!  (illegal!)\n");
+				return -1;
+			} else {
+				dev_dbg(&adap->dev,
+					"Probing for slave at 0x%02x\n",
+					(cmsg->addr & 0xff));
+				probe = 1;
+
+				/*
+				 * Probe is a special read of 1 byte.
+				 * We don't care about the result, we just
+				 * want to see that it is successful.
+				 */
+				cmd.write_len = 1;
+				cmd.write_data = detect_buffer;
+				cmd.read_len = 1;
+				cmd.read_data = NULL;
+			}
+		}
+
+		cmd.addr = cmsg->addr;
+
+		if (probe || (cmsg->flags & I2C_M_TEN)) {
+			busops->get_twi_config(&newcfg, busops->data);
+			busops->get_twi_config(&oldcfg, busops->data);
+
+			/* For probes, we don't want any retries */
+			if (probe)
+				newcfg.nak = 0;
+
+			/* Set the special 10-bit address flag, if required */
+			if (cmsg->flags & I2C_M_TEN)
+				newcfg.add10 = 1;
+
+			busops->set_twi_config(&newcfg, busops->data);
+		}
+
+		ret = busops->xfer_cmd(&cmd, busops->data);
+
+		if (probe || (cmsg->flags & I2C_M_TEN))
+			busops->set_twi_config(&oldcfg, busops->data);
+
+		switch (ret) {
+		case PMCTWI_XFER_LOST_ARBITRATION:
+			dev_dbg(&adap->dev, "We lost arbitration: "
+				"Could not become bus master\n");
+			break;
+		case PMCTWI_XFER_NO_RESPONSE:
+			dev_dbg(&adap->dev, "No response\n");
+			break;
+		case PMCTWI_XFER_DATA_COLLISION:
+			dev_dbg(&adap->dev, "Data collision\n");
+			break;
+		case PMCTWI_XFER_BUSY:
+			dev_dbg(&adap->dev, "Port was busy\n");
+			/*
+			 *  TODO: We could potentially loop and retry
+			 *        in this case
+			 */
+			break;
+		case PMCTWI_XFER_TIMEOUT:
+			dev_dbg(&adap->dev, "Transfer timeout\n");
+			break;
+		}
+		if (ret != PMCTWI_XFER_OK) {
+			if (probe)
+				dev_dbg(&adap->dev, "Probe failed\n");
+			return -1;
+		}
+
+		if (dual) {
+			dev_dbg(&adap->dev,
+				"SMBus read 0x%02x from reg 0x%02x\n",
+				nmsg->buf[0], cmsg->buf[0]);
+
+			/* Skip one more ahead, since we just did 2 commands */
+			i++;
+		} else {
+			if (probe)
+				dev_dbg(&adap->dev, "Probe successful\n");
+			else
+				dev_dbg(&adap->dev,
+					"I2C %s %d bytes successfully\n",
+					(cmsg->flags & I2C_M_RD) ?
+						"read" : "wrote",
+					cmsg->len);
+		}
+	}
+
+	return 0;
+}
+
+static u32 pmctwi_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_10BIT_ADDR | I2C_FUNC_SMBUS_EMUL;
+}
+
+struct i2c_algorithm pmctwi_algorithm = {
+	.master_xfer	= pmctwi_master_xfer,
+	.smbus_xfer	= NULL,
+	.algo_control	= NULL,	/* TODO: someday */
+	.functionality	= pmctwi_i2c_func,
+};
+
+EXPORT_SYMBOL(pmctwi_algorithm);
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 4d44a2d..f2998b8 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -573,4 +573,11 @@ config I2C_PNX
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-pnx.
 
+config I2C_PMCMSP
+	tristate "PMC MSP I2C Controller"
+	depends on I2C && PMC_MSP
+	select I2C_ALGO_PMCTWI
+	help
+	  Supports the special PMC TWI SoC chip on the MSP platform
+
 endmenu
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 03505aa..8923878 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_I2C_PARPORT_LIGHT)	+= i2c-parport-light.o
 obj-$(CONFIG_I2C_PASEMI)	+= i2c-pasemi.o
 obj-$(CONFIG_I2C_PCA_ISA)	+= i2c-pca-isa.o
 obj-$(CONFIG_I2C_PIIX4)		+= i2c-piix4.o
+obj-$(CONFIG_I2C_PMCMSP)	+= i2c-pmcmsp.o
 obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
 obj-$(CONFIG_I2C_PROSAVAGE)	+= i2c-prosavage.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
new file mode 100644
index 0000000..a8b9cfa
--- /dev/null
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -0,0 +1,419 @@
+/*
+ * Specific bus support for PMC-TWI compliant implementation on 7120 chip
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-pmctwi.h>
+#include <linux/mutex.h>
+
+#include <asm/io.h>
+
+#include <msp_regs.h>
+#include <msp_cic_int.h>
+
+#define MSP_TW_SF_CLK_REG_OFFSET	0x00
+#define MSP_TW_HS_CLK_REG_OFFSET	0x04
+#define MSP_TW_CFG_REG_OFFSET		0x08
+#define MSP_TW_CMD_REG_OFFSET		0x0c
+#define MSP_TW_ADD_REG_OFFSET		0x10
+#define MSP_TW_DAT_0_REG_OFFSET		0x14
+#define MSP_TW_DAT_1_REG_OFFSET		0x18
+#define MSP_TW_INT_STS_REG_OFFSET	0x1c
+#define MSP_TW_INT_MSK_REG_OFFSET	0x20
+#define MSP_TW_BUSY_REG_OFFSET		0x24
+#define MSP_TW_REG_SIZE			0x28
+
+#define MSP_TW_INT_STS_DONE		(1 << 0)
+#define MSP_TW_INT_STS_LOST_ARBITRATION	(1 << 1)
+#define MSP_TW_INT_STS_NO_RESPONSE	(1 << 2)
+#define MSP_TW_INT_STS_DATA_COLLISION	(1 << 3)
+#define MSP_TW_INT_STS_BUSY		(1 << 4)
+#define MSP_TW_INT_STS_ALL		0x1f
+
+#define MSP_MAX_BYTES_PER_RW		8
+#define MSP_MAX_POLL			5
+#define MSP_POLL_DELAY			10
+#define MSP_IRQ_TIMEOUT			(MSP_MAX_POLL * MSP_POLL_DELAY)
+
+#define MSP_TW_IRQ 			MSP_INT_2WIRE
+/* Use the following instead to disable interrupt mode */
+/* #define MSP_TW_IRQ 			0 */
+
+/* IO Operation macros */
+#define pmcmsp_twi_readl	__raw_readl
+#define pmcmsp_twi_writel	__raw_writel
+
+struct pmcmsp_priv_data {
+	void __iomem *iobase;			/* iomapped base for IO */
+	enum pmctwi_xfer_result last_result;	/* result of last xfer */
+	int irq;				/* IRQ to use (0 disables) */
+	struct completion wait;			/* Completion struct for xfer */
+	struct mutex lock;			/* Used for threadsafeness */
+};
+
+static struct i2c_adapter pmcmsp_twi_adapter;
+
+/* The default settings */
+const static struct pmctwi_clockcfg pmctwi_defclockcfg = {
+	.standard = {
+		.filter = 0x3,
+		.clock = 0x1f,
+	},
+	.highspeed = {
+		.filter = 0x3,
+		.clock = 0x1f,
+	},
+};
+
+const static struct pmctwi_cfg pmctwi_deftwicfg = {
+	.arbf		= 0x03,
+	.nak		= 0x03,
+	.add10		= 0x00,
+	.mst_code	= 0x00,
+	.arb		= 0x01,
+	.highspeed	= 0x00,
+};
+
+/*
+ * Gets the current clock configuration
+ */
+static void pmcmsp_get_clock_config(struct pmctwi_clockcfg *cfg, void *data)
+{
+	struct pmcmsp_priv_data *p = data;
+	
+	mutex_lock(&p->lock);
+	pmctwi_reg_to_clock(pmcmsp_twi_readl(p->iobase +
+				MSP_TW_SF_CLK_REG_OFFSET),
+				&(cfg->standard));
+	pmctwi_reg_to_clock(pmcmsp_twi_readl(p->iobase +
+				MSP_TW_HS_CLK_REG_OFFSET),
+				&(cfg->highspeed));
+	mutex_unlock(&p->lock);
+}
+
+/*
+ * Sets the current clock configuration
+ */
+static void pmcmsp_set_clock_config(const struct pmctwi_clockcfg *cfg,
+					void *data)
+{
+	struct pmcmsp_priv_data *p = data;
+	
+	mutex_lock(&p->lock);
+	pmcmsp_twi_writel(pmctwi_clock_to_reg(&(cfg->standard)),
+				p->iobase + MSP_TW_SF_CLK_REG_OFFSET);
+	pmcmsp_twi_writel(pmctwi_clock_to_reg(&(cfg->highspeed)),
+				p->iobase + MSP_TW_HS_CLK_REG_OFFSET);
+	mutex_unlock(&p->lock);
+}
+
+/*
+ * Gets the current TWI bus configuration
+ */
+static void pmcmsp_get_twi_config(struct pmctwi_cfg *cfg, void *data)
+{
+	struct pmcmsp_priv_data *p = data;
+	
+	mutex_lock(&p->lock);
+	pmctwi_reg_to_cfg(pmcmsp_twi_readl(
+				p->iobase + MSP_TW_CFG_REG_OFFSET), cfg);
+	mutex_unlock(&p->lock);
+}
+
+/*
+ * Sets the current TWI bus configuration
+ */
+static void pmcmsp_set_twi_config(const struct pmctwi_cfg *cfg, void *data)
+{
+	struct pmcmsp_priv_data *p = data;
+	
+	mutex_lock(&p->lock);
+	pmcmsp_twi_writel(pmctwi_cfg_to_reg(cfg),
+				p->iobase + MSP_TW_CFG_REG_OFFSET);
+	mutex_unlock(&p->lock);
+}
+
+/*
+ * Parses the 'int_sts' register and returns a well-defined error code
+ */
+static enum pmctwi_xfer_result pmcmsp_get_result(u32 reg)
+{
+	if (reg & MSP_TW_INT_STS_LOST_ARBITRATION) {
+		dev_dbg(&pmcmsp_twi_adapter.dev,
+			"  Result: Lost arbitration\n");
+		return PMCTWI_XFER_LOST_ARBITRATION;
+	} else if (reg & MSP_TW_INT_STS_NO_RESPONSE) {
+		dev_dbg(&pmcmsp_twi_adapter.dev,
+			"  Result: No response\n");
+		return PMCTWI_XFER_NO_RESPONSE;
+	} else if (reg & MSP_TW_INT_STS_DATA_COLLISION) {
+		dev_dbg(&pmcmsp_twi_adapter.dev,
+			"  Result: Data collision\n");
+		return PMCTWI_XFER_DATA_COLLISION;
+	} else if (reg & MSP_TW_INT_STS_BUSY) {
+		dev_dbg(&pmcmsp_twi_adapter.dev,
+			"  Result: Bus busy\n");
+		return PMCTWI_XFER_BUSY;
+	}
+
+	dev_dbg(&pmcmsp_twi_adapter.dev, "  Result: Operation succeeded\n");
+	return PMCTWI_XFER_OK;
+}
+
+/*
+ * Polls the 'busy' register until the command is complete
+ * Note: Assumes p->lock is held.
+ */
+static void pmcmsp_poll_complete(struct pmcmsp_priv_data* p)
+{
+	int i;
+	u32 val = 0;
+	
+	for (i = 0; i < MSP_MAX_POLL; i++) {
+		val = pmcmsp_twi_readl(p->iobase + MSP_TW_BUSY_REG_OFFSET);
+		if (val == 0) {
+			u32 reason = pmcmsp_twi_readl(p->iobase +
+						MSP_TW_INT_STS_REG_OFFSET);
+			pmcmsp_twi_writel(reason, p->iobase +
+						MSP_TW_INT_STS_REG_OFFSET);
+			p->last_result = pmcmsp_get_result(reason);
+			return;
+		}
+		udelay(MSP_POLL_DELAY);
+	}
+
+	dev_dbg(&pmcmsp_twi_adapter.dev, "  Result: Poll timeout\n");
+	p->last_result = PMCTWI_XFER_TIMEOUT;
+}
+
+/*
+ * In interrupt mode, handle the interrupt
+ * Note: Assumes p->lock is held.
+ */
+static irqreturn_t pmcmsp_interrupt(int irq, void* data)
+{
+	struct pmcmsp_priv_data *p = data;
+	
+	u32 reason = pmcmsp_twi_readl(p->iobase + MSP_TW_INT_STS_REG_OFFSET);
+	pmcmsp_twi_writel(reason, p->iobase + MSP_TW_INT_STS_REG_OFFSET);
+
+	dev_dbg(&pmcmsp_twi_adapter.dev, "    Got interrupt 0x%08x\n",
+			reason);
+	if (!(reason & MSP_TW_INT_STS_DONE))
+		return IRQ_NONE;
+
+	p->last_result = pmcmsp_get_result(reason);
+	complete(&p->wait);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Do the transfer (low level):
+ *  - May use interrupt-driven or polling, depending on if an IRQ is
+ *  presently registered
+ * Note: Assumes p->lock is held
+ */
+static enum pmctwi_xfer_result pmcmsp_do_xfer(u32 reg,
+					struct pmcmsp_priv_data *p)
+{
+	dev_dbg(&pmcmsp_twi_adapter.dev, "  Writing cmd reg 0x%08x\n", reg);
+	pmcmsp_twi_writel(reg, p->iobase + MSP_TW_CMD_REG_OFFSET);
+	if (p->irq) {
+		unsigned long timeleft = wait_for_completion_timeout(
+						&p->wait, MSP_IRQ_TIMEOUT);
+		if (timeleft == 0) {
+			dev_dbg(&pmcmsp_twi_adapter.dev,
+				"  Result: IRQ timeout\n");
+			complete(&p->wait);
+			p->last_result = PMCTWI_XFER_TIMEOUT;
+		}
+	} else
+		pmcmsp_poll_complete(p);
+
+	return p->last_result;
+}
+
+/*
+ * Helper routine, converts 'pmctwi_cmd' struct to register format
+ */
+static inline u32 pmcmsp_cmd_to_reg(const struct pmctwi_cmd *cmd)
+{
+	return (u32)(((cmd->type & 0x3) << 8) |
+			(((cmd->write_len - 1) & 0x7) << 4) |
+			(((cmd->read_len - 1) & 0x7) << 0));
+}
+
+/*
+ * Do the transfer (high level)
+ */
+static enum pmctwi_xfer_result pmcmsp_xfer_cmd(struct pmctwi_cmd *cmd,
+						void *data)
+{
+	struct pmcmsp_priv_data *p = data;
+	u64 *write_data, *read_data;
+	enum pmctwi_xfer_result retval;
+
+	write_data = (u64*)cmd->write_data;
+	read_data = (u64*)cmd->read_data;
+
+	if ((cmd->type == PMCTWI_CMD_WRITE && cmd->write_len == 0) ||
+	    (cmd->type == PMCTWI_CMD_READ && cmd->read_len == 0) ||
+	    (cmd->type == PMCTWI_CMD_WRITE_READ &&
+	    (cmd->read_len == 0 || cmd->write_len == 0))) {
+		printk(KERN_ERR "%s: Cannot transfer less than 1 byte\n",
+		        __FUNCTION__);
+		return -1;
+	}
+
+	if ((cmd->read_len > MSP_MAX_BYTES_PER_RW) ||
+	    (cmd->write_len > MSP_MAX_BYTES_PER_RW)) {
+		printk(KERN_ERR "%s: Cannot transfer more than %d bytes\n",
+			__FUNCTION__, MSP_MAX_BYTES_PER_RW);
+	}
+
+	mutex_lock(&p->lock);
+	dev_dbg(&pmcmsp_twi_adapter.dev, "Setting address to 0x%08x\n",
+		cmd->addr);
+	pmcmsp_twi_writel(cmd->addr, p->iobase + MSP_TW_ADD_REG_OFFSET);
+
+	if ((cmd->type == PMCTWI_CMD_WRITE) ||
+	    (cmd->type == PMCTWI_CMD_WRITE_READ)) {
+		u64 tmp = be64_to_cpu(*write_data);
+		tmp >>= (8 - cmd->write_len) * 8;
+		dev_dbg(&pmcmsp_twi_adapter.dev, "Writing 0x%016llx\n", tmp);
+		pmcmsp_twi_writel((u32)(tmp & 0x00000000ffffffffLL),
+				p->iobase + MSP_TW_DAT_0_REG_OFFSET);
+		if (cmd->write_len > 4)
+			pmcmsp_twi_writel((u32)(tmp >> 32),
+					p->iobase + MSP_TW_DAT_1_REG_OFFSET);
+	}
+
+	retval = pmcmsp_do_xfer(pmcmsp_cmd_to_reg(cmd), p);
+
+	if ((cmd->type == PMCTWI_CMD_READ) ||
+	    (cmd->type == PMCTWI_CMD_WRITE_READ)) {
+		int i;
+		u64 rmsk = ~(0xffffffffffffffffLL << (cmd->read_len*8));
+		u64 tmp = (u64)pmcmsp_twi_readl(p->iobase +
+					MSP_TW_DAT_0_REG_OFFSET);
+		if (cmd->read_len > 4)
+			tmp |= (u64)pmcmsp_twi_readl(p->iobase +
+					MSP_TW_DAT_1_REG_OFFSET) << 32;
+		tmp &= rmsk;
+		dev_dbg(&pmcmsp_twi_adapter.dev, "Read 0x%016llx\n", tmp);
+		
+		for (i = 0; i < cmd->read_len; i++)
+			cmd->read_data[i] = (u8)((tmp >> i) & 0xff);
+	}
+	mutex_unlock(&p->lock);
+	
+	return retval;
+}
+
+static struct pmcmsp_priv_data pmcmsp_priv;
+
+static struct pmctwi_data pmcmsp_twi_algdata = {
+	.data			= (void*)&pmcmsp_priv,
+	.get_clock_config	= pmcmsp_get_clock_config,
+	.set_clock_config	= pmcmsp_set_clock_config,
+	.get_twi_config		= pmcmsp_get_twi_config,
+	.set_twi_config		= pmcmsp_set_twi_config,
+	.xfer_cmd		= pmcmsp_xfer_cmd,
+};
+
+static struct i2c_adapter pmcmsp_twi_adapter = {
+	.owner		= THIS_MODULE,
+	.class		= I2C_CLASS_HWMON,
+	.algo		= &pmctwi_algorithm,
+	.algo_data	= &pmcmsp_twi_algdata,
+	.name		= "PMC MSP TWI/SMB/I2C driver",
+};
+
+static int __init pmcmsp_twi_init(void)
+{
+	pmcmsp_priv.iobase = ioremap(MSP_TWI_BASE, MSP_TW_REG_SIZE);
+	if (pmcmsp_priv.iobase == NULL)
+		return -ENOMEM;
+
+	init_completion(&pmcmsp_priv.wait); 
+	mutex_init(&pmcmsp_priv.lock);
+	pmcmsp_priv.irq = MSP_TW_IRQ;
+
+	if (pmcmsp_priv.irq) {
+		int rc = request_irq(pmcmsp_priv.irq, pmcmsp_interrupt,
+				SA_SHIRQ | SA_INTERRUPT | SA_SAMPLE_RANDOM,
+				"TWI", &pmcmsp_priv);
+		if (rc == 0) {
+			/*
+			 * Enable 'DONE' interrupt only
+			 *
+			 * If you enable all interrupts, you will get one on
+			 * error and another when the operation completes.
+			 * This way you only have to handle one interrupt,
+			 * but you can still check all result flags.
+			 */
+			pmcmsp_twi_writel(MSP_TW_INT_STS_DONE,
+					pmcmsp_priv.iobase +
+					MSP_TW_INT_MSK_REG_OFFSET);
+		} else {
+			printk(KERN_WARNING
+				"Could not assign TWI IRQ handler "
+				"to irq %d (continuing with poll)\n",
+				pmcmsp_priv.irq);
+			pmcmsp_priv.irq = 0;
+		}
+	}
+
+	pmcmsp_set_clock_config(&pmctwi_defclockcfg, &pmcmsp_priv);
+	pmcmsp_set_twi_config(&pmctwi_deftwicfg, &pmcmsp_priv);
+
+	printk(KERN_WARNING "Registering MSP7120 I2C adapter\n");
+
+	return i2c_add_adapter(&pmcmsp_twi_adapter);
+}
+
+static void __exit pmcmsp_twi_exit(void)
+{
+	if (pmcmsp_priv.irq) {
+		pmcmsp_twi_writel(0,
+			pmcmsp_priv.iobase + MSP_TW_INT_MSK_REG_OFFSET);
+		free_irq(pmcmsp_priv.irq, &pmcmsp_priv);
+	}
+	i2c_del_adapter(&pmcmsp_twi_adapter);
+}
+
+MODULE_DESCRIPTION("PMC MSP TWI/SMB/I2C driver");
+MODULE_LICENSE("GPL");
+
+module_init(pmcmsp_twi_init);
+module_exit(pmcmsp_twi_exit);
diff --git a/include/linux/i2c-algo-pmctwi.h b/include/linux/i2c-algo-pmctwi.h
new file mode 100644
index 0000000..7b6ca58
--- /dev/null
+++ b/include/linux/i2c-algo-pmctwi.h
@@ -0,0 +1,135 @@
+/*
+ * Device-independent algorithm for using PMC-TWI SoC busses.
+ *
+ * See drivers/i2c/busses/i2c-pmcmsp.c for an example implementation.
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef I2C_ALGO_PMCTWI_H
+#define I2C_ALGO_PMCTWI_H
+
+#include <linux/i2c.h>
+
+/* TWI command type */
+enum pmctwi_cmd_type {
+	PMCTWI_CMD_WRITE	= 0, /* Write only */
+	PMCTWI_CMD_READ		= 1, /* Read only */
+	PMCTWI_CMD_WRITE_READ	= 2, /* Write then Read */
+	PMCTWI_CMD_RESERVED	= 3,
+};
+
+/* Corresponds to a PMCTWI clock configuration register */
+struct pmctwi_clock {
+	u8 filter;	/* Bits 15:12,	default = 0x03 */
+	u16 clock;	/* Bits 9:0,	default = 0x001f */
+};
+
+static inline u32 pmctwi_clock_to_reg(const struct pmctwi_clock *clock) {
+	return (u32)(((clock->filter & 0xf) << 12) |
+			(clock->clock & 0x03ff));
+}
+
+static inline void pmctwi_reg_to_clock(u32 reg, struct pmctwi_clock *clock) {
+	clock->filter = (u8)((reg >> 12) & 0xf);
+	clock->clock = (u16)(reg & 0x03ff);
+}
+
+struct pmctwi_clockcfg {
+	struct pmctwi_clock standard;	/* The standard/fast clock config */
+	struct pmctwi_clock highspeed;	/* The highspeed clock config */
+};
+
+/* Corresponds to the main TWI configuration register */
+struct pmctwi_cfg {
+	u8 arbf;	/* Bits 15:12,	default=0x03 */
+	u8 nak;		/* Bits 11:8,	default=0x03 */
+	u8 add10;	/* Bit 7,	default=0x00 */
+	u8 mst_code;	/* Bits 6:4,	default=0x00 */
+	u8 arb;		/* Bit 1,	default=0x01 */
+	u8 highspeed;	/* Bit 0,	default=0x00 */
+};
+
+static inline u32 pmctwi_cfg_to_reg(const struct pmctwi_cfg *cfg) {
+	return (u32)(((cfg->arbf & 0xf) << 12) |
+			((cfg->nak & 0xf) << 8) |
+			((cfg->add10 & 0x1) << 7) |
+			((cfg->mst_code & 0x7) << 4) |
+			((cfg->arb & 0x1) << 1) |
+			((cfg->highspeed & 0x1) << 0));
+}
+
+static inline void pmctwi_reg_to_cfg(u32 reg, struct pmctwi_cfg *cfg) {
+	cfg->arbf = (u8)((reg >> 12) & 0xf);
+	cfg->nak = (u8)((reg >> 8) & 0xf);
+	cfg->add10 = (u8)((reg >> 7) & 0x1);
+	cfg->mst_code = (u8)((reg >> 4) & 0x7);
+	cfg->arb = (u8)((reg >> 1) & 0x1);
+	cfg->highspeed = (u8)(reg & 0x1);
+}
+
+/* A single pmctwi command to issue */
+struct pmctwi_cmd {
+	u16 addr;	/* The slave address (7 or 10 bits) */
+	enum pmctwi_cmd_type type;	/* The command type */
+	u8 write_len;	/* Number of bytes in the write buffer */
+	u8 read_len;	/* Number of bytes in the read buffer */
+	u8*write_data;	/* Buffer of characters to send */
+	u8 *read_data;	/* Buffer to fill with incoming data */
+};
+
+/* The possible results of the xferCmd */
+enum pmctwi_xfer_result {
+	PMCTWI_XFER_OK	= 0,
+	PMCTWI_XFER_TIMEOUT,
+	PMCTWI_XFER_BUSY,
+	PMCTWI_XFER_DATA_COLLISION,
+	PMCTWI_XFER_NO_RESPONSE,
+	PMCTWI_XFER_LOST_ARBITRATION,
+};
+
+/* The set of operations each bus must implement to use this algorithm */
+struct pmctwi_data {
+	void *data;	/* Optional bus-specific data */
+
+	/* Get both clock configuration registers */
+	void (*get_clock_config)(struct pmctwi_clockcfg *cfg, void *data);
+
+	/* Set both clock configuration registers */
+	void (*set_clock_config)(const struct pmctwi_clockcfg *cfg,
+					void *data);
+
+	/* Get the TWI configuration register */
+	void (*get_twi_config)(struct pmctwi_cfg *cfg, void *data);
+
+	/* Set the TWI configuration register */
+	void (*set_twi_config)(const struct pmctwi_cfg *cfg, void *data);
+
+	/* Send the command, reading and/or writing all data specified */
+	enum pmctwi_xfer_result (*xfer_cmd)(struct pmctwi_cmd *cmd,
+						void *data);
+};
+
+extern struct i2c_algorithm pmctwi_algorithm;
+
+#endif /* I2C_ALGO_PMCTWI_H */
