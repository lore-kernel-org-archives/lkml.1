Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYIVQKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYIVQKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYIVQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:10:33 -0400
Received: from ns2.protei.ru ([195.239.28.26]:43216 "EHLO mail.protei.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYIVQKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:10:32 -0400
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 12:10:32 EDT
Message-ID: <48D7C0A2.9090406@protei.ru>
Date: Mon, 22 Sep 2008 19:58:26 +0400
From: Nickolay Vinogradov <nickolay@protei.ru>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SCTP checksum patch for 2.6.26.5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCTP checksum calculation fix for BigEndian.
ntohl() doesn't do anything on BigEndian.

diff --git a/Makefile b/Makefile
diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
index ba75c67..2f0ed64 100644
--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -74,5 +74,19 @@ static inline __u32 sctp_update_cksum(__u8 *buffer, 
__u16 length, __u32 crc32)

  static inline __u32 sctp_end_cksum(__u32 crc32)
  {
-       return ntohl(~crc32);
+       __u32 result;
+       __u8 byte0, byte1, byte2, byte3;
+
+       result = ~crc32;
+
+       byte0 = result & 0xff;
+       byte1 = (result>>8) & 0xff;
+       byte2 = (result>>16) & 0xff;
+       byte3 = (result>>24) & 0xff;
+
+       crc32 = ((byte0 << 24) |
+                (byte1 << 16) |
+                (byte2 << 8)  |
+                byte3);
+       return crc32;
  }
diff --git a/net/sctp/output.c b/net/sctp/output.c


-- 
Nickolay Vinogradov
Protei Research and Development Center
St.Petersburg, 194044, Russia
Tel.: +7 812 449 47 27
