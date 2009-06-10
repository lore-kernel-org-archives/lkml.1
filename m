Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbZFJDhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbZFJDhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZFJDeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:34:06 -0400
Received: from kroah.org ([198.145.64.141]:56754 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668AbZFJDeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:34:05 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:43 2009
Message-Id: <20090610002343.171466406@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:43 -0700
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
       alan@lxorguk.ukuu.org.uk, Thomas Chenault <thomas_chenault@dell.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/60] net: fix skb_seq_read returning wrong offset/length for page frag data
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=net-fix-skb_seq_read-returning-wrong-offset-length-for-page-frag-data.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Chenault <thomas_chenault@dell.com>

[ Upstream commit 995b337952cdf7e05d288eede580257b632a8343 ]

When called with a consumed value that is less than skb_headlen(skb)
bytes into a page frag, skb_seq_read() incorrectly returns an
offset/length relative to skb->data. Ensure that data which should come
from a page frag does.

Signed-off-by: Thomas Chenault <thomas_chenault@dell.com>
Tested-by: Shyam Iyer <shyam_iyer@dell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1992,7 +1992,7 @@ unsigned int skb_seq_read(unsigned int c
 next_skb:
 	block_limit = skb_headlen(st->cur_skb) + st->stepped_offset;
 
-	if (abs_offset < block_limit) {
+	if (abs_offset < block_limit && !st->frag_data) {
 		*data = st->cur_skb->data + (abs_offset - st->stepped_offset);
 		return block_limit - abs_offset;
 	}


