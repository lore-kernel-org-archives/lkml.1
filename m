Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYK3OE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYK3OE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 09:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYK3OEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 09:04:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:59309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYK3OEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 09:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Za8G8xKcSbjoxpMCObbAlb2c9k3Dqm5k5l5frY6Bm3x86AoW3TUq0sMXxJVErcVFz7
         hwdVdzZsMP6GWzB9+m634Qa1lasn6S1AjCMoUfFVuN4oTyMrertmpA+HEMztpxRrDMT4
         GXixgilkin0OHe52yqwElG2QctUeaoxBo+9HQ=
Message-ID: <2f11576a0811300604r4c7335d4qec943a68c545dfae@mail.gmail.com>
Date: Sun, 30 Nov 2008 23:04:49 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/09] memcg: make inactive_anon_is_low()
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <84144f020811300450m7f450a1eue9ee820db2022ca5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081130195508.814B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <84144f020811300450m7f450a1eue9ee820db2022ca5@mail.gmail.com>
X-Google-Sender-Auth: d6f02c3e2c48a378
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> make inactive_anon_is_low for memcgroup.
>> it improve active_anon vs inactive_anon ratio balancing.
>
> The subject line of this patch seems to be truncated and the changelog
> seems bit terse. While the change may be obvious to memcg developers,
> it's not for the casual reader.

Yes, I'm wrong.
Will fix.




>> +static inline int
>> +mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
>> +{
>> +       return 1;
>> +}
>> +
>> +
>
> An extra newline here.

Will fix.


===================================================================
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -156,6 +156,9 @@ struct mem_cgroup {
>>        unsigned long   last_oom_jiffies;
>>        int             obsolete;
>>        atomic_t        refcnt;
>> +
>> +       int inactive_ratio;
>> +
>
> Is there a reason why this is not unsigned long? A comment here
> explaining what ->inactive_ratio is used for would be nice.

Ah sorry.
the type of zone->inactive_ratio is unsigned int.

Then, I'd like to change it to unsigned int.
because difference of the global reclaim easily cause silly mistake and bug.


>> +static void mem_cgroup_set_inactive_ratio(struct mem_cgroup *memcg)
>> +{
>> +       unsigned int gb, ratio;
>> +
>> +       gb = res_counter_read_u64(&memcg->res, RES_LIMIT) >> 30;
>> +       ratio = int_sqrt(10 * gb);
>
> You might want to consider adding a comment explaining what the above
> calculation is supposed to be doing.

Yes, Of cource.
Thanks.



>>  static DEFINE_MUTEX(set_limit_mutex);
>>
>>  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>> @@ -1381,6 +1411,11 @@ static int mem_cgroup_resize_limit(struc
>>                                GFP_HIGHUSER_MOVABLE, false);
>>                if (!progress)                  retry_count--;
>>        }
>> +
>> +       if (!ret)
>> +               mem_cgroup_set_inactive_ratio(memcg);
>> +
>> +
>
> An extra newline here.

Will fix.


>> @@ -1423,6 +1458,7 @@ int mem_cgroup_resize_memsw_limit(struct
>>                if (curusage >= oldusage)
>>                        retry_count--;
>>        }
>> +
>>        return ret;
>>  }
>
> There's some diff noise here.

ditto.
thanks.
