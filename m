Return-Path: <linux-kernel-owner+w=401wt.eu-S1763120AbXFBTUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763120AbXFBTUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbXFBTUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:20:46 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50626 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751AbXFBTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:20:45 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: dwmw2@infradead.org
Subject: [Trivial Patch] Remove JFFS2 dependency on internal Zlib header
Date: Sat, 2 Jun 2007 15:20:36 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EMcYG1HvS4B8aeJ"
Message-Id: <200706021520.36478.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_EMcYG1HvS4B8aeJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

History:
  During the discussion over the speed and stability of the proposed inclusion 
of a stripped-down, minimized version of the LZO compression algorithm it was 
noted that the way that patch handled separation of compression and 
decompression could be used for zlib as well. Then it was noted that moving 
the private zlib header 'zutil.h' to a combined zlib directory would break 
JFFS2, which used it. On examining JFFS2 it became clear that the only thing 
JFFS2 used the header for was a single constant. Since his code was involved, 
Mark Adler was contacted and he stated that that constant - PRESET_DICT - was 
part of the zlib standard and defined in RFC 1950. So, to remove the 
dependency the simplest recourse is to replace PRESET_DICT with the 'magic 
number' it represents.

Signed-off-by: Daniel Hazelton <dhazelton@enter.net>

DRH

diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..9f1b935 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
-#include <linux/zutil.h>
 #include "nodelist.h"
 #include "compr.h"

@@ -154,7 +153,7 @@ static int jffs2_zlib_decompress(unsigned char *data_in,

        /* If it's deflate, and it's got no preset dictionary, then
           we can tell zlib to skip the adler32 check. */
-       if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
+       if (srclen > 2 && !(data_in[1] & 0x20) &&
            ((data_in[0] & 0x0f) == Z_DEFLATED) &&
            !(((data_in[0]<<8) + data_in[1]) % 31)) {

--Boundary-00=_EMcYG1HvS4B8aeJ
Content-Type: text/x-diff;
  charset="utf-8";
  name="remove-jffs2-zutil.h-dependency.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="remove-jffs2-zutil.h-dependency.patch"

diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..9f1b935 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
-#include <linux/zutil.h>
 #include "nodelist.h"
 #include "compr.h"
 
@@ -154,7 +153,7 @@ static int jffs2_zlib_decompress(unsigned char *data_in,
 
 	/* If it's deflate, and it's got no preset dictionary, then
 	   we can tell zlib to skip the adler32 check. */
-	if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
+	if (srclen > 2 && !(data_in[1] & 0x20) &&
 	    ((data_in[0] & 0x0f) == Z_DEFLATED) &&
 	    !(((data_in[0]<<8) + data_in[1]) % 31)) {
 

--Boundary-00=_EMcYG1HvS4B8aeJ--
