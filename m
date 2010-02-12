Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0BLRVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:21:34 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48242 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab0BLRVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:21:32 -0500
Message-ID: <4B758E09.9030708@cs.wisc.edu>
Date: Fri, 12 Feb 2010 11:21:13 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Tao Ma <tao.ma@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: lockdep warning for iscsi in 2.6.33-rc6
References: <4B7107CF.3060703@oracle.com> <4B71B7D9.9040501@cs.wisc.edu> <4B7200DC.60103@oracle.com>
In-Reply-To: <4B7200DC.60103@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 06:42 PM, Tao Ma wrote:
> Hi Mike,
>
> Mike Christie wrote:
>> On 02/09/2010 12:59 AM, Tao Ma wrote:
>>> Hi Mike,
>>> I meet with a lockdep warning for iscsi in 2.6.33-rc6.
>>> the lockdep is attached.
>>>
>>
>> If the lockdep output is saying that there is a problem with the iscsi
>> host taking its mutex then the scsi host mutex, I think that might be
>> a mistake in the lockdep detection. We always take the iscsi host
>> mutex then take the scsi host mutex.
>>
>> Could it get confused if we are scanning two hosts at the same time?
>> If it is just looking at if a lock is being taken then it would look
>> like host1 has its ihost->mutex and then took its shost->mutex, but
>> then host2 could start to get scanned at the same time, and it is
>> going to take its ihost->mutex. It would then look like we are trying
>> to grab a ihost->mutex while holding a shost->mutex. However, the
>> mutexs are not global and they are different instances of the mutex
>> because each host has its own.
> If these 2 mutexes are grabed in the same order(in your description,
> ihost->mutex first and then shost->mutex), there would be no problem.

I checked the code and we are taking the locks in the proper order, but 
I did some more testing and I do not think it was detecting what I 
thought above.

I just did a login with one iscsi session and got the lockdep warning. 
So I will do some more digging into what is going on.
