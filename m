Return-Path: <linux-kernel-owner+w=401wt.eu-S1764469AbZBNBgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764469AbZBNBgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763334AbZBNBQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:26 -0500
Received: from kroah.org ([198.145.64.141]:50384 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763330AbZBNBQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:18 -0500
Date: Fri, 13 Feb 2009 17:13:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Shyam Iyer <shyam_iyer@dell.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/48] net: Fix OOPS in skb_seq_read().
Message-ID: <20090214011300.GU17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-oops-in-skb_seq_read.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shyam Iyer <shyam_iyer@dell.com>

[ Upstream commit 71b3346d182355f19509fadb8fe45114a35cc499 ]

It oopsd for me in skb_seq_read. addr2line said it was
linux-2.6/net/core/skbuff.c:2228, which is this line:

	while (st->frag_idx < skb_shinfo(st->cur_skb)->nr_frags) {

I added some printks in there and it looks like we hit this:

        } else if (st->root_skb == st->cur_skb &&
                   skb_shinfo(st->root_skb)->frag_list) {
                 st->cur_skb = skb_shinfo(st->root_skb)->frag_list;
                 st->frag_idx = 0;
                 goto next_skb;
        }

Actually I did some testing and added a few printks and found that the
st->cur_skb->data was 0 and hence the ptr used by iscsi_tcp was null.
This caused the kernel panic.

 	if (abs_offset < block_limit) {
-		*data = st->cur_skb->data + abs_offset;
+		*data = st->cur_skb->data + (abs_offset - st->stepped_offset);

I enabled the debug_tcp and with a few printks found that the code did
not go to the next_skb label and could find that the sequence being
followed was this -

It hit this if condition -

        if (st->cur_skb->next) {
                st->cur_skb = st->cur_skb->next;
                st->frag_idx = 0;
                goto next_skb;

And so, now the st pointer is shifted to the next skb whereas actually
it should have hit the second else if first since the data is in the
frag_list.

        else if (st->root_skb == st->cur_skb &&
                 skb_shinfo(st->root_skb)->frag_list) {
                st->cur_skb = skb_shinfo(st->root_skb)->frag_list;
                goto next_skb;
        }

Reversing the two conditions the attached patch fixes the issue for me
on top of Herbert's patches.

Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/skbuff.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2110,13 +2110,13 @@ next_skb:
 		st->frag_data = NULL;
 	}
 
-	if (st->cur_skb->next) {
-		st->cur_skb = st->cur_skb->next;
+	if (st->root_skb == st->cur_skb &&
+	    skb_shinfo(st->root_skb)->frag_list) {
+		st->cur_skb = skb_shinfo(st->root_skb)->frag_list;
 		st->frag_idx = 0;
 		goto next_skb;
-	} else if (st->root_skb == st->cur_skb &&
-		   skb_shinfo(st->root_skb)->frag_list) {
-		st->cur_skb = skb_shinfo(st->root_skb)->frag_list;
+	} else if (st->cur_skb->next) {
+		st->cur_skb = st->cur_skb->next;
 		st->frag_idx = 0;
 		goto next_skb;
 	}

