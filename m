Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbXIXQgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbXIXQgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbXIXQ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57938 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760782AbXIXQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:03 -0400
Date: Mon, 24 Sep 2007 09:21:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>,
       nfs@lists.sourceforge.net, trond.myklebust@fys.uio.no,
       Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [31/50] Correctly close old nfsd/lockd sockets.
Message-ID: <20070924162146.GF13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="correctly-close-old-nfsd-lockd-sockets.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

commit 7a1fa065a0264f6b3d3003ba5635289f6583c478 in mainline.

Commit aaf68cfbf2241d24d46583423f6bff5c47e088b3 added a bias
to sk_inuse, so this test for an unused socket now fails.  So no
sockets get closed because they are old (they might get closed
if the client closed them).

This bug has existed since 2.6.21-rc1.

Thanks to Wolfgang Walter for finding and reporting the bug.

Cc: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svcsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1573,7 +1573,8 @@ svc_age_temp_sockets(unsigned long closu
 
 		if (!test_and_set_bit(SK_OLD, &svsk->sk_flags))
 			continue;
-		if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY, &svsk->sk_flags))
+		if (atomic_read(&svsk->sk_inuse) > 1
+		    || test_bit(SK_BUSY, &svsk->sk_flags))
 			continue;
 		atomic_inc(&svsk->sk_inuse);
 		list_move(le, &to_be_aged);

-- 
