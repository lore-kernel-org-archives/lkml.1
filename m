Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZJZWG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZJZWG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZJZWGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:06:55 -0400
Received: from relay1.sgi.com ([192.48.179.29]:47871 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753520AbZJZWGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:06:54 -0400
Message-ID: <4AE61D84.9000107@sgi.com>
Date: Mon, 26 Oct 2009 15:07:00 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box>
In-Reply-To: <20091026215544.GA3355@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> On Mon, Oct 26, 2009 at 11:03:59AM -0700, Mike Travis wrote:
>>
>> Andi Kleen wrote:
>>> Mike Travis <travis@sgi.com> writes:
>>>
>>>> With a large number of processors in a system there is an excessive amount
>>>> of messages sent to the system console.  It's estimated that with 4096
>>>> processors in a system, and the console baudrate set to 56K, the startup
>>>> messages will take about 84 minutes to clear the serial port.
>>>>
>>>> This patch adds (for SGI UV only) a kernel start option "limit_console_
>>>> output" (or 'lco' for short), which when set provides the ability to
>>>> temporarily reduce the console loglevel during system startup.  This allows
>>>> informative messages to still be seen on the console without producing
>>>> excessive amounts of repetious messages.
>>>>
>>>> Note that all the messages are still available in the kernel log buffer.
>>> I've run into the same problem (kernel log being flooded on large number of CPU thread
>>> systems). It's definitely not a UV only problem. Making such a option UV only
>>> is definitely not the right approach, if anything it needs to be for everyone.
>> I could use something like the MAXSMP config option to enable it...?
> 
> No, it's a problem long before MAXSMP sizes.
> 
>>> Frankly a lot of these messages made sense for debugging at some point,
>>> but really don't anymore and should just be removed.
>> That they still go to the kernel log buffer means the messages are still
>> available for debugging system problems.  KDB has a kernel print option if
>> you end up there before being able to use 'dmesg'.
> 
> Again they should be just reevaluated and pr_debug()ed or completely
> removed.
> 
>>> Also I don't like the defaults of on. It would be better to evaluate if
>>> these various messages are really useful and if they are not just remove them.
>> I believe most distros already do that by setting the loglevel argument
>> (but I could be wrong since I haven't looked at too many of them.)
> 
> Even spamming dmesg is a problem. loglevel doesn't fix that.
> 
>>> For example do we really need the scheduler debug messages by default?
>> This was the most painful message at Nasa (which has a 2k cpu system).  It took
>> well over an hour for these scheduler messages to print, just because we wanted
>> to get some other DEBUG prints.
> 
> They should be just removed.

I had changed this to CONFIG_DEBUG_SCHED at one time.  Perhaps this would be
acceptible?

> 
>>> Or do we really need to print the caches for each CPU at boot? The information
>>> is in sysfs anyways and rarely changes (I added this originally on 64bit,
>>> but in hindsight it was a bad idea)
>> I was attempting not to decide whether each message was pertinent, only if it
>> was redundant.
> 
> You should decide or at least ask whoever added it
> 
> ("How many bugs did you fix with that message last year?" If the answer
> is < 10 or so, remove it)

Ok.

>>> I don't think it makes much sense to print more than 2-3 lines for each CPU boot
>>> for example.
>> That would still be 4 to 12 thousand lines of information which, as you say is
>> available by other means.
> 
> A simple checkpoint for debugging is not available by other means.
> 
> The cache, mce etc. information is.
> 
> For the checkpoint problem on CPU boot it might be reasonable
> to write them into a special buffer and only print it when the other
> CPU does not come up (BP detects a time out)
> 
> With that a single line of per CPU output should be feasible without
> losing any debuggability.
> 
> In fact debuggability could be improved by putting the output 
> at better strategic points instead of the ad-hoc way it is currently.
> 
> -Andi
> 

Ok, thanks for the feedback.  I'll see about reducing the output more
intelligently for CPU's (as per Ingo's suggestions as well.)

Mike
