Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbYGVXbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbYGVXbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbYGVXXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:12 -0400
Received: from mail.suse.de ([195.135.220.2]:53644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbYGVXXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:10 -0400
Date: Tue, 22 Jul 2008 16:17:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Jenkins <darrenrjenkins@gmail.com>, Karsten Keil <kkeil@suse.de>
Subject: [patch 39/47] drivers/isdn/i4l/isdn_common.c fix small resource
	leak
Message-ID: <20080722231716.GN8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-isdn-i4l-isdn_common.c-fix-small-resource-leak.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Darren Jenkins <darrenrjenkins@gmail.com>

commit 4fc89e3911aa5357b55b85b60c4beaeb8a48a290 upstream

Coverity CID: 1356 RESOURCE_LEAK

I found a very old patch for this that was Acked but did not get applied
https://lists.linux-foundation.org/pipermail/kernel-janitors/2006-September/016362.html

There looks to be a small leak in isdn_writebuf_stub() in isdn_common.c, when
copy_from_user() returns an un-copied data length (length != 0).  The below
patch should be a minimally invasive fix.

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/i4l/isdn_common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1977,8 +1977,10 @@ isdn_writebuf_stub(int drvidx, int chan,
 	if (!skb)
 		return -ENOMEM;
 	skb_reserve(skb, hl);
-	if (copy_from_user(skb_put(skb, len), buf, len))
+	if (copy_from_user(skb_put(skb, len), buf, len)) {
+		dev_kfree_skb(skb);
 		return -EFAULT;
+	}
 	ret = dev->drv[drvidx]->interface->writebuf_skb(drvidx, chan, 1, skb);
 	if (ret <= 0)
 		dev_kfree_skb(skb);

-- 
