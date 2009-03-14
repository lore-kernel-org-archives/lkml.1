Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbZCNBmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbZCNBmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZCNBVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:03 -0400
Received: from kroah.org ([198.145.64.141]:35364 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754091AbZCNBUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:40 2009
Message-Id: <20090314011040.309454816@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:37 -0700
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
       alan@lxorguk.ukuu.org.uk, Yauhen Kharuzhy <jekhor@gmail.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 060/114] s3cmci: Fix hangup in do_pio_write()
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=s3cmci-fix-hangup-in-do_pio_write.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yauhen Kharuzhy <jekhor@gmail.com>

commit 994244883739e4044bef76d4e5d7a9b66dc6c7b6 upstream.

This commit fixes the regression what was added by commit
088a78af978d0c8e339071a9b2bca1f4cb368f30 "s3cmci: Support transfers
which are not multiple of 32 bits."

fifo_free() now returns amount of available space in FIFO buffer in
bytes.  But do_pio_write() writes to FIFO 32-bit words.  Condition for
return from cycle is (fifo_free() == 0), but when fifo has 1..3 bytes
of free space then this condition will never be true and system hangs.

This patch changes condition in the while() to (fifo_free() > 3).

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

---
 drivers/mmc/host/s3cmci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -329,7 +329,7 @@ static void do_pio_write(struct s3cmci_h
 
 	to_ptr = host->base + host->sdidata;
 
-	while ((fifo = fifo_free(host))) {
+	while ((fifo = fifo_free(host)) > 3) {
 		if (!host->pio_bytes) {
 			res = get_data_buffer(host, &host->pio_bytes,
 							&host->pio_ptr);


