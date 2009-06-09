Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbZFIK1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbZFIK1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760746AbZFIKTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:55 -0400
Received: from kroah.org ([198.145.64.141]:54964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760740AbZFIKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:54 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:02 2009
Message-Id: <20090609094102.377860651@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:32 -0700
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
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 44/87] ide: fix OOPS during ide-cd error recovery
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ide-fix-oops-during-ide-cd-error-recovery.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit e3b29f05124b07303088795396ff858811d2acb8 upstream.

On Tuesday 19 May 2009 20:29:28 Martin Lottermoser wrote:

>   hdc: cdrom_decode_status: error=0x40 <3>{ LastFailedSense=0x04 }
>   ide: failed opcode was: unknown
>   hdc: DMA disabled
>   ------------[ cut here ]------------
>   kernel BUG at drivers/ide/ide-io.c:872!

It is possible for ide-cd to ignore ide_error()'s return value under
some circumstances.  Workaround it in ide_intr() and ide_timer_expiry()
by checking if there is a device/port reset pending currently.

Fixes bug #13345:

	http://bugzilla.kernel.org/show_bug.cgi?id=13345

Reported-by: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Reported-and-tested-by: Modestas Vainius <modestas@vainius.eu>
Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -967,7 +967,7 @@ void ide_timer_expiry (unsigned long dat
 		}
 		spin_lock_irq(&hwif->lock);
 		enable_irq(hwif->irq);
-		if (startstop == ide_stopped) {
+		if (startstop == ide_stopped && hwif->polling == 0) {
 			ide_unlock_port(hwif);
 			plug_device = 1;
 		}
@@ -1145,7 +1145,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	 * same irq as is currently being serviced here, and Linux
 	 * won't allow another of the same (on any CPU) until we return.
 	 */
-	if (startstop == ide_stopped) {
+	if (startstop == ide_stopped && hwif->polling == 0) {
 		BUG_ON(hwif->handler);
 		ide_unlock_port(hwif);
 		plug_device = 1;


