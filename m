Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZLMNMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZLMNMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZLMNLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:11:44 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38866 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753102AbZLMNLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:11:43 -0500
Date: Sun, 13 Dec 2009 14:11:39 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/staging/batman-adv: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0912131411100.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.
Similarly for usb-alloc urb.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/staging/batman-adv/send.c   |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/batman-adv/send.c b/drivers/staging/batman-adv/send.c
index d724798..eb61750 100644
--- a/drivers/staging/batman-adv/send.c
+++ b/drivers/staging/batman-adv/send.c
@@ -363,8 +363,10 @@ void add_bcast_packet_to_list(unsigned char *packet_buff, int packet_len)
 		return;
 
 	forw_packet->packet_buff = kmalloc(packet_len, GFP_ATOMIC);
-	if (!forw_packet->packet_buff)
+	if (!forw_packet->packet_buff) {
+		kfree(forw_packet);
 		return;
+	}
 
 	forw_packet->packet_len = packet_len;
 	memcpy(forw_packet->packet_buff, packet_buff, forw_packet->packet_len);
