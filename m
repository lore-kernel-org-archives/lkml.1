Return-Path: <linux-kernel-owner+w=401wt.eu-S968689AbXGaEel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968689AbXGaEel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967566AbXGaEbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:31:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34540 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967541AbXGaEba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:31:30 -0400
Date: Mon, 30 Jul 2007 21:32:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, agk@redhat.com,
       Olaf Kirch <olaf.kirch@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/26] dm crypt: fix avoid cloned bio ref after free
Message-ID: <20070731043224.GL3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Olaf Kirch <olaf.kirch@oracle.com>

Do not access the bio after generic_make_request

We should never access a bio after generic_make_request - there's no guarantee
it still exists.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=98221eb757de03d9aa6262b1eded2be708640ccc

 drivers/md/dm-crypt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.21.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6.21.6/drivers/md/dm-crypt.c
@@ -655,9 +655,12 @@ static void process_write(struct crypt_i
 
 		generic_make_request(clone);
 
+		/* Do not reference clone after this - it
+		 * may be gone already. */
+
 		/* out of memory -> run queues */
 		if (remaining)
-			congestion_wait(bio_data_dir(clone), HZ/100);
+			congestion_wait(WRITE, HZ/100);
 	}
 }
 

-- 
