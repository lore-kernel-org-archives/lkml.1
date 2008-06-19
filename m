Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbYFSVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbYFSVc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYFSVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:31:45 -0400
Received: from mail.suse.de ([195.135.220.2]:38031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYFSVbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:31:44 -0400
Date: Thu, 19 Jun 2008 14:29:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Juergen Kosel <juergen.kosel@gmx.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 03/15] opti621: disable read prefetch
Message-ID: <20080619212945.GD20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="opti621-disable-read-prefetch.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 62128b2ca812c1266f4ff7bac068bf0b626c6179 upstream

This fixes 2.6.25 regression (kernel.org bugzilla bug #10723) caused by:

commit 912fb29a36a7269ac1c4a4df45bc0ac1d2637972
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Fri Oct 19 00:30:11 2007 +0200

    opti621: always tune PIO
...

Based on a bugreport from Juergen Kosel & inspired by pata_opti.c code.

Bisected-by: Juergen Kosel <juergen.kosel@gmx.de>
Tested-by: Juergen Kosel <juergen.kosel@gmx.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/pci/opti621.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -103,18 +103,6 @@
  *  address: 50 ns, data: 50 ns, recovery: 100 ns.
  */
 
-/* #define READ_PREFETCH 0 */
-/* Uncomment for disable read prefetch.
- * There is some readprefetch capatibility in hdparm,
- * but when I type hdparm -P 1 /dev/hda, I got errors
- * and till reset drive is inaccessible.
- * This (hw) read prefetch is safe on my drive.
- */
-
-#ifndef READ_PREFETCH
-#define READ_PREFETCH 0x40 /* read prefetch is enabled */
-#endif /* else read prefetch is disabled */
-
 #define READ_REG 0	/* index of Read cycle timing register */
 #define WRITE_REG 1	/* index of Write cycle timing register */
 #define CNTRL_REG 3	/* index of Control register */
@@ -260,7 +248,8 @@ static void opti621_set_pio_mode(ide_dri
 
 	cycle1 = ((first.data_time-1)<<4)  | (first.recovery_time-2);
 	cycle2 = ((second.data_time-1)<<4) | (second.recovery_time-2);
-	misc = READ_PREFETCH | ((ax-1)<<4) | ((drdy-2)<<1);
+
+	misc = ((ax - 1) << 4) | ((drdy - 2) << 1);
 
 #ifdef OPTI621_DEBUG
 	printk("%s: master: address: %d, data: %d, "

-- 
