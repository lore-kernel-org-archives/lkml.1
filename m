Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYJGAt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYJGAt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYJGAnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:60515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbYJGAnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:52 -0400
Date: Mon, 6 Oct 2008 17:38:33 -0700
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
       alan@lxorguk.ukuu.org.uk, James.Bottomley@HansenPartnership.com,
       jens.axboe@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [patch 26/71] sg: disable interrupts inside sg_copy_buffer
Message-ID: <20081007003833.GA3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sg-disable-interrupts-inside-sg_copy_buffer.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This is the backport of the upstream commit 50bed2e2862a8f3a4f7d683d0d27292e71ef18b9

The callers of sg_copy_buffer must disable interrupts before calling
it (since it uses kmap_atomic). Some callers use it on
interrupt-disabled code but some need to take the trouble to disable
interrupts just for this. No wonder they forget about it and we hit a
bug like:

http://bugzilla.kernel.org/show_bug.cgi?id=11529

James said that it might be better to disable interrupts inside the
function rather than risk the callers getting it wrong.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/scatterlist.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -312,8 +312,9 @@ static size_t sg_copy_buffer(struct scat
 	struct scatterlist *sg;
 	size_t buf_off = 0;
 	int i;
+	unsigned long flags;
 
-	WARN_ON(!irqs_disabled());
+	local_irq_save(flags);
 
 	for_each_sg(sgl, sg, nents, i) {
 		struct page *page;
@@ -358,6 +359,8 @@ static size_t sg_copy_buffer(struct scat
 			break;
 	}
 
+	local_irq_restore(flags);
+
 	return buf_off;
 }
 

-- 
