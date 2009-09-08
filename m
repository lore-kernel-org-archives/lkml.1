Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZIHGMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZIHGMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZIHGMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:12:24 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:42458 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbZIHGMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=B7jxLjrtU14bBWtADcyJwVuL0CU/VankKgrvYaVG2ybvMEPkqEVN0HtaliyqJeBdmA
         +2t4+m3JkF4ULnva0JAKCp/Nwz2UdAWwTm6P4oJ+rXXx0yjF0DMDYbKgpXdvXMD3fRof
         UamFkQnGwxrq4JQer5oNgrtVTr/Hq+x+dkXAY=
Date: Mon, 7 Sep 2009 23:12:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
References: <20090613230842.GA18347@gallifrey> <alpine.LNX.2.00.0906231038500.7457@wotan.suse.de> <20090623185814.GB24108@gallifrey> <200906231106.37460.dmitry.torokhov@gmail.com> <20090628140452.GA15816@gallifrey> <20090904055139.4BEAB526EA5@mailhub.coreip.homeip.net> <20090905235159.GA23660@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090905235159.GA23660@gallifrey>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090908064542.CDF50526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 12:51:59AM +0100, Dr. David Alan Gilbert wrote:
> * Dmitry Torokhov (dmitry.torokhov@gmail.com) wrote:
> > On Sun, Jun 28, 2009 at 03:04:52PM +0100, Dr. David Alan Gilbert wrote:
> > > * Dmitry Torokhov (dmitry.torokhov@gmail.com) wrote:
> > > > On Tuesday 23 June 2009 11:58:15 Dr. David Alan Gilbert wrote:
> > > 
> > > <snip>
> > >  
> > > > > Yep; I'm OK with the i8042.noaux from my point of view, but it's a
> > > > > bit worrying that this used to work fine.  There's obviously been
> > > > > a change somewhere since 2.6.18 (and as I remember from the dmesg
> > > > > the keyboard and aux ports are being initialised in different orders).
> > > > > (Actually I say obviously since 2.6.18 - but the 2.6.18 I tried
> > > > > I think I only used the debian version - I should go back and
> > > > > see if I can do a vanilla one), but this box has been running
> > > > > Linux since the time it was originally bought with loads of distros
> > > > > and clean kernels years ago.
> > > > >
> > > > > While this machine is old, the motherboard was a pretty common one
> > > > > at the time.
> > > > >
> > > > 
> > > > Any chance I could get dmesg with i8042.debug with 2.6.18? There was
> > > > quite a large change back then when we got rid of the polling timer
> > > > in i8042.
> > > 
> > > Apologies for the delay; attached is the dmesg from the Debian 2.6.18
> > > in which keyboard works as previously described.
> > > 
> > 
> > Sorry for taking so long to respond. The only vidible difference beween
> > the old and the new way is that we don't "close" serio ports anymore if
> > we fail to detect a mouse/keyboard.
> > 
> > Could you please try the patch below and tell me if it helps?
> 
> Yes that fixes it - thank you!
> (Tested on 2.6.31-rc8, having first checked rc8 on it's own was still broken)
> 

That is great news! Would you mind testing a slightly modifued version
of the patch and if it still works I will get it applied.

Thanks!

-- 
Dmitry

Input: i8042 - try disabling and re-enabling AUX port at close

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Ever since we switched from having a polling timer to registering IRQ
handlers for both keyboard and AUX ports at the driver registration
time, on certain boxes probing for a mouse results in keyboard
stopping working. The only real difference between old and new way is
that before we disabled ports after unsuccessful probe whereas now we
leave them as is. Try to emulate the old behavior by disabling and
immediately re-enabling AUX and KBD ports when corresponding serio
port is being closed.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/i8042.c |   50 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 49 insertions(+), 1 deletions(-)


diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index b53a015..db5a0b3 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -264,6 +264,49 @@ static int i8042_aux_write(struct serio *serio, unsigned char c)
 					I8042_CMD_MUX_SEND + port->mux);
 }
 
+
+/*
+ * i8042_aux_close attempts to clear AUX or KBD port state by disabling
+ * and then re-enabling it.
+ */
+
+static void i8042_port_close(struct serio *serio)
+{
+	int irq_bit;
+	int disable_bit;
+	const char *port_name;
+
+	if (serio == i8042_ports[I8042_AUX_PORT_NO].serio) {
+		irq_bit = ~I8042_CTR_AUXINT;
+		disable_bit = ~I8042_CTR_AUXDIS;
+		port_name = "AUX";
+	} else {
+		irq_bit = ~I8042_CTR_KBDINT;
+		disable_bit = ~I8042_CTR_KBDDIS;
+		port_name = "KBD";
+	}
+
+	i8042_ctr &= ~irq_bit;
+	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
+		printk(KERN_WARNING
+			"i8042.c: Can't write CTR while closing %s port.\n",
+			port_name);
+
+	udelay(50);
+
+	i8042_ctr &= ~disable_bit;
+	i8042_ctr |= irq_bit;
+	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
+		printk(KERN_ERR "i8042.c: Can't reactivate %s port.\n",
+			port_name);
+
+	/*
+	 * See if there is any data appeared while we were messing with
+	 * port state.
+	 */
+	i8042_interrupt(0, NULL);
+}
+
 /*
  * i8042_start() is called by serio core when port is about to finish
  * registering. It will mark port as existing so i8042_interrupt can
@@ -393,7 +436,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 }
 
 /*
- * i8042_enable_kbd_port enables keybaord port on chip
+ * i8042_enable_kbd_port enables keyboard port on chip
  */
 
 static int i8042_enable_kbd_port(void)
@@ -841,6 +884,9 @@ static void i8042_controller_reset(void)
 	i8042_ctr |= I8042_CTR_KBDDIS | I8042_CTR_AUXDIS;
 	i8042_ctr &= ~(I8042_CTR_KBDINT | I8042_CTR_AUXINT);
 
+	if (i8042_command(&i8042_initial_ctr, I8042_CMD_CTL_WCTR))
+		printk(KERN_WARNING "i8042.c: Can't write CTR while resetting.\n");
+
 /*
  * Disable MUX mode if present.
  */
@@ -1026,6 +1072,7 @@ static int __devinit i8042_create_kbd_port(void)
 	serio->write		= i8042_dumbkbd ? NULL : i8042_kbd_write;
 	serio->start		= i8042_start;
 	serio->stop		= i8042_stop;
+	serio->close		= i8042_port_close;
 	serio->port_data	= port;
 	serio->dev.parent	= &i8042_platform_device->dev;
 	strlcpy(serio->name, "i8042 KBD port", sizeof(serio->name));
@@ -1056,6 +1103,7 @@ static int __devinit i8042_create_aux_port(int idx)
 	if (idx < 0) {
 		strlcpy(serio->name, "i8042 AUX port", sizeof(serio->name));
 		strlcpy(serio->phys, I8042_AUX_PHYS_DESC, sizeof(serio->phys));
+		serio->close = i8042_port_close;
 	} else {
 		snprintf(serio->name, sizeof(serio->name), "i8042 AUX%d port", idx);
 		snprintf(serio->phys, sizeof(serio->phys), I8042_MUX_PHYS_DESC, idx + 1);
