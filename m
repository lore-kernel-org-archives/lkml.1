Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXKGSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXKGSud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXKGSu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:50:26 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:50659 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbXKGSuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:50:25 -0500
Message-ID: <473208ED.9000707@tiscali.nl>
Date: Wed, 07 Nov 2007 19:50:21 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix incorrect test in trident_ac97_set(); sound/oss/trident.c
References: <47320533.4020400@tiscali.nl> <2c0942db0711071043p7cd31f6di9031816c1fed81ca@mail.gmail.com>
In-Reply-To: <2c0942db0711071043p7cd31f6di9031816c1fed81ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Nov 7, 2007 10:34 AM, Roel Kluin <12o3l@tiscali.nl> wrote:
>> If count reaches zero, the loop ends, but the postfix decrement subtracts it.
>> so, testing for 'count == 0' will not work.
>>
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/sound/oss/trident.c b/sound/oss/trident.c
>> index 96adc47..94b5fb4 100644
>> --- a/sound/oss/trident.c
>> +++ b/sound/oss/trident.c
>> @@ -2939,7 +2939,7 @@ trident_ac97_set(struct ac97_codec *codec, u8 reg, u16 val)
>>
>>         data |= (mask | (reg & AC97_REG_ADDR));
>>
>> -       if (count == 0) {
>> +       if (count == -1) {
>>                 printk(KERN_ERR "trident: AC97 CODEC write timed out.\n");
>>                 spin_unlock_irqrestore(&card->lock, flags);
>>                 return;
>> @@ -2999,7 +2999,7 @@ trident_ac97_get(struct ac97_codec *codec, u8 reg)
>>         } while (count--);
>>         spin_unlock_irqrestore(&card->lock, flags);
>>
>> -       if (count == 0) {
>> +       if (count == -1) {
>>                 printk(KERN_ERR "trident: AC97 CODEC read timed out.\n");
>>                 data = 0;
>>         }
> 
> You didn't test this: count is unsigned. Change the loop condition to
> be --count instead.
> 
> Ray

Yep, you're right, here:
--
If count reaches zero, the loop ends, but the postfix decrement still subtracts:
testing for 'count == 0' will not work.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 96adc47..6959ee1 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -2935,7 +2935,7 @@ trident_ac97_set(struct ac97_codec *codec, u8 reg, u16 val)
 	do {
 		if ((inw(TRID_REG(card, address)) & busy) == 0)
 			break;
-	} while (count--);
+	} while (--count);
 
 	data |= (mask | (reg & AC97_REG_ADDR));
 
@@ -2996,7 +2996,7 @@ trident_ac97_get(struct ac97_codec *codec, u8 reg)
 		data = inl(TRID_REG(card, address));
 		if ((data & busy) == 0)
 			break;
-	} while (count--);
+	} while (--count);
 	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (count == 0) {
