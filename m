Return-Path: <linux-kernel-owner+w=401wt.eu-S965075AbXCSVnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075AbXCSVnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965145AbXCSVnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:43:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:56103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075AbXCSVm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:57 -0400
Date: Mon, 19 Mar 2007 14:41:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 29/31] Input: i8042 - fix AUX IRQ delivery check
Message-ID: <20070319214108.GE9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-fix-aux-irq-delivery-check.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dtor@insightbb.com>

Input: i8042 - fix AUX IRQ delivery check

On boxes that do not implement AUX LOOP command we can not
verify AUX IRQ delivery and must assume that it is wired
properly.

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -543,6 +543,7 @@ static int __devinit i8042_check_aux(voi
 {
 	int retval = -1;
 	int irq_registered = 0;
+	int aux_loop_broken = 0;
 	unsigned long flags;
 	unsigned char param;
 
@@ -572,6 +573,8 @@ static int __devinit i8042_check_aux(voi
 		if (i8042_command(&param, I8042_CMD_AUX_TEST) ||
 		    (param && param != 0xfa && param != 0xff))
 			return -1;
+
+		aux_loop_broken = 1;
 	}
 
 /*
@@ -595,7 +598,7 @@ static int __devinit i8042_check_aux(voi
  * used it for a PCI card or somethig else.
  */
 
-	if (i8042_noloop) {
+	if (i8042_noloop || aux_loop_broken) {
 /*
  * Without LOOP command we can't test AUX IRQ delivery. Assume the port
  * is working and hope we are right.

-- 
