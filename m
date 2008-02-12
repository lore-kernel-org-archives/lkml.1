Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbYBLJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbYBLJXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYBLJXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:23:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48018
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbYBLJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:23:06 -0500
Date: Tue, 12 Feb 2008 01:23:36 -0800 (PST)
Message-Id: <20080212.012336.241084860.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: CRC32C big endian bugs...
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802061200.14690.chris.mason@oracle.com>
References: <200802061200.14690.chris.mason@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CRC32C implementation in the btrfs progs is different from the one
in the kernel, so obviously nothing can possibly work on big-endian.

This is getting less and less fun by the minute, I simply wanted to
test btrfs on Niagara :-/

Here is a patch to fix that:

--- vanilla/btrfs-progs-0.12/crc32c.c	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/crc32c.c	2008-02-12 01:19:33.000000000 -0800
@@ -91,13 +91,11 @@ static const u32 crc32c_table[256] = {
  * crc using table.
  */
 
-u32 crc32c_le(u32 seed, unsigned char const *data, size_t length)
+u32 crc32c_le(u32 crc, unsigned char const *data, size_t length)
 {
-	u32 crc = (__force __u32)(cpu_to_le32(seed));
-	
 	while (length--)
 		crc =
 		    crc32c_table[(crc ^ *data++) & 0xFFL] ^ (crc >> 8);
 
-	return le32_to_cpu((__force __le32)crc);
+	return crc;
 }
