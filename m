Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXGPQTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXGPQTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbXGPQTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:19:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:35045 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbXGPQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=j8HFi08VCqkUFT7m1QB7m42UHAEqBLzV3qJs3ADTNAg1AUociHvhJ8eFooF6WGU8qVu1S4rZ30KixXs0sWAFpVbMqBxq/0DOCiTiWguLvn4XtclwJMbQWskONsVMImpDdCKp2JSjkPP8H89PKK3qL+MAj0pEyVk3s94PMegcWE0=
Message-ID: <469B9A53.1030600@googlemail.com>
Date: Mon, 16 Jul 2007 18:18:27 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, htejun@gmail.com, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	 <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469A5C94.7030201@googlemail.com>	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com> <469B91A7.909@googlemail.com>
In-Reply-To: <469B91A7.909@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Satyam Sharma wrote:
>   
>> Hi Gabriel,
>>
>> On 7/16/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>>
>>   
>>     
>>> ( http://194.231.229.228/Oops.txt )
>>>     
>>>       
>>   
>>     
>>> I cannot reproduce this on plain 2.6.22 so I've started to bisect the
>>> problem.
>>>     
>>>       
>> Could you reproduce this oops at will at the "bad" points? [ Note that
>> git-bisect isn't quite applicable to bugs that are not 100% reproducible.
>> The ones that passed as "good" may have passed only because the
>> bug didn't get triggered on that particular test. Also, a perfectly good
>> commit could get unnecessarily marked "bad" because the bug
>> happened to get triggered for it ... so it's not quite trust-worthy for
>> your case. ]
>>   
>>     
>
> Yes all marked 'bad' ponts have the Oops , at least here.
>
>   
>>   
>>     
>>> Here the bisect result:
>>>
>>> 3007e997de91ec59af39a3f9c91595b31ae6e08b is first bad commit
>>> commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
>>> Author: Tejun Heo <htejun@gmail.com>
>>> Date:   Thu Jun 14 04:27:23 2007 +0900
>>>
>>>     sysfs: use sysfs_mutex to protect the sysfs_dirent tree
>>>
>>>     As kobj sysfs dentries and inodes are gonna be made reclaimable,
>>>     i_mutex can't be used to protect sysfs_dirent tree.  Use sysfs_mutex
>>>     globally instead.  As the whole tree is protected with sysfs_mutex,
>>>     there is no reason to keep sysfs_rename_sem.  Drop it.
>>>
>>>     While at it, add docbook comments to functions which require
>>>     sysfs_mutex locking.
>>>
>>>     Signed-off-by: Tejun Heo <htejun@gmail.com>
>>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> :040000 040000 9deba7887752bc343cc4f5dea2dac70e895ea8b6
>>> 75340b6e18c1ada500bb1a2b99ee88fd93ebae8c M      fs
>>>     
>>>       
>> Hmm, I don't see why this one could introduce an oops in SLUB,
>> but it's doing some locking-related stuff, and if it didn't get it right,
>> the resulting races /could/ lead to some oops. But ... a recently
>> posted patch (http://lkml.org/lkml/2007/7/16/204) from Akinobu
>> Mita does point to an oops that was introduced by commit
>> 0c096b507f15397da890051ee73de4266d3941fb that belongs to the
>> same patchset -- kmem_cache_free(NULL) is illegal and so will oops.
>> A curious coincidence is that you do see sysfs_new_dirent() in the
>> stack trace there, but the oops there is in kmem_cache_free(), not
>> kmem_cache_zalloc() as your dmesg output indicated.
>>
>> Try that patch anyway, but I don't think that'll solve your problem --
>> if it was, you would've been seeing "unable to handle kernel NULL
>> pointer dereference" but what you've been posting is "unable to
>> handle kernel paging request at virtual address <non_null_ptr>" ...
>>   
>>     
>
> I will try this patch and look whatever it helps.
>   

With that patch my box is killed right after fixed modules in modprobed
without any trace :|

I try now without again


Gabriel
