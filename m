Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZKVXk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZKVXk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 18:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZKVXk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 18:40:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:40286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbZKVXk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 18:40:26 -0500
Date: Sun, 22 Nov 2009 15:42:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@linux.intel.com
Subject: Re: [patch] timer: Add a mod_timer_msec() API function
Message-ID: <20091122154220.59dc9ac0@infradead.org>
In-Reply-To: <20091122154111.197e1a8a@infradead.org>
References: <20091122154111.197e1a8a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of the new API;

these will be split up and sent to the various maintainers
once there is agreement on the API; for now this is just to
show how the API will be used.




diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d8f2145..758d1ce 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1373,7 +1373,7 @@ static void ahci_sw_activity(struct ata_link *link)
 
 	emp->activity++;
 	if (!timer_pending(&emp->timer))
-		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
+		mod_timer_msec(&emp->timer, 10, 1);
 }
 
 static void ahci_sw_activity_blink(unsigned long arg)
@@ -1409,7 +1409,7 @@ static void ahci_sw_activity_blink(unsigned long arg)
 
 		/* toggle state */
 		led_message |= (activity_led_state << 16);
-		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(100));
+		mod_timer_msec(&emp->timer, 100, 5);
 	} else {
 		/* switch to idle */
 		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index b0e569b..54005e2 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -188,13 +188,13 @@ static void bluecard_enable_activity_led(bluecard_info_t *info)
 		outb(0x10 | 0x40, iobase + 0x30);
 
 		/* Stop the LED after HZ/4 */
-		mod_timer(&(info->timer), jiffies + HZ / 4);
+		mod_timer_msec(&(info->timer), 250, 20);
 	} else {
 		/* Enable power LED */
 		outb(0x08 | 0x20, iobase + 0x30);
 
 		/* Stop the LED after HZ/2 */
-		mod_timer(&(info->timer), jiffies + HZ / 2);
+		mod_timer_msec(&(info->timer), 500, 40);
 	}
 }
 
diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 40aec0f..5c2189f 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -312,7 +312,7 @@ static struct sk_buff *bcsp_dequeue(struct hci_uart *hu)
 		struct sk_buff *nskb = bcsp_prepare_pkt(bcsp, skb->data, skb->len, bt_cb(skb)->pkt_type);
 		if (nskb) {
 			__skb_queue_tail(&bcsp->unack, skb);
-			mod_timer(&bcsp->tbcsp, jiffies + HZ / 4);
+			mod_timer_msec(&bcsp->tbcsp, 250, 20);
 			spin_unlock_irqrestore(&bcsp->unack.lock, flags);
 			return nskb;
 		} else {
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 426bfdd..cc9e7b4 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -506,7 +506,7 @@ unlock:
 	spin_unlock_irqrestore(&isi_card[card].card_lock, flags);
 	/*	schedule another tx for hopefully in about 10ms	*/
 sched_again:
-	mod_timer(&tx, jiffies + msecs_to_jiffies(10));
+	mod_timer_msec(&tx, 10, 0);
 }
 
 /*
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index dd0083b..4ad6113 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -869,7 +869,7 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 	spin_lock_bh(&moxa_lock);
 	brd->ready = 1;
 	if (!timer_pending(&moxaTimer))
-		mod_timer(&moxaTimer, jiffies + HZ / 50);
+		mod_timer_msec(&moxaTimer, 20, 0);
 	spin_unlock_bh(&moxa_lock);
 
 	return 0;
@@ -1556,7 +1556,7 @@ static void moxa_poll(unsigned long ignored)
 	moxaLowWaterChk = 0;
 
 	if (served)
-		mod_timer(&moxaTimer, jiffies + HZ / 50);
+		mod_timer_msec(&moxaTimer, 20, 0);
 	spin_unlock(&moxa_lock);
 }
 
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 4846b73..63d5b70 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -4024,7 +4024,7 @@ static bool load_next_tx_holding_buffer(struct mgsl_struct *info)
 				info->get_tx_holding_index=0;
 
 			/* restart transmit timer */
-			mod_timer(&info->tx_timer, jiffies + msecs_to_jiffies(5000));
+			mod_timer_msec(&info->tx_timer, 5000, 100);
 
 			ret = true;
 		}
@@ -5653,8 +5653,7 @@ static void usc_start_transmitter( struct mgsl_struct *info )
 			
 			usc_TCmd( info, TCmd_SendFrame );
 			
-			mod_timer(&info->tx_timer, jiffies +
-					msecs_to_jiffies(5000));
+			mod_timer_msec(&info->tx_timer, 5000, 100);
 		}
 		info->tx_active = true;
 	}
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 8678f0c..58402a0 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -803,7 +803,7 @@ static void update_tx_timer(struct slgt_info *info)
 	 */
 	if (info->params.mode == MGSL_MODE_HDLC) {
 		int timeout  = (tbuf_bytes(info) * 7) + 1000;
-		mod_timer(&info->tx_timer, jiffies + msecs_to_jiffies(timeout));
+		mod_timer_msec(&info->tx_timer, timeout, 0);
 	}
 }
 
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index 2b18adc..b032af6 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -2685,7 +2685,7 @@ static int startup(SLMP_INFO * info)
 
 	change_params(info);
 
-	mod_timer(&info->status_timer, jiffies + msecs_to_jiffies(10));
+	mod_timer_msec(&info->status_timer, 10, 0);
 
 	if (info->port.tty)
 		clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
@@ -4252,8 +4252,7 @@ static void tx_start(SLMP_INFO *info)
 			write_reg(info, TXDMA + DIR, 0x40);		/* enable Tx DMA interrupts (EOM) */
 			write_reg(info, TXDMA + DSR, 0xf2);		/* clear Tx DMA IRQs, enable Tx DMA */
 	
-			mod_timer(&info->tx_timer, jiffies +
-					msecs_to_jiffies(5000));
+			mod_timer_msec(&info->tx_timer, 5000, 100);
 		}
 		else {
 			tx_load_fifo(info);
@@ -5534,7 +5533,7 @@ static void status_timeout(unsigned long context)
 	if (status)
 		isr_io_pin(info,status);
 
-	mod_timer(&info->status_timer, jiffies + msecs_to_jiffies(10));
+	mod_timer_msec(&info->status_timer, 10, 0);
 }
 
 
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index ac11be0..8b391b2 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -147,7 +147,7 @@ void gameport_start_polling(struct gameport *gameport)
 	if (!gameport->poll_cnt++) {
 		BUG_ON(!gameport->poll_handler);
 		BUG_ON(!gameport->poll_interval);
-		mod_timer(&gameport->poll_timer, jiffies + msecs_to_jiffies(gameport->poll_interval));
+		mod_timer_msec(&gameport->poll_timer, gameport->poll_interval, 0);
 	}
 
 	spin_unlock(&gameport->timer_lock);
@@ -171,7 +171,7 @@ static void gameport_run_poll_handler(unsigned long d)
 
 	gameport->poll_handler(gameport);
 	if (gameport->poll_cnt)
-		mod_timer(&gameport->poll_timer, jiffies + msecs_to_jiffies(gameport->poll_interval));
+		mod_timer_msec(&gameport->poll_timer, gameport->poll_interval, 0);
 }
 
 /*
diff --git a/drivers/input/keyboard/corgikbd.c b/drivers/input/keyboard/corgikbd.c
index 634af6a..d49846f 100644
--- a/drivers/input/keyboard/corgikbd.c
+++ b/drivers/input/keyboard/corgikbd.c
@@ -179,7 +179,7 @@ static void corgikbd_scankeyboard(struct corgikbd *corgikbd_data)
 
 	/* if any keys are pressed, enable the timer */
 	if (num_pressed)
-		mod_timer(&corgikbd_data->timer, jiffies + msecs_to_jiffies(SCAN_INTERVAL));
+		mod_timer_msec(&corgikbd_data->timer, SCAN_INTERVAL, 0);
 
 	spin_unlock_irqrestore(&corgikbd_data->lock, flags);
 }
@@ -249,7 +249,7 @@ static void corgikbd_hinge_timer(unsigned long data)
 			spin_unlock_irqrestore(&corgikbd_data->lock, flags);
 		}
 	}
-	mod_timer(&corgikbd_data->htimer, jiffies + msecs_to_jiffies(HINGE_SCAN_INTERVAL));
+	mod_timer_msec(&corgikbd_data->htimer, HINGE_SCAN_INTERVAL, 0);
 }
 
 #ifdef CONFIG_PM
@@ -341,7 +341,7 @@ static int __devinit corgikbd_probe(struct platform_device *pdev)
 	if (err)
 		goto fail;
 
-	mod_timer(&corgikbd->htimer, jiffies + msecs_to_jiffies(HINGE_SCAN_INTERVAL));
+	mod_timer_msec(&corgikbd->htimer, HINGE_SCAN_INTERVAL, 0);
 
 	/* Setup sense interrupts - RisingEdge Detect, sense lines as inputs */
 	for (i = 0; i < CORGI_KEY_SENSE_NUM; i++) {
diff --git a/drivers/input/keyboard/spitzkbd.c b/drivers/input/keyboard/spitzkbd.c
index 1396742..c64e4d0 100644
--- a/drivers/input/keyboard/spitzkbd.c
+++ b/drivers/input/keyboard/spitzkbd.c
@@ -228,7 +228,7 @@ static void spitzkbd_scankeyboard(struct spitzkbd *spitzkbd_data)
 
 	/* if any keys are pressed, enable the timer */
 	if (num_pressed)
-		mod_timer(&spitzkbd_data->timer, jiffies + msecs_to_jiffies(SCAN_INTERVAL));
+		mod_timer_msec(&spitzkbd_data->timer, SCAN_INTERVAL, 0);
 
 	spin_unlock_irqrestore(&spitzkbd_data->lock, flags);
 }
@@ -269,7 +269,7 @@ static irqreturn_t spitzkbd_hinge_isr(int irq, void *dev_id)
 	struct spitzkbd *spitzkbd_data = dev_id;
 
 	if (!timer_pending(&spitzkbd_data->htimer))
-		mod_timer(&spitzkbd_data->htimer, jiffies + msecs_to_jiffies(HINGE_SCAN_INTERVAL));
+		mod_timer_msec(&spitzkbd_data->htimer, HINGE_SCAN_INTERVAL, 0);
 
 	return IRQ_HANDLED;
 }
@@ -303,7 +303,7 @@ static void spitzkbd_hinge_timer(unsigned long data)
 
 		spin_unlock_irqrestore(&spitzkbd_data->lock, flags);
 	} else {
-		mod_timer(&spitzkbd_data->htimer, jiffies + msecs_to_jiffies(HINGE_SCAN_INTERVAL));
+		mod_timer_msec(&spitzkbd_data->htimer, HINGE_SCAN_INTERVAL, 0);
 	}
 }
 
@@ -399,7 +399,7 @@ static int __devinit spitzkbd_probe(struct platform_device *dev)
 	if (err)
 		goto fail;
 
-	mod_timer(&spitzkbd->htimer, jiffies + msecs_to_jiffies(HINGE_SCAN_INTERVAL));
+	mod_timer_msec(&spitzkbd->htimer, HINGE_SCAN_INTERVAL, 0);
 
 	/* Setup sense interrupts - RisingEdge Detect, sense lines as inputs */
 	for (i = 0; i < SPITZ_KEY_SENSE_NUM; i++) {
diff --git a/drivers/input/touchscreen/corgi_ts.c b/drivers/input/touchscreen/corgi_ts.c
index 94a1919..031ca5c 100644
--- a/drivers/input/touchscreen/corgi_ts.c
+++ b/drivers/input/touchscreen/corgi_ts.c
@@ -199,10 +199,10 @@ static void ts_interrupt_main(struct corgi_ts *corgi_ts, int isTimer)
 			corgi_ts->pendown = 1;
 			new_data(corgi_ts);
 		}
-		mod_timer(&corgi_ts->timer, jiffies + HZ / 100);
+		mod_timer_msec(&corgi_ts->timer, 10, 0);
 	} else {
 		if (corgi_ts->pendown == 1 || corgi_ts->pendown == 2) {
-			mod_timer(&corgi_ts->timer, jiffies + HZ / 100);
+			mod_timer_msec(&corgi_ts->timer, 10, 0);
 			corgi_ts->pendown++;
 			return;
 		}
diff --git a/drivers/input/touchscreen/w90p910_ts.c b/drivers/input/touchscreen/w90p910_ts.c
index 6ccbdbb..a39e07e 100644
--- a/drivers/input/touchscreen/w90p910_ts.c
+++ b/drivers/input/touchscreen/w90p910_ts.c
@@ -133,7 +133,7 @@ static irqreturn_t w90p910_ts_interrupt(int irq, void *dev_id)
 	case TS_WAIT_Y_COORD:
 		w90p910_report_event(w90p910_ts, true);
 		w90p910_prepare_next_packet(w90p910_ts);
-		mod_timer(&w90p910_ts->timer, jiffies + msecs_to_jiffies(100));
+		mod_timer_msec(&w90p910_ts->timer, 100, 0);
 		break;
 
 	case TS_IDLE:
diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index 33dcd8d..83cd958 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -179,7 +179,7 @@ static void timer_tick(unsigned long data)
 			timeout = 1;
 
 	if (cs->running) {
-		mod_timer(&cs->timer, jiffies + msecs_to_jiffies(GIG_TICK));
+		mod_timer_msec(&cs->timer, GIG_TICK, 0);
 		if (timeout) {
 			gig_dbg(DEBUG_CMD, "scheduling timeout");
 			tasklet_schedule(&cs->event_tasklet);
diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
index ec099fc..0667bf4 100644
--- a/drivers/leds/ledtrig-ide-disk.c
+++ b/drivers/leds/ledtrig-ide-disk.c
@@ -29,7 +29,7 @@ void ledtrig_ide_activity(void)
 {
 	ide_activity++;
 	if (!timer_pending(&ledtrig_ide_timer))
-		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
+		mod_timer_msec(&ledtrig_ide_timer, 10, 0);
 }
 EXPORT_SYMBOL(ledtrig_ide_activity);
 
@@ -39,7 +39,7 @@ static void ledtrig_ide_timerfunc(unsigned long data)
 		ide_lastactivity = ide_activity;
 		/* INT_MAX will set each LED to its maximum brightness */
 		led_trigger_event(ledtrig_ide, INT_MAX);
-		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
+		mod_timer_msec(&ledtrig_ide_timer, 10, 0);
 	} else {
 		led_trigger_event(ledtrig_ide, LED_OFF);
 	}
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 3b83406..d136ad5 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -61,7 +61,7 @@ static void led_timer_function(unsigned long data)
 
 	led_set_brightness(led_cdev, brightness);
 
-	mod_timer(&timer_data->timer, jiffies + msecs_to_jiffies(delay));
+	mod_timer_msec(&timer_data->timer, delay, 0);
 }
 
 static ssize_t led_delay_on_show(struct device *dev,
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index b5c6813..9ec51a7 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -182,7 +182,7 @@ static void msp430_ir_interrupt(unsigned long data)
 		budget_ci->ir.last_raw = raw;
 	}
 
-	mod_timer(&budget_ci->ir.timer_keyup, jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT));
+	mod_timer_msec(&budget_ci->ir.timer_keyup, IR_KEYPRESS_TIMEOUT, 0);
 }
 
 static int msp430_ir_init(struct budget_ci *budget_ci)
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index ebd51af..6448149 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -141,7 +141,7 @@ static void bttv_input_timer(unsigned long data)
 		ir_enltv_handle_key(btv);
 	else
 		ir_handle_key(btv);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+	mod_timer_msec(&ir->timer, ir->polling, 0);
 }
 
 /* ---------------------------------------------------------------*/
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 48f22fa..4101a06 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -147,7 +147,7 @@ static void cx231xx_ir_work(struct work_struct *work)
 	struct cx231xx_IR *ir = container_of(work, struct cx231xx_IR, work);
 
 	cx231xx_ir_handle_key(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+	mod_timer_msec(&ir->timer, ir->polling, 0);
 }
 
 void cx231xx_ir_start(struct cx231xx_IR *ir)
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index a0e8c62..a45510c 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -358,7 +358,7 @@ static void saa7134_input_timer(unsigned long data)
 	struct card_ir *ir = dev->remote;
 
 	build_key(dev);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+	mod_timer_msec(&ir->timer, ir->polling, 0);
 }
 
 void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
@@ -941,7 +941,7 @@ static void nec_task(unsigned long data)
 		dprintk("Repeat last key\n");
 
 	/* Keep repeating the last key */
-	mod_timer(&ir->timer_keyup, jiffies + msecs_to_jiffies(150));
+	mod_timer_msec(&ir->timer_keyup, 150, 0);
 
 	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
 }
diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 0869baf..47c58c8 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -329,7 +329,7 @@ static int chip_thread(void *data)
 			desc->setmode(chip, V4L2_TUNER_MODE_MONO);
 
 		/* schedule next check */
-		mod_timer(&chip->wt, jiffies+msecs_to_jiffies(2000));
+		mod_timer_msec(&chip->wt, 2000, 100);
 	}
 
 	v4l2_dbg(1, debug, sd, "thread exiting\n");
@@ -1893,7 +1893,7 @@ static int tvaudio_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *fr
 		desc->setmode(chip, V4L2_TUNER_MODE_MONO);
 		if (chip->prevmode != V4L2_TUNER_MODE_MONO)
 			chip->prevmode = -1; /* reset previous mode */
-		mod_timer(&chip->wt, jiffies+msecs_to_jiffies(2000));
+		mod_timer_msec(&chip->wt, 2000, 100);
 	}
 	return 0;
 }
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fc25586..b1255c3 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1471,7 +1471,7 @@ static irqreturn_t atmci_detect_interrupt(int irq, void *dev_id)
 	 * middle of the timer routine when this interrupt triggers.
 	 */
 	disable_irq_nosync(irq);
-	mod_timer(&slot->detect_timer, jiffies + msecs_to_jiffies(20));
+	mod_timer_msec(&slot->detect_timer, 20, 0);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 89bf8cd..2f60f5d 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -906,7 +906,7 @@ static void wbsd_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			 * We cannot resume card detection immediatly
 			 * because of capacitance and delays in the chip.
 			 */
-			mod_timer(&host->ignore_timer, jiffies + HZ / 100);
+			mod_timer_msec(&host->ignore_timer, 10, 0);
 		}
 	}
 	wbsd_write_index(host, WBSD_IDX_SETUP, setup);
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 0dd7839..ba3a0c2 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -4309,7 +4309,7 @@ s2io_alarm_handle(unsigned long data)
 	struct net_device *dev = sp->dev;
 
 	s2io_handle_errors(dev);
-	mod_timer(&sp->alarm_timer, jiffies + HZ / 2);
+	mod_timer_msec(&sp->alarm_timer, 500, 0);
 }
 
 static irqreturn_t s2io_msix_ring_handle(int irq, void *dev_id)
@@ -5483,7 +5483,7 @@ static void s2io_phy_id(unsigned long data)
 		writeq(val64, &bar0->adapter_control);
 	}
 
-	mod_timer(&sp->id_timer, jiffies + HZ / 2);
+	mod_timer_msec(&sp->id_timer, 500, 0);
 }
 
 /**
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 8e1a55d..616de6d 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -551,7 +551,7 @@ static void at76_ledtrig_tx_timerfunc(unsigned long data)
 	if (tx_lastactivity != tx_activity) {
 		tx_lastactivity = tx_activity;
 		led_trigger_event(ledtrig_tx, LED_FULL);
-		mod_timer(&ledtrig_tx_timer, jiffies + HZ / 4);
+		mod_timer_msec(&ledtrig_tx_timer, 250, 0);
 	} else
 		led_trigger_event(ledtrig_tx, LED_OFF);
 }
@@ -560,7 +560,7 @@ static void at76_ledtrig_tx_activity(void)
 {
 	tx_activity++;
 	if (!timer_pending(&ledtrig_tx_timer))
-		mod_timer(&ledtrig_tx_timer, jiffies + HZ / 4);
+		mod_timer_msec(&ledtrig_tx_timer, 250, 0);
 }
 
 static int at76_remap(struct usb_device *udev)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 52bed89..e0bb24e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -416,7 +416,7 @@ set_timer:
 	if (!sc->ani.caldone)
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
-	mod_timer(&sc->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
+	mod_timer_msec(&sc->ani.timer, cal_interval, 0);
 }
 
 static void ath_start_ani(struct ath_softc *sc)
@@ -427,8 +427,7 @@ static void ath_start_ani(struct ath_softc *sc)
 	sc->ani.shortcal_timer = timestamp;
 	sc->ani.checkani_timer = timestamp;
 
-	mod_timer(&sc->ani.timer,
-		  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
+	mod_timer_msec(&sc->ani.timer, ATH_ANI_POLLINTERVAL, 0);
 }
 
 /*
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 1840a05..7efee46 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2703,7 +2703,7 @@ static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 	deferred_flush[iommu_id].next++;
 
 	if (!timer_on) {
-		mod_timer(&unmap_timer, jiffies + msecs_to_jiffies(10));
+		mod_timer_msec(&unmap_timer, 10, 0);
 		timer_on = 1;
 	}
 	list_size++;
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 6f2be5a..d7e26d4 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -558,7 +558,7 @@ bfad_bfa_tmo(unsigned long data)
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	}
 
-	mod_timer(&bfad->hal_tmo, jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+	mod_timer_msec(&bfad->hal_tmo, BFA_TIMER_FREQ, 0);
 }
 
 void
@@ -568,7 +568,7 @@ bfad_init_timer(struct bfad_s *bfad)
 	bfad->hal_tmo.function = bfad_bfa_tmo;
 	bfad->hal_tmo.data = (unsigned long)bfad;
 
-	mod_timer(&bfad->hal_tmo, jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+	mod_timer_msec(&bfad->hal_tmo, BFA_TIMER_FREQ, 0);
 }
 
 int
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index c1d5be4..6941151 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -838,7 +838,7 @@ static void process_act_open_rpl(struct s3_conn *c3cn, struct sk_buff *skb)
 	if (rpl->status == CPL_ERR_CONN_EXIST &&
 	    c3cn->retry_timer.function != act_open_retry_timer) {
 		c3cn->retry_timer.function = act_open_retry_timer;
-		if (!mod_timer(&c3cn->retry_timer, jiffies + HZ / 2))
+		if (!mod_timer_msec(&c3cn->retry_timer, 500, 0))
 			c3cn_hold(c3cn);
 	} else
 		fail_act_open(c3cn, act_open_rpl_status_to_errno(rpl->status));
diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 48aa30a..c4a03be 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -397,7 +397,7 @@ int usbdrv_open(struct net_device *dev)
 
     zfLnxCreateThread(dev);
 
-    mod_timer(&(macp->hbTimer10ms), jiffies + (1*HZ)/100);   //10 ms
+    mod_timer_msec(&(macp->hbTimer10ms), 10, 0);
 
     netif_carrier_on(dev);
 
@@ -711,7 +711,7 @@ void zfLnx10msTimer(struct net_device* dev)
 {
     struct usbdrv_private *macp = dev->ml_priv;
 
-    mod_timer(&(macp->hbTimer10ms), jiffies + (1*HZ)/100);   //10 ms
+    mod_timer_msec(&(macp->hbTimer10ms), 10, 0);
     zfiHeartBeat(dev);
     return;
 }
diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 3e86240..375cf55 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -582,7 +582,7 @@ static void speedtch_status_poll(unsigned long data)
 
 	/* The following check is racy, but the race is harmless */
 	if (instance->poll_delay < MAX_POLL_DELAY)
-		mod_timer(&instance->status_checker.timer, jiffies + msecs_to_jiffies(instance->poll_delay));
+		mod_timer_msec(&instance->status_checker.timer, instance->poll_delay, 0);
 	else
 		atm_warn(instance->usbatm, "Too many failures - disabling line status polling\n");
 }
@@ -601,7 +601,7 @@ static void speedtch_resubmit_int(unsigned long data)
 			schedule_delayed_work(&instance->status_checker, 0);
 		else {
 			atm_dbg(instance->usbatm, "%s: usb_submit_urb failed with result %d\n", __func__, ret);
-			mod_timer(&instance->resubmit_timer, jiffies + msecs_to_jiffies(RESUBMIT_DELAY));
+			mod_timer_msec(&instance->resubmit_timer, RESUBMIT_DELAY, 0);
 		}
 	}
 }
@@ -654,7 +654,7 @@ static void speedtch_handle_int(struct urb *int_urb)
 
 fail:
 	if ((int_urb = instance->int_urb))
-		mod_timer(&instance->resubmit_timer, jiffies + msecs_to_jiffies(RESUBMIT_DELAY));
+		mod_timer_msec(&instance->resubmit_timer, RESUBMIT_DELAY, 0);
 }
 
 static int speedtch_atm_start(struct usbatm_data *usbatm, struct atm_dev *atm_dev)
@@ -688,7 +688,7 @@ static int speedtch_atm_start(struct usbatm_data *usbatm, struct atm_dev *atm_de
 	}
 
 	/* Start status polling */
-	mod_timer(&instance->status_checker.timer, jiffies + msecs_to_jiffies(1000));
+	mod_timer_msec(&instance->status_checker.timer, 1000, 50);
 
 	return 0;
 }
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index fbea856..79481ea 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -248,7 +248,7 @@ static int usbatm_submit_urb(struct urb *urb)
 		spin_unlock_irq(&channel->lock);
 
 		/* make sure the channel doesn't stall */
-		mod_timer(&channel->delay, jiffies + msecs_to_jiffies(THROTTLE_MSECS));
+		mod_timer_msec(&channel->delay, THROTTLE_MSECS, 0);
 	}
 
 	return ret;
@@ -282,7 +282,7 @@ static void usbatm_complete(struct urb *urb)
 			atm_warn(channel->usbatm, "%s: urb 0x%p failed (%d)!\n",
 				__func__, urb, status);
 		/* throttle processing in case of an error */
-		mod_timer(&channel->delay, jiffies + msecs_to_jiffies(THROTTLE_MSECS));
+		mod_timer_msec(&channel->delay, THROTTLE_MSECS, 0);
 	} else
 		tasklet_schedule(&channel->tasklet);
 }
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 5e09664..83d6bc2 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -1520,7 +1520,7 @@ return_urb:
 		dum->udev = NULL;
 	} else if (dum->rh_state == DUMMY_RH_RUNNING) {
 		/* want a 1 msec delay here */
-		mod_timer (&dum->timer, jiffies + msecs_to_jiffies(1));
+		mod_timer_msec (&dum->timer, 1, 0);
 	}
 
 	spin_unlock_irqrestore (&dum->lock, flags);
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index a8c8543..7428f94 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1229,8 +1229,7 @@ static irqreturn_t m66592_irq(int irq, void *_m66592)
 					& M66592_VBSTS;
 			m66592->scount = M66592_MAX_SAMPLING;
 
-			mod_timer(&m66592->timer,
-					jiffies + msecs_to_jiffies(50));
+			mod_timer_msec(&m66592->timer, 50, 0);
 		}
 		if (intsts0 & M66592_DVSQ)
 			irq_device_state(m66592);
@@ -1277,14 +1276,12 @@ static void m66592_timer(unsigned long _m66592)
 				else
 					m66592_usb_disconnect(m66592);
 			} else {
-				mod_timer(&m66592->timer,
-					jiffies + msecs_to_jiffies(50));
+				mod_timer_msec(&m66592->timer, 50, 0);
 			}
 		} else {
 			m66592->scount = M66592_MAX_SAMPLING;
 			m66592->old_vbus = tmp;
-			mod_timer(&m66592->timer,
-					jiffies + msecs_to_jiffies(50));
+			mod_timer_msec(&m66592->timer, 50, 0);
 		}
 	}
 	spin_unlock_irqrestore(&m66592->lock, flags);
@@ -1493,7 +1490,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		m66592->old_vbus = m66592_read(m66592,
 					 M66592_INTSTS0) & M66592_VBSTS;
 		m66592->scount = M66592_MAX_SAMPLING;
-		mod_timer(&m66592->timer, jiffies + msecs_to_jiffies(50));
+		mod_timer_msec(&m66592->timer, 50, 0);
 	}
 
 	return 0;
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index e220fb8..bb0d70b 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1167,8 +1167,7 @@ static irqreturn_t r8a66597_irq(int irq, void *_r8a66597)
 					& VBSTS;
 			r8a66597->scount = R8A66597_MAX_SAMPLING;
 
-			mod_timer(&r8a66597->timer,
-					jiffies + msecs_to_jiffies(50));
+			mod_timer_msec(&r8a66597->timer, 50, 0);
 		}
 		if (intsts0 & DVSQ)
 			irq_device_state(r8a66597);
@@ -1208,14 +1207,12 @@ static void r8a66597_timer(unsigned long _r8a66597)
 				else
 					r8a66597_usb_disconnect(r8a66597);
 			} else {
-				mod_timer(&r8a66597->timer,
-					jiffies + msecs_to_jiffies(50));
+				mod_timer_msec(&r8a66597->timer, 50, 0);
 			}
 		} else {
 			r8a66597->scount = R8A66597_MAX_SAMPLING;
 			r8a66597->old_vbus = tmp;
-			mod_timer(&r8a66597->timer,
-					jiffies + msecs_to_jiffies(50));
+			mod_timer_msec(&r8a66597->timer, 50, 0);
 		}
 	}
 	spin_unlock_irqrestore(&r8a66597->lock, flags);
@@ -1443,7 +1440,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		r8a66597->old_vbus = r8a66597_read(r8a66597,
 					 INTSTS0) & VBSTS;
 		r8a66597->scount = R8A66597_MAX_SAMPLING;
-		mod_timer(&r8a66597->timer, jiffies + msecs_to_jiffies(50));
+		mod_timer_msec(&r8a66597->timer, 50, 0);
 	}
 
 	return 0;
diff --git a/net/dsa/mv88e6xxx.c b/net/dsa/mv88e6xxx.c
index efe661a..2680d65 100644
--- a/net/dsa/mv88e6xxx.c
+++ b/net/dsa/mv88e6xxx.c
@@ -309,7 +309,7 @@ static void mv88e6xxx_ppu_access_put(struct dsa_switch *ds)
 	/*
 	 * Schedule a timer to re-enable the PHY polling unit.
 	 */
-	mod_timer(&ps->ppu_timer, jiffies + msecs_to_jiffies(10));
+	mod_timer_msec(&ps->ppu_timer, 10, 0);
 	mutex_unlock(&ps->ppu_mutex);
 }
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 99508d6..35476bd 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -371,7 +371,7 @@ static void ipmr_expire_process(unsigned long dummy)
 	struct mfc_cache *c, **cp;
 
 	if (!spin_trylock(&mfc_unres_lock)) {
-		mod_timer(&ipmr_expire_timer, jiffies+HZ/10);
+		mod_timer_msec(&ipmr_expire_timer, 100, 0);
 		return;
 	}
 
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 8674d49..4307e08 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -255,7 +255,7 @@ void sctp_generate_t3_rtx_event(unsigned long peer)
 		SCTP_DEBUG_PRINTK("%s:Sock is busy.\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->T3_rtx_timer, jiffies + (HZ/20)))
+		if (!mod_timer_msec(&transport->T3_rtx_timer, 50, 0))
 			sctp_transport_hold(transport);
 		goto out_unlock;
 	}
@@ -296,7 +296,7 @@ static void sctp_generate_timeout_event(struct sctp_association *asoc,
 				  timeout_type);
 
 		/* Try again later.  */
-		if (!mod_timer(&asoc->timers[timeout_type], jiffies + (HZ/20)))
+		if (!mod_timer_msec(&asoc->timers[timeout_type], 50, 0))
 			sctp_association_hold(asoc);
 		goto out_unlock;
 	}
@@ -373,7 +373,7 @@ void sctp_generate_heartbeat_event(unsigned long data)
 		SCTP_DEBUG_PRINTK("%s:Sock is busy.\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
+		if (!mod_timer_msec(&transport->hb_timer, 50, 0))
 			sctp_transport_hold(transport);
 		goto out_unlock;
 	}
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 5a5166a..842e8a4 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -338,7 +338,7 @@ static void cx81801_receive(struct tty_struct *tty,
 		/* Complete modem response received, apply config to codec */
 
 		spin_lock_bh(&ams_delta_lock);
-		mod_timer(&cx81801_timer, jiffies + msecs_to_jiffies(150));
+		mod_timer_msec(&cx81801_timer, 150, 0);
 		apply = !ams_delta_muted && !cx81801_cmd_pending;
 		cx81801_cmd_pending = 1;
 		spin_unlock_bh(&ams_delta_lock);
