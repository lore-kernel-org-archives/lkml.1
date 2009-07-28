Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZG1OlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZG1OlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZG1OlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:41:12 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:60092 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZG1OlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:41:10 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of b44/b43 modules
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	<87k52izvd9.fsf@scholz.fias.uni-frankfurt.de>
	<87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
	<200907092203.10294.rjw@sisk.pl>
	<1247171295.1905.5.camel@johannes.local>
	<87prc78ga9.fsf@scholz.fias.uni-frankfurt.de>
	<1247322985.30647.108.camel@johannes.local>
	<8763dznnki.fsf@scholz.fias.uni-frankfurt.de>
	<1247334464.30647.109.camel@johannes.local>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
Date: Tue, 28 Jul 2009 16:40:36 +0200
In-Reply-To: <1247334464.30647.109.camel@johannes.local> (Johannes Berg's
	message of "Sat, 11 Jul 2009 19:47:44 +0200")
Message-ID: <87my6ovpjv.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2009-07-11 at 19:20 +0200, Jan Scholz wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > On Sat, 2009-07-11 at 16:07 +0200, Jan Scholz wrote:
>> >
>> >> > Jan, can you run with console_suspend=0 (or whatever it is now, Rafael
>> >> > will correct me if I'm wrong) that should work on your platform, and put
>> >> > a bunch of printk calls into __ieee80211_suspend in net/mac80211/pm.c to
>> >> > see where in there it's hanging?
>> >> 
>> >> Did that, seems like it hangs in
>> >>   drv_remove_interface(local, &conf);
>> >
>> > Ok, thanks! I was going to suggest doing the same in
>> > b43_op_remove_interface in drivers/net/wireless/b43/main.c, but I think
>> > the problem is just that we have an ordering problem and call drv_stop
>> > before drv_remove_interface. I'll try to come up with a fix soon --
>> > might not be able to today though, in the meantime I guess you can just
>> > move the drv_stop call to the end of the function and tell me if that
>> > works -- that would be racy but should be ok most of the time.
>> 
>> I moved drv_stop to the end of the function (see patch below) and now
>> suspend works fine.
>
> Thanks, that's what I suspected -- I'll take a closer look into what is
> required to make it race-free against RX.
>

Hi,

The bug is still present in v2.6.31-rc4, it's still fixed by the patch
(see below) suggested as a test by Johannes.

Regards,
   Jan

>> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
>> index 7a549f9..0ac15fb 100644
>> --- a/net/mac80211/pm.c
>> +++ b/net/mac80211/pm.c
>> @@ -58,12 +58,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>>  	/* flush again, in case driver queued work */
>>  	flush_workqueue(local->hw.workqueue);
>>  
>> -	/* stop hardware - this must stop RX */
>> -	if (local->open_count) {
>> -		ieee80211_led_radio(local, false);
>> -		drv_stop(local);
>> -	}
>> -
>>  	/* remove STAs */
>>  	spin_lock_irqsave(&local->sta_lock, flags);
>>  	list_for_each_entry(sta, &local->sta_list, list) {
>> @@ -111,6 +105,12 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>>  		drv_remove_interface(local, &conf);
>>  	}
>>  
>> +	/* stop hardware - this must stop RX */
>> +	if (local->open_count) {
>> +		ieee80211_led_radio(local, false);
>> +		drv_stop(local);
>> +	}
>> +
>>  	local->suspended = true;
>>  	local->quiescing = false;
>> 

-- 
 Jan Scholz                                ____  ____    __    ___ 
                                          ( ___)(_  _)  /__\  / __)
 Frankfurt Institute for Advanced Studies  )__)  _)(_  /(__)\ \__ \
                                          (__)  (____)(__)(__)(___/
 Goethe Universitaet Frankfurt
 Ruth-Moufang-Str. 1                             Tel. 069-798-47534
 60438 Frankfurt am Main
