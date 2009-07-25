Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915AbZGYO6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbZGYO6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZGYO6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:58:20 -0400
Received: from ms01.sssup.it ([193.205.80.99]:41042 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbZGYO6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:58:19 -0400
Message-ID: <4A6B1D86.6060209@sssup.it>
Date: Sat, 25 Jul 2009 16:58:14 +0200
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Jamie Lokier <jamie@shareable.org>, Peter Zijlstra <peterz@infradead.org>,
       sen wang <wangsen.linux@gmail.com>, mingo@elte.hu,
       akpm@linux-foundation.org, kernel@kolivas.org, npiggin@suse.de,
       arjan@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
References: <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>	 <1248441290.6987.52.camel@twins>	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>	 <1248442415.6987.56.camel@twins>	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>	 <1248443656.6987.61.camel@twins>	 <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>	 <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org>	 <1248451279.6987.138.camel@twins>  <20090724233057.GO27755@shareable.org> <1248525201.8429.113.camel@Palantir>
In-Reply-To: <1248525201.8429.113.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Raistlin ha scritto:
>> For simple things like "try to keep the buffer to my DVD writer full"
>> (no I don't know how much CPU that requires - it's a kind of "best
>> effort but try very hard!"), it would be quite useful to have
>> something like RT-bandwidth which grants a certain percentage of time
>> as an RT task, and effectively downgrades it to SCHED_OTHER when that
>> time is exceeded to permit some fairness with the rest of the system
> Well, agree, again. If you want something very useful, you need the
> combination of the two: user space techniques and kernel space support.
>   
I didn't follow the entire discussion, however I'd like to add a 
comment, if it may be of any help. What is useful actually depends on 
the usage scenario and its requirements, comprising for example 
real-time and security requirements. On one hand, giving a real-time 
task the opportunity to keep running even if its budget is exhausted may 
be of course useful for the real-time task. In fact, in the real-time 
literature, you can find the term "soft reservations" to denote those 
real-time scheduling mechanisms that have such a property (and still 
preserve theoretical schedulability), with various different ways of 
distributing the spare capacity on the real-time tasks. On a GPOS like 
Linux, it may also be useful to "downgrade" a RT task to SCHED_OTHER 
when its budget is exhausted. In fact, in the AQuoSA EDF-based scheduler 
[academic], if the flag "SOFT_SERVER" is specified when creating a 
server, this is exactly what happens :-). On a related note, in the 
POSIX SPORADIC_SERVER (and e.g., its implementation by Dario Faggioli) 
there is a "low priority" field specifying the priority at which the 
task should run when the budget is exhausted).
However, if you depart from the traditional "embedded" context (i.e., 
for industrial control), switching for example to a "multi-user server" 
context, then a task "triggering" the throttling might not constitute 
necessarily a system bug that "needs a reboot", but it may simply be due 
to an application trying to over-use the system as compared to how much 
it is supposed to use it. Imagine a "pay-per-compute" context in which 
the share of a server is granted to a user (i.e., to a VM). Then, a 
provider would not necessarily want to grant a user more computation 
capability than the user has paid for. In fact, in the AQuoSA scheduler 
[again, academic], an access-control model exists by which the sys-admin 
may decide what users (and user groups) are authorized to access the 
"SOFT_SERVER" facility (i.e., real-time reservations for "gold" users 
might be allowed to be soft, but the ones for "bronze" users might not).

Therefore, IMHO there is no "silver bullet", but what behavior is best 
depends on the security requirements that may be in-place. Access to the 
"soft server" mentioned above is just an example, but plenty of other 
issues may arise, including: maximum system capacity that users may be 
authorized to occupy, maximum RT server periods that users may be 
authorized to use (for not starving the background OS for too much), 
minimum RT server period (for not causing too much scheduling overhead), 
etc... A more detailed discussion about security requirements arising 
when granting real-time facilities to unprivileged users on a GPOS may 
be found in [1], in case anyone is interested.

Regards,

  T.

[1] Tommaso Cucinotta "Access Control for Adaptive Reservations on 
Multi-User Systems", in Proceedings of the 14th IEEE Real-Time and 
Embedded Technology and Applications Symposium (RTAS 2008), St. Louis, 
MO, United States, April 2008, available at: 
http://feanor.sssup.it/~tommaso/publications/RTAS-2008.pdf

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://feanor.sssup.it/~tommaso

