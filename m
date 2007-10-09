Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXJIPab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXJIPab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXJIPaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:30:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53850 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbXJIPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:30:20 -0400
Date: Tue, 9 Oct 2007 16:30:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, yanzheng@21cn.com, linux-kernel@vger.kernel.org
Subject: Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree
Message-ID: <20071009153011.GW8181@ftp.linux.org.uk>
References: <200710081705.l98H5eoj009691@imap1.linux-foundation.org> <20071008184044.GA1875@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008184044.GA1875@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 10:40:44PM +0400, Alexey Dobriyan wrote:
> On Mon, Oct 08, 2007 at 10:05:40AM -0700, akpm@linux-foundation.org wrote:
> > --- a/mm/fremap.c~fix-vm_can_nonlinear-check-in-sys_remap_file_pages
> > +++ a/mm/fremap.c
> > @@ -160,7 +160,7 @@ asmlinkage long sys_remap_file_pages(uns
> >  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
> >  		goto out;
> >  
> > -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> > +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
> 
> Ick.
> 
> [PATCH] typo time?
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---

[snip]
Well, well...  For the sake of experiment I'd modified sparse with
--- a/evaluate.c
+++ b/evaluate.c
@@ -916,6 +916,7 @@ static struct symbol *evaluate_binop(struct expression *expr)
 			rtype = integer_promotion(rtype);
 		} else {
 			// The rest do usual conversions
+			if (op == '&' && expr->left->type == EXPR_PREOP &&
+			      expr->left->op == '!')
+				warning(expr->pos, "dubious: !x & y");
 			ltype = usual_conversions(op, expr->left, expr->right,
 						  lclass, rclass, ltype, rtype);
 			ctype = rtype = ltype;

and ran cross-builds.  Very nice hit rate:
	* all places caught by Alexey's patch caught by that
	* a bunch of additional bugs found
	* a bunch of harmless but dumb (&& misspelled as & for no reason, etc.)
	* one "don't know what they are doing, but it's certainly not right"
case (asus-laptop one below)

and no false positives.  They _are_ possible (& deliberately used in something
like !foo() & !bar() to get both called), but none had been there in the
kernel.

Trying to go for a wider patterns like that (!x | y, x & !y, x | !y) had not
caught anything useful (one borderline case in mm/page_alloc.c - | used
instead of || for no good reason, etc.).  It had found a lot of rather
revolting bitbanging, but that's it (
(!!test_bit(A, x)) << 2 | (!!test_bit(B, x)) << 1 | !!test_bit(C,x)
- that kind of thing).

Here's the list of what got caught, the patch incremental to Alexey's in the
end of posting.

arch/ia64/kernel/acpi.c:861:28: warning: dubious: !x & y
        if ((lsapic->header.type != ACPI_MADT_TYPE_LOCAL_SAPIC) ||
		    (!lsapic->lapic_flags & ACPI_MADT_ENABLED)) {
Bug (missing parens)

arch/sparc64/kernel/time.c:1071:23: warning: dubious: !x & y
	if (!mregs && !dregs & !bregs)
		return -1;
Harmless, but dumb (& -> &&)

drivers/acpi/asus_acpi.c:599:22: warning: dubious: !x & y
	if (invert)		/* invert target value */
		led_out = !led_out & 0x1;
Extremely dumb in any reading (led_out is 0 or 1 when we get here)

drivers/acpi/battery.c:423:45: warning: dubious: !x & y
		if ((!battery->flags.battery_present_prev & acpi_battery_present(battery))
		    || (battery->flags.battery_present_prev & !acpi_battery_present(battery))) {
Misspelled !=, actually (.battery_present_prev had been assigned acpi_batter_present()
at earlier point)

drivers/acpi/battery.c:451:44: warning: dubious: !x & y
	if ((!battery->flags.battery_present_prev &
	     acpi_battery_present(battery)) ||
	    (battery->flags.battery_present_prev &
	     !acpi_battery_present(battery))) {
Ditto.

drivers/block/paride/pt.c:663:19: warning: dubious: !x & y
drivers/block/paride/pt.c:667:20: warning: dubious: !x & y
drivers/block/pktcdvd.c:2207:14: warning: dubious: !x & y
drivers/block/pktcdvd.c:2211:14: warning: dubious: !x & y

Bugs, covered by Alexey's patch

drivers/char/isicom.c:1530:23: warning: dubious: !x & y
	if (!inw(base + 0xe) & 0x1 || (portcount != 0 && portcount != 4 &&
				portcount != 8 && portcount != 16)) {
Bug (missing parens).


drivers/isdn/act2000/module.c:313:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:342:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:350:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:354:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:369:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:389:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:397:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:404:21: warning: dubious: !x & y
drivers/isdn/act2000/module.c:527:34: warning: dubious: !x & y
drivers/isdn/act2000/module.c:542:34: warning: dubious: !x & y
drivers/isdn/act2000/module.c:557:34: warning: dubious: !x & y
drivers/isdn/i4l/isdn_ttyfax.c:837:24: warning: dubious: !x & y

Bugs (covered by Alexey's patch)

drivers/isdn/i4l/isdn_ttyfax.c:909:60: warning: dubious: !x & y
			if ((f->phase != ISDN_FAX_PHASE_D) || (!info->faxonline & 1))

Bug (missing parens)

drivers/isdn/icn/icn.c:1305:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1331:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1351:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1369:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1378:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1394:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1408:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1427:21: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1474:20: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1489:20: warning: dubious: !x & y
drivers/isdn/icn/icn.c:1504:20: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1187:21: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1213:21: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1241:21: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1267:22: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1276:22: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1306:22: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1398:20: warning: dubious: !x & y
drivers/isdn/isdnloop/isdnloop.c:1413:20: warning: dubious: !x & y
drivers/media/video/pvrusb2/pvrusb2-ctrl.c:413:12: warning: dubious: !x & y

Covered by Alexey's patch

drivers/isdn/isdnloop/isdnloop.c:1292:22: warning: dubious: !x & y
				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
drivers/isdn/isdnloop/isdnloop.c:1336:22: warning: dubious: !x & y
				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
drivers/isdn/isdnloop/isdnloop.c:1383:20: warning: dubious: !x & y
		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
Missing parens in all cases

drivers/misc/asus-laptop.c:325:14: warning: dubious: !x & y
		out = !out & 0x1;
Hell knows what's going on there, very odd code around.

drivers/net/eepro.c:642:40: warning: dubious: !x & y
		printk(KERN_DEBUG " AutoPort: %d\n", GetBit(!Word,ee_Jabber));
Probably a bug

drivers/net/tokenring/olympic.c:360:38: warning: dubious: !x & y
		while (!readl(olympic_mmio+CLKCTL) & CLKCTL_PAUSE) { 
Missing parens (definitely - CLKCTL_PAUSE is 1<<15)

drivers/net/wireless/airo.c:6420:20: warning: dubious: !x & y
drivers/net/wireless/atmel.c:1764:21: warning: dubious: !x & y

Covered by Alexey's patch

drivers/net/wireless/libertas/wext.c:1541:22: warning: dubious: !x & y
	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&

Missing parens

drivers/net/wireless/prism54/isl_ioctl.c:1121:21: warning: dubious: !x & y
drivers/net/wireless/prism54/isl_ioctl.c:2633:30: warning: dubious: !x & y
drivers/net/wireless/zd1211rw/zd_rf_uw2453.c:406:20: warning: dubious: !x & y

Covered by Alexey's patch

drivers/s390/cio/cmf.c:339:30: warning: dubious: !x & y
drivers/s390/cio/cmf.c:342:31: warning: dubious: !x & y
		if ((!sch->schib.scsw.actl & SCSW_ACTL_SUSPENDED) &&
		    (sch->schib.scsw.actl &
		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT)) &&
		    (!sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS))
Missing parens

drivers/scsi/atari_NCR5380.c:1873:43: warning: dubious: !x & y
	while (!(tmp = NCR5380_read(STATUS_REG)) & SR_REQ)
Missing parens

drivers/scsi/sun3_NCR5380.c:1867:46: warning: dubious: !x & y
    while (!(tmp = NCR5380_read(STATUS_REG)) & SR_REQ);
Ditto

drivers/serial/m32r_sio.c:424:35: warning: dubious: !x & y
		while (!serial_in(up, UART_LSR) & UART_LSR_THRE);
Ditto

drivers/usb/core/hub.c:332:25: warning: dubious: !x & y
	if (!hub->disconnected & list_empty(&hub->event_list)) {
Harmless, but odd (& -> &&)

drivers/video/i810/i810_main.c:1479:22: warning: dubious: !x & y
drivers/video/sis/sis_main.c:430:19: warning: dubious: !x & y
fs/ocfs2/alloc.c:3964:20: warning: dubious: !x & y

Covered by Alexey's patch

fs/ocfs2/dlmglue.c:673:2: warning: dubious: !x & y
	BUG_ON((!lockres->l_flags & OCFS2_LOCK_BUSY));
Missing parens

fs/reiserfs/super.c:1993:47: warning: dubious: !x & y
	if (!REISERFS_I(nd.dentry->d_inode)->i_flags & i_nopack_mask) {
Missing parens

mm/fremap.c:163:21: warning: dubious: !x & y
Covered by patch in -mm that had started that

net/ieee80211/ieee80211_wx.c:711:22: warning: dubious: !x & y
Covered by Alexey's patch
-----------------------------------------------------------------------

Misc bugs caught by looking for !x & y in the tree

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 3d45d24..7d78d22 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -858,7 +858,7 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	lsapic = (struct acpi_madt_local_sapic *)obj->buffer.pointer;
 
 	if ((lsapic->header.type != ACPI_MADT_TYPE_LOCAL_SAPIC) ||
-	    (!lsapic->lapic_flags & ACPI_MADT_ENABLED)) {
+	    (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))) {
 		kfree(buffer.pointer);
 		return -EINVAL;
 	}
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index 69cad1b..23a51ab 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -1068,7 +1068,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 	 * Not having a register set can lead to trouble.
 	 * Also starfire doesn't have a tod clock.
 	 */
-	if (!mregs && !dregs & !bregs)
+	if (!mregs && !dregs && !bregs)
 		return -1;
 
 	if (mregs) {
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index d915fec..1db2055 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -596,7 +596,7 @@ write_led(const char __user * buffer, unsigned long count,
 	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
 
 	if (invert)		/* invert target value */
-		led_out = !led_out & 0x1;
+		led_out = !led_out;
 
 	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
 		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 9b2c0f7..3762ce2 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -420,8 +420,7 @@ static int acpi_battery_update(struct acpi_battery *battery,
 		result = acpi_battery_get_status(battery);
 		if (result)
 			goto end;
-		if ((!battery->flags.battery_present_prev & acpi_battery_present(battery))
-		    || (battery->flags.battery_present_prev & !acpi_battery_present(battery))) {
+		if (battery->flags.battery_present_prev != acpi_battery_present(battery)) {
 			result = acpi_battery_init_update(battery);
 			if (result)
 				goto end;
@@ -448,10 +447,7 @@ static void acpi_battery_notify_update(struct acpi_battery *battery)
 		return;
 	}
 
-	if ((!battery->flags.battery_present_prev &
-	     acpi_battery_present(battery)) ||
-	    (battery->flags.battery_present_prev &
-	     !acpi_battery_present(battery))) {
+	if (battery->flags.battery_present_prev != acpi_battery_present(battery)) {
 		battery->flags.init_update = 1;
 	} else {
 		battery->flags.update[ACPI_BATTERY_INFO] = 1;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 77a7a4a..1c14ec5 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1527,7 +1527,7 @@ static int __devinit reset_card(struct pci_dev *pdev,
 	msleep(10);
 
 	portcount = inw(base + 0x2);
-	if (!inw(base + 0xe) & 0x1 || (portcount != 0 && portcount != 4 &&
+	if (!(inw(base + 0xe) & 0x1) || (portcount != 0 && portcount != 4 &&
 				portcount != 8 && portcount != 16)) {
 		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure.",
 			card + 1);
diff --git a/drivers/isdn/i4l/isdn_ttyfax.c b/drivers/isdn/i4l/isdn_ttyfax.c
index a943d07..6081b3f 100644
--- a/drivers/isdn/i4l/isdn_ttyfax.c
+++ b/drivers/isdn/i4l/isdn_ttyfax.c
@@ -906,7 +906,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 			sprintf(rs, "\r\n0-2");
 			isdn_tty_at_cout(rs, info);
 		} else {
-			if ((f->phase != ISDN_FAX_PHASE_D) || (!info->faxonline & 1))
+			if ((f->phase != ISDN_FAX_PHASE_D) || !(info->faxonline & 1))
 				PARSE_ERROR1;
 			par = isdn_getnum(p);
 			if ((par < 0) || (par > 2))
diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index bb92e3c..8a8b20d 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1289,7 +1289,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				}
 				break;
 		case ISDN_CMD_CLREAZ:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (card->leased)
 					break;
@@ -1333,7 +1333,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				}
 				break;
 		case ISDN_CMD_SETL3:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				return 0;
 		default:
@@ -1380,7 +1380,7 @@ if_writecmd(const u_char __user *buf, int len, int id, int channel)
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		return (isdnloop_writecmd(buf, len, 1, card));
 	}
diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
index 09b3cfb..28c7482 100644
--- a/drivers/net/tokenring/olympic.c
+++ b/drivers/net/tokenring/olympic.c
@@ -357,7 +357,7 @@ static int __devinit olympic_init(struct net_device *dev)
 
 	if(!(readl(olympic_mmio+BCTL) & BCTL_MODE_INDICATOR)) { 
 		t=jiffies;
-		while (!readl(olympic_mmio+CLKCTL) & CLKCTL_PAUSE) { 
+		while (!(readl(olympic_mmio+CLKCTL) & CLKCTL_PAUSE)) { 
 			schedule() ; 
 			if(time_after(jiffies, t + 2*HZ)) {
 				printk(KERN_ERR "IBM Cardbus tokenring adapter not responsing.\n") ; 
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 2fcc3bf..edd4395 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1538,7 +1538,7 @@ static int wlan_get_encodeext(struct net_device *dev,
 		index = adapter->wep_tx_keyidx;
 	}
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP) {
 		if (index != 0 || adapter->mode != IW_MODE_INFRA)
 			goto out;
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 34a7969..a6302a3 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -336,10 +336,10 @@ static int cmf_copy_block(struct ccw_device *cdev)
 
 	if (sch->schib.scsw.fctl & SCSW_FCTL_START_FUNC) {
 		/* Don't copy if a start function is in progress. */
-		if ((!sch->schib.scsw.actl & SCSW_ACTL_SUSPENDED) &&
+		if (!(sch->schib.scsw.actl & SCSW_ACTL_SUSPENDED) &&
 		    (sch->schib.scsw.actl &
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT)) &&
-		    (!sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS))
+		    !(sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS))
 			return -EBUSY;
 	}
 	cmb_data = cdev->private->cmb;
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 03dbe60..5696588 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -1870,7 +1870,7 @@ static int do_abort(struct Scsi_Host *host)
 	 * the target sees, so we just handshake.
 	 */
 
-	while (!(tmp = NCR5380_read(STATUS_REG)) & SR_REQ)
+	while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ))
 		;
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index de73393..9337465 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -1864,7 +1864,7 @@ static int do_abort (struct Scsi_Host *host)
      * the target sees, so we just handshake.
      */
     
-    while (!(tmp = NCR5380_read(STATUS_REG)) & SR_REQ);
+    while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ));
 
     NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
diff --git a/drivers/serial/m32r_sio.c b/drivers/serial/m32r_sio.c
index 6e09c8b..d71f7bd 100644
--- a/drivers/serial/m32r_sio.c
+++ b/drivers/serial/m32r_sio.c
@@ -421,7 +421,7 @@ static void transmit_chars(struct uart_sio_port *up)
 		up->port.icount.tx++;
 		if (uart_circ_empty(xmit))
 			break;
-		while (!serial_in(up, UART_LSR) & UART_LSR_THRE);
+		while (!(serial_in(up, UART_LSR) & UART_LSR_THRE));
 
 	} while (--count > 0);
 
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f7b337f..b6ff0cc 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -329,7 +329,7 @@ static void kick_khubd(struct usb_hub *hub)
 	to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
 
 	spin_lock_irqsave(&hub_event_lock, flags);
-	if (!hub->disconnected & list_empty(&hub->event_list)) {
+	if (!hub->disconnected && list_empty(&hub->event_list)) {
 		list_add_tail(&hub->event_list, &hub_event_list);
 		wake_up(&khubd_wait);
 	}
diff --git a/fs/block_dev.c b/fs/block_dev.c
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f71250e..da94956 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -670,7 +670,7 @@ static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *loc
 {
 	mlog_entry_void();
 
-	BUG_ON((!lockres->l_flags & OCFS2_LOCK_BUSY));
+	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BUSY));
 	BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
 
 	if (lockres->l_requested > LKM_NLMODE &&
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index a005451..630a7eb 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1990,7 +1990,7 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!REISERFS_I(nd.dentry->d_inode)->i_flags & i_nopack_mask) {
+	if (!(REISERFS_I(nd.dentry->d_inode)->i_flags & i_nopack_mask)) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
 		path_release(&nd);
diff --git a/include/linux/fs.h b/include/linux/fs.h
