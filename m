Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbXI1VkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbXI1VkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXI1VkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:40:00 -0400
Received: from zion.dlh.net ([194.126.239.225]:53197 "EHLO mail.dlh.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753182AbXI1Vj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:39:59 -0400
X-Greylist: delayed 3450 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 17:39:59 EDT
Message-ID: <23966.84.62.25.8.1191012145.squirrel@cs1.dlh.net>
Date: Fri, 28 Sep 2007 22:42:25 +0200 (CEST)
Subject: PATCH: tcp rfc 2385 security/bugfix for sparc64
From: "Peter Lieven" <pl@dlh.net>
To: sparclinux@vger.kernel.org, davem@davemloft.net
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TCP MD5 signatures on sparc64 (big-endian) completely fail on current
kernel releases in interoperability with Cisco/Foundry or other
little-endian linux systems.

The root cause is a cast in the return statement of tcp_v4_md5_do_lookup,
where a tcp4_md5sig_key is casted onto tcp_md5sig_key without proper
conversion. On little-endian systems the upper 8 bits are cut of which
yields the expected behaviour. However, on big-endian systems (like
sparc64) only the most significant 8 bits are preserved. Since
TCP_MD5SIG_MAXKEYLEN is 80, this always yields 0.

In the calculation of the md5 signature afterwards the key is therefore
not appended to the tcp segment which could result in a security problem
since only the presence of a md5 signature is checked, and the key itself
doesn't matter.

--- linux.old/include/net/tcp.h 2007-09-28 21:43:26.000000000 +0200 +++
linux/include/net/tcp.h     2007-09-28 21:45:35.000000000 +0200 @@ -1055,6
+1055,7 @@ static inline void clear_all_retrans_hin
 struct crypto_hash;

 /* - key database */
+/* this should be compatible with the head of the following two structs */
 struct tcp_md5sig_key {
        u8                      *key;
        u8                      keylen;
@@ -1062,13 +1063,13 @@ struct tcp_md5sig_key {

 struct tcp4_md5sig_key {
        u8                      *key;
-       u16                     keylen;
+       u8                      keylen;
        __be32                  addr;
 };

 struct tcp6_md5sig_key {
        u8                      *key;
-       u16                     keylen;
+       u8                      keylen;
 #if 0
        u32                     scope_id;       /* XXX */
 #endif


Signed-off-by: Peter Lieven <pl@dlh.net>
Signed-off-by: Matthias M. Dellweg <2500@gmx.de>



