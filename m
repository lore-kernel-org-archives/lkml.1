Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZIXBJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZIXBJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZIXBJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:09:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbZIXBJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:09:06 -0400
Message-ID: <4ABAC663.60906@cn.fujitsu.com>
Date: Thu, 24 Sep 2009 09:07:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mbroz@redhat.com,
       tytso@mit.edu, jens.axboe@oracle.com, mingo@elte.hu
Subject: Re: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with
 	blk_trace_init_sysfs
References: <c4e36d110909210307m6579807ehe4d659053c4dc696@mail.gmail.com>	 <4AB86A03.7060207@cn.fujitsu.com> <c4e36d110909220057q6d9ce816yfcec7de4849c1969@mail.gmail.com>
In-Reply-To: <c4e36d110909220057q6d9ce816yfcec7de4849c1969@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Subject: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with
>>> blk_trace_init_sysfs
>>> From: Zdenek Kabelac <zkabelac@redhat.com>
>>>
>>> Adds missing blk_trace_remove_sysfs() to be in pair with
>>> blk_trace_init_sysfs() introduced in commit
>>> 1d54ad6da9192fed5dd3b60224d9f2dfea0dcd82.
>>>
>>> Problem was noticed via kmemleak backtrace when some sysfs entries
>>> were note properly destroyed during  device removal:
>>>
>> Thanks for reporting and fixing this!
>>
>>> @@ -465,6 +466,7 @@ void blk_unregister_queue(struct gendisk *disk)
>>>
>>>               kobject_uevent(&q->kobj, KOBJ_REMOVE);
>>>               kobject_del(&q->kobj);
>>> +             blk_trace_remove_sysfs(disk_to_dev(disk));
>> This should be moved outside of 'if'.
>>
> 
> I was not really sure about the proper place - if it could be placed
> before if() or after the if(){} - as I've not checked in depth

Just use the reverse order against blk_register_queue() should be fine.

> connection between kobj and sysfs. It's somewhat unclear why all the
> kobject operation are only within this if(){} block - so I've thought
> there is some reason...
> IMHO only elv_unregister_queue() should be probably in the if(){} block.
> 

Seems it's a bug to put kobject_put(dev->kobj) in the if block.

I created a stacked device (mdadm) and kmemleak still reported leaks
even after I fixed the blktrace issue. And then I moved kobejct_put()
outside the if, no more leaks reports.

> Feel free to update/fix.
> 
