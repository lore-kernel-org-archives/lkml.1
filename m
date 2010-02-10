Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0BJAmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:42:52 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:36432 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0BJAmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:42:50 -0500
Message-ID: <4B7200DC.60103@oracle.com>
Date: Wed, 10 Feb 2010 08:42:04 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: lockdep warning for iscsi in 2.6.33-rc6
References: <4B7107CF.3060703@oracle.com> <4B71B7D9.9040501@cs.wisc.edu>
In-Reply-To: <4B71B7D9.9040501@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B720100.0185:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Mike Christie wrote:
> On 02/09/2010 12:59 AM, Tao Ma wrote:
>> Hi Mike,
>> I meet with a lockdep warning for iscsi in 2.6.33-rc6.
>> the lockdep is attached.
>>
> 
> If the lockdep output is saying that there is a problem with the iscsi 
> host taking its mutex then the scsi host mutex, I think that might be a 
> mistake in the lockdep detection. We always take the iscsi host mutex 
> then take the scsi host mutex.
> 
> Could it get confused if we are scanning two hosts at the same time? If 
> it is just looking at if a lock is being taken then it would look like 
> host1 has its ihost->mutex and then took its shost->mutex, but then 
> host2 could start to get scanned at the same time, and it is going to 
> take its ihost->mutex. It would then look like we are trying to grab a 
> ihost->mutex while holding a shost->mutex. However, the mutexs are not 
> global and they are different instances of the mutex because each host 
> has its own.
If these 2 mutexes are grabed in the same order(in your description, 
ihost->mutex first and then shost->mutex), there would be no problem.
> 
> If that is not the problem, maybe it has something to do with some sysfs 
> lock and ata doing scanning while iscsi is.
yeah it looks so from the lockdep output.

You know the real bad thing is that after lockdep find an error, it will 
set debug_locks to 0, so any future check will be disabled. As iscsi 
start up very early, no other check can be proceeded.

Regards,
Tao
