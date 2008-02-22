Return-Path: <linux-kernel-owner+w=401wt.eu-S934277AbYBVWEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbYBVWEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbYBVWDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:03:49 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:62810 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761993AbYBVWDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:03:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CqG7p4iOUKZst7+VohF3N8zdI1W6PVVuFaMDQ4jxNaWHR+o97g0JNiTQoXeZPvm0qUZ6mlsRUkyRZpmIDRyb65/AcFxNv0plcyc+N47t8JDz5CXweFjBVrGalft1XkB5CWCc5a3gotchwpQ8KCRG6yeTlJsdz9QIIbnFpDVAe6w=
Message-ID: <47BF46AF.7010200@gmail.com>
Date: Fri, 22 Feb 2008 17:03:27 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "Bill Huey (hui)" <bill.huey@gmail.com>, Andi Kleen <ak@suse.de>,
       Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net,
       gregkh@suse.de, pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152707.4804.59177.stgit@novell1.haskins.net> <200802211741.10299.ak@suse.de> <20080222190814.GD11213@linux.vnet.ibm.com> <9810cff90802221119j23818e74g2721512a693a0a01@mail.gmail.com> <9810cff90802221121s216f69f4k4a5f39eaaf11dd7f@mail.gmail.com> <20080222194341.GE11213@linux.vnet.ibm.com> <1203710145.4772.107.camel@sven.thebigcorporation.com> <20080222202316.GF11213@linux.vnet.ibm.com>
In-Reply-To: <20080222202316.GF11213@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Governing the timeout by context-switch overhead sounds even better to me.
> Really easy to calibrate, and short critical sections are of much shorter
> duration than are a context-switch pair.

Yeah, fully agree.  This is on my research "todo" list.  My theory is 
that the ultimate adaptive-timeout algorithm here would essentially be 
the following:

*) compute the context-switch pair time average for the system.  This is 
your time threshold (CSt).

*) For each lock, maintain an average hold-time (AHt) statistic (I am 
assuming this can be done cheaply...perhaps not).

The adaptive code would work as follows:

if (AHt > CSt) /* dont even bother if the average is greater than CSt */
    timeout = 0;
else
    timeout = AHt;

if (adaptive_wait(timeout))
    sleep();

Anyone have some good ideas on how to compute CSt?  I was thinking you 
could create two kthreads that message one another (measuring round-trip 
time) for some number (say 100) to get an average.  You could probably 
just approximate it with flushing workqueue jobs.

-Greg

> 
> 							Thanx, Paul
> 
>> Sven
>>
>>> 							Thanx, Paul
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

