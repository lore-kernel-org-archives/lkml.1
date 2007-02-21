Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbXBUBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbXBUBqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXBUBqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:46:16 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:35391 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXBUBqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WbjbpoNAjyfwr7dTEGYCPycLxqwMnB+/qF4MrM8VHdM4pUd2geeq/4/OF9zkzKJIp3YEUkg0RYyJwIVX6uoYXIEBMKX7hPCbsH7+KZTRAxboG7Q+xCJAVFl/VpDtdWMNR1IWXLsdCw9puY+tv0T2nO/T2nzZgmNgYz5Zy+z6Kho=
Message-ID: <758a2bbf0702201746p3959235ele3db9b600a9f8104@mail.gmail.com>
Date: Tue, 20 Feb 2007 17:46:13 -0800
From: "Vijay Sampath" <vsampath@gmail.com>
To: joern@wohnheim.fh-wedel.de, linux-mtd@lists.infradead.org
Subject: [PATCH] [MTD] CHIPS: oops in cfi_amdstd_sync
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vijay Sampath <vsampath@gmail.com>

The files cfi_cmdset_0002.c and cfi_cmdset_0020.c do not initialize
their wait queues like is done in cfi_cmdset_0001.c. This causes an
oops when the wait queue is accessed. I have copied the code from
cfi_cmdset_0001.c that is pertinent to initialization of the wait
queue.

Signed-off-by: Vijay Sampath <vsampath@gmail.com>
---

diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff
linux-2.6.20.1-vanilla/drivers/mtd/chips/cfi_cmdset_0002.c
linux-2.6/drivers/mtd/chips/cfi_cmdset_0002.c
--- linux-2.6.20.1-vanilla/drivers/mtd/chips/cfi_cmdset_0002.c	2007-02-20
17:01:57.000000000 -0800
+++ linux-2.6/drivers/mtd/chips/cfi_cmdset_0002.c	2007-02-20
17:05:23.000000000 -0800
@@ -359,6 +359,8 @@ struct mtd_info *cfi_cmdset_0002(struct
 		cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
 		cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
 		cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+		cfi->chips[i].ref_point_counter = 0;
+		init_waitqueue_head(&(cfi->chips[i].wq));
 	}

 	map->fldrv = &cfi_amdstd_chipdrv;
diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff
linux-2.6.20.1-vanilla/drivers/mtd/chips/cfi_cmdset_0020.c
linux-2.6/drivers/mtd/chips/cfi_cmdset_0020.c
--- linux-2.6.20.1-vanilla/drivers/mtd/chips/cfi_cmdset_0020.c	2007-02-20
17:01:57.000000000 -0800
+++ linux-2.6/drivers/mtd/chips/cfi_cmdset_0020.c	2007-02-20
17:06:14.000000000 -0800
@@ -158,6 +158,8 @@ struct mtd_info *cfi_cmdset_0020(struct
 		cfi->chips[i].word_write_time = 128;
 		cfi->chips[i].buffer_write_time = 128;
 		cfi->chips[i].erase_time = 1024;
+		cfi->chips[i].ref_point_counter = 0;
+		init_waitqueue_head(&(cfi->chips[i].wq));
 	}

 	return cfi_staa_setup(map);
