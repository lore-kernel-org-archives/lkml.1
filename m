Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbZLPAfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbZLPAfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbZLPAfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:35:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62529 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761442AbZLPAfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:35:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=uojwo5MvlMms6IkYRf02yFjXZa+7EIIMYfDvq8BVn55SVrzUwCwDVwAfD3eOJJuAk/
         +cpoqZuQdvXyknQwgCIWnz9kVXXy8Z51hbm1Rj3BjLg28ACAUA45u49y8rmBWnICo3wV
         Xocz7BvJD0poIgn1Z45cYGJSxsTlWPAaxbSGM=
Message-ID: <4B282BBD.4050106@gmail.com>
Date: Wed, 16 Dec 2009 01:37:17 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Kyungmin Park <kyungmin.park@samsung.com>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OneNAND: Fix test of unsigned in onenand_otp_walk()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd->writesize and len are unsigned so the test does not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
you can test this with:

#include <stdio.h>

int main()
{
        int c = 1, d = 1;
        unsigned a = 30;
        unsigned b = 10;

        if ((b * c) - (d + a) < 0)
                printf("good\n");
        else
                printf("bad\n");
        return 0;
}


diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index ff66e43..cbe2711 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -2725,7 +2725,7 @@ static int onenand_otp_walk(struct mtd_info *mtd, loff_t from, size_t len,
 	}
 
 	/* Check User/Factory boundary */
-	if (((mtd->writesize * otp_pages) - (from + len)) < 0)
+	if (mtd->writesize * otp_pages < from + len)
 		return 0;
 
 	onenand_get_device(mtd, FL_OTPING);
