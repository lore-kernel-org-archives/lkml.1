Return-Path: <linux-kernel-owner+w=401wt.eu-S936556AbZLQEaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936556AbZLQEaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935669AbZLQEEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:42 -0500
Received: from kroah.org ([198.145.64.141]:55639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935654AbZLQEEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:52 2009
Message-Id: <20091217035652.466792154@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [074/151] powerpc/therm_adt746x: Record pwm invert bit at module load time]
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Darrick J. Wong <djwong@us.ibm.com>

commit 1496e89ae2a0962748e55165a590fa3209c6f158 upstream.

In commit 0512a9a8e277a9de2820211eef964473b714ae65, we unilaterally zero the
"pwm invert" bit in the fan behavior configuration register.  On my PowerBook
G4, this results in the fans going to full speed at low temperature and
shutting off at high temperature because the pwm invert bit is supposed to be
set.

Therefore, record the pwm invert bit at driver load time, and write the bit
into the fan behavior control register.  This restores correct behavior on my
PBG4 and should work around the bit being set to the wrong value after
suspend/resume (which is what the original patch was trying to fix).  It also
fixes a minor omission where the pwm invert bit correction is NOT performed
when switching into automatic mode.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/macintosh/therm_adt746x.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -79,6 +79,7 @@ struct thermostat {
 	u8			limits[3];
 	int			last_speed[2];
 	int			last_var[2];
+	int			pwm_inv[2];
 };
 
 static enum {ADT7460, ADT7467} therm_type;
@@ -229,19 +230,23 @@ static void write_fan_speed(struct therm
 	
 	if (speed >= 0) {
 		manual = read_reg(th, MANUAL_MODE[fan]);
+		manual &= ~INVERT_MASK;
 		write_reg(th, MANUAL_MODE[fan],
-			(manual|MANUAL_MASK) & (~INVERT_MASK));
+			manual | MANUAL_MASK | th->pwm_inv[fan]);
 		write_reg(th, FAN_SPD_SET[fan], speed);
 	} else {
 		/* back to automatic */
 		if(therm_type == ADT7460) {
 			manual = read_reg(th,
 				MANUAL_MODE[fan]) & (~MANUAL_MASK);
-
+			manual &= ~INVERT_MASK;
+			manual |= th->pwm_inv[fan];
 			write_reg(th,
 				MANUAL_MODE[fan], manual|REM_CONTROL[fan]);
 		} else {
 			manual = read_reg(th, MANUAL_MODE[fan]);
+			manual &= ~INVERT_MASK;
+			manual |= th->pwm_inv[fan];
 			write_reg(th, MANUAL_MODE[fan], manual&(~AUTO_MASK));
 		}
 	}
@@ -418,6 +423,10 @@ static int probe_thermostat(struct i2c_c
 
 	thermostat = th;
 
+	/* record invert bit status because fw can corrupt it after suspend */
+	th->pwm_inv[0] = read_reg(th, MANUAL_MODE[0]) & INVERT_MASK;
+	th->pwm_inv[1] = read_reg(th, MANUAL_MODE[1]) & INVERT_MASK;
+
 	/* be sure to really write fan speed the first time */
 	th->last_speed[0] = -2;
 	th->last_speed[1] = -2;


