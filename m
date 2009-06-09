Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbZFIKbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbZFIKbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932094AbZFIKUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:51 -0400
Received: from kroah.org ([198.145.64.141]:55241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbZFIKUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:50 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:06 2009
Message-Id: <20090609094105.911241431@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:47 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 59/87] cdc-acm: Fix long standing abuse of tty->low_latency
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=cdc-acm-fix-long-standing-abuse-of-tty-low_latency.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

commit 7a9a65ced11ece416b730d6f21040a18e62d78a8 upstream.

ACM sets the low latency flag but calls the flip buffer routines from
IRQ context which isn't permitted (and as of 2.6.29 causes a warning
hence this one was caught)

Fortunatelt ACM doesn't need to set this flag in the first place as it
only set it to work around problems in ancient (pre tty flip rewrite)
kernels.

Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -546,10 +546,6 @@ static int acm_tty_open(struct tty_struc
 	tty->driver_data = acm;
 	acm->tty = tty;
 
-	/* force low_latency on so that our tty_push actually forces the data through,
-	   otherwise it is scheduled, and with high data rates data can get lost. */
-	tty->low_latency = 1;
-
 	if (usb_autopm_get_interface(acm->control) < 0)
 		goto early_bail;
 	else


