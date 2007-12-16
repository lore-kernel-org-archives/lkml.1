Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXLPSi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXLPSi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbXLPSit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:38:49 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:43827 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXLPSis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:38:48 -0500
Message-ID: <47657096.50302@cosmosbay.com>
Date: Sun, 16 Dec 2007 19:38:14 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RANDOM] Move two variables to read_mostly section to save	memory
References: <47650FBD.2060209@cosmosbay.com> <20071216130028.GB14233@stusta.de> <476539D5.7050305@cosmosbay.com> <20071216165348.GC14233@stusta.de> <476563A1.4090508@cosmosbay.com> <20071216181455.GD14233@stusta.de>
In-Reply-To: <20071216181455.GD14233@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 16 Dec 2007 19:38:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk a écrit :
> On Sun, Dec 16, 2007 at 06:42:57PM +0100, Eric Dumazet wrote:
>> Adrian Bunk a écrit :
>> ...
>>> And even more funny, with gcc 4.2 and CONFIG_CC_OPTIMIZE_FOR_SIZE=y your 
>>> patch doesn't seem to make any space difference - are you using an older 
>>> compiler or even worse CONFIG_CC_OPTIMIZE_FOR_SIZE=n for being able to see 
>>> any space difference?
>>>
>>> In both cases your code uglification would be even more pointless...
>>>
>> I believe that CONFIG_SMP is uglification for you Adrian, but still I am 
>> glad linux have it.
>>
>> If your CONFIG_SYSCTL=n is really that important for you, why dont you 
>> define a new qualifier that can indeed mark some variables as :
>>
>> const if CONFIG_SYSCTL=n
>> read_mostly if CONFIG_SYCTL=y
>>
>> This way you can keep compiler optimizations for your CONFIG_SYCTL=n, while 
>> many people like me can still continue to optimize their kernel.
>>
>> Seeing so many sysctl already read_mostly in kernel, I wonder why you NACK 
>> my patch, while it's easy to share your concerns with other people and find 
>> a solution.
> 
> You omitted an answer to my main important point...
> 
> Let me ask it in a more simple way:
> 
> Do you see any space difference at all with gcc 4.2 and 
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y ?
> 


I am using gcc-4.2.1

CONFIG_CC_OPTIMIZE_FOR_SIZE=y makes no difference for me.

$ make defconfig
$ egrep "OPTIMIZE_FOR_SIZE|CONFIG_SMP" .config
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SMP=y
$ make vmlinux
$ nm -v vmlinux|grep -4 random_read_wakeup_thresh
c057a02c d excluded_id_list
c057a100 d zero_bdi
c057a180 D random_table
c057a300 d input_pool
c057a400 d random_read_wakeup_thresh
c057a404 d random_write_wakeup_thresh
    <SAME HOLE HERE>
c057a480 d blocking_pool
c057a580 d nonblocking_pool
c057a680 d rekey_work

After my patch, I still gain 120 bytes.

Please realize that most people now build their kernels with CONFIG_SMP=y, or 
use a distro one (with CONFIG_SMP=y as well)

Your CONFIG_SYSCTL point is valid and should be addressed by a separate patch set.
