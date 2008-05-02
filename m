Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbYEBRL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbYEBRL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYEBRLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:11:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbYEBRLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:11:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=Oa4oHrgUmmf4ErlP6UwOy2Jhsu6LjPlyOLM1DzFQYggXjuO7Vk5Eu9ax2dPucEv6D
	mmv2y3KekxDKyZq5ifZIQ==
Subject: Re: CPU POSIX timers livelock
From: Frank Mayhar <fmayhar@google.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
In-Reply-To: <1209744785.15210.52.camel@elijah.suse.cz>
References: <1209740741.15210.49.camel@elijah.suse.cz>
	 <20080502152126.GA3130@atjola.homenet>
	 <1209744785.15210.52.camel@elijah.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Organization: Google, Inc.
Date: Fri, 02 May 2008 10:10:26 -0700
Message-Id: <1209748226.13467.6.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 18:13 +0200, Petr Tesarik wrote: 
> On Fri, 2008-05-02 at 17:21 +0200, Björn Steinbrink wrote:
> > [Added Roland McGrath and Frank Mayhar to Cc:, as this sounds similar
> > enough to what has been discussed here http://lkml.org/lkml/2008/2/6/505]
> 
> Yes, I've just now found the thread too, read it, and I think this is
> just another case where the current implementation does not scale.
> 
> Was there any followup to the patch posted on the 7th of March? The
> interesting discussion seems to be interrupted there. :(

Roland and I have continued the conversation but we took it off the LKML
since it was really getting into the nitty-gritty details of the
implementation and wasn't that interesting to someone not actually
directly involved.

The upshot is that I have a proposed patch that I have handed to Roland
to review.  He's pretty busy, though, so he may not have gotten to it
yet.  Perhaps this thread will give him further incentive. :-)

Petr's analysis pretty much matches mine, except that he went into a bit
more detail in actually computing numbers and whatnot whereas I just
reasoned that with a sufficiently large number of threads pretty much
any process that uses POSIX timers can cause the system to livelock,
simply because repeatedly running the thread group list in
run_posix_cpu_timers() will at some point take as long as the timer tick
itself.

My proposed patch that Roland is reviewing corrects the implementation
of run_posix_cpu_timers() to make it run in constant time for a
particular machine by defining a couple of new structures and keeping
the thread group timers in one of these.  It's way more complex than
this and I have a README that goes into detail if anyone is interested.

I've tested the patch with as many as 200,000 threads (all of which are
running a prime number sieve and are therefore CPU bound) and it appears
to work fine.  Before I post it again, though, I want Roland to sign off
on it.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

