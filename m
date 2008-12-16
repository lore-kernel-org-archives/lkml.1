Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYLPJY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYLPJY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYLPJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:24:13 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43169 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbYLPJYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:24:11 -0500
Message-Id: <20081216092408.362722962@linux.vnet.ibm.com>
References: <20081216091544.061115344@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 16 Dec 2008 10:15:45 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [patch 1/1] hvc_console: escape magic sysrq key
Content-Disposition: inline; filename=hvc/common/08_hvc_escape_sysrq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

The ctrl-o (^O) is a common control key used by several applications like vim.

To allow users to send ^O to the terminal, this patch introduces a check
if ^O is pressed again if the sysrq_pressed variable is already set.
In this case, clear sysrq_pressed state and flip the ^O character to the tty.
(The old behavior has always set "sysrq_pressed" if ^0 has been entered, and it
has not flipped the ^O character to the tty.)

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/hvc_console.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -642,8 +642,11 @@ int hvc_poll(struct hvc_struct *hp)
 				/* Handle the SysRq Hack */
 				/* XXX should support a sequence */
 				if (buf[i] == '\x0f') {	/* ^O */
-					sysrq_pressed = 1;
-					continue;
+					/* if ^0 is pressed again, reset
+					 * sysrq_pressed and flip ^0 char */
+					sysrq_pressed = (sysrq_pressed) ? 0 : 1;
+					if (sysrq_pressed)
+						continue;
 				} else if (sysrq_pressed) {
 					handle_sysrq(buf[i], tty);
 					sysrq_pressed = 0;

-- 
Hendrik Brueckner
D/3303 Linux on System z Development
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

