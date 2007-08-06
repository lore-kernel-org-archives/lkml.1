Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXHFK07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXHFK07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762030AbXHFK0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:26:51 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:19683 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbXHFK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Yc3dqV2oCELSKxGhXQLERe6Qq/L659fEPmQ/9RhTID7hp8xyrijtFVzz4WtovYvN4BZ6TXrydTOmq5eZPTe+nNrhCGnET94N0tnoMVrtZE4OWqHDqp7T1OJX3MaCn1HzlfN1lLd2mxySTDr6dklXaSmZJPLpy6BcjBiY8m3jNS4=
Message-ID: <46B6F75D.1070808@gmail.com>
Date: Mon, 06 Aug 2007 12:26:37 +0200
From: dragoran <drago01@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de>
In-Reply-To: <p73zm14lxyy.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> dragoran <drago01@gmail.com> writes:
>
>   
>> Its possible to set the io priority using tools like ionice and syscalls.
>> But this works only as root.
>> Why can't a non root user change the priority of his processes to idle?
>> I understand that realtime priority requires root but why idle?
>> For instance the beagle trys to set its priority to idle but fails
>> because it does not run as root.
>> Any reason for this that I have missed? I can't think of a case where
>> setting the io priority to idle would have a negative impact for other
>> users or the whole system.
>>     
>
> Very low priority can starve others when it holds some kernel resource
> needed by another task.  
>
> Consider three tasks: one very low priority, one high priority: Low
> priority task holds some kernel resource, middle task eats as much CPU
> as it gets; high priority task wants to get the resource. High
> priority will need to wait for low running, which could take a long
> time. With true SCHED_IDLE (i believe the current implementation is
> not true) this could be never or at least a very long time.
>
> There are ways to defend against this problem (known as priority inheritance),
> but the kernel doesn't do them consistently. The same issue could also
> happen for user space managed resources.
>
> For IO I suppose the same could happen too. e.g. low priority
> task wants to write out a page and keeps it locked until the IO 
> is finished. High priority task wants to access the page and has
> to wait until it is unlocked. Middle task generates an endless
> stream of IO that makes the idle priority writeout never finish.
couldn't this be fixed by bumping idle tasks to middle while they hold a 
pagelock?
ex:
task A - hp
task B - mp
task C - lp (idle)
task C locks a page -> becomes a mp (middle prio) task until its finished
task C unlocks the page -> back to idle

> In general idle priorities are quite risky, even for root.
>
> -Andi
>
>   

