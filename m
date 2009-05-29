Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbZE2TGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbZE2TGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZE2TGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:06:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZE2TGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:06:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=iA+rdw0CFOi46fbpmnrxaEgSRhltFmgz7l3F+GmsuZPRAEccjECJJlNGq3TCq0Gnx
	FKz7cs2wCAamxFgfRDNsA==
MIME-Version: 1.0
In-Reply-To: <20090529165716.GB18141@gandalf.sssup.it>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	 <1243377729-2176-3-git-send-email-vgoyal@redhat.com>
	 <e98e18940905271353kc6890dbxa1ea63026c8faec1@mail.gmail.com>
	 <20090528160003.GA4335@redhat.com>
	 <e98e18940905281241v4aa24716j91f351a828af604a@mail.gmail.com>
	 <20090529160610.GC26962@redhat.com>
	 <20090529165716.GB18141@gandalf.sssup.it>
Date: Fri, 29 May 2009 12:06:03 -0700
Message-ID: <e98e18940905291206p2e05bc5cxf499479270e34074@mail.gmail.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in 
	elevaotor layer
From: Nauman Rafique <nauman@google.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, Chad Talbott <ctalbott@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 9:57 AM, Fabio Checconi <fchecconi@gmail.com> wrote:
>> From: Vivek Goyal <vgoyal@redhat.com>
>> Date: Fri, May 29, 2009 12:06:10PM -0400
>>
>> On Thu, May 28, 2009 at 12:41:27PM -0700, Nauman Rafique wrote:
> ...
>> > I have some concerns about the new preemption logic.
>>
>> Actually we need a more proper definition of in-class preemption. Across
>> class preemption means that RT class always gets to run first.
>>
>> What does in-class preemption mean? If I look at the current CFQ code,
>> it does look like that preempting process will gain share. It is always
>> added to the front of the tree with "rb_key=0" and that means, this new
>> queue will get fresh time slice (even if it got time slice very recently).
>>
>> Currently I have just tried to make the behavior same as CFQ to reduce
>> the possiblility of regressions. That's a different thing that we can
>> discuss what should be the exact behavior in case of in-class preemption
>> and first it needs to be fixed in CFQ, if current behavior is an issue.
>>
>> On the other hand, I am not sure if previous bfq preemption logic was
>> working. We were checking if the new request belonged to the queue which
>> will be served next, then preempt the existing queue. While looking
>> for the next queue, I think we did not consider the current active
>> entity (as it was not on the tree). So after expiry of the current
>> queue, it might get selected next if it has not got its share. So there
>> was no point in preempting the queue. If queue already got its share, then
>> anyway the next queue will be selected next and there is no point in
>> preempting the current queue.
>>
>
> BFQ had no preemption logic, as far as I know; it simply was not
> preemptive, and the guarantees it provided took that into account.
>
> I don't know what is the best way to introduce a CFQ-like preemption logic
> into the wf2q+ code; for sure anything that does not schedule according
> to the algorithm's timestamps is a good candidate to break the guarantees
> the scheduler can provide, making it an extremely complex way to get
> the same worst-case delays of a (much simpler) round-robin scheduler.
>

What you guys think of my suggestion of handling preemption?
Basically, we don't modify the start/finish tags, so overall the
fairness properties should not be broken. But in short term, we still
allow preemption and let one queue jump another.
