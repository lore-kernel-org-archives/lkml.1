Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZGOIdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZGOIdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 04:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZGOIdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 04:33:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42622 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZGOIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 04:33:10 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitzu.com
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	<20090702190845.0cafc46a.akpm@linux-foundation.org>
	<6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
	<20090702235527.7ddc873c.akpm@linux-foundation.org>
	<6599ad830907030911m6176dc59id3a7d897b03d2bd@mail.gmail.com>
	<20090703095000.cf46ad19.akpm@linux-foundation.org>
	<6599ad830907031054x74d90149y38aae60afa403d58@mail.gmail.com>
	<20090703111016.ceb28541.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 15 Jul 2009 01:33:05 -0700
In-Reply-To: <20090703111016.ceb28541.akpm@linux-foundation.org> (Andrew Morton's message of "Fri\, 3 Jul 2009 11\:10\:16 -0700")
Message-ID: <m1ocrm73cu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, lizf@cn.fujitzu.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, bblum@google.com, menage@google.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that  shows only unique tgids
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 3 Jul 2009 10:54:48 -0700 Paul Menage <menage@google.com> wrote:
>
>> >__Unfortunately radix-trees are presented as operating on
>> > void* data, so one would need to do some typecasting when storing
>> > BITS_PER_LONG-sized bitfields inside them.
>> 
>> That would mean adding something a bit like the IDA wrapper that
>> converts IDR to deal with bitfields?
>
> I guess so.
>
>> Is the benefit of avoiding a vmalloc() at all costs really worth the
>> additional complexity
>
> Well no.  But nor was it worth the additional complexity the last twenty
> times someone resorted to vmalloc to solve a problem of this nature.  Taking
> a kernel-wide perspective here gives a different answer.
>
> However I don't think a little scoreboarding thing (what's the correct
> term) built around radix-trees would suffice to solve many of those
> past sins.  Whereas a general dynamic array thing would be applicable
> in many cases.

It is even easier.  Just grab the logic from proc_pid_readdir.
It uses rcu locking.
It returns pids in order.
It needs no mallocs to use.

The people who ran benchmarks tell me I actually sped up proc,
when I started traversing the existing bitmap of pids.

It makes the guarantee that for every process that existed for
the length of the operation you will see it's pid.  Processes
that die or were born half way through we don't say anything about
but if they stay around you will get them next time.

I think guaranteeing a truly atomic snapshot is likely to be a
horrible idea requiring all kinds of nasty locking, and smp
scalability issues.  So please walk the list of pids and
just return those that belong to your cgroup.

Compare to the rest of the implementations everyone is balking
at it should be simple.

Eric
