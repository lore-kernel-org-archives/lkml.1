Return-Path: <linux-kernel-owner+w=401wt.eu-S935923AbXHNV5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923AbXHNV5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbXHNViU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:38:20 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37650 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933839AbXHNViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:38:17 -0400
In-Reply-To: <20070814212858.GB23308@one.firstfloor.org>
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU>
Cc: cra@WPI.EDU, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: William Cattey <wdc@MIT.EDU>
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
Date: Tue, 14 Aug 2007 17:37:33 -0400
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.752.3)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The system was otherwise completely idle.  The only active task was  
starting the X server.

The failure is 100% reproducible on my test system.

We have not run a lot of different kernels per se.  We ran 2.6.9, and  
it was fine.  When we ran RHEL 5, it came with 2.6.18.  All we really  
did was rebuild 2.6.18 with that chunk of code removed, and the  
problem went away.  Mind you, when that chunk of code was removed,  
there were a ton of errors about multiply freed audit blocks.  But at  
least the X server EDID transfer was successful.

As far as enabling/disabling the audit functionality:  I'm clueless  
about it. I think RHEL turned it on by default, but I don't know how  
to turn it on or off myself.

I will also note that the small stand-alone utility read_edid never  
failed.  It was only when vm86 was called from inside of the X  
server.  So perhaps there's a race condition with memory not being  
where it's expected to be when a large app calls out to real mode?

-Bill

----

William Cattey
Linux Platform Coordinator
MIT Information Services & Technology

W92-176, 617-253-0140, wdc@mit.edu
http://web.mit.edu/wdc/www/


On Aug 14, 2007, at 5:28 PM, Andi Kleen wrote:

> On Tue, Aug 14, 2007 at 04:52:54PM -0400, William Cattey wrote:
>> The corruption originally looked like a race condition.
>>
>> Sometimes the EDID buffer would be all zeros.
>> Sometimes it would contain partial data, and then the rest of the
>> buffer filled with zeros.
>> The amount of data transferred into the buffer before going to all
>> zeros is non-deterministic.
>>
>> When we put a known value in each byte of the buffer before making
>> the vm86 call, the known data would always be overwritten either with
>> EDID data or zeros.
>
> Hmm, that might be consistent with something going wrong with  
> sleeping.
> Was the system under high load? Perhaps something else can thrash
> some real mode state when you sleep. On the other hand vm86 in user
> mode can schedule anyways, so it might have already happened.
>
> But I think the mutex was actually added post 2.6.16 so if you saw
> it in 2.6.16 already it might have been something else.
>
> Also when audit is not enabled (did you have it enabled?) the audit
> function doesn't do very much?
>
> If you can reliably reproduce it one way might be to comment
> out more and more of the audit code until you find who causes
> the corruption (that might cause some corrupted audit data,
> but that should be fine for testing)
>
> -Andi

