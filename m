Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbZAMPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbZAMPAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZAMPAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:00:20 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:47214 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZAMPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:00:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=L4F9u+QkpOFLk7x6QFe8tB+684+fuGdS6Uj9iGoxJBG6ivp7rSC0DsOJMvRNzqa4y6
         ZJfLMlGTc2H6auUkkks9B4uq8LXl1bqNKmtDr7RayFXgQRuyL5gBHmWTmDS0WnrZ4P+n
         jgAX8TJeLp7zMU4M/t2NzVIsPM/PzE9TxKqq4=
Message-ID: <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com>
Date: Tue, 13 Jan 2009 20:30:16 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Dave Jones" <davej@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20090113142423.GA30710@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112153304.GA19995@ioremap.net>
	 <20090112154456.GA27269@redhat.com>
	 <20090112154827.GB20743@ioremap.net>
	 <20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
	 <20090113135246.GA29251@ioremap.net>
	 <20090113140627.507f15e1@lxorguk.ukuu.org.uk>
	 <20090113142423.GA30710@ioremap.net>
X-Google-Sender-Auth: 71bd4a822e380591
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 7:54 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Tue, Jan 13, 2009 at 02:06:27PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
>> > Do you _REALLY_ think anyone can calculate it yourself and then properly
>> > calculate adjustment used to properly select oom-killed process?
>>
>> Its always a heuristic.
>
> For the system which knows what it is. User does not and really can not
> work with it, since there is no sane way to implement that heuristic in
> the applications or even in (theoretically possible) monitor daemon.
>
> So, effectively, oom adjustment does not work.
>
>> > So far my patch is the sanest way to deal with the OOM selection
>>
>> No. You keep maintaining this but your crude hack is useless in a non
>> co-operative environment, has lots of issue with name aliasing and
>> doesn't deal with real needs.
>
> It is created because of real needs. Because people need to control the
> behaviour of the system and they want to control which application will
> be killed to free the memory. Attached patch is not the best solution,
> but it works for the all cases I can think about.
>

Where does this end? Tomorrow you'll add an interface for applications
that should *not* be killed? What sort of a heuristic is name? I think
the only name the kernel knows about is "init".

> Let's take you 'name aliasing' claim: if there are several processes
> with the same name, system will select the one with the worst score
> according to the own magical algorithm. So it will not kill random
> process just because it happend to have ricky name.
>

Having a name in the kernel is like building a hit-list, why can't the
examples that Alan sent work for you?
Names are tricky as well, if someone used a symbolic link to the
application with a different name, they would no longer be candidates
for OOM first? or vice-versa?

> And the same applies to the other issues. It just helps system to select
> the process to be killed according to userspace expectation of what
> should be killed to free the memory.
>
>> We have container interfaces that can do this and far more and do them
>> right. In fact the very start of all the OpenVZ and container work years
>> ago was the beancounter patches which were addressed at exactly this
>> problem (although more specifically 'making sure undergraduates processes
>> get killed first')
>
> Are the beancounters used to limit amount of virtual ram and not the
> physical one? It really does not work to limit for example some java
> machine which will ate all virtual space swapping out different node.
> It works for some (and likely the most, I do not argue this) cases and
> has overhead. But we are talking not about how to limit the processes,
> but what to do when we happend to have out-of-memory condition. And it
> happens all the time even if you put the processes into the separate
> container, since there are situations (that's why it was started at
> first), when you have a huge process which should not be killed and set
> of either its children or external processes, which should be checked
> and some of them (administrator would like to specify the less
> important) should be killed without much harm to the system.
>
> And patch I presented allows to do it. It introduces a hint for the
> killer on what processes should be checked first. It works exactly the
> way people work with their system: they run different application and
> expect some of them to be higher or lower priority when things come to
> the oom condition. No one ever proposes to kill exactly the process we
> select (although that may be a good idea in some cases), but instead to
> show that oom-killer should check given group first. The group
> administrator knows to be potentially harmless.
>

You can replace the lines of kernel code you wrote with a simple
one-line script that Alan sent out.

Balbir
