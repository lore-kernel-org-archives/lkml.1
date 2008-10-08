Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYJHFHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYJHFHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 01:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYJHFHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 01:07:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62171 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbYJHFHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 01:07:07 -0400
Message-ID: <48EC3F50.7050306@cn.fujitsu.com>
Date: Wed, 08 Oct 2008 13:04:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: fix unchecked format
References: <48EC19A8.4010307@cn.fujitsu.com> <20081008040508.GB31788@Krystal>
In-Reply-To: <20081008040508.GB31788@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No.

1)
In current code, when the second, third... probe is registered
with the same marker name, its format is not checked.

marker_probe_register("marker_name", "field1 %s", XXX);
marker_probe_register("marker_name", "field1 %d", XXX);

the second call, "field1 %d" is not check for ever.
and this probe may cause kernel core-dump.

because these two probes share the same marker_entry, and
we do not check the format when they are being shared.

if several probes share the same marker_entry we should
make sure all these probes's format are the same.

2)
set_marker() check marker's format with marker_entry's format
my fix change marker_probe_register(),
and marker_probe_register() check probes' format with marker_entry's format.

they are not duplicate check.

3)
my patch change marker_probe_register(), and this fix can not
make the module load fail in an condition.
for: marker_update_probe_range() return void.

Thanks, Lai.

Mathieu Desnoyers wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>> when the second, third... probe is registered, its format is
>> not checked, this patch fix it.
>>
> 
> It's already checked here :
> 
> marker_update_probes
>   marker_update_probe_range
>     set_marker
>  
>         if ((*entry)->format) {
>                 if (strcmp((*entry)->format, elem->format) != 0) {
>                         printk(KERN_NOTICE
>                                 "Format mismatch for probe %s "
>                                 "(%s), marker (%s)\n",
>                                 (*entry)->name,
>                                 (*entry)->format,
>                                 elem->format);
>                         return -EPERM;
>                 }
>         } else {
>                 ret = marker_set_format(entry, elem->format);
>                 if (ret)
>                         return ret;
>         }
> 
> Given that marker_probe_register can be called to connect a probe to a
> marker which does not exist yet (e.g. marker in a module not loaded), I
> am not sure it makes sense to check for format string mismatch so early
> in marker_probe_register (the moment it adds the marker to the hash
> table). That's actually why I chose to leave it in later stage which
> does the actual connection of the probes to the markers
> (marker_update_probes).
> 
> If you really want to check it earlier, how do you plan to deal with
> this scenario ?
> 
> 1 - a marker probe is registered for markerA with format string
>     "field1 %s"
> 2 - a module is loaded, which contains a marker markerA with format
>     string "field1 %d"
> 
> I think it would be _really_ bad to make the module load fail because of
> a marker format string mismatch... this is why I chose just to give a
> warning in set_marker, which is shown when the markers are updated,
> which happens when the module is loaded and when the marker hash table
> is modified.
> 
> Mathieu
> 
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/kernel/marker.c b/kernel/marker.c
>> index 4440a09..1196a6b 100644
>> --- a/kernel/marker.c
>> +++ b/kernel/marker.c
>> @@ -651,11 +651,17 @@ int marker_probe_register(const char *name, const char *format,
>>  	entry = get_marker(name);
>>  	if (!entry) {
>>  		entry = add_marker(name, format);
>> -		if (IS_ERR(entry)) {
>> +		if (IS_ERR(entry))
>>  			ret = PTR_ERR(entry);
>> -			goto end;
>> -		}
>> +	} else if (format) {
>> +		if (!entry->format)
>> +			ret = marker_set_format(&entry, format);
>> +		else if (strcmp(entry->format, format))
>> +			ret = -EPERM;
>>  	}
>> +	if (ret)
>> +		goto end;
>> +
>>  	/*
>>  	 * If we detect that a call_rcu is pending for this marker,
>>  	 * make sure it's executed now.
>>
>>
> 


