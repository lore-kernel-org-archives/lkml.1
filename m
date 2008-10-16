Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYJPDFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYJPDFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 23:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYJPDF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 23:05:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:8553 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYJPDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 23:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=txJUpgzsNXxXTuaeNDmFJUlS3reC3ejwA7hH2rrqhVAAd8sadtjmVne1r//KIHvre6
         W51osSjzPLZdZXnJ/Snizh3gbdh9cagPz70j0o4vWqkCCYO7xegu0TovmtwHbm+/nraR
         dD1iHYOe23wFmomyAXpKRZi60vEC8qxxhT3Us=
Date: Wed, 15 Oct 2008 23:05:15 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan Opmeer <arjan@opmeer.net>
Cc: akpm@linux-foundation.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Update Elantech touchpad driver to v5 for
	kernel 2.6.27-rc5-mm1
Message-ID: <20081016030515.GA28113@amd.corenet.prv>
References: <20080914032344.GA16228@adopmeer.homeip.net> <20080919041727.GB7594@core.corenet.prv> <20080919070530.GA7599@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20080919070530.GA7599@adopmeer.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arjan,

On Fri, Sep 19, 2008 at 09:05:30AM +0200, Arjan Opmeer wrote:
> 
> Hi Dmitry,
> 
> (Sorry for calling you Dimitry earlier :)
> 
> On Fri, Sep 19, 2008 at 12:17:27AM -0400, Dmitry Torokhov wrote:
> > On Sun, Sep 14, 2008 at 05:23:44AM +0200, Arjan Opmeer wrote:
> > > 
> > > Update the Elantech touchpad driver to v5
> > 
> > Could you tell me if issues with pressure reporting mentioned in bugzilla
> > #8781 have been resolved?
> 
> I am not exactly sure what the issue is that is described there.
> 
> As far as I know the touchpad does not report pressure (maybe the EeePC
> style touchpad does, but I do not have hands on experience with that).
> However the Xorg Synaptics driver requires pressure events to work. So I
> chose a default pressure value and the driver always toggles between no
> pressure and default pressure for no touch and touch respectively. This
> seems to work well for all my testers as I have not heard any complaints.
> 

I see. In this case the driver should not really report ABS_PRESSURE but
only BTN_TOUCH. I understand that this would require synaptics X driver
changes but that should be OK. I wrote a patch to the X driver which
seems to be working if I bastardize my synaptics touchpad but I would
like to have it tested with real Elantech device. I am attaching the
version of Elantech driver that I want to apply (there were some timy
changes) and the patch to teh Synaptics X driver (against recent git
pull from its repository). If you could give it a try that would be
grand.

Thanks!

-- 
Dmitry

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="synaptics-no-abspressure.patch"

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 15 Oct 2008 22:47:46 -0400
Subject: [PATCH] Add support for touchpads (such as Elantech) that do not report pressure.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 src/eventcomm.c    |   77 +++++++++++++++++++++++++++++++++++-----------------
 src/synapticsstr.h |    1 +
 2 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/src/eventcomm.c b/src/eventcomm.c
index b2d0891..b5076e3 100644
--- a/src/eventcomm.c
+++ b/src/eventcomm.c
@@ -77,7 +77,9 @@ static Bool
 event_query_is_touchpad(int fd)
 {
     int ret;
-    unsigned long evbits[NBITS(KEY_MAX)];
+    unsigned long evbits[NBITS(EV_MAX)];
+    unsigned long absbits[NBITS(ABS_MAX)];
+    unsigned long keybits[NBITS(KEY_MAX)];
 
     /* Check for ABS_X, ABS_Y, ABS_PRESSURE and BTN_TOOL_FINGER */
 
@@ -89,20 +91,24 @@ event_query_is_touchpad(int fd)
 	!TEST_BIT(EV_KEY, evbits))
 	return FALSE;
 
-    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_ABS, sizeof(evbits)), evbits));
+    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_ABS, sizeof(absbits)), absbits));
     if (ret < 0)
 	return FALSE;
-    if (!TEST_BIT(ABS_X, evbits) ||
-	!TEST_BIT(ABS_Y, evbits) ||
-	!TEST_BIT(ABS_PRESSURE, evbits))
+    if (!TEST_BIT(ABS_X, absbits) ||
+	!TEST_BIT(ABS_Y, absbits))
 	return FALSE;
 
-    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_KEY, sizeof(evbits)), evbits));
+    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_KEY, sizeof(keybits)), keybits));
     if (ret < 0)
 	return FALSE;
-    if (!TEST_BIT(BTN_TOOL_FINGER, evbits))
+
+    /* we expect touchpad either report raw pressure or touches */
+    if (!TEST_BIT(ABS_PRESSURE, absbits) && !TEST_BIT(BTN_TOUCH, keybits))
+	return FALSE;
+    /* all Synaptics-like touchpad report BTN_TOOL_FINGER */
+    if (!TEST_BIT(BTN_TOOL_FINGER, keybits))
 	return FALSE;
-    if (TEST_BIT(BTN_TOOL_PEN, evbits))
+    if (TEST_BIT(BTN_TOOL_PEN, keybits))
 	return FALSE;			    /* Don't match wacom tablets */
 
     return TRUE;
@@ -114,12 +120,13 @@ event_query_axis_ranges(LocalDevicePtr local)
 {
     SynapticsPrivate *priv = (SynapticsPrivate *)local->private;
     struct input_absinfo abs;
-    unsigned long evbits[NBITS(KEY_MAX)];
+    unsigned long absbits[NBITS(ABS_MAX)];
+    unsigned long keybits[NBITS(KEY_MAX)];
     char buf[256];
     int rc;
 
     SYSCALL(rc = ioctl(local->fd, EVIOCGABS(ABS_X), &abs));
-    if (rc == 0)
+    if (rc >= 0)
     {
 	xf86Msg(X_INFO, "%s: x-axis range %d - %d\n", local->name,
 		abs.minimum, abs.maximum);
@@ -130,7 +137,7 @@ event_query_axis_ranges(LocalDevicePtr local)
 		strerror(errno));
 
     SYSCALL(rc = ioctl(local->fd, EVIOCGABS(ABS_Y), &abs));
-    if (rc == 0)
+    if (rc >= 0)
     {
 	xf86Msg(X_INFO, "%s: y-axis range %d - %d\n", local->name,
 		abs.minimum, abs.maximum);
@@ -140,17 +147,31 @@ event_query_axis_ranges(LocalDevicePtr local)
 	xf86Msg(X_ERROR, "%s: failed to query axis range (%s)\n", local->name,
 		strerror(errno));
 
-    SYSCALL(rc = ioctl(local->fd, EVIOCGABS(ABS_PRESSURE), &abs));
-    if (rc == 0)
+    priv->has_pressure = FALSE;
+    SYSCALL(rc = ioctl(local->fd, EVIOCGBIT(EV_ABS, sizeof(absbits)), absbits));
+    if (rc >= 0)
+	priv->has_pressure = TEST_BIT(ABS_PRESSURE, absbits);
+    else
+	xf86Msg(X_ERROR, "%s: failed to query ABS bits (%s)\n", local->name,
+		strerror(errno));
+
+    if (priv->has_pressure)
     {
-	xf86Msg(X_INFO, "%s: pressure range %d - %d\n", local->name,
-		abs.minimum, abs.maximum);
-	priv->minp = abs.minimum;
-	priv->maxp = abs.maximum;
-    }
+	SYSCALL(rc = ioctl(local->fd, EVIOCGABS(ABS_PRESSURE), &abs));
+	if (rc >= 0)
+	{
+	    xf86Msg(X_INFO, "%s: pressure range %d - %d\n", local->name,
+		    abs.minimum, abs.maximum);
+	    priv->minp = abs.minimum;
+	    priv->maxp = abs.maximum;
+	}
+    } else
+	xf86Msg(X_ERROR,
+		"%s: device does not report pressure, will use touch data\n",
+		local->name, strerror(errno));
 
     SYSCALL(rc = ioctl(local->fd, EVIOCGABS(ABS_TOOL_WIDTH), &abs));
-    if (rc == 0)
+    if (rc >= 0)
     {
 	xf86Msg(X_INFO, "%s: finger width range %d - %d\n", local->name,
 		abs.minimum, abs.maximum);
@@ -158,19 +179,19 @@ event_query_axis_ranges(LocalDevicePtr local)
 	priv->maxw = abs.maximum;
     }
 
-    SYSCALL(rc = ioctl(local->fd, EVIOCGBIT(EV_KEY, sizeof(evbits)), evbits));
+    SYSCALL(rc = ioctl(local->fd, EVIOCGBIT(EV_KEY, sizeof(keybits)), keybits));
     if (rc >= 0)
     {
 	buf[0] = 0;
-	if ((priv->has_left = TEST_BIT(BTN_LEFT, evbits)))
+	if ((priv->has_left = TEST_BIT(BTN_LEFT, keybits)))
 	   strcat(buf, " left");
-	if ((priv->has_right = TEST_BIT(BTN_RIGHT, evbits)))
+	if ((priv->has_right = TEST_BIT(BTN_RIGHT, keybits)))
 	   strcat(buf, " right");
-	if ((priv->has_middle = TEST_BIT(BTN_MIDDLE, evbits)))
+	if ((priv->has_middle = TEST_BIT(BTN_MIDDLE, keybits)))
 	   strcat(buf, " middle");
-	if ((priv->has_double = TEST_BIT(BTN_TOOL_DOUBLETAP, evbits)))
+	if ((priv->has_double = TEST_BIT(BTN_TOOL_DOUBLETAP, keybits)))
 	   strcat(buf, " double");
-	if ((priv->has_triple = TEST_BIT(BTN_TOOL_TRIPLETAP, evbits)))
+	if ((priv->has_triple = TEST_BIT(BTN_TOOL_TRIPLETAP, keybits)))
 	   strcat(buf, " triple");
 	xf86Msg(X_INFO, "%s: buttons:%s\n", local->name, buf);
     }
@@ -229,6 +250,8 @@ EventReadHwState(LocalDevicePtr local, struct SynapticsHwInfo *synhw,
     struct input_event ev;
     Bool v;
     struct SynapticsHwState *hw = &(comm->hwState);
+    SynapticsPrivate *priv = (SynapticsPrivate *)local->private;
+    SynapticsSHM *para = priv->synpara;
 
     while (SynapticsReadEvent(comm, &ev)) {
 	switch (ev.type) {
@@ -304,6 +327,10 @@ EventReadHwState(LocalDevicePtr local, struct SynapticsHwInfo *synhw,
 	    case BTN_B:
 		hw->guest_right = v;
 		break;
+	    case BTN_TOUCH:
+		if (!priv->has_pressure)
+			hw->z = v ? para->finger_high + 1 : 0;
+		break;
 	    }
 	    break;
 	case EV_ABS:
diff --git a/src/synapticsstr.h b/src/synapticsstr.h
index cc0a29f..688167c 100644
--- a/src/synapticsstr.h
+++ b/src/synapticsstr.h
@@ -145,6 +145,7 @@ typedef struct _SynapticsPrivateRec
     Bool has_middle;			/* middle button detected for this device */
     Bool has_double;			/* double click detected for this device */
     Bool has_triple;			/* triple click detected for this device */
+    Bool has_pressure;			/* device reports pressure */
 } SynapticsPrivate;
 
 #endif /* _SYNAPTICSSTR_H_ */
-- 
1.5.5.1


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="elantech-touchpad-driver.patch"

Input: psmouse - add support for Elantech touchpads

From: Arjan Opmeer <arjan@opmeer.net>

This is version 5 of the driver. Relative mode support has been
dropped (users wishing to use touchpad in relative mode can use
standard PS/2 protocol emilation done in hardware). The driver
supports both original version of Elantech protocol and the newer
one used by touchpads installed in EeePC.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 Documentation/input/elantech.txt   |  405 ++++++++++++++++++++++
 drivers/input/mouse/Kconfig        |   25 +
 drivers/input/mouse/Makefile       |    1 
 drivers/input/mouse/elantech.c     |  674 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/elantech.h     |  124 +++++++
 drivers/input/mouse/psmouse-base.c |   23 +
 drivers/input/mouse/psmouse.h      |    1 
 7 files changed, 1251 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/input/elantech.txt
 create mode 100644 drivers/input/mouse/elantech.c
 create mode 100644 drivers/input/mouse/elantech.h


diff --git a/Documentation/input/elantech.txt b/Documentation/input/elantech.txt
new file mode 100644
index 0000000..a10c3b6
--- /dev/null
+++ b/Documentation/input/elantech.txt
@@ -0,0 +1,405 @@
+Elantech Touchpad Driver
+========================
+
+	Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
+
+	Extra information for hardware version 1 found and
+	provided by Steve Havelka
+
+	Version 2 (EeePC) hardware support based on patches
+	received from Woody at Xandros and forwarded to me
+	by user StewieGriffin at the eeeuser.com forum
+
+
+Contents
+~~~~~~~~
+
+ 1. Introduction
+ 2. Extra knobs
+ 3. Hardware version 1
+    3.1 Registers
+    3.2 Native relative mode 4 byte packet format
+    3.3 Native absolute mode 4 byte packet format
+ 4. Hardware version 2
+    4.1 Registers
+    4.2 Native absolute mode 6 byte packet format
+        4.2.1 One finger touch
+        4.2.2 Two finger touch
+
+
+
+1. Introduction
+   ~~~~~~~~~~~~
+
+Currently the Linux Elantech touchpad driver is aware of two different
+hardware versions unimaginatively called version 1 and version 2. Version 1
+is found in "older" laptops and uses 4 bytes per packet. Version 2 seems to
+be introduced with the EeePC and uses 6 bytes per packet.
+
+The driver tries to support both hardware versions and should be compatible
+with the Xorg Synaptics touchpad driver and its graphical configuration
+utilities.
+
+Additionally the operation of the touchpad can be altered by adjusting the
+contents of some of its internal registers. These registers are represented
+by the driver as sysfs entries under /sys/bus/serio/drivers/psmouse/serio?
+that can be read from and written to.
+
+Currently only the registers for hardware version 1 are somewhat understood.
+Hardware version 2 seems to use some of the same registers but it is not
+known whether the bits in the registers represent the same thing or might
+have changed their meaning.
+
+On top of that, some register settings have effect only when the touchpad is
+in relative mode and not in absolute mode. As the Linux Elantech touchpad
+driver always puts the hardware into absolute mode not all information
+mentioned below can be used immediately. But because there is no freely
+available Elantech documentation the information is provided here anyway for
+completeness sake.
+
+
+/////////////////////////////////////////////////////////////////////////////
+
+
+2. Extra knobs
+   ~~~~~~~~~~~
+
+Currently the Linux Elantech touchpad driver provides two extra knobs under
+/sys/bus/serio/drivers/psmouse/serio? for the user.
+
+* debug
+
+   Turn different levels of debugging ON or OFF.
+
+   By echoing "0" to this file all debugging will be turned OFF.
+
+   Currently a value of "1" will turn on some basic debugging and a value of
+   "2" will turn on packet debugging. For hardware version 1 the default is
+   OFF. For version 2 the default is "1".
+
+   Turning packet debugging on will make the driver dump every packet
+   received to the syslog before processing it. Be warned that this can
+   generate quite a lot of data!
+
+* paritycheck
+
+   Turns parity checking ON or OFF.
+
+   By echoing "0" to this file parity checking will be turned OFF. Any
+   non-zero value will turn it ON. For hardware version 1 the default is ON.
+   For version 2 the default it is OFF.
+
+   Hardware version 1 provides basic data integrity verification by
+   calculating a parity bit for the last 3 bytes of each packet. The driver
+   can check these bits and reject any packet that appears corrupted. Using
+   this knob you can bypass that check.
+
+   It is not known yet whether hardware version 2 provides the same parity
+   bits. Hence checking is disabled by default. Currently even turning it on
+   will do nothing.
+
+
+/////////////////////////////////////////////////////////////////////////////
+
+
+3. Hardware version 1
+   ==================
+
+3.1 Registers
+    ~~~~~~~~~
+
+By echoing a hexadecimal value to a register it contents can be altered.
+
+For example:
+
+   echo -n 0x16 > reg_10
+
+* reg_10
+
+   bit   7   6   5   4   3   2   1   0
+         B   C   T   D   L   A   S   E
+
+         E: 1 = enable smart edges unconditionally
+         S: 1 = enable smart edges only when dragging
+         A: 1 = absolute mode (needs 4 byte packets, see reg_11)
+         L: 1 = enable drag lock (see reg_22)
+         D: 1 = disable dynamic resolution
+         T: 1 = disable tapping
+         C: 1 = enable corner tap
+         B: 1 = swap left and right button
+
+* reg_11
+
+   bit   7   6   5   4   3   2   1   0
+         1   0   0   H   V   1   F   P
+
+         P: 1 = enable parity checking for relative mode
+         F: 1 = enable native 4 byte packet mode
+         V: 1 = enable vertical scroll area
+         H: 1 = enable horizontal scroll area
+
+* reg_20
+
+         single finger width?
+
+* reg_21
+
+         scroll area width (small: 0x40 ... wide: 0xff)
+
+* reg_22
+
+         drag lock time out (short: 0x14 ... long: 0xfe;
+                             0xff = tap again to release)
+
+* reg_23
+
+         tap make timeout?
+
+* reg_24
+
+         tap release timeout?
+
+* reg_25
+
+         smart edge cursor speed (0x02 = slow, 0x03 = medium, 0x04 = fast)
+
+* reg_26
+
+         smart edge activation area width?
+
+
+3.2 Native relative mode 4 byte packet format
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+byte 0:
+   bit   7   6   5   4   3   2   1   0
+         c   c  p2  p1   1   M   R   L
+
+         L, R, M = 1 when Left, Right, Middle mouse button pressed
+            some models have M as byte 3 odd parity bit
+         when parity checking is enabled (reg_11, P = 1):
+            p1..p2 = byte 1 and 2 odd parity bit
+         c = 1 when corner tap detected
+
+byte 1:
+   bit   7   6   5   4   3   2   1   0
+        dx7 dx6 dx5 dx4 dx3 dx2 dx1 dx0
+
+         dx7..dx0 = x movement;   positive = right, negative = left
+         byte 1 = 0xf0 when corner tap detected
+
+byte 2:
+   bit   7   6   5   4   3   2   1   0
+        dy7 dy6 dy5 dy4 dy3 dy2 dy1 dy0
+
+         dy7..dy0 = y movement;   positive = up,    negative = down
+
+byte 3:
+   parity checking enabled (reg_11, P = 1):
+
+      bit   7   6   5   4   3   2   1   0
+            w   h  n1  n0  ds3 ds2 ds1 ds0
+
+            normally:
+               ds3..ds0 = scroll wheel amount and direction
+                          positive = down or left
+                          negative = up or right
+            when corner tap detected:
+               ds0 = 1 when top right corner tapped
+               ds1 = 1 when bottom right corner tapped
+               ds2 = 1 when bottom left corner tapped
+               ds3 = 1 when top left corner tapped
+            n1..n0 = number of fingers on touchpad
+               only models with firmware 2.x report this, models with
+               firmware 1.x seem to map one, two and three finger taps
+               directly to L, M and R mouse buttons
+            h = 1 when horizontal scroll action
+            w = 1 when wide finger touch?
+
+   otherwise (reg_11, P = 0):
+
+      bit   7   6   5   4   3   2   1   0
+           ds7 ds6 ds5 ds4 ds3 ds2 ds1 ds0
+
+            ds7..ds0 = vertical scroll amount and direction
+                       negative = up
+                       positive = down
+
+
+3.3 Native absolute mode 4 byte packet format
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+byte 0:
+   firmware version 1.x:
+
+      bit   7   6   5   4   3   2   1   0
+            D   U  p1  p2   1  p3   R   L
+
+            L, R = 1 when Left, Right mouse button pressed
+            p1..p3 = byte 1..3 odd parity bit
+            D, U = 1 when rocker switch pressed Up, Down
+
+   firmware version 2.x:
+
+      bit   7   6   5   4   3   2   1   0
+           n1  n0  p2  p1   1  p3   R   L
+
+            L, R = 1 when Left, Right mouse button pressed
+            p1..p3 = byte 1..3 odd parity bit
+            n1..n0 = number of fingers on touchpad
+
+byte 1:
+   firmware version 1.x:
+
+      bit   7   6   5   4   3   2   1   0
+            f   0  th  tw  x9  x8  y9  y8
+
+            tw = 1 when two finger touch
+            th = 1 when three finger touch
+            f  = 1 when finger touch
+
+   firmware version 2.x:
+
+      bit   7   6   5   4   3   2   1   0
+            .   .   .   .  x9  x8  y9  y8
+
+byte 2:
+   bit   7   6   5   4   3   2   1   0
+        x7  x6  x5  x4  x3  x2  x1  x0
+
+         x9..x0 = absolute x value (horizontal)
+
+byte 3:
+   bit   7   6   5   4   3   2   1   0
+        y7  y6  y5  y4  y3  y2  y1  y0
+
+         y9..y0 = absolute y value (vertical)
+
+
+/////////////////////////////////////////////////////////////////////////////
+
+
+4. Hardware version 2
+   ==================
+
+
+4.1 Registers
+    ~~~~~~~~~
+
+By echoing a hexadecimal value to a register it contents can be altered.
+
+For example:
+
+   echo -n 0x56 > reg_10
+
+* reg_10
+
+   bit   7   6   5   4   3   2   1   0
+         0   1   0   1   0   1   D   0
+
+         D: 1 = enable drag and drop
+
+* reg_11
+
+   bit   7   6   5   4   3   2   1   0
+         1   0   0   0   S   0   1   0
+
+         S: 1 = enable vertical scroll
+
+* reg_21
+
+         unknown (0x00)
+
+* reg_22
+
+         drag and drop release time out (short: 0x70 ... long 0x7e;
+                                   0x7f = never i.e. tap again to release)
+
+
+4.2 Native absolute mode 6 byte packet format
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+4.2.1 One finger touch
+      ~~~~~~~~~~~~~~~~
+
+byte 0:
+
+   bit   7   6   5   4   3   2   1   0
+        n1  n0   .   .   .   .   R   L
+
+         L, R = 1 when Left, Right mouse button pressed
+         n1..n0 = numbers of fingers on touchpad
+
+byte 1:
+
+   bit   7   6   5   4   3   2   1   0
+        x15 x14 x13 x12 x11 x10 x9  x8
+
+byte 2:
+
+   bit   7   6   5   4   3   2   1   0
+        x7  x6  x5  x4  x4  x2  x1  x0
+
+         x15..x0 = absolute x value (horizontal)
+
+byte 3:
+
+   bit   7   6   5   4   3   2   1   0
+         .   .   .   .   .   .   .   .
+
+byte 4:
+
+   bit   7   6   5   4   3   2   1   0
+        y15 y14 y13 y12 y11 y10 y8  y8
+
+byte 5:
+
+   bit   7   6   5   4   3   2   1   0
+        y7  y6  y5  y4  y3  y2  y1  y0
+
+         y15..y0 = absolute y value (vertical)
+
+
+4.2.2 Two finger touch
+      ~~~~~~~~~~~~~~~~
+
+byte 0:
+
+   bit   7   6   5   4   3   2   1   0
+        n1  n0  ay8 ax8  .   .   R   L
+
+         L, R = 1 when Left, Right mouse button pressed
+         n1..n0 = numbers of fingers on touchpad
+
+byte 1:
+
+   bit   7   6   5   4   3   2   1   0
+        ax7 ax6 ax5 ax4 ax3 ax2 ax1 ax0
+
+         ax8..ax0 = first finger absolute x value
+
+byte 2:
+
+   bit   7   6   5   4   3   2   1   0
+        ay7 ay6 ay5 ay4 ay3 ay2 ay1 ay0
+
+         ay8..ay0 = first finger absolute y value
+
+byte 3:
+
+   bit   7   6   5   4   3   2   1   0
+         .   .  by8 bx8  .   .   .   .
+
+byte 4:
+
+   bit   7   6   5   4   3   2   1   0
+        bx7 bx6 bx5 bx4 bx3 bx2 bx1 bx0
+
+         bx8..bx0 = second finger absolute x value
+
+byte 5:
+
+   bit   7   6   5   4   3   2   1   0
+        by7 by8 by5 by4 by3 by2 by1 by0
+
+         by8..by0 = second finger absolute y value
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index f488b68..4e99342 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -25,8 +25,8 @@ config MOUSE_PS2
 	  mice with wheels and extra buttons, Microsoft, Logitech or Genius
 	  compatible.
 
-	  Synaptics TouchPad users might be interested in a specialized
-	  XFree86 driver at:
+	  Synaptics, ALPS or Elantech TouchPad users might be interested
+	  in a specialized Xorg/XFree86 driver at:
 		<http://w1.894.telia.com/~u89404340/touchpad/index.html>
 	  and a new version of GPM at:
 		<http://www.geocities.com/dt_or/gpm/gpm.html>
@@ -87,6 +87,27 @@ config MOUSE_PS2_TRACKPOINT
 
 	  If unsure, say Y.
 
+config MOUSE_PS2_ELANTECH
+	bool "Elantech PS/2 protocol extension"
+	depends on MOUSE_PS2
+	help
+	  Say Y here if you have an Elantech PS/2 touchpad connected
+	  to your system.
+
+	  Note that if you enable this driver you will need an updated
+	  X.org Synaptics driver that does not require ABS_PRESSURE
+	  reports from the touchpad (i.e. post 1.5.0 version). You can
+	  grab a patch for the driver here:
+
+	  http://userweb.kernel.org/~dtor/synaptics-no-abspressure.patch
+
+	  If unsure, say N.
+
+	  This driver exposes some configuration registers via sysfs
+	  entries. For further information,
+	  see <file:Documentation/input/elantech.txt>.
+
+
 config MOUSE_PS2_TOUCHKIT
 	bool "eGalax TouchKit PS/2 protocol extension"
 	depends on MOUSE_PS2
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 8e6e690..96f1dd8 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_MOUSE_GPIO)	+= gpio_mouse.o
 psmouse-objs := psmouse-base.o synaptics.o
 
 psmouse-$(CONFIG_MOUSE_PS2_ALPS)	+= alps.o
+psmouse-$(CONFIG_MOUSE_PS2_ELANTECH)	+= elantech.o
 psmouse-$(CONFIG_MOUSE_PS2_OLPC)	+= hgpk.o
 psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)	+= logips2pp.o
 psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
new file mode 100644
index 0000000..b0756c3
--- /dev/null
+++ b/drivers/input/mouse/elantech.c
@@ -0,0 +1,674 @@
+/*
+ * Elantech Touchpad driver (v5)
+ *
+ * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/serio.h>
+#include <linux/libps2.h>
+#include "psmouse.h"
+#include "elantech.h"
+
+#define elantech_debug(format, arg...)				\
+	do {							\
+		if (etd->debug)					\
+			printk(KERN_DEBUG format, ##arg);	\
+	} while (0)
+
+/*
+ * Send a Synaptics style sliced query command
+ */
+static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c,
+				unsigned char *param)
+{
+	if (psmouse_sliced_command(psmouse, c) ||
+	    ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+		pr_err("elantech.c: synaptics_send_cmd query 0x%02x failed.\n", c);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * A retrying version of ps2_command
+ */
+static int elantech_ps2_command(struct psmouse *psmouse,
+				unsigned char *param, int command)
+{
+	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	struct elantech_data *etd = psmouse->private;
+	int rc;
+	int tries = ETP_PS2_COMMAND_TRIES;
+
+	do {
+		rc = ps2_command(ps2dev, param, command);
+		if (rc == 0)
+			break;
+		tries--;
+		elantech_debug("elantech.c: retrying ps2 command 0x%02x (%d).\n",
+			command, tries);
+		msleep(ETP_PS2_COMMAND_DELAY);
+	} while (tries > 0);
+
+	if (rc)
+		pr_err("elantech.c: ps2 command 0x%02x failed.\n", command);
+
+	return rc;
+}
+
+/*
+ * Send an Elantech style special command to read a value from a register
+ */
+static int elantech_read_reg(struct psmouse *psmouse, unsigned char reg,
+				unsigned char *val)
+{
+	struct elantech_data *etd = psmouse->private;
+	unsigned char param[3];
+	int rc = 0;
+
+	if (reg < 0x10 || reg > 0x26)
+		return -1;
+
+	if (reg > 0x11 && reg < 0x20)
+		return -1;
+
+	switch (etd->hw_version) {
+	case 1:
+		if (psmouse_sliced_command(psmouse, ETP_REGISTER_READ) ||
+		    psmouse_sliced_command(psmouse, reg) ||
+		    ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+			rc = -1;
+		}
+		break;
+
+	case 2:
+		if (elantech_ps2_command(psmouse,  NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(psmouse,  NULL, ETP_REGISTER_READ) ||
+		    elantech_ps2_command(psmouse,  NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(psmouse,  NULL, reg) ||
+		    elantech_ps2_command(psmouse, param, PSMOUSE_CMD_GETINFO)) {
+			rc = -1;
+		}
+		break;
+	}
+
+	if (rc)
+		pr_err("elantech.c: failed to read register 0x%02x.\n", reg);
+	else
+		*val = param[0];
+
+	return rc;
+}
+
+/*
+ * Send an Elantech style special command to write a register with a value
+ */
+static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg,
+				unsigned char val)
+{
+	struct elantech_data *etd = psmouse->private;
+	int rc = 0;
+
+	if (reg < 0x10 || reg > 0x26)
+		return -1;
+
+	if (reg > 0x11 && reg < 0x20)
+		return -1;
+
+	switch (etd->hw_version) {
+	case 1:
+		if (psmouse_sliced_command(psmouse, ETP_REGISTER_WRITE) ||
+		    psmouse_sliced_command(psmouse, reg) ||
+		    psmouse_sliced_command(psmouse, val) ||
+		    ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
+			rc = -1;
+		}
+		break;
+
+	case 2:
+		if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(psmouse, NULL, ETP_REGISTER_WRITE) ||
+		    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(psmouse, NULL, reg) ||
+		    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(psmouse, NULL, val) ||
+		    elantech_ps2_command(psmouse, NULL, PSMOUSE_CMD_SETSCALE11)) {
+			rc = -1;
+		}
+		break;
+	}
+
+	if (rc)
+		pr_err("elantech.c: failed to write register 0x%02x with value 0x%02x.\n",
+			reg, val);
+
+	return rc;
+}
+
+/*
+ * Dump a complete mouse movement packet to the syslog
+ */
+static void elantech_packet_dump(unsigned char *packet, int size)
+{
+	int	i;
+
+	printk(KERN_DEBUG "elantech.c: PS/2 packet [");
+	for (i = 0; i < size; i++)
+		printk("%s0x%02x ", (i) ? ", " : " ", packet[i]);
+	printk("]\n");
+}
+
+/*
+ * Interpret complete data packets and report absolute mode input events for
+ * hardware version 1. (4 byte packets)
+ */
+static void elantech_report_absolute_v1(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct elantech_data *etd = psmouse->private;
+	unsigned char *packet = psmouse->packet;
+	int fingers;
+
+	if (etd->fw_version_maj == 0x01) {
+		/* byte 0:  D   U  p1  p2   1  p3   R   L
+		   byte 1:  f   0  th  tw  x9  x8  y9  y8 */
+		fingers = ((packet[1] & 0x80) >> 7) +
+				((packet[1] & 0x30) >> 4);
+	} else {
+		/* byte 0: n1  n0  p2  p1   1  p3   R   L
+		   byte 1:  0   0   0   0  x9  x8  y9  y8 */
+		fingers = (packet[0] & 0xc0) >> 6;
+	}
+
+	input_report_key(dev, BTN_TOUCH, fingers != 0);
+
+	/* byte 2: x7  x6  x5  x4  x3  x2  x1  x0
+	   byte 3: y7  y6  y5  y4  y3  y2  y1  y0 */
+	if (fingers) {
+		input_report_abs(dev, ABS_X,
+			((packet[1] & 0x0c) << 6) | packet[2]);
+		input_report_abs(dev, ABS_Y, ETP_YMAX_V1 -
+			(((packet[1] & 0x03) << 8) | packet[3]));
+	}
+
+	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
+	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
+	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
+	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+
+	if ((etd->fw_version_maj == 0x01) &&
+	    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
+		/* rocker up */
+		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40);
+		/* rocker down */
+		input_report_key(dev, BTN_BACK, packet[0] & 0x80);
+	}
+
+	input_sync(dev);
+}
+
+/*
+ * Interpret complete data packets and report absolute mode input events for
+ * hardware version 2. (6 byte packets)
+ */
+static void elantech_report_absolute_v2(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	unsigned char *packet = psmouse->packet;
+	int fingers, x1, y1, x2, y2;
+
+	/* byte 0: n1  n0   .   .   .   .   R   L */
+	fingers = (packet[0] & 0xc0) >> 6;
+	input_report_key(dev, BTN_TOUCH, fingers != 0);
+
+	switch (fingers) {
+	case 1:
+		/* byte 1: x15 x14 x13 x12 x11 x10 x9  x8
+		   byte 2: x7  x6  x5  x4  x4  x2  x1  x0 */
+		input_report_abs(dev, ABS_X, (packet[1] << 8) | packet[2]);
+		/* byte 4: y15 y14 y13 y12 y11 y10 y8  y8
+		   byte 5: y7  y6  y5  y4  y3  y2  y1  y0 */
+		input_report_abs(dev, ABS_Y, ETP_YMAX_V2 -
+			((packet[4] << 8) | packet[5]));
+		break;
+
+	case 2:
+		/* The coordinate of each finger is reported separately with
+		   a lower resolution for two finger touches */
+		/* byte 0:  .   .  ay8 ax8  .   .   .   .
+		   byte 1: ax7 ax6 ax5 ax4 ax3 ax2 ax1 ax0 */
+		x1 = ((packet[0] & 0x10) << 4) | packet[1];
+		/* byte 2: ay7 ay6 ay5 ay4 ay3 ay2 ay1 ay0 */
+		y1 = ETP_2FT_YMAX - (((packet[0] & 0x20) << 3) | packet[2]);
+		/* byte 3:  .   .  by8 bx8  .   .   .   .
+		   byte 4: bx7 bx6 bx5 bx4 bx3 bx2 bx1 bx0 */
+		x2 = ((packet[3] & 0x10) << 4) | packet[4];
+		/* byte 5: by7 by8 by5 by4 by3 by2 by1 by0 */
+		y2 = ETP_2FT_YMAX - (((packet[3] & 0x20) << 3) | packet[5]);
+		/* For compatibility with the X Synaptics driver scale up one
+		   coordinate and report as ordinary mouse movent */
+		input_report_abs(dev, ABS_X, x1 << 2);
+		input_report_abs(dev, ABS_Y, y1 << 2);
+		/* For compatibility with the proprietary X Elantech driver
+		   report both coordinates as hat coordinates */
+		input_report_abs(dev, ABS_HAT0X, x1);
+		input_report_abs(dev, ABS_HAT0Y, y1);
+		input_report_abs(dev, ABS_HAT1X, x2);
+		input_report_abs(dev, ABS_HAT1Y, y2);
+		break;
+	}
+
+	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
+	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
+	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
+	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+
+	input_sync(dev);
+}
+
+static int elantech_check_parity_v1(struct psmouse *psmouse)
+{
+	struct elantech_data *etd = psmouse->private;
+	unsigned char *packet = psmouse->packet;
+	unsigned char p1, p2, p3;
+
+	/* Parity bits are placed differently */
+	if (etd->fw_version_maj == 0x01) {
+		/* byte 0:  D   U  p1  p2   1  p3   R   L */
+		p1 = (packet[0] & 0x20) >> 5;
+		p2 = (packet[0] & 0x10) >> 4;
+	} else {
+		/* byte 0: n1  n0  p2  p1   1  p3   R   L */
+		p1 = (packet[0] & 0x10) >> 4;
+		p2 = (packet[0] & 0x20) >> 5;
+	}
+
+	p3 = (packet[0] & 0x04) >> 2;
+
+	return etd->parity[packet[1]] == p1 &&
+	       etd->parity[packet[2]] == p2 &&
+	       etd->parity[packet[3]] == p3;
+}
+
+/*
+ * Process byte stream from mouse and handle complete packets
+ */
+static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
+{
+	struct elantech_data *etd = psmouse->private;
+
+	if (psmouse->pktcnt < psmouse->pktsize)
+		return PSMOUSE_GOOD_DATA;
+
+	if (etd->debug > 1)
+		elantech_packet_dump(psmouse->packet, psmouse->pktsize);
+
+	switch (etd->hw_version) {
+	case 1:
+		if (etd->paritycheck && !elantech_check_parity_v1(psmouse))
+			return PSMOUSE_BAD_DATA;
+
+		elantech_report_absolute_v1(psmouse);
+		break;
+
+	case 2:
+		/* We don't now how to check parity in protocol v2 */
+		elantech_report_absolute_v2(psmouse);
+		break;
+	}
+
+	return PSMOUSE_FULL_PACKET;
+}
+
+/*
+ * Put the touchpad into absolute mode
+ */
+static int elantech_set_absolute_mode(struct psmouse *psmouse)
+{
+	struct elantech_data *etd = psmouse->private;
+	unsigned char val;
+	int tries = ETP_READ_BACK_TRIES;
+	int rc = 0;
+
+	switch (etd->hw_version) {
+	case 1:
+		etd->reg_10 = 0x16;
+		etd->reg_11 = 0x8f;
+		if (elantech_write_reg(psmouse, 0x10, etd->reg_10) ||
+		    elantech_write_reg(psmouse, 0x11, etd->reg_11)) {
+			rc = -1;
+		}
+		break;
+
+	case 2:
+					/* Windows driver values */
+		etd->reg_10 = 0x54;
+		etd->reg_11 = 0x88;	/* 0x8a */
+		etd->reg_21 = 0x60;	/* 0x00 */
+		if (elantech_write_reg(psmouse, 0x10, etd->reg_10) ||
+		    elantech_write_reg(psmouse, 0x11, etd->reg_11) ||
+		    elantech_write_reg(psmouse, 0x21, etd->reg_21)) {
+			rc = -1;
+			break;
+		}
+		/*
+		 * Read back reg 0x10. The touchpad is probably initalising
+		 * and not ready until we read back the value we just wrote.
+		 */
+		do {
+			rc = elantech_read_reg(psmouse, 0x10, &val);
+			if (rc == 0)
+				break;
+			tries--;
+			elantech_debug("elantech.c: retrying read (%d).\n",
+				tries);
+			msleep(ETP_READ_BACK_DELAY);
+		} while (tries > 0);
+		if (rc)
+			pr_err("elantech.c: failed to read back register 0x10.\n");
+		break;
+	}
+
+	if (rc)
+		pr_err("elantech.c: failed to initialise registers.\n");
+
+	return rc;
+}
+
+/*
+ * Set the appropriate event bits for the input subsystem
+ */
+static void elantech_set_input_params(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	struct elantech_data *etd = psmouse->private;
+
+	__set_bit(EV_KEY, dev->evbit);
+	__set_bit(EV_ABS, dev->evbit);
+
+	__set_bit(BTN_LEFT, dev->keybit);
+	__set_bit(BTN_RIGHT, dev->keybit);
+
+	__set_bit(BTN_TOUCH, dev->keybit);
+	__set_bit(BTN_TOOL_FINGER, dev->keybit);
+	__set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
+	__set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
+
+	switch (etd->hw_version) {
+	case 1:
+		/* Rocker button */
+		if ((etd->fw_version_maj == 0x01) &&
+		    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
+			__set_bit(BTN_FORWARD, dev->keybit);
+			__set_bit(BTN_BACK, dev->keybit);
+		}
+		input_set_abs_params(dev, ABS_X, ETP_XMIN_V1, ETP_XMAX_V1, 0, 0);
+		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V1, ETP_YMAX_V1, 0, 0);
+		break;
+
+	case 2:
+		input_set_abs_params(dev, ABS_X, ETP_XMIN_V2, ETP_XMAX_V2, 0, 0);
+		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V2, ETP_YMAX_V2, 0, 0);
+		input_set_abs_params(dev, ABS_HAT0X, ETP_2FT_XMIN, ETP_2FT_XMAX, 0, 0);
+		input_set_abs_params(dev, ABS_HAT0Y, ETP_2FT_YMIN, ETP_2FT_YMAX, 0, 0);
+		input_set_abs_params(dev, ABS_HAT1X, ETP_2FT_XMIN, ETP_2FT_XMAX, 0, 0);
+		input_set_abs_params(dev, ABS_HAT1Y, ETP_2FT_YMIN, ETP_2FT_YMAX, 0, 0);
+		break;
+	}
+}
+
+struct elantech_attr_data {
+	size_t		field_offset;
+	unsigned char	reg;
+};
+
+/*
+ * Display a register value by reading a sysfs entry
+ */
+static ssize_t elantech_show_int_attr(struct psmouse *psmouse, void *data,
+					char *buf)
+{
+	struct elantech_data *etd = psmouse->private;
+	struct elantech_attr_data *attr = data;
+	unsigned char *reg = (unsigned char *) etd + attr->field_offset;
+	int rc = 0;
+
+	if (attr->reg)
+		rc = elantech_read_reg(psmouse, attr->reg, reg);
+
+	return sprintf(buf, "0x%02x\n", (attr->reg && rc) ? -1 : *reg);
+}
+
+/*
+ * Write a register value by writing a sysfs entry
+ */
+static ssize_t elantech_set_int_attr(struct psmouse *psmouse,
+				     void *data, const char *buf, size_t count)
+{
+	struct elantech_data *etd = psmouse->private;
+	struct elantech_attr_data *attr = data;
+	unsigned char *reg = (unsigned char *) etd + attr->field_offset;
+	unsigned long value;
+	int err;
+
+	err = strict_strtoul(buf, 16, &value);
+	if (err)
+		return err;
+
+	if (value > 0xff)
+		return -EINVAL;
+
+	/* Do we need to preserve some bits for version 2 hardware too? */
+	if (etd->hw_version == 1) {
+		if (attr->reg == 0x10)
+			/* Force absolute mode always on */
+			value |= ETP_R10_ABSOLUTE_MODE;
+		else if (attr->reg == 0x11)
+			/* Force 4 byte mode always on */
+			value |= ETP_R11_4_BYTE_MODE;
+	}
+
+	if (!attr->reg || elantech_write_reg(psmouse, attr->reg, value) == 0)
+		*reg = value;
+
+	return count;
+}
+
+#define ELANTECH_INT_ATTR(_name, _register)				\
+	static struct elantech_attr_data elantech_attr_##_name = {	\
+		.field_offset = offsetof(struct elantech_data, _name),	\
+		.reg = _register,					\
+	};								\
+	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,			\
+			    &elantech_attr_##_name,			\
+			    elantech_show_int_attr,			\
+			    elantech_set_int_attr)
+
+ELANTECH_INT_ATTR(reg_10, 0x10);
+ELANTECH_INT_ATTR(reg_11, 0x11);
+ELANTECH_INT_ATTR(reg_20, 0x20);
+ELANTECH_INT_ATTR(reg_21, 0x21);
+ELANTECH_INT_ATTR(reg_22, 0x22);
+ELANTECH_INT_ATTR(reg_23, 0x23);
+ELANTECH_INT_ATTR(reg_24, 0x24);
+ELANTECH_INT_ATTR(reg_25, 0x25);
+ELANTECH_INT_ATTR(reg_26, 0x26);
+ELANTECH_INT_ATTR(debug, 0);
+ELANTECH_INT_ATTR(paritycheck, 0);
+
+static struct attribute *elantech_attrs[] = {
+	&psmouse_attr_reg_10.dattr.attr,
+	&psmouse_attr_reg_11.dattr.attr,
+	&psmouse_attr_reg_20.dattr.attr,
+	&psmouse_attr_reg_21.dattr.attr,
+	&psmouse_attr_reg_22.dattr.attr,
+	&psmouse_attr_reg_23.dattr.attr,
+	&psmouse_attr_reg_24.dattr.attr,
+	&psmouse_attr_reg_25.dattr.attr,
+	&psmouse_attr_reg_26.dattr.attr,
+	&psmouse_attr_debug.dattr.attr,
+	&psmouse_attr_paritycheck.dattr.attr,
+	NULL
+};
+
+static struct attribute_group elantech_attr_group = {
+	.attrs = elantech_attrs,
+};
+
+/*
+ * Use magic knock to detect Elantech touchpad
+ */
+int elantech_detect(struct psmouse *psmouse, int set_properties)
+{
+	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	unsigned char param[3];
+
+	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
+
+	if (ps2_command(ps2dev,  NULL, PSMOUSE_CMD_DISABLE) ||
+	    ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11) ||
+	    ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11) ||
+	    ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11) ||
+	    ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+		pr_err("elantech.c: sending Elantech magic knock failed.\n");
+		return -1;
+	}
+
+	/*
+	 * Report this in case there are Elantech models that use a different
+	 * set of magic numbers
+	 */
+	if (param[0] != 0x3c || param[1] != 0x03 || param[2] != 0xc8) {
+		pr_info("elantech.c: unexpected magic knock result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+		return -1;
+	}
+
+	if (set_properties) {
+		psmouse->vendor = "Elantech";
+		psmouse->name = "Touchpad";
+	}
+
+	return 0;
+}
+
+/*
+ * Clean up sysfs entries when disconnecting
+ */
+static void elantech_disconnect(struct psmouse *psmouse)
+{
+	sysfs_remove_group(&psmouse->ps2dev.serio->dev.kobj,
+			   &elantech_attr_group);
+	kfree(psmouse->private);
+	psmouse->private = NULL;
+}
+
+/*
+ * Put the touchpad back into absolute mode when reconnecting
+ */
+static int elantech_reconnect(struct psmouse *psmouse)
+{
+	if (elantech_detect(psmouse, 0))
+		return -1;
+
+	if (elantech_set_absolute_mode(psmouse)) {
+		pr_err("elantech.c: failed to put touchpad back into absolute mode.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize the touchpad and create sysfs entries
+ */
+int elantech_init(struct psmouse *psmouse)
+{
+	struct elantech_data *etd;
+	int i, error;
+	unsigned char param[3];
+
+	etd = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
+	psmouse->private = etd;
+	if (!etd)
+		return -1;
+
+	etd->parity[0] = 1;
+	for (i = 1; i < 256; i++)
+		etd->parity[i] = (etd->parity[i & (i - 1)] ^ 1);
+
+	/*
+	 * Find out what version hardware this is
+	 */
+	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
+		pr_err("elantech.c: failed to query firmware version.\n");
+		goto init_fail;
+	}
+	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	etd->fw_version_maj = param[0];
+	etd->fw_version_min = param[2];
+
+	/*
+	 * Assume every version greater than this is new EeePC style
+	 * hardware with 6 byte packets
+	 */
+	if ((etd->fw_version_maj >= 0x02) && (etd->fw_version_min >= 0x30)) {
+		etd->hw_version = 2;
+		/* For now show extra debug information */
+		etd->debug = 1;
+		/* Don't know how to do parity checking for version 2 */
+		etd->paritycheck = 0;
+	} else {
+		etd->hw_version = 1;
+		etd->paritycheck = 1;
+	}
+	pr_info("elantech.c: assuming hardware version %d, firmware version %d.%d\n",
+		etd->hw_version, etd->fw_version_maj, etd->fw_version_min);
+
+	if (synaptics_send_cmd(psmouse, ETP_CAPABILITIES_QUERY, param)) {
+		pr_err("elantech.c: failed to query capabilities.\n");
+		goto init_fail;
+	}
+	pr_info("elantech.c: Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	etd->capabilities = param[0];
+
+	if (elantech_set_absolute_mode(psmouse)) {
+		pr_err("elantech.c: failed to put touchpad into absolute mode.\n");
+		goto init_fail;
+	}
+
+	elantech_set_input_params(psmouse);
+
+	error = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
+				   &elantech_attr_group);
+	if (error) {
+		pr_err("elantech.c: failed to create sysfs attributes, error: %d.\n",
+			error);
+		goto init_fail;
+	}
+
+	psmouse->protocol_handler = elantech_process_byte;
+	psmouse->disconnect = elantech_disconnect;
+	psmouse->reconnect = elantech_reconnect;
+	psmouse->pktsize = etd->hw_version == 2 ? 6 : 4;
+
+	return 0;
+
+ init_fail:
+	kfree(etd);
+	return -1;
+}
diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
new file mode 100644
index 0000000..bee282b
--- /dev/null
+++ b/drivers/input/mouse/elantech.h
@@ -0,0 +1,124 @@
+/*
+ * Elantech Touchpad driver (v5)
+ *
+ * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+#ifndef _ELANTECH_H
+#define _ELANTECH_H
+
+/*
+ * Command values for Synaptics style queries
+ */
+#define ETP_FW_VERSION_QUERY		0x01
+#define ETP_CAPABILITIES_QUERY		0x02
+
+/*
+ * Command values for register reading or writing
+ */
+#define ETP_REGISTER_READ		0x10
+#define ETP_REGISTER_WRITE		0x11
+
+/*
+ * Hardware version 2 custom PS/2 command value
+ */
+#define ETP_PS2_CUSTOM_COMMAND		0xf8
+
+/*
+ * Times to retry a ps2_command and millisecond delay between tries
+ */
+#define ETP_PS2_COMMAND_TRIES		3
+#define ETP_PS2_COMMAND_DELAY		500
+
+/*
+ * Times to try to read back a register and millisecond delay between tries
+ */
+#define ETP_READ_BACK_TRIES		5
+#define ETP_READ_BACK_DELAY		2000
+
+/*
+ * Register bitmasks for hardware version 1
+ */
+#define ETP_R10_ABSOLUTE_MODE		0x04
+#define ETP_R11_4_BYTE_MODE		0x02
+
+/*
+ * Capability bitmasks
+ */
+#define ETP_CAP_HAS_ROCKER		0x04
+
+/*
+ * One hard to find application note states that X axis range is 0 to 576
+ * and Y axis range is 0 to 384 for harware version 1.
+ * Edge fuzz might be necessary because of bezel around the touchpad
+ */
+#define ETP_EDGE_FUZZ_V1		32
+
+#define ETP_XMIN_V1			(  0 + ETP_EDGE_FUZZ_V1)
+#define ETP_XMAX_V1			(576 - ETP_EDGE_FUZZ_V1)
+#define ETP_YMIN_V1			(  0 + ETP_EDGE_FUZZ_V1)
+#define ETP_YMAX_V1			(384 - ETP_EDGE_FUZZ_V1)
+
+/*
+ * It seems the resolution for hardware version 2 doubled.
+ * Hence the X and Y ranges are doubled too.
+ * The bezel around the pad also appears to be smaller
+ */
+#define ETP_EDGE_FUZZ_V2		8
+
+#define ETP_XMIN_V2			(   0 + ETP_EDGE_FUZZ_V2)
+#define ETP_XMAX_V2			(1152 - ETP_EDGE_FUZZ_V2)
+#define ETP_YMIN_V2			(   0 + ETP_EDGE_FUZZ_V2)
+#define ETP_YMAX_V2			( 768 - ETP_EDGE_FUZZ_V2)
+
+/*
+ * For two finger touches the coordinate of each finger gets reported
+ * separately but with reduced resolution.
+ */
+#define ETP_2FT_FUZZ			4
+
+#define ETP_2FT_XMIN			(  0 + ETP_2FT_FUZZ)
+#define ETP_2FT_XMAX			(288 - ETP_2FT_FUZZ)
+#define ETP_2FT_YMIN			(  0 + ETP_2FT_FUZZ)
+#define ETP_2FT_YMAX			(192 - ETP_2FT_FUZZ)
+
+struct elantech_data {
+	unsigned char reg_10;
+	unsigned char reg_11;
+	unsigned char reg_20;
+	unsigned char reg_21;
+	unsigned char reg_22;
+	unsigned char reg_23;
+	unsigned char reg_24;
+	unsigned char reg_25;
+	unsigned char reg_26;
+	unsigned char debug;
+	unsigned char capabilities;
+	unsigned char fw_version_maj;
+	unsigned char fw_version_min;
+	unsigned char hw_version;
+	unsigned char paritycheck;
+	unsigned char parity[256];
+};
+
+#ifdef CONFIG_MOUSE_PS2_ELANTECH
+int elantech_detect(struct psmouse *psmouse, int set_properties);
+int elantech_init(struct psmouse *psmouse);
+#else
+static inline int elantech_detect(struct psmouse *psmouse, int set_properties)
+{
+	return -ENOSYS;
+}
+static inline int elantech_init(struct psmouse *psmouse)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_MOUSE_PS2_ELANTECH */
+
+#endif
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 126e977..bad348c 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -29,6 +29,7 @@
 #include "lifebook.h"
 #include "trackpoint.h"
 #include "touchkit_ps2.h"
+#include "elantech.h"
 
 #define DRIVER_DESC	"PS/2 mouse driver"
 
@@ -650,6 +651,19 @@ static int psmouse_extensions(struct psmouse *psmouse,
 		max_proto = PSMOUSE_IMEX;
 	}
 
+/*
+ * Try Elantech touchpad.
+ */
+	if (max_proto > PSMOUSE_IMEX && 
+			elantech_detect(psmouse, set_properties) == 0) {
+		if (!set_properties || elantech_init(psmouse) == 0)
+			return PSMOUSE_ELANTECH;
+/*
+ * Init failed, try basic relative protocols
+ */
+		max_proto = PSMOUSE_IMEX;
+	}
+
 	if (max_proto > PSMOUSE_IMEX) {
 		if (genius_detect(psmouse, set_properties) == 0)
 			return PSMOUSE_GENPS;
@@ -789,6 +803,15 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.detect		= hgpk_detect,
 	},
 #endif
+#ifdef CONFIG_MOUSE_PS2_ELANTECH
+	{
+		.type		= PSMOUSE_ELANTECH,
+		.name		= "ETPS/2",
+		.alias		= "elantech",
+		.detect		= elantech_detect,
+		.init		= elantech_init,
+	},
+ #endif
 	{
 		.type		= PSMOUSE_CORTRON,
 		.name		= "CortronPS/2",
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 8b608a1..54ed267 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -90,6 +90,7 @@ enum psmouse_type {
 	PSMOUSE_TOUCHKIT_PS2,
 	PSMOUSE_CORTRON,
 	PSMOUSE_HGPK,
+	PSMOUSE_ELANTECH,
 	PSMOUSE_AUTO		/* This one should always be last */
 };
 

--BOKacYhQ+x31HxR3--
