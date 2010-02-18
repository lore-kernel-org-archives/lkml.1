Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab0BRRGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:06:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:64813 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0BRRGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:06:35 -0500
Message-ID: <4B7D7386.4040503@windriver.com>
Date: Thu, 18 Feb 2010 11:06:14 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, mort@sgi.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH 08/28] kdb: core for kgdb back end (2 of 2)
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com><1266014143-29444-9-git-send-email-jason.wessel@windriver.com><m1zl37xhmm.fsf@fess.ebiederm.org> <4B7D5704.6060504@windriver.com> <m1fx4ywlgr.fsf@fess.ebiederm.org>
In-Reply-To: <m1fx4ywlgr.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2010 17:06:09.0955 (UTC) FILETIME=[AACF8F30:01CAB0BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jason Wessel <jason.wessel@windriver.com> writes:
>
>   
>> Eric W. Biederman wrote:
>>     
>>> Jason Wessel <jason.wessel@windriver.com> writes:
>>>
>>>   
>>>       
>>>> This patch contains the hooks and instrumentation into kernel which
>>>> live outside the kernel/debug directory, which the kdb core
>>>> will call to run commands like lsmod, dmesg, bt etc...
>>>>     
>>>>         
>>> You know this dropping the locks from vmalloc_info and swap_info
>>> is down right ugly, and I don't believe it is safe.  That code
>>> was not designed to run while the write_lock is held.
>>>   
>>>       
>> Perhaps we can find some middle ground.  I don't mind simply not
>> allowing the information to be queried from kdb if the locks are not
>> available. 
>>
>> Which is less ugly you, making the swap_lock global or adding a function
>> to query it?
>>     
>
> My recommendation would be to simply drop the swap_info and meminfo
> information for now, and have kdb do what is good at.
>   

I have no objection to dropping this for now.

> Skimming through the history of the discussion it appears Christoph
> Hellwig asked you to do something about these bits on the first
> review.
>
>   
If you are referring to the statement from the RFC patch:

"Patch 1 still containes a lot random junk. E.g. all those meminfo and
whatever hooks aren't required for a very basic kernel debugger"

Most of that was restructured in that code base vs what you have taken a
look at and we are down to a handful of instrumentation points.

> From a maintenance point of view anything where you have to know which
> locks a function will take is fragile.  It is entirely too easy to create
> a change that is fine in it's normal context but breaks kdb.
>
>   

Sure, but that is life for kdb in the current state.  You either make
safe query macros or create something to call helper functions to
inspect code.  Either way it is maintenance.

> Alt-sysrq already allows capturing that kind of information, without any
> thorny maintenance issues.  

Alt-sysrq cannot be called from all the same contexts that you can
invoke kdb.  The maintenance issue you speak of is avoided because of
the points you can actually invoke a sysrq.  Certainly you are not going
to be able to call Alt-sysrq, in an nmi as well as a number of other
contexts.

> By contrast kdb appears to be a much larger
> and inferior tool.
>
>   

I am not certain as to what comparison you are trying to draw here.  If
you are only using kdb to obtain meminfo and swapinfo, sure I buy your
argument.   If you are using kdb to modify, inspect memory and execute
back traces at certain places then I think this is not an apples to
apples comparison.

I'll post a new version of the patch with the hooks you asked about
stripped out.  The commands will also get removed from the kdb command
shell.

Thanks,
Jason.
