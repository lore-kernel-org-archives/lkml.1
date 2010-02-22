Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0BVLT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 06:19:58 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26873 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab0BVLTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 06:19:55 -0500
Message-ID: <004401cab3b0$f4d387c0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
       <joel.clark@intel.com>
References: <000a01cab118$8bbc8600$66f8800a@maildom.okisemi.com> <20100219152907.75065c83@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH]Add new device drivers for Topcliff
Date: Mon, 22 Feb 2010 20:19:50 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for very useful advice and it was good example.
I confirm "linux/Documentation/SubmittingPatches" and tried "diff -up" for
8250 driver.

The driver is developed for new device of Topcliff.

Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

--- a/drivers/serial/8250.c 2010-01-05 19:02:46.000000000 -0500
+++ b/drivers/serial/8250.c 2010-02-04 18:15:27.000000000 -0500
@@ -39,6 +39,14 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>

+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+/* For using DMA features. */
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/dma-mapping.h>
+#include <ioh/ioh_dma_main.h>
+#endif
+
 #include <asm/io.h>
 #include <asm/irq.h>

@@ -126,6 +134,18 @@ static unsigned long probe_rsa[PORT_RSA_
 static unsigned int probe_rsa_count;
 #endif /* CONFIG_SERIAL_8250_RSA  */

+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+/* Structure for storing the DMA channel related information. */
+struct ioh_dma_feature
+{
+ u32 buf;
+ u32 phy_addr;
+ s32 channel;
+ u32 size;
+};
+#endif
+
+
 struct uart_8250_port {
  struct uart_port port;
  struct timer_list timer;  /* "no irq" timer */
@@ -156,6 +176,17 @@ struct uart_8250_port {
   */
  void   (*pm)(struct uart_port *port,
           unsigned int state, unsigned int old);
+
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ struct ioh_dma_feature rx_dma; /* DMA operation for Receive.      */
+ struct ioh_dma_feature tx_dma; /* DMA operation for Transmit.      */
+ unsigned int buffer;   /* The buffer for DMA descriptors.    */
+ unsigned int buffer_phy;  /* The physical address of the buffer.   */
+ unsigned int dma_flag;   /* DMA flag variable for enabling DMA transfer.
*/
+ unsigned int rx_fifo_size;  /* The UART Rx fifo size.      */
+ unsigned int dma_progress;  /* The DMA in progress flag.     */
+ unsigned int dma_enabled;  /* The DMA enable flag.       */
+#endif
 };

 struct irq_info {
@@ -296,6 +327,25 @@ static const struct serial8250_config ua
   .fcr  = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_00,
   .flags  = UART_CAP_FIFO | UART_CAP_AFE,
  },
+#if defined(CONFIG_SERIAL_8250_IOH)
+ [PORT_IOH_256FIFO] = {
+  .name       = "IOH_256FIFO",
+  .fifo_size  = 256,
+  .tx_loadsz  = 256,
+  .fcr        = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
+       UART_FCR7_256BYTE,
+  .flags      = UART_CAP_FIFO | UART_CAP_AFE,
+ },
+
+ [PORT_IOH_64FIFO] = {
+  .name       = "IOH_64FIFO",
+  .fifo_size  = 64,
+  .tx_loadsz  = 64,
+  .fcr        = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
+       UART_FCR7_64BYTE,
+  .flags      = UART_CAP_FIFO | UART_BUG_NOMSR,
+ },
+#endif
 };

 #if defined (CONFIG_SERIAL_8250_AU1X00)
@@ -380,6 +430,71 @@ static inline int map_8250_out_reg(struc

 #endif

+
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+
+/* Function for calculating the Rx FIFO size of the IOH UART. */
+void get_rx_fifo_size(struct uart_8250_port * up,u8 fcr_value)
+{
+ unsigned fifo_size;
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"get_rx_fifo -> The FCR register value:
%x.\n",fcr_value);
+#endif
+/* check if the UART is a 64 byte FIFO UART */
+ if((up->port.flags & UPF_IOH_UART_64_FIFO) != 0)
+ {
+  switch((fcr_value & 0xC0))
+  {
+   case 0: fifo_size = 1;
+     break;
+
+   case 0x40: fifo_size = 16;
+     break;
+
+   case 0x80: fifo_size = 32;
+     break;
+
+   case 0xC0: fifo_size = 56;
+     break;
+
+   default: fifo_size = 1;
+     break;
+  }
+ }
+ else
+ {
+/* UART is 256 byte byte FIFO UART */
+  switch((fcr_value & 0xC0))
+  {
+   case 0: fifo_size = 1;
+     break;
+
+   case 0x40: fifo_size = 64;
+     break;
+
+   case 0x80: fifo_size = 128;
+     break;
+
+   case 0xC0: fifo_size = 224;
+     break;
+
+   default: fifo_size = 1;
+     break;
+  }
+ }
+/* save the fifo size for reference */
+ up->rx_fifo_size = fifo_size;
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function get_rx_fifo_size stores fifo_size as:
%u.\n",fifo_size);
+#endif
+}
+
+#endif
+
+
+
+
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
  offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -547,15 +662,277 @@ serial_out_sync(struct uart_8250_port *u
  (up->port.serial_in(&(up)->port, (offset)))
 #define serial_out(up, offset, value) \
  (up->port.serial_out(&(up)->port, (offset), (value)))
+
 /*
  * We used to support using pause I/O for certain machines.  We
  * haven't supported this for a while, but just in case it's badly
  * needed for certain old 386 machines, I've left these #define's
  * in....
  */
+
 #define serial_inp(up, offset)  serial_in(up, offset)
 #define serial_outp(up, offset, value) serial_out(up, offset, value)

+
+#if 1  //  /*for 2.6.33-rc3 */
+
+/* DMA TX callback function */
+void ioh_dma_tx_callback(int status,unsigned long data)
+{
+ struct uart_8250_port *up = (struct uart_8250_port *)data;
+// struct circ_buf *xmit = &up->port.info->xmit;
+ struct circ_buf *xmit = &up->port.state->xmit;/*for 2.6.33-rc3*/
+ u8 value;
+
+#ifdef DEBUG
+ if(status == IOH_DMA_END)
+ {
+  printk(KERN_DEBUG"ioh_dma_tx_callback -> DMA END interrupt obtained " \
+     "for transmission.\n");
+
+ }
+#endif
+ if(status == IOH_DMA_ABORT)
+ {
+  printk(KERN_ERR"ioh_dma_tx_callback -> DMA ABORT interrupt obtained " \
+    "for transmission.\n");
+ }
+
+ /* Un-mapping the DMA buffer. */
+ if(up->tx_dma.phy_addr > 0)
+
dma_unmap_single(up->port.dev,up->tx_dma.phy_addr,up->tx_dma.size,DMA_TO_DEV
ICE);
+
+ dma_unmap_single(up->port.dev,up->buffer_phy,PAGE_SIZE,DMA_TO_DEVICE);
+
+ /*Enable TX interrupt.*/
+ if(uart_circ_chars_pending(xmit))
+ {
+  value = (u8)serial_in(up,UART_IER);
+  serial_out(up,UART_IER,(value | 0x02));
+  up->ier = serial_in(up,UART_IER);
+ }
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function ioh_dma_tx_callback invoked.\n");
+#endif
+}
+
+/* Function for DMA setting for Scatter Gather Mode. */
+void set_scatter_gather_dma_mode(struct uart_8250_port *up,unsigned count)
+{
+ u32 in_address;
+ u32 out_address;
+ u32 desc_address;
+ u32 total_desc;
+ u32 i,j;
+ u8 value;
+ ioh_dma_desc_t * desc;
+ int channel = up->tx_dma.channel;
+ ioh_dma_mode_param_t mode = {
+         .TransferDirection = IOH_DMA_DIR_OUT_TO_IN,
+         .DMASizeType  = IOH_DMA_SIZE_TYPE_8BIT,
+         .DMATransferMode = DMA_SCATTER_GATHER_MODE
+        };
+
+ desc = (ioh_dma_desc_t *)up->tx_dma.buf;
+
+ /* Mapping the DMA buffer for transfer. */
+ out_address  = dma_map_single(up->port.dev,(void
*)up->buffer,PAGE_SIZE,DMA_TO_DEVICE);
+ in_address  = up->port.mapbase + (map_8250_in_reg(up,UART_TX));
+ desc_address = dma_map_single(up->port.dev,(void
*)up->tx_dma.buf,up->tx_dma.size,DMA_TO_DEVICE);
+ up->buffer_phy = out_address;
+ up->tx_dma.phy_addr = desc_address;
+
+ /* Disable Transmit hardware interrupt.*/
+ value = (u8)serial_in(up,UART_IER);
+ serial_out(up,UART_IER,(value & 0xFD));
+ up->ier = serial_in(up,UART_IER);
+
+ total_desc = count/(up->tx_loadsz);
+
+ if((count % (up->tx_loadsz)) > 0)
+  total_desc++;
+
+
dma_sync_single_for_cpu(up->port.dev,desc_address,up->tx_dma.size,DMA_TO_DEV
ICE);
+
+ /* Organising the DMA descriptors. */
+ for(i = 0,j = 0; (i< total_desc && count > 0); i++)
+ {
+  desc[i].insideAddress = in_address;
+  desc[i].outsideAddress = (out_address + j);
+
+  if((int)(count - (up->tx_loadsz)) > 0)
+  {
+   desc[i].size = up->tx_loadsz | IOH_DMA_SIZE_TYPE_8BIT;
+   count = count - (up->tx_loadsz);
+   j+=(up->tx_loadsz);
+  }
+  else
+  {
+   desc[i].size = count | IOH_DMA_SIZE_TYPE_8BIT;
+   j+=count;
+   count = 0;
+  }
+
+  desc[i].nextDesc = ((((u32)((desc_address + ((i +
1)*(sizeof(ioh_dma_desc_t)))))) & 0xFFFFFFFC) |
DMA_DESC_FOLLOW_WITHOUT_INTERRUPT);
+ }
+
+ desc[i - 1].nextDesc = (DMA_DESC_END_WITH_INTERRUPT);
+
+
dma_sync_single_for_device(up->port.dev,desc_address,up->tx_dma.size,DMA_TO_
DEVICE);
+
+ /* Initiating the DMA transfer. */
+ ioh_set_dma_mode(channel,mode);
+ ioh_set_dma_desc(channel,(ioh_dma_desc_t *)((desc_address & 0xFFFFFFFC) |
DMA_DESC_FOLLOW_WITHOUT_INTERRUPT),\
+     (((ioh_dma_desc_t *)desc_address) + (total_desc - 1)));
+ ioh_dma_set_callback(channel,ioh_dma_tx_callback,(u32)up);
+ ioh_enable_dma(channel);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function set_scatter_gather_dma_mode invoked.\n");
+#endif
+}
+
+/* Function for DMA settings for ONE SHOT mode. */
+void set_one_shot_dma_mode(struct uart_8250_port *up,unsigned count)
+{
+ u32 in_address;
+ u32 out_address;
+ u8 value;
+ int channel = up->tx_dma.channel;
+ ioh_dma_mode_param_t mode = {
+         .TransferDirection = IOH_DMA_DIR_OUT_TO_IN,
+         .DMASizeType  = IOH_DMA_SIZE_TYPE_8BIT,
+         .DMATransferMode = DMA_ONE_SHOT_MODE
+        };
+
+ /* Disable Receive hardware interrupt.*/
+ value = (u8)serial_in(up,UART_IER);
+ serial_out(up,UART_IER,(value & 0xFD));
+ up->ier = serial_in(up,UART_IER);
+
+ /* Mapping the DMA buffer for transfer. */
+ out_address  = dma_map_single(up->port.dev,(void
*)up->buffer,PAGE_SIZE,DMA_TO_DEVICE);
+ in_address  = up->port.mapbase + (map_8250_in_reg(up,UART_TX));
+ up->buffer_phy = out_address;
+ up->tx_dma.phy_addr = 0;
+
+ /* Initiating the DMA transfer. */
+ ioh_set_dma_mode(channel,mode);
+ ioh_set_dma_addr(channel,in_address,out_address);
+ ioh_set_dma_count(channel,count);
+ ioh_dma_set_callback(channel,ioh_dma_tx_callback,(u32)up);
+ ioh_enable_dma(channel);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function set_one_shot_dma_mode invoked.\n");
+#endif
+}
+
+/* Function for pushing the received characters to tty buffer. */
+/* At high baud rates tty buffer does not get emptied sufficiently fast
+     and hence multiple retries are required to push the data into the
buffer */
+
+static int push_rx(struct tty_struct *tty, const unsigned char *buf, int
size)
+{
+    u32 sz, i, j;
+    u32 loop;
+    u32 pushed;
+
+     for (pushed = 0, i = 0, loop = 1; (pushed < size) && loop; pushed +=
sz, i++)
+      {
+         sz = tty_insert_flip_string(tty, &buf[pushed], size - pushed);
+
+         for (j = 0; (j < 100000) && (sz == 0); j++)
+          {
+            tty_flip_buffer_push(tty);
+            sz = tty_insert_flip_string(tty, &buf[pushed], size - pushed);
+          }
+
+         if (sz == 0)
+          {
+            loop = 0;
+          }
+      }
+
+     tty_flip_buffer_push(tty);
+
+#ifdef DEBUG
+     printk(KERN_DEBUG"push_rx -> %d characters pushed. Remained " \
+   "%d characters.\n", pushed, size - pushed);
+ printk(KERN_DEBUG"Function push_rx return %u.\n",pushed);
+#endif
+
+     return(pushed);
+}
+
+/* The DMA reception callback function. */
+void ioh_dma_rx_callback(int status,unsigned long data)
+{
+ struct uart_8250_port *up = (struct uart_8250_port *)data;
+ unsigned fifo_size;
+      unsigned long flags;
+ u8 value;
+
+ spin_lock_irqsave(&up->port.lock, flags);
+
+ /* Normal end. */
+ if(status == IOH_DMA_END)
+ {
+  /* Preparing the DMA buffer to be accessed by the CPU*/
+
dma_sync_single_for_cpu(up->port.dev,up->rx_dma.phy_addr,up->rx_dma.size,DMA
_FROM_DEVICE);
+
+#ifdef DEBUG
+  printk(KERN_DEBUG"ioh_dma_rx_callback -> DMA END interrupt obtained for
reception.\n");
+#endif
+  fifo_size = up->rx_fifo_size;
+//  push_rx(up->port.info->port.tty,(char *)up->rx_dma.buf,fifo_size);
+  push_rx(up->port.state->port.tty,(char *)up->rx_dma.buf,fifo_size);
/*for 2.6.33-rc3 */
+
+ }
+ /* DMA abort. */
+ else if(status == IOH_DMA_ABORT)
+ {
+  printk(KERN_ERR"ioh_dma_rx_callback -> DMA ABORT interrupt obtained for
reception.\n");
+ }
+
+ /* Unmapping the buffer from DMA accesible area. */
+
dma_unmap_single(up->port.dev,up->rx_dma.phy_addr,up->rx_dma.size,DMA_FROM_D
EVICE);
+
+ /*Enable hardware interrupt.*/
+ value = (u8)serial_in(up,UART_IER);
+ serial_out(up,UART_IER,(value | 0x01));
+ up->ier = serial_in(up,UART_IER);
+ up->dma_progress = 0;
+
+ spin_unlock_irqrestore(&up->port.lock, flags);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"ioh_dma_rx_callback -> Function ioh_dma_rx_callback is
invoked.\n");
+#endif
+}
+
+/* For initiating the DMA operation.*/
+void handle_dma_operation(struct uart_8250_port *up)
+{
+ u8 value;
+ int channel = up->rx_dma.channel;
+
+ /* Disable Receive hardware interrupt.*/
+ value = (u8)serial_in(up,UART_IER);
+ serial_out(up,UART_IER,(value & 0xFE));
+ up->ier = serial_in(up,UART_IER);
+
+ /* Enabling the DMA transfer. */
+ ioh_enable_dma(channel);
+ up->dma_progress = 1;
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"handle_dma_operation -> DMA settings for reception
completed.\n");
+ printk(KERN_DEBUG"Function handle_dma_operation invoked.\n");
+#endif
+}
+#endif  //   /*for 2.6.33-rc3 */
+
 /* Uart divisor latch read */
 static inline int _serial_dl_read(struct uart_8250_port *up)
 {
@@ -1037,6 +1414,20 @@ static void autoconfig_16550a(struct uar
   return;
  }

+#if defined(CONFIG_SERIAL_8250_IOH)
+ if((up->port.flags & UPF_IOH_UART ) != 0)
+ {
+  if((up->port.flags & UPF_IOH_UART_64_FIFO) != 0)
+  {
+   up->port.type = PORT_IOH_64FIFO;  /* IOH 2 Line 64 FIFO UART */
+  }
+  else
+  {
+    up->port.type = PORT_IOH_256FIFO;  /* IOH 8 Line 256 FIFO UART */
+  }
+ }
+#endif
+
  /*
   * Try writing and reading the UART_IER_UUE bit (b6).
   * If it works, this is probably one of the Xscale platform's
@@ -1184,6 +1575,7 @@ static void autoconfig(struct uart_8250_

  switch (scratch) {
  case 0:
+
   autoconfig_8250(up);
   break;
  case 1:
@@ -1193,7 +1585,31 @@ static void autoconfig(struct uart_8250_
   up->port.type = PORT_16550;
   break;
  case 3:
-  autoconfig_16550a(up);
+#ifdef CONFIG_SERIAL_8250_IOH
+  if ((up->port.type != PORT_IOH_256FIFO) && (up->port.type !=
PORT_IOH_64FIFO))
+#endif
+  {
+
+#ifdef DEBUG
+   printk(KERN_DEBUG
+   "IOH UART LOG:function autoconfig->autoconfig_16550a invoked "
+   "for port %d\n",up->port.type);
+#endif
+   autoconfig_16550a(up);
+
+  }
+
+#ifdef CONFIG_SERIAL_8250_IOH
+  else
+  {
+
+#ifdef DEBUG
+   printk(KERN_DEBUG
+   "IOH UART LOG:function autoconfig->autoconfig_16550a not "
+   "invoked for IOH UART port %d\n",up->port.type);
+#endif
+  }
+#endif
   break;
  }

@@ -1221,18 +1637,35 @@ static void autoconfig(struct uart_8250_
 #endif

  serial_outp(up, UART_LCR, save_lcr);
-
+#ifdef CONFIG_SERIAL_8250_IOH
+ if ((up->port.type != PORT_IOH_256FIFO) && (up->port.type !=
PORT_IOH_64FIFO))
+ /* autoconfig is not done for ioh uarts. hence do not report any kernel
warning */
+#endif
+ {
  if (up->capabilities != uart_config[up->port.type].flags) {
-  printk(KERN_WARNING
-         "ttyS%d: detected caps %08x should be %08x\n",
-         serial_index(&up->port), up->capabilities,
-         uart_config[up->port.type].flags);
+   printk(KERN_WARNING "ttyS%d: detected caps %08x should be %08x\n",
+    up->port.line, up->capabilities,
+    uart_config[up->port.type].flags);
+  }
+
  }

  up->port.fifosize = uart_config[up->port.type].fifo_size;
  up->capabilities = uart_config[up->port.type].flags;
  up->tx_loadsz = uart_config[up->port.type].tx_loadsz;

+#ifdef DEBUG
+    printk(KERN_DEBUG
+          "IOH UART LOG:autoconfig: up->port.type = %d,up->port.fifosize
=%d,"
+       "up->capabilities = %x,up->tx_loadsz = %d\n",up->port.type,
+        up->port.fifosize, up->capabilities, up->tx_loadsz);
+
+ printk(KERN_DEBUG
+       "IOH UART LOG:autoconfig: port.name = %s, port.fcr = %x\n",
+       uart_config[up->port.type].name,uart_config[up->port.type].fcr);
+
+#endif
+
  if (up->port.type == PORT_UNKNOWN)
   goto out;

@@ -1458,7 +1891,11 @@ ignore_char:
 static void transmit_chars(struct uart_8250_port *up)
 {
  struct circ_buf *xmit = &up->port.state->xmit;
- int count;
+ int count = 0;
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ unsigned limit = 0;
+ unsigned size = 0;
+#endif

  if (up->port.x_char) {
   serial_outp(up, UART_TX, up->port.x_char);
@@ -1475,15 +1912,61 @@ static void transmit_chars(struct uart_8
   return;
  }

+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ if(((up->port.flags & UPF_IOH_UART) != 0))
+ {
+  size = uart_circ_chars_pending(xmit);
+
+  if(size  > PAGE_SIZE)
+  {
+   size = PAGE_SIZE;
+  }
+
+  count = size;
+ }
+
+ else
+#endif
  count = up->tx_loadsz;
- do {
+ do
+ {
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+  if((((up->port.flags & UPF_IOH_UART) != 0)) && (size > 0))
+  {
+   ((char *)(up->buffer))[limit] = xmit->buf[xmit->tail];
+   limit++;
+
+  }
+  else
+#endif
   serial_out(up, UART_TX, xmit->buf[xmit->tail]);
+
   xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
   up->port.icount.tx++;
   if (uart_circ_empty(xmit))
    break;
  } while (--count > 0);

+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ if(limit > 0)
+ {
+  if(limit > up->tx_loadsz)
+  {
+   set_scatter_gather_dma_mode(up,limit);
+#ifdef DEBUG
+   printk(KERN_DEBUG"transmit_chars -> Function set_scatter_gather_dma_mode
invoked.\n");
+#endif
+  }
+  else
+  {
+   set_one_shot_dma_mode(up,limit);
+#ifdef DEBUG
+   printk(KERN_DEBUG"transmit_chars -> Function set_one_shot_dma_mode
invoked.\n");
+#endif
+  }
+ }
+#endif
+
  if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
   uart_write_wakeup(&up->port);

@@ -1491,6 +1974,10 @@ static void transmit_chars(struct uart_8

  if (uart_circ_empty(xmit))
   __stop_tx(up);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function transmit_chars invoked.\n");
+#endif
 }

 static unsigned int check_modem_status(struct uart_8250_port *up)
@@ -1530,13 +2017,34 @@ static void serial8250_handle_port(struc

  DEBUG_INTR("status = %x...", status);

- if (status & (UART_LSR_DR | UART_LSR_BI))
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ if ((up->dma_flag) && (up->dma_enabled))/* If reception has to be done
through DMA. */
+ {
+#ifdef DEBUG
+  printk(KERN_DEBUG"serial8250_handle_port -> Proceeding to handle
reception " \
+    "interrupt through DMA operation.\n");
+#endif
+  handle_dma_operation(up);
+ }
+ else
+#endif
+ {
+  if ((status & (UART_LSR_DR | UART_LSR_BI))
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+    && (!up->dma_progress)
+#endif
+   )
   receive_chars(up, &status);
+ }
  check_modem_status(up);
  if (status & UART_LSR_THRE)
   transmit_chars(up);

  spin_unlock_irqrestore(&up->port.lock, flags);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"serial8250_handle_port invoked.\n");
+#endif
 }

 /*
@@ -1571,7 +2079,28 @@ static irqreturn_t serial8250_interrupt(
   up = list_entry(l, struct uart_8250_port, list);

   iir = serial_in(up, UART_IIR);
-  if (!(iir & UART_IIR_NO_INT)) {
+  if (!(iir & UART_IIR_NO_INT))
+  {
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+   /* Determing whether the receive FIFO is full. */
+   if((iir & UART_IIR_RDI) && !(iir & 0x8) && ((up->port.flags &
UPF_IOH_UART) != 0))
+   {
+
+    up->dma_flag = 1;
+
+#ifdef DEBUG
+    printk(KERN_DEBUG"serial8250_interrupt -> DMA Mode enabled for
reception.\n");
+#endif
+   }
+   else
+   {
+    up->dma_flag = 0;
+#ifdef DEBUG
+    printk(KERN_DEBUG"serial8250_interrupt -> DMA Mode disabled for
reception.\n");
+#endif
+   }
+#endif
+
    serial8250_handle_port(up);

    handled = 1;
@@ -1945,6 +2474,154 @@ static int serial8250_startup(struct uar
  unsigned char lsr, iir;
  int retval;

+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ /* Initialising the device for DMA support. */
+ int dma_flag = 0;
+ up->dma_progress = 0;
+ up->dma_enabled = 0;
+
+ if((up->port.flags & UPF_IOH_UART ) != 0)
+ {
+  struct pci_dev pdev;
+
+//  switch((up->port.flags & 0xE000000))/*for 2.6.27-rc3 morinaga delete
2010.01.25*/
+  switch((up->port.flags & (UPF_IOH_UART | UPF_IOH_UART_BIT0 |
UPF_IOH_UART_BIT1)))  /*for 2.6.33-rc3 */
+
+  {
+   case UPF_IOH_UART0:
+#ifdef DEBUG
+     printk(KERN_DEBUG"serial8250_startup -> UART0 detected.\n");
+#endif
+     pdev.device = PCI_DEVICE_ID_IOH_UART0;
+     up->port.mctrl |= TIOCM_RTS;
+     break;
+
+   case UPF_IOH_UART1:
+#ifdef DEBUG
+     printk(KERN_DEBUG"serial8250_startup -> UART1 detected.\n");
+#endif
+     pdev.device = PCI_DEVICE_ID_IOH_UART1;
+     break;
+
+   case UPF_IOH_UART2:
+#ifdef DEBUG
+     printk(KERN_DEBUG"serial8250_startup -> UART2 detected.\n");
+#endif
+     pdev.device = PCI_DEVICE_ID_IOH_UART2;
+     break;
+
+   case UPF_IOH_UART3:
+#ifdef DEBUG
+     printk(KERN_DEBUG"serial8250_startup -> UART3 detected.\n");
+#endif
+     pdev.device = PCI_DEVICE_ID_IOH_UART3;
+     break;
+
+   default:
+     break;
+  }
+
+  /* Allocating space for DMA buffer. */
+  up->rx_dma.buf = (u32)__get_free_page(GFP_KERNEL|GFP_DMA);
+  if(!(up->rx_dma.buf))
+  {
+   printk(KERN_ERR"serial8250_startup -> DMA buffer allocation " \
+     "failed for Rx DMA buffer.\n");
+   return -ENOMEM;
+  }
+
+  /* For transmission process. */
+  up->tx_dma.buf = (u32)__get_free_page(GFP_KERNEL|GFP_DMA);
+  if(!(up->tx_dma.buf))
+  {
+   free_page(up->rx_dma.buf);
+   printk(KERN_ERR"serial8250_startup -> DMA buffer allocation " \
+     "failed for TX DMA buffer.\n");
+   return -ENOMEM;
+  }
+
+  /* For copying of transmit data. */
+  up->buffer = (u32)__get_free_page(GFP_KERNEL|GFP_DMA);
+  if(!(up->buffer))
+  {
+   free_page(up->rx_dma.buf);
+   free_page(up->tx_dma.buf);
+   printk(KERN_ERR"serial8250_startup -> DMA buffer allocation " \
+     "failed for Buffer.\n");
+   return -ENOMEM;
+  }
+
+  up->rx_dma.size = PAGE_SIZE;
+  up->tx_dma.size = PAGE_SIZE;
+
+  /* Requesting for DMA channel for reception. */
+  up->rx_dma.channel = ioh_request_dma(&pdev,IOH_DMA_RX_DATA_REQ0);
+  if(up->rx_dma.channel < 0)
+  {
+   free_page(up->rx_dma.buf);
+   free_page(up->tx_dma.buf);
+   free_page(up->buffer);
+   up->rx_dma.buf = 0;
+   up->tx_dma.buf = 0;
+   up->buffer = 0;
+
+   printk(KERN_ERR"serial8250_startup -> DMA channel allocation for " \
+     "reception failed.\n");
+   return -EIO;
+  }
+
+  /* Requesting DMA channel for transmission. */
+  up->tx_dma.channel = ioh_request_dma(&pdev,IOH_DMA_TX_DATA_REQ0);
+  if(up->tx_dma.channel < 0)
+  {
+   free_page(up->rx_dma.buf);
+   free_page(up->tx_dma.buf);
+   free_page(up->buffer);
+   up->rx_dma.buf = 0;
+   up->tx_dma.buf = 0;
+   up->buffer = 0;
+   ioh_free_dma(up->rx_dma.channel);
+
+   printk(KERN_ERR"serial8250_startup -> DMA channel allocation for " \
+     "transmission failed.\n");
+   return -EIO;
+  }
+
+  /* Performing DMA settings for reception. */
+  {
+   u32 in_address;
+   u32 out_address;
+   u32 size;
+   int channel = up->rx_dma.channel;
+   ioh_dma_mode_param_t mode = {
+           .TransferDirection = IOH_DMA_DIR_IN_TO_OUT,
+           .DMASizeType  = IOH_DMA_SIZE_TYPE_8BIT,
+           .DMATransferMode = DMA_ONE_SHOT_MODE
+          };
+
+   /* Mapping the DMA buffer to DMA accessible area and obtaining its base
address. */
+   out_address = dma_map_single(up->port.dev,(void
*)up->rx_dma.buf,up->rx_dma.size,DMA_FROM_DEVICE);
+   in_address = up->port.mapbase + (map_8250_in_reg(up,UART_RX));
+   size  = up->rx_fifo_size;
+   up->rx_dma.phy_addr = out_address;
+
+   /* Setting the DMA settings. */
+   (void)ioh_set_dma_mode(channel,mode);
+   (void)ioh_set_dma_addr(channel,in_address,out_address);
+   (void)ioh_set_dma_count(channel,size);
+   (void)ioh_dma_set_callback(channel,ioh_dma_rx_callback,(u32)up);
+  }
+
+  dma_flag = 1;
+
+#ifdef DEBUG
+  printk(KERN_DEBUG"serial8250_startup -> Buffer Allocation successful and
DMA " \
+    "channels obtained are Reception: %d Transmission: %d.\n", \
+    up->rx_dma.channel,up->tx_dma.channel);
+#endif
+ }
+#endif
+
  up->capabilities = uart_config[up->port.type].flags;
  up->mcr = 0;

@@ -1995,6 +2672,22 @@ static int serial8250_startup(struct uar
      (serial_inp(up, UART_LSR) == 0xff)) {
   printk(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
          serial_index(&up->port));
+
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ /* Releasing the DMA resources on failure.*/
+ if(dma_flag == 1 )
+ {
+  ioh_free_dma(up->rx_dma.channel);
+  ioh_free_dma(up->tx_dma.channel);
+  free_page(up->rx_dma.buf);
+  free_page(up->tx_dma.buf);
+  free_page(up->buffer);
+  up->rx_dma.buf = 0;
+  up->tx_dma.buf = 0;
+  up->buffer = 0;
+ }
+#endif
+
   return -ENODEV;
  }

@@ -2076,7 +2769,23 @@ static int serial8250_startup(struct uar
  } else {
   retval = serial_link_irq_chain(up);
   if (retval)
+  {
+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+  /* Releasing the DMA resources on failure.*/
+   if(dma_flag == 1 )
+   {
+    ioh_free_dma(up->rx_dma.channel);
+    ioh_free_dma(up->tx_dma.channel);
+    free_page(up->rx_dma.buf);
+    free_page(up->tx_dma.buf);
+    free_page(up->buffer);
+    up->rx_dma.buf = 0;
+    up->tx_dma.buf = 0;
+    up->buffer = 0;
+   }
+  #endif
    return retval;
+  }
  }

  /*
@@ -2171,6 +2880,31 @@ static void serial8250_shutdown(struct u
  struct uart_8250_port *up = (struct uart_8250_port *)port;
  unsigned long flags;

+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ /* Releasing the DMA resources on exit.*/
+ if((up->port.flags & UPF_IOH_UART ) != 0 )
+ {
+  if(up->rx_dma.channel >= 0)
+   ioh_free_dma(up->rx_dma.channel);
+  if(up->tx_dma.channel >= 0)
+   ioh_free_dma(up->tx_dma.channel);
+
+  if(up->rx_dma.buf)
+   free_page(up->rx_dma.buf);
+  if(up->tx_dma.buf)
+   free_page(up->tx_dma.buf);
+  if(up->buffer)
+   free_page(up->buffer);
+
+  up->rx_dma.buf = 0;
+  up->tx_dma.buf = 0;
+  up->buffer = 0;
+
+#ifdef DEBUG
+  printk(KERN_DEBUG"serial8250_shutdown -> DMA buffers and channels
released.\n");
+#endif
+ }
+#endif
  /*
   * Disable interrupts from this port
   */
@@ -2241,6 +2975,7 @@ serial8250_set_termios(struct uart_port
  unsigned char cval, fcr = 0;
  unsigned long flags;
  unsigned int baud, quot;
+ unsigned int bdrate;

  switch (termios->c_cflag & CSIZE) {
  case CS5:
@@ -2277,6 +3012,11 @@ serial8250_set_termios(struct uart_port
       port->uartclk / 16);
  quot = serial8250_get_divisor(port, baud);

+#ifdef DEBUG
+ printk(KERN_DEBUG "IOH UART LOG:max_baud: %d\n,baud :%d\n quot:%d\n"
+          ,max_baud,baud, quot);
+#endif
+
  /*
   * Oxford Semi 952 rev B workaround
   */
@@ -2285,11 +3025,42 @@ serial8250_set_termios(struct uart_port

  if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
   if (baud < 2400)
+   {
    fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
+
+#ifdef CONFIG_SERIAL_8250_IOH
+    if((up->port.flags & UPF_IOH_UART) !=0)
+    {
+               fcr |= UART_FCR7_64BYTE; /* This enables 256 byte FIFO for
UART 0.*/
+    }
+#endif
+   }
+
   else
    fcr = uart_config[up->port.type].fcr;
  }

+#if defined(CONFIG_SERIAL_8250_IOH) && defined(ENABLE_IOH_DMA_FEATURE)
+ /* Deciding whether to use DMA feature or not.*/
+ if ((baud >=38400) && ((up->port.flags & UPF_IOH_UART) !=0))
+ {
+  up->dma_enabled = 1;
+
+ }
+ else
+ {
+  up->dma_enabled = 0;
+ }
+
+
+ get_rx_fifo_size(up,fcr);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"serial8250_set_termios -> The Rx fifo size is:
%u\n",up->rx_fifo_size);
+#endif
+
+#endif
+
  /*
   * MCR-based auto flow control.  When AFE is enabled, RTS will be
   * deasserted when the receive FIFO contains more characters than
@@ -2408,8 +3179,22 @@ serial8250_set_termios(struct uart_port
  serial8250_set_mctrl(&up->port, up->port.mctrl);
  spin_unlock_irqrestore(&up->port.lock, flags);
  /* Don't rewrite B0 */
- if (tty_termios_baud_rate(termios))
+
+ bdrate = tty_termios_baud_rate(termios);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "tty_termios_baud_rate value:%d\n",bdrate);
+#endif
+
+ if (bdrate)
+ {
   tty_termios_encode_baud_rate(termios, baud, baud);
+
+#ifdef DEBUG
+  printk(KERN_DEBUG "termios->c_ispeed:%d\n,termios->c_ospeed:%d\n "
+        ,termios->c_ispeed,termios->c_ospeed );
+#endif
+ }
 }

 static void
@@ -2576,21 +3361,27 @@ static void serial8250_config_port(struc
   return;

  ret = serial8250_request_rsa_resource(up);
- if (ret < 0)
+ if (ret < 0){
   probeflags &= ~PROBE_RSA;
+ }

- if (up->port.iotype != up->cur_iotype)
+ if (up->port.iotype != up->cur_iotype){
   set_io_from_upio(port);
+ }

- if (flags & UART_CONFIG_TYPE)
+ if (flags & UART_CONFIG_TYPE){
   autoconfig(up, probeflags);
- if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
+ }
+ if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ){
   autoconfig_irq(up);
+ }

- if (up->port.type != PORT_RSA && probeflags & PROBE_RSA)
+ if (up->port.type != PORT_RSA && probeflags & PROBE_RSA){
   serial8250_release_rsa_resource(up);
- if (up->port.type == PORT_UNKNOWN)
+ }
+ if (up->port.type == PORT_UNKNOWN){
   serial8250_release_std_resource(up);
+ }
 }

 static int
@@ -2685,6 +3476,7 @@ static void __init serial8250_isa_init_p
   up->port.regshift = old_serial_port[i].iomem_reg_shift;
   set_io_from_upio(&up->port);
   up->port.irqflags |= irqflag;
+
  }
 }

diff -up a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c 2010-01-05 19:02:46.000000000 -0500
+++ b/drivers/serial/8250_pci.c 2010-02-04 18:15:27.000000000 -0500
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/pci_ids.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -30,6 +31,8 @@

 #undef SERIAL_DEBUG_PCI

+#define PCI_VENDOR_ID_IOH (0x8086)
+
 /*
  * init function returns:
  *  > 0 - number of ports
@@ -726,6 +729,83 @@ static int pci_ni8430_init(struct pci_de
 #define NI8430_PORTCON 0x0f
 #define NI8430_PORTCON_TXVR_ENABLE (1 << 3)

+#if defined(CONFIG_SERIAL_8250_IOH)
+
+static int
+pci_ioh_init(struct pci_dev *dev)
+{
+ int retval = 0;
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "IOH UART LOG:function pci_ioh_init invoked \n");
+
+ printk(KERN_DEBUG "IOH UART LOG:function pci_ioh_init->pci_enable_wake
invoked \n");
+#endif
+
+ /* disable Wake on UART */
+   pci_enable_wake(dev,PCI_D3hot,0);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "IOH UART LOG:function pci_ioh_init return =
%d\n",retval);
+#endif
+
+  return (retval);
+}
+
+static int
+pci_ioh_setup(struct serial_private *priv, const struct pciserial_board
*board,
+  struct uart_port *port, int idx)
+{
+ int retval = 1 ;
+ unsigned int bar = 0;
+ unsigned int offset = 0;
+
+ if (idx == 0)
+ {
+  /* IOH UART has only 1 channel per device */
+  switch (priv->dev->device)
+  {
+   case PCI_DEVICE_ID_IOH_UART0:
+     port->flags |= UPF_IOH_UART0;
+     break;
+
+   case PCI_DEVICE_ID_IOH_UART1:
+     port->flags |= UPF_IOH_UART1;
+     break;
+   case PCI_DEVICE_ID_IOH_UART2:
+     port->flags |= UPF_IOH_UART2;
+     break;
+   case PCI_DEVICE_ID_IOH_UART3:
+     port->flags |= UPF_IOH_UART3;
+     break;
+   default:
+    break;
+  }
+
+  retval=setup_port(priv, port, bar, offset, board->reg_shift);
+
+  #ifdef ENABLE_IOH_DMA_FEATURE
+   /* Obtaing the Memory Map base for DMA operations. */
+   port->mapbase = pci_resource_start(priv->dev,1);
+  #ifdef DEBUG
+   printk(KERN_DEBUG"pci_ioh_setup -> The Map Base has been obtained.\n");
+  #endif
+  #endif
+ }
+
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "pci_ioh_setup -> Function pci_ioh_setup invoked \n");
+ printk(KERN_DEBUG "pci_ioh_setup -> board.base_baud = %d, flags = %d,
num_ports = %d,reg_shift = %d\n",
+   board->base_baud,board->flags,board->num_ports,board->reg_shift);
+ printk(KERN_DEBUG "pci_ioh_setup -> port->flags =%x\n",port->flags);
+ printk(KERN_DEBUG "Function pci_ioh_setup return = %d\n",retval);
+
+#endif
+ return (retval);
+}
+#endif
+
 static int
 pci_ni8430_setup(struct serial_private *priv,
    const struct pciserial_board *board,
@@ -918,7 +998,8 @@ static int pci_oxsemi_tornado_init(struc
      (dev->device & 0xF000) != 0xC000)
   return 0;

- p = pci_iomap(dev, 0, 5);
+ //p = pci_iomap(dev, 0, 5);
+ p = pci_iomap(dev, 1, 5);
  if (p == NULL)
   return -ENOMEM;

@@ -1393,6 +1474,43 @@ static struct pci_serial_quirk pci_seria
   .setup  = pci_default_setup,
  },
  /*
+  * IOH UART
+  */
+#if defined(CONFIG_SERIAL_8250_IOH)
+ {
+  .vendor     = PCI_VENDOR_ID_IOH,
+  .device     = PCI_DEVICE_ID_IOH_UART0,
+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_ioh_init,
+  .setup      = pci_ioh_setup,
+ },
+ {
+  .vendor     = PCI_VENDOR_ID_IOH,
+  .device     = PCI_DEVICE_ID_IOH_UART1,
+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_ioh_init,
+  .setup      = pci_ioh_setup,
+ },
+ {
+  .vendor     = PCI_VENDOR_ID_IOH,
+  .device     = PCI_DEVICE_ID_IOH_UART2,
+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_ioh_init,
+  .setup      = pci_ioh_setup,
+ },
+ {
+  .vendor     = PCI_VENDOR_ID_IOH,
+  .device     = PCI_DEVICE_ID_IOH_UART3,
+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_ioh_init,
+  .setup      = pci_ioh_setup,
+ },
+#endif
+ /*
   * Default "match everything" terminator entry
   */
  {
@@ -1571,6 +1689,10 @@ enum pci_board_num_t {
  pbn_ADDIDATA_PCIe_2_3906250,
  pbn_ADDIDATA_PCIe_4_3906250,
  pbn_ADDIDATA_PCIe_8_3906250,
+#if defined(CONFIG_SERIAL_8250_IOH)
+ pbn_ioh_uart_8L_256FIFO,  /* ioh 8 Line UART with 256 byte FIFO */
+ pbn_ioh_uart_2L_64FIFO    /* ioh 2 Line UART with 64 byte FIFO */
+#endif
 };

 /*
@@ -2228,6 +2350,27 @@ static struct pciserial_board pci_boards
   .uart_offset = 0x200,
   .first_offset = 0x1000,
  },
+
+#if defined(CONFIG_SERIAL_8250_IOH)
+
+ /*
+  * IOH UART
+  */
+ [pbn_ioh_uart_8L_256FIFO] = {
+  .flags      = FL_BASE0,
+  .num_ports  = 1,
+  .base_baud  = 115200,  /* OKISEMI For LSI */
+  .reg_shift  = 0,
+ },
+
+ [pbn_ioh_uart_2L_64FIFO] = {
+  .flags      = FL_BASE0,
+  .num_ports  = 1,
+  .base_baud  = 115200,  /* OKISEMI For LSI*/
+  .reg_shift  = 0,
+ },
+#endif
+
 };

 static const struct pci_device_id softmodem_blacklist[] = {
@@ -2473,8 +2616,20 @@ pciserial_init_one(struct pci_dev *dev,
   return -EINVAL;
  }

+#ifdef DEBUG
+ printk(KERN_DEBUG "IOH UART LOG:function pciserial_init_one ent->vendor"
+        " = %x\n, ent->device = %x, ent->driver_data = %ld\n  ",
+        ent->vendor, ent->device, ent->driver_data);
+#endif
+
  board = &pci_boards[ent->driver_data];

+#ifdef DEBUG
+ printk(KERN_DEBUG "IOH UART LOG:function pciserial_init_one board->"
+       "base_baud = %u\n, board->flags = %d, board->num_ports = %d\n "
+       , board->base_baud,board->flags, board->num_ports);
+#endif
+
  rc = pci_enable_device(dev);
  if (rc)
   return rc;
@@ -2540,6 +2695,17 @@ static int pciserial_suspend_one(struct
  if (priv)
   pciserial_suspend_ports(priv);

+#if defined(CONFIG_SERIAL_8250_IOH)
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "IOH UART LOG:pciserial_suspend_one->pci_enable_wake"
+       "invoked \n");
+#endif
+
+
+ pci_enable_wake(dev, PCI_D3hot, 1);
+#endif
+
  pci_save_state(dev);
  pci_set_power_state(dev, pci_choose_state(dev, state));
  return 0;
@@ -2561,6 +2727,17 @@ static int pciserial_resume_one(struct p
   /* FIXME: We cannot simply error out here */
   if (err)
    printk(KERN_ERR "pciserial: Unable to re-enable ports, trying to
continue.\n");
+
+#if defined(CONFIG_SERIAL_8250_IOH)
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "IOH UART LOG:pciserial_resume_one->pci_enable_wake"
+       "invoked \n");
+#endif
+
+ pci_enable_wake(dev, PCI_D3hot, 0);
+#endif
+
   pciserial_resume_ports(priv);
  }
  return 0;
@@ -3649,6 +3826,44 @@ static struct pci_device_id serial_pci_t
   0, 0, pbn_b0_1_115200 },

  /*
+  * IOH UART
+  */
+#if defined(CONFIG_SERIAL_8250_IOH)
+
+ {   PCI_VENDOR_ID_IOH,
+  PCI_DEVICE_ID_IOH_UART0,  /*device id for ioh uart with 8 i/o lines and
256 byte fifo. */
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_ioh_uart_8L_256FIFO },
+
+ {   PCI_VENDOR_ID_IOH,
+  PCI_DEVICE_ID_IOH_UART1,  /*device id for ioh uart with 2 i/o lines and
256 byte fifo. */
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_ioh_uart_2L_64FIFO },
+
+ {   PCI_VENDOR_ID_IOH,
+  PCI_DEVICE_ID_IOH_UART2,  /*device id for ioh uart with 8 i/o lines and
64 byte fifo. */
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_ioh_uart_2L_64FIFO },
+
+ {   PCI_VENDOR_ID_IOH,
+  PCI_DEVICE_ID_IOH_UART3,  /*device id for ioh uart with 2 i/o lines and
64 byte fifo. */
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_ioh_uart_2L_64FIFO },
+#endif
+
+ /*
   * These entries match devices with class COMMUNICATION_SERIAL,
   * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
   */
Common subdirectories: a/drivers/serial/cpm_uart and
b/drivers/serial/cpm_uart
Common subdirectories: a/drivers/serial/jsm and b/drivers/serial/jsm
diff -up a/drivers/serial/Kconfig b/drivers/serial/Kconfig
--- a/drivers/serial/Kconfig 2010-01-05 19:02:46.000000000 -0500
+++ b/drivers/serial/Kconfig 2010-02-04 18:15:27.000000000 -0500
@@ -89,6 +89,14 @@ config SERIAL_8250_PCI
    disable this feature if you only need legacy serial support.
    Saves about 9K.

+config SERIAL_8250_IOH
+ tristate "IOH PCI serial device support"
+ depends on SERIAL_8250 && PCI && SERIAL_8250_PCI
+ default SERIAL_8250_PCI
+ help
+   This makes the PCI serial driver to support high speed IOH serial ports.
+
+
 config SERIAL_8250_PNP
  tristate "8250/16550 PNP device support" if EMBEDDED
  depends on SERIAL_8250 && PNP
diff -up a/drivers/serial/Makefile b/drivers/serial/Makefile
--- a/drivers/serial/Makefile 2010-01-05 19:02:46.000000000 -0500
+++ b/drivers/serial/Makefile 2010-02-04 18:15:27.000000000 -0500
@@ -1,6 +1,10 @@
 #
 # Makefile for the kernel serial device drivers.
 #
+#
+#This is needed to enable ioh dma#
+EXTRA_CFLAGS +=-DENABLE_IOH_DMA_FEATURE
+EXTRA_CFLAGS +=-DCONFIG_SERIAL_8250_IOH

 obj-$(CONFIG_SERIAL_CORE) += serial_core.o
 obj-$(CONFIG_SERIAL_21285) += 21285.o
diff -up a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c 2010-01-05 19:02:46.000000000 -0500
+++ b/drivers/serial/serial_core.c 2010-02-04 18:15:27.000000000 -0500
@@ -2197,6 +2197,7 @@ uart_configure_port(struct uart_driver *
   * is expected to claim the resources and map the port for us.
   */
  flags = 0;
+
  if (port->flags & UPF_AUTO_IRQ)
   flags |= UART_CONFIG_IRQ;
  if (port->flags & UPF_BOOT_AUTOCONF) {
@@ -2486,6 +2487,7 @@ int uart_add_one_port(struct uart_driver
   printk(KERN_ERR "Cannot register tty device on line %d\n",
          uport->line);

+
  /*
   * Ensure UPF_DEAD is not set.
   */

