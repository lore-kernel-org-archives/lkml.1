Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZDND63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZDND63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZDND6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:58:20 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:25785 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZDND6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YQggrFGthhJXvP6RYUNr6FKdSvBTvEw1Xv61a8Mkk9z+HWyefPu1+qVnmWif9ezPFo
         NT7Um3oA1h7NHAyqWuybrqq06PAbpDGkuzGpss3uGdWBRtBJ3lhF4REdLcJtGvH0XTmY
         y3zQLeuIPm/oB/ryQRpYOonDRS/3av9FVr1Eo=
Message-ID: <49E40A07.6010905@gmail.com>
Date: Tue, 14 Apr 2009 12:59:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH #upstream-fixes] pata_legacy: fix no device fail path
References: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com> <1208782090.7115.179.camel@twins> <480FF821.9050208@gmail.com> <49E0C102.4020705@pobox.com> <49E22ED9.40100@gmail.com>
In-Reply-To: <49E22ED9.40100@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pata_legacy can't detect any device, it unregisters the
platform_device and fails detection.  However, it forgets to detach
ata host triggering weird failures as the host later gets freed by
devres while still attached.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Peter Zijlstra <peterz@infradead.org>
---
Well, with or without test verification, this patch is correct.  Thanks.

 drivers/ata/pata_legacy.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 3f830f0..0c6dde8 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1032,6 +1032,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 			return 0;
 		}
 	}
+	ata_host_detach(host);
 fail:
 	platform_device_unregister(pdev);
 	return ret;
