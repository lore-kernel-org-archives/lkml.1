Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXJZVGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXJZVGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXJZVFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:05:50 -0400
Received: from dvhart.com ([64.146.134.43]:47399 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764854AbXJZVFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:05:49 -0400
Message-ID: <472256AB.6060109@mbligh.org>
Date: Fri, 26 Oct 2007 14:05:47 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com, riel@redhat.com, linux-mm@kvack.org
Subject: Re: OOM notifications
References: <20071018201531.GA5938@dmt> <20071026140201.ae52757c.akpm@linux-foundation.org>
In-Reply-To: <20071026140201.ae52757c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 18 Oct 2007 16:15:31 -0400
> Marcelo Tosatti <marcelo@kvack.org> wrote:
> 
>> Hi,
>>
>> AIX contains the SIGDANGER signal to notify applications to free up some
>> unused cached memory:
>>
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0007.0/0901.html
>>
>> There have been a few discussions on implementing such an idea on Linux,
>> but nothing concrete has been achieved.
>>
>> On the kernel side Rik suggested two notification points: "about to
>> swap" (for desktop scenarios) and "about to OOM" (for embedded-like
>> scenarios).
>>
>> With that assumption in mind it would be necessary to either have two
>> special devices for notification, or somehow indicate both events
>> through the same file descriptor.
>>
>> Comments are more than welcome.
> 
> Martin was talking about some mad scheme wherin you'd create a bunch of
> pseudo files (say, /proc/foo/0, /proc/foo/1, ..., /proc/foo/9) and each one
> would become "ready" when the MM scanning priority reaches 10%, 20%, ... 
> 100%.
> 
> Obviously there would need to be a lot of abstraction to unhook a permanent
> userspace feature from a transient kernel implementation, but the basic
> idea is that a process which wants to know when the VM is getting into the
> orange zone would select() on the file "7" and a process which wants to
> know when the VM is getting into the red zone would select on file "9".
> 
> It get more complicated with NUMA memory nodes and cgroup memory
> controllers.

We ended up not doing that, but making a scanner that saw what
percentage of the LRU was touched in the last n seconds, and
printing that to userspace to deal with.

Turns out priority is a horrible metric to use for this - it
stays at default for ages, then falls off a cliff far too
quickly to react to.

