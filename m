Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419Ab0AEVSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0AEVSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323Ab0AEVSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:18:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35835 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab0AEVSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q8AT75MG+W0AfXTXIJO668mwK/4n8WzyYZPwI+6D78EO2sSFYTvDQz0tgqYW30hUiN
         tfqaqhNvMvRWs9B4hOheF1JQI0sWUUfQY7xBxUdDC49kNBOnZiB/c2G+0UPiYzpvJExt
         rYdAhCuI7j8WoKXtnY97HQumKjfC0+dbqrEWI=
Message-ID: <4B43AD8F.2030809@gmail.com>
Date: Tue, 05 Jan 2010 22:22:23 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: test off by one in {piix4,vt596}_transaction()
References: <4B3773F2.3010703@gmail.com> <20100105175511.39dc6c42@hyperion.delvare>
In-Reply-To: <20100105175511.39dc6c42@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (timeout++ < MAX_TIMEOUT)' timeout reaches MAX_TIMEOUT + 1 after the loop
This is probably unlikely to produce a problem.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> That's right... but I'd rather change the loops to use "++timeout" and
> leave the conditions as is (or maybe change it to "=="). I think it's
> easier to read that way. Would that be OK with you?

Ok,

 drivers/i2c/busses/i2c-piix4.c  |    4 ++--
 drivers/i2c/busses/i2c-viapro.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 1e245e9..e56e4b6 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -324,12 +324,12 @@ static int piix4_transaction(void)
 	else
 		msleep(1);
 
-	while ((timeout++ < MAX_TIMEOUT) &&
+	while ((++timeout < MAX_TIMEOUT) &&
 	       ((temp = inb_p(SMBHSTSTS)) & 0x01))
 		msleep(1);
 
 	/* If the SMBus is still busy, we give up */
-	if (timeout >= MAX_TIMEOUT) {
+	if (timeout == MAX_TIMEOUT) {
 		dev_err(&piix4_adapter.dev, "SMBus Timeout!\n");
 		result = -ETIMEDOUT;
 	}
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
index e4b1543..a84a909 100644
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -165,10 +165,10 @@ static int vt596_transaction(u8 size)
 	do {
 		msleep(1);
 		temp = inb_p(SMBHSTSTS);
-	} while ((temp & 0x01) && (timeout++ < MAX_TIMEOUT));
+	} while ((temp & 0x01) && (++timeout < MAX_TIMEOUT));
 
 	/* If the SMBus is still busy, we give up */
-	if (timeout >= MAX_TIMEOUT) {
+	if (timeout == MAX_TIMEOUT) {
 		result = -ETIMEDOUT;
 		dev_err(&vt596_adapter.dev, "SMBus timeout!\n");
 	}
