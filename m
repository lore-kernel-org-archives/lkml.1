Return-Path: <linux-kernel-owner+w=401wt.eu-S1030369AbXDMXfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369AbXDMXfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030891AbXDMXfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:35:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46082
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030369AbXDMXfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:35:30 -0400
Date: Fri, 13 Apr 2007 16:35:21 -0700 (PDT)
Message-Id: <20070413.163521.45883605.davem@davemloft.net>
To: drraid@gmail.com
Cc: linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: Kernel 2.6.20.4 Unaligned address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1f8291090704101602q41e30a7doe79f3606643b628b@mail.gmail.com>
References: <1f8291090704101602q41e30a7doe79f3606643b628b@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "doctor raid" <drraid@gmail.com>
Date: Tue, 10 Apr 2007 16:02:01 -0700

> [1] kernel errors reporting unaligned access of memory
> [2]  The following two lines iterate twice a piece, about once every 2 minutes:
> 
>       Kernel unaligned access at TPC[79c344] arpt_do_table+0x3cc/0x640
>        Kernel unaligned access at TPC[79c33c] arpt_do_table+0x3c4/0x640

This patch below should fix this problem.

Patrick I'm going to push this to Linus.  Even if it doesn't
fix this person's problem, either both the input device loop
and the output device loop should use the "long" casting
optimization or both should not :-)

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 5170f5c..57b0221 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -166,13 +166,9 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		return 0;
 	}
 
-	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
-		unsigned long odev;
-		memcpy(&odev, outdev + i*sizeof(unsigned long),
-		       sizeof(unsigned long));
-		ret |= (odev
-			^ ((const unsigned long *)arpinfo->outiface)[i])
-			& ((const unsigned long *)arpinfo->outiface_mask)[i];
+	for (i = 0, ret = 0; i < IFNAMSIZ; i++) {
+		ret |= (outdev[i] ^ arpinfo->outiface[i])
+			& arpinfo->outiface_mask[i];
 	}
 
 	if (FWINV(ret != 0, ARPT_INV_VIA_OUT)) {
