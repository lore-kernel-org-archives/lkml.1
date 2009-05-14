Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbZENFj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbZENFj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 01:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZENFjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 01:39:43 -0400
Received: from cathcart.site5.com ([74.54.107.137]:55851 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZENFjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 01:39:41 -0400
Message-ID: <4A0BAE9B.1090401@compulab.co.il>
Date: Thu, 14 May 2009 08:39:39 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: cbou@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] da9030_battery: fix race between event handler and monitor
References: <1242112809-10021-1-git-send-email-mike@compulab.co.il> <20090513114046.6557fc0e.akpm@linux-foundation.org>
In-Reply-To: <20090513114046.6557fc0e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Tue, 12 May 2009 10:20:09 +0300
> Mike Rapoport <mike@compulab.co.il> wrote:
> 
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> 
> We seem to be missing a changelog.

My bad...

>> diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
>> index 1662bb0..3364198 100644
>> --- a/drivers/power/da9030_battery.c
>> +++ b/drivers/power/da9030_battery.c
>> @@ -22,8 +22,6 @@
>>  #include <linux/debugfs.h>
>>  #include <linux/seq_file.h>

[ snip ]

> What is this race? What are the user-visible effects when it occurs? 

There are cases when charging monitor and the event handler try to change the
charger state simultaneously. For instance, a charger is connected to the
system, there's the detection event and the event handler tries to enable
charging. It is possible that the periodic charging monitor runs at the same
time and it still thinks there's no external charger. So it tries to disable the
charging. As the result, even if the conditions necessary to charge the battery
hold, there will be no actual charging.

> How does the patch fix the race?

The patch changes the event handler so that instead of enabling/disabling the
charger immediately it would rather make the monitor run. The monitor code then
decides what should be the charger state.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.

