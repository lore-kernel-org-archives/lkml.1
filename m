Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZI2Rg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZI2Rg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZI2Rg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:36:26 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:37195 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZI2Rg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:36:26 -0400
Message-ID: <4AC24525.9060607@nortel.com>
Date: Tue, 29 Sep 2009 11:34:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Henrik Austad <henrik@austad.us>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
References: <1253615424.20345.76.camel@Palantir>	 <1253623867.20345.156.camel@Palantir> <1253644603.18939.25.camel@laptop>	 <200909270855.49367.henrik@austad.us> <1254240635.7775.44.camel@Palantir>
In-Reply-To: <1254240635.7775.44.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2009 17:36:17.0419 (UTC) FILETIME=[597C2DB0:01CA412B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 10:10 AM, Raistlin wrote:
> On Sun, 2009-09-27 at 08:55 +0200, Henrik Austad wrote:
>>> An alternative is starting the child out with 0 runtime, and have the
>>> parent run sched_setscheduler() on it giving us a clear point to run
>>> admission on.
>>
>> Why not start it as sched_fair/sched_rt and let the child apply for
>> resources the same way the parent did? That would be fairly
>> straightforward and lead to predictable behaviour, and also make a nice, 
>> simple hook into the acceptance-tests.
>>
> Yeah, that's an option as well... It maybe overlap a little bit with
> reset_on_fork, but I like tha fact that it allows the task itself to ask
> for EDF bandwidth without having to rely on its parent... Thoughts about
> that?

Basically it boils down to a policy decision...if a task with guaranteed
cpu allocation fork()s, should the child automatically get a guaranteed
allocation or not?  If so, should that allocation cause the parent's
allocation to be reduced or not?

Personally I don't like the idea of fork() resulting in permanently
reduced allocation for the parent.  I think the logical choices are either

a) The child should get an identical bandwidth guarantee as the parent
and if that can't be guaranteed then the fork() should fail, maybe with
an errno of EBUSY.

b) The child should start out with no guarantees (SCHED_OTHER nice 0
maybe?) and should have to request a bandwidth guarantee.  This could
complicate things in some circumstances because if it can't get the
guarantee then it needs to inform the parent somehow.

Given that any serious users of EDF are likely pretty specialized,
either one would probably work.  Which is the best policy is a different
question, and one that I don't have enough experience with to offer an
opinion.

Chris
