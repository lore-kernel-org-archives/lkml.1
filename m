Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZIAO6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZIAO6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZIAO6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:58:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60508 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbZIAO6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:58:09 -0400
From: "Pandita, Vikram" <vikram.pandita@ti.com>
To: Govindraj <govindraj.ti@gmail.com>, HU TAO-TGHK48 <taohu@motorola.com>
CC: vimal singh <vimal.newwork@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       Chen Xiaolong-A21785 <A21785@motorola.com>
Date: Tue, 1 Sep 2009 20:28:00 +0530
Subject: RE: [RFC][PATCH]: Adding support for omap-serail driver
Thread-Topic: [RFC][PATCH]: Adding support for omap-serail driver
Thread-Index: Acoq1BeXw52jxpBaQ26uuf5BwmE50AAP+pDg
Message-ID: <FCCFB4CDC6E5564B9182F639FC35608702F9AF18DC@dbde02.ent.ti.com>
References: <ce9ab5790908280649n77765dedm9161316a181b6a07@mail.gmail.com>
	 <F12CE1A68F023D498A2691C7B539311503935B24@ZMY16EXM66.ds.mot.com>
 <d6a0f7aa0909010013n2c9334cdt56afa642e2a0617@mail.gmail.com>
In-Reply-To: <d6a0f7aa0909010013n2c9334cdt56afa642e2a0617@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

govindraj

>-----Original Message-----
>From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of
>Govindraj
>Sent: Tuesday, September 01, 2009 2:14 AM
>To: HU TAO-TGHK48
>Cc: vimal singh; linux-omap@vger.kernel.org; LKML; linux-serial@vger.kernel.org; Ye Yuan.Bo-A22116;
>Chen Xiaolong-A21785
>Subject: Re: [RFC][PATCH]: Adding support for omap-serail driver
>
>On Mon, Aug 31, 2009 at 5:20 PM, HU TAO-TGHK48<taohu@motorola.com> wrote:
>>
>> 1. Shall we cleanup PM related stuff in arch/arm/mach-omap2/serial.c as
>> well?
>>    Originally serail.c register UART IRQ  to decide if UART idle for a
>> while and is able to enter low power mode (e.g. retention).
>>    To work with original 8250 driver, it is probably the only way since
>> 8250 is not aware of OMAP PM.
>>
>>    However  it would be more reasonable to merge PM stuff to
>> omap-serial.c. since the new driver is already OMAP specific
>>
>> 2. There is an issue for DMA  with current implementation in serial.c
>>    When Rx DMA is active NO Rx IRQ will be generated.
>>    So serial.c will easily set uart->can_sleep with "1" even there is
>> Rx DMA ongoing
>>    +   if ((iir & 0x4) && up->use_dma) {
>>    +           up->ier &= ~UART_IER_RDI;
>>    +           serial_out(up, UART_IER, up->ier
>>
>>   In my view, the best way is to do the idle detection in
>> omap_serial.c.
>
>Yes I understand that we cannot adapt 8250 PM model for omap-serial
>driver in DMA mode I am currently working on that adaption with dma
>mode and will be posting a separate patch for changes on serial.c.
>
>Wouldn't it be cleaner to inherit and adapt the Serial-PM framework
>from serial.c rather than redefining the PM changes in the driver.
>
>As Serial-PM framework already has support for interrupt mode and we
>have to adapt the same for DMA  mode.
>
>Also defining PM changes in omap-serial would need changes in PM framework.
>As PM framework calls functions from serail.c file if we are defining
>PM framework in our driver then we may need to redefine the functions
>as in serial.c or modify the PM-framework for uart-activity check.
>I feel adapting the existing serial-PM framework for DMA mode would be
>better rather than
>doing these changes.

You can take reference of how to integrate omap-serial driver PM 
with mach-omap2/serial.c as follows, for reference --- 


---
>From 69112426bd6009cb11e104b9aafcc65429d662f0 Mon Sep 17 00:00:00 2001
From: Vikram Pandita <vikram.pandita@ti.com>
Date: Fri, 21 Aug 2009 11:15:58 -0500
Subject: [RFC PATCH] OMAP: Serial: Keep uart in no idle mode when DMA ongoing

Keep UART in NoIdle mode when DMA is going on.

Only once UART transfers are complete, switch to smart idle and
allow OsIdle to kick in

Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
---
 arch/arm/mach-omap2/serial.c |   12 ++++++++++++
 drivers/serial/omap-serial.c |    2 +-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index ff9beb7..a6ee6ab 100755
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -359,9 +359,21 @@ static void omap_uart_allow_sleep(struct omap_uart_state *uart)
 	del_timer(&uart->timer);
 }
 
+extern int are_driveromap_uarts_active(int *);
+
 static void omap_uart_idle_timer(unsigned long data)
 {
 	struct omap_uart_state *uart = (struct omap_uart_state *)data;
+	int dummy;
+
+	if (are_driveromap_uarts_active(&dummy)){
+		/* Keep UART on NoIdle when DMA channel is enabled in omap
+		 * serial: do not allow UART to goto Smart-idle till its done
+		 * dma'ing
+		 */
+		omap_uart_block_sleep(uart);
+		return;
+	}
 
 	omap_uart_allow_sleep(uart);
 }
diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 938f29f..f105e24 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -1641,6 +1641,7 @@ int omap24xx_uart_cts_wakeup(int uart_no, int state)
 	return 0;
 }
 EXPORT_SYMBOL(omap24xx_uart_cts_wakeup);
+#endif
 /**
  * are_driver8250_uarts_active() - Check if any ports managed by this
  * driver are currently busy.  This should be called with interrupts
@@ -1709,7 +1710,6 @@ int are_driveromap_uarts_active(int *driver8250_managed)
 }
 EXPORT_SYMBOL(are_driveromap_uarts_active);
 
-#endif
 
 static void serial_omap_display_reg(struct uart_port *port)
 {
-- 
1.6.3.3.334.g916e1


