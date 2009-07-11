Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZGKJzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZGKJzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 05:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZGKJy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 05:54:56 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:43028 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbZGKJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 05:54:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=FNcQ1uL2S+7jWfAbjuEOMzPvlb+OOwuJY3SEjbpI0e/ttwPXewLHwqT9QRhYGf8a;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: linux-kernel@vger.kernel.org
Message-Id: <C7739469-5CD4-478A-AD68-BD38D01FCD59@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: Chris Snook <chris.snook@gmail.com>
In-Reply-To: <13a12eea0907110116g62bd0aa1n6f1d35a067351ff1@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Suggested code change : Simple : Scale pdflush threads from  desktop to server
Date: Sat, 11 Jul 2009 02:54:52 -0700
References: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net> <13a12eea0907110116g62bd0aa1n6f1d35a067351ff1@mail.gmail.com>
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec796e8e351988fadb1415ff62dc43851671350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris, et al, inline,

	Initial bottom line is to add some minimal server scalability and KISS.
	
	This is a heads up and says "have you considered this"?

	Yes, these are sensible changes and have no possible regressions
	except wrt the printk and an alternative rate limiting is suggested.

	Mitchell Erblich
	===============
	
On Jul 11, 2009, at 1:16 AM, Chris Snook wrote:

> On Fri, Jul 10, 2009 at 9:25 PM, Mitchell Erblich<erblichs@earthlink.net 
> > wrote:
>> Group,
>>
>>                pdflush threads clean dirty pages
>>
>>          Under the past simple assumption that a greater number of
>>          page daemon threads will have the TENDENCY to clean
>>          the pages faster.
>>
>>        Another assumption is that a server will have at least 2x /  
>> 4x the
>>        number of drives and memory, so allocating more pdflush()  
>> threads
>>        makes sense.
>
> That's a rather sweeping generalization.

	Not really, the current  default desktop system will have 1 drive
	and 2 to 4GB of physical memory.

	A normal server will have at least 2 drives so the min
	of PDFLUSH gets increased to 2x. This is a fairly
	conservative increase.
>
>
>>        Relying on a recent change, code base on whether the system is
>>        a desktop or a server, scale the number of pdthreads() which  
>> would
>>        result in the below code change.
>>
>>        The suggestion is to double the MIN number of threads and  
>> set the
>>        MAX number to 4x.
>>
>>        ./mm/pdflush.c
>>        /* Scale for a server */
>>        #define MIN_PDFLUSH_THREADS     4               /* 2x  
>> desktop value
>> */
>>        #define MAX_PDFLUSH_THREADS     32              /* 4x  
>> desktop value
>> */
>
> So, you're taking a well-established and empirically validated set of
> constants, and changing it only in the case where users are least
> tolerant of change?  I agree that the existing pdflush tuning is a bit
> of a kludge, but this just adds more noise to the data we need to
> analyze and optimize pdflush.

	The MAX gets changed and ONLY gets bumped based on the
	assumption of non-idle PDFLUSH threads. Just because we
	may set a higher POSSIBLE MAX thread value, does not mean
	that the MAX number will be allocated.

	Since the normal user will be a desktop, then that system has no
	change in functionality.

	If the system is a server, then only two additional; THREADS will
	be waiting without a lag.

	And yes, CFS has at least one tuneable based on interactiveness
	AND is to be set whether you are a DESKTOP OR SERVER in
	behaviour.
	
>
>
>>        /*
>>         * secondary suggestion is to add a DEBUG type /var/log/system
>> messages that
>>         * will rate limit independent of desktop or server.
>>         */
>>
>>        else if (nr_pdflush_threads == MAX_PDFLUSH_THREADS) {
>>                   /* optional PDFLUSH msg */
>>                   if (printk_ratelimit() {
>>                                                    printk(KERN_INFO
>> "MAX_PDFLUSH_THREADS Limited\n");
>>                   }
>>         }
>
> Log messages, even at debug level, for normal conditions are a  
> really bad idea.

	This is SUGGESTED with PARANOIA, (see triple events for msg)
	First, I really think I need a if NOT rate limit then print msg.
	And yes, sent a followup msg on that.

	However, this code is best executed every sec if their are MAX  
pdflush()
	threads and none are idle.
	
	And is then reason for rate limiting. So, the output is limited via  
three
	limiting events. (every sec, rate limit, and MAX threads).
	FYI: this else is not creating another pdflush thread where the if  
"is".
	May want to do something with jiffies, for a more restrictive limiting,
	  so it is at most executed every X secs, if nr_pdflush_threads stays  
at MAX,

	So, knowing that the system would
	be NORMALLY creating more pdthreads, may generate some minimal
	reason for write congestion even when hardware is capable of more.

	Some more knowledgeable users may want to see if they periodicly
	bump into the MAX value.
>
> pdflush definitely needs work, but twiddling constants will, at best,
> optimize it for a small subset of the user base for a brief period of
> time.  We really need patches that do intelligent things based on
> system resources and load, and we need data to support them.

	First, if a simple change gets us a 90% solution, then
	what is wrong with that?

	pdflush() in my opinion needs some level of feedback on
	how much is in the write queues per fs, the latency
	of them being served,  write congestion, etc, but
	a KISS approach is to accept that default desktop will have
	a lower I/O capacity and that a server with a higher I/O
	capacity should have a higher CAPABLE number of pdthreads.
	
	Also, a earlier Suggested changeby me also allows pdflush threads
	to be created more freq when their is write load.

	
>
>
> -- Chris

