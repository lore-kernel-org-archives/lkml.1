Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYKSS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYKSS16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYKSS1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:27:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:13562 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbYKSS1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:to:cc:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding:from;
        b=M2+xxAoPKhe2GvuyMg8jAPCsfxu6hysQ6RdasFFCoR8kl5YpdvZ5G2BxLZANlVHt3t
         EvEQlISt6TA3OK1Ho2ZYfSQUiN/p47biDJzvGzcUXNcJl+JgQyxe4u4F5vgug7f3BZV0
         BMJtdYtcBelyxHOAMRzYFjomuK/WcMll2oq48=
Subject: Re: debugctl msr
To: eranian@gmail.com
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 19:27:25 +0100
Message-Id: <1227119245.6025.12.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
From: Markus Metzger <markus.t.metzger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 18:13 +0100, stephane eranian wrote:

> Speaking of locking, I also ran into another issue with ds_lock.
> Perfmon sessions each have a spinlock for access serialization, but to
> prevent from PMU and timers interrupts, interrupts are masked. Thus,
> when perfmon
> calls ds.c, interrupts are masked. That means that we lock/unlock ds_lock
> with interrupts disabled. The lock checker triggered when I ran a simple perfmon
> session and warned of possible lock inversion. Suppose you are coming from the
> ptrace code into ds. You grab ds_lock, but the same process is also running
> a perfmon session with PEBS and a counter overflows, you get into
> the PMU interrupt handler which may call into ds.c and try to grab the ds_lock.
> For that reason, I think you should use a
> spin_lock_irqsave/spin_unlock_irqrestore
> pairs to protect your ds context.

OK. So far, there was no user that called ds_*() with interrupts
disabled.


> I found another issue with ds_release(). You need to skip freeing the
> buffer when it
> is NULL, i.e., was already allocated by caller of ds_request_pebs().

ds_release() is not robust with respect to double release, if that's
what you mean. Is that desirable?

For a single ds_release() call matching a corresponding successful
ds_request() call, the buffer is freed if and only if it had been
allocated by ds.c.

Kfree() itself handles NULL pointers and scripts/checkpatch.pl warns on
a check for NULL around a kfree() call.


> I have attached a diff for the ds.c interface. It disables
> ds_validate_access(), export
> the PEBS functions to modules, fixes ds_release().
> 


> As for handling the interrupt is ds.c, not clear how this could work
> with current perfmon.
> I don't know how this work on the BTS side. On the PMU side, that is not because
> I am using PEBS, that I don't also use other counters as well. Longer
> term, I think, there
> needs to be a lower-level PMU interrupt service where you would
> register a callback
> on PMU interrupts. It would be used by NMI watchdog, perfmon,
> Oprofile, ds.c. 

That's even preferable to having the interrupt code itself in ds.c

The point I was trying to make is that buffer overflows should not be
handled on higher levels (i.e. users of ds.c). That's why I am so
reluctant to expose the interrupt threshold in the ds.c interface.


regards,
markus.

