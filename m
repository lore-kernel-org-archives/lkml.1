Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYCJWPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYCJWPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYCJWPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:15:25 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:34852 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYCJWPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:15:25 -0400
Message-ID: <47D5B2E9.2030509@tiscali.nl>
Date: Mon, 10 Mar 2008 23:15:05 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: akpm@linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>,
       benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>
Subject: Re: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
References: <47D47B11.1000303@tiscali.nl>	 <20080310084633.5246ecfe@paperstreet.colino.net> <1205136413.8621.3.camel@pasglop> <47D4EFC1.1050403@tiscali.nl> <64d5b5e6dfd0d1820d21db323ef88e25@kernel.crashing.org> <47D5A585.8050107@tiscali.nl> <1dd996a5ad3a455c91886cacd3243128@kernel.crashing.org>
In-Reply-To: <1dd996a5ad3a455c91886cacd3243128@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> It includes suggested changes by Segher Boessenkool and I think this
>> version was tested by Darrick J. Wong
> 
>> -    u8 reg;
>> +    u8 reg, temp;
>>      struct i2c_client *client = to_i2c_client(dev);
>>      struct adt7473_data *data = i2c_get_clientdata(client);
>> -    int temp = simple_strtol(buf, NULL, 10);
>> -    temp = temp && 0xFF;
>> +
>> +    temp = simple_strtol(buf, NULL, 10) & 0xFF;
> 
> It still does this superfluous "& 0xff", which hides the lack of
> range checking.

Sorry didn't quite grep that
---
logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
index 9587869..98937d3 100644
--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -566,11 +566,11 @@ static ssize_t set_max_duty_at_crit(struct device *dev,
 				    const char *buf,
 				    size_t count)
 {
-	u8 reg;
+	u8 reg, temp;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
-	temp = temp && 0xFF;
+
+	temp = simple_strtol(buf, NULL, 10);
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = temp;

