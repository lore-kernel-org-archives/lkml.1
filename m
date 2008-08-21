Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYHUMwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYHUMwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYHUMwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:52:13 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:58634 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYHUMwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:52:12 -0400
Message-ID: <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48AD5A21.7020801@s5r6.in-berlin.de>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
    <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de>
    <1219316568.8651.107.camel@twins>
    <20080821114745.GD21089@linux.vnet.ibm.com>
    <48AD5A21.7020801@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 06:26:35 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 
     2.6.27-rc4	released
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: paulmck@linux.vnet.ibm.com, "Peter Zijlstra" <peterz@infradead.org>,
       jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Howells" <dhowells@redhat.com>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Paul E. McKenney wrote:
>> On Thu, Aug 21, 2008 at 01:02:48PM +0200, Peter Zijlstra wrote:
>>> On Thu, 2008-08-21 at 12:57 +0200, Stefan Richter wrote:
>>>> Peter Zijlstra wrote:
>>>>> On Wed, 2008-08-20 at 20:50 -0600, jmerkey@wolfmountaingroup.com
>>>>> wrote:
>>>>>
>>>>>>  volatiles left in the code due to the previously stated
>>>>>>  (and still present) severe breakage of the GNU compiler with SMP
>>>>>>  shared data.  most of the barrier() functions are just plain broken
>>>>>>  and do not result in proper compiler behavior in this tree.
>>>>> Can you provide explicit detail?
>>>>>
>>>>> By using barrier() the compiler should clobber all its memory and
>>>>> registers therefore forcing a write/reload of the variable.
>>>> I hope Jeff didn't try mere barrier()s only.  smp_wmb() and smp_rmb()
>>>> are the more relevant barrier variants for mdb, from what I remember
>>>> when I last looked at it.
>>> Sure, but volatile isn't a replacement for memory barriers.
>>
>> Let's face it, the C standard does not support concurrency, so we are
>> all in a state of sin in any case, forced to rely on combinations of
>> gcc-specific non-standard language extensions and assembly language.
>>
>> Could be worse!!!
>
> Nevertheless, an analysis of which particular parts of code generation
> are insufficient if one particular volatile qualification is removed is
> IMO likely to turn up places in mdb where a clearer or/and more
> efficient implementation is possible.  (Based on what I saw a few
> revisions ago; I haven't looked at the current one yet.)
> --
> Stefan Richter
> -=====-==--- =--- =-=-=
> http://arcgraph.de/sr/
>

I used the smp_wmb() functions.  I noted a couple of things.  a) some of
these macros just emit __asm__ __volatile__ into the code so why not just
say "volatile" to begin with b) smp_wmb() in some cases worked and in
other cases jut optimized away the global reference. c) I can go back and
break the code again by inserting them and building broken assembler d) I
ave been doing hardware and software design since the early 1980;s, I
invented SMP affinity scheduling, and yes, I understand barriers and this
concept of instruction score-boarding and optimization very well -- its
not an excuse for a busted C compiler.

It did not break all the places in the code, but broke enough for SMP to
lock up and fail,  It turned global variables into local variables.  If
you want me to reproduce this I can but it will have to wait til this
evening
because I have some product releases to get out the door at Omega 8 today.

It's simple to reproduce.  Take away the volatile declaration for the
rlock_t structure in mdb-ia32.c (rlock_t debug_lock) in all code
references and watch the thing lock up in SMP with multiple processors in
the debugger each stuck with their own local copy of debug_lock.

The barrier functions do not appear to work in all cases.

Jeff

