Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYIIAnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYIIAnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYIIAnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:43:01 -0400
Received: from mfo32.po.2iij.net ([210.128.50.15]:1166 "EHLO mfo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbYIIAnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:43:01 -0400
X-Greylist: delayed 2287 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 20:43:00 EDT
Message-ID: <48C5BDA0.90105@tripeaks.co.jp>
Date: Tue, 09 Sep 2008 09:04:48 +0900
From: Atsuo Igarashi <atsuo_igarashi@tripeaks.co.jp>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: linux-kernel@vger.kernel.org,
       Atsuo Igarashi <atsuo_igarashi@tripeaks.co.jp>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Subject: [PATCH] kgdb: could not write to the last of valid memory with kgdb.
Content-Type: multipart/mixed;
 boundary="------------030506070109060804040609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030506070109060804040609
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

I'm using i.MX31 ARM11 board which has 104Mbyte valid memory.
When I'd invoked a print command to write the last of valid memory from gdb,
there was no response from kgdb.

It seems that the following line causes this problem.

kernel/kgdb.c: write_mem_msg()
...
 491 			flush_icache_range(addr, addr + length + 1);

If the last byte of valid memory is specified, the last cache line and the next
cache line will be flushed by the ARM11 V6's function from flush_icache_range().
I'm not sure why the 2nd parameter has +1, I assume this +1 is unnecessary for
ARM11 V6's cache.
I send a patch to remove this +1, does anyone know necessity for other architectures?

Regards,

Signed-off-by Atsuo Igarashi <atsuo_igarashi@tripeaks.co.jp>

--------------030506070109060804040609
Content-Type: text/x-diff;
 name="kgdb_write_mem_msg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kgdb_write_mem_msg.diff"

 kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index eaa21fc..949806a 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -488,7 +488,7 @@ static int write_mem_msg(int binary)
 		if (err)
 			return err;
 		if (CACHE_FLUSH_IS_SAFE)
-			flush_icache_range(addr, addr + length + 1);
+			flush_icache_range(addr, addr + length);
 		return 0;
 	}
 

--------------030506070109060804040609--
