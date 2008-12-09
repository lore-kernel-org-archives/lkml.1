Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYLIGhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYLIGhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 01:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYLIGhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 01:37:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:53506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYLIGha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 01:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=l7+E8sbsZ8oF6bpcwB3gyOSsa+B932WlQBHQE5q75Ic5LYV9uGxXJUpkH0dkA8xTkZ
         uD1hq8BbYvTcnt7qhzaorwQaux9ws0IgIhu+i7xe71d7XB0qFT8L6lOq2BNjIM8kYtnv
         W3qMFG8ILunOl3uqpFS+abhpRsEnSGYMv+HGg=
Message-ID: <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
Date: Tue, 9 Dec 2008 07:37:27 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v2
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "David Miller" <davem@davemloft.net>,
       "Paul Mackerras" <paulus@samba.org>
In-Reply-To: <20081208012211.GA23106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081208012211.GA23106@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 8, 2008 at 2:22 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>
> There's a new "counter group record" facility that is a straightforward
> extension of the existing "irq record" notification type. This record
> type can be set on a 'master' counter, and if the master counter triggers
> an IRQ or an NMI, all the 'secondary' counters are read out atomically
> and are put into the counter-group record. The result can then be read()
> out by userspace via a single system call. (Based on extensive feedback
> from Paul Mackerras and David Miller, thanks guys!)
>

That is unfortunately not generic enough.You need a bit more
flexibility than master/secondaries, I am afraid.  What tools want
is to be able to express:
   - when event X overflows, record values of events  J, K
   - when event Y overflows, record values of events  Z, J

I am not making this up. I know tools that do just that, i.e., that is
collecting
two distinct profiles in a single run. This is how, for instance, you
can collect
a flat profile and the call graph in one run, very much like gprof.

When a you get a notification and you read out the sample, you'd like
to know if which order values are returned. Given you do not expose counters,
I would assume the only possibility would be return them in file
descriptor order.
But that assumes at the time you create the file descriptor for an
event you have
all the other file descriptors you need...

> There's also more generic x86 support: all 4 generic PMCs of Nehalem /
> Core i7 are supported - i've run 4 instances of KernelTop and they used
> up four separate PMCs.
>
Core/Atom have 5 counters, Nehalem has 7.
Why are you not using all of them already?
