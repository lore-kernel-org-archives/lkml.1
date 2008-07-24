Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYGXKiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYGXKiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYGXKir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:38:47 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:44877 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752065AbYGXKiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:38:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2JN+kwbqA7UJwUvn3dlJThn8fWvwz8OPBaqfn6tESgLB4mv/EDLDCiRcWUUPTDqF5laXIkQ3dljMt5XIVJ/W5ezMpusgmNYVOFZSjeJnWpogWSG9dEYkBkMNFIyQ+mPp3l9+GbN6XLC/Xb3SKEvsyOqaN8Pwml27D0b/DE5B/d4=  ;
X-YMail-OSG: kD9zvoAVM1mhRDoFT9ow1i3nSgoVFzQ9TLzUua9JOAyJqMZKmBVT9UcPXR7O0OhZtugC559nESU9P1V._dOlLQAfRl5U62x3NwehFq2qJJEKIe6me1DvNJp3kGTgwAr3_qI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Kernel WARNING: at net/core/dev.c:1330 __netif_schedule+0x2c/0x98()
Date: Thu, 24 Jul 2008 20:38:35 +1000
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, jarkao2@gmail.com,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com,
       paulmck@linux.vnet.ibm.com
References: <1216890648.7257.258.camel@twins> <20080724.023210.229338550.davem@davemloft.net> <1216894136.7257.266.camel@twins>
In-Reply-To: <1216894136.7257.266.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242038.36693.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 20:08, Peter Zijlstra wrote:
> On Thu, 2008-07-24 at 02:32 -0700, David Miller wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Thu, 24 Jul 2008 11:27:05 +0200
> >
> > > Well, not only lockdep, taking a very large number of locks is
> > > expensive as well.
> >
> > Right now it would be on the order of 16 or 32 for
> > real hardware.
> >
> > Much less than the scheduler currently takes on some
> > of my systems, so currently you are the pot calling the
> > kettle black. :-)
>
> One nit, and then I'll let this issue rest :-)
>
> The scheduler has a long lock dependancy chain (nr_cpu_ids rq locks),
> but it never takes all of them at the same time. Any one code path will
> at most hold two rq locks.

Aside from lockdep, is there a particular problem with taking 64k locks
at once? (in a very slow path, of course) I don't think it causes a
problem with preempt_count, does it cause issues with -rt kernel?

Hey, something kind of cool (and OT) I've just thought of that we can
do with ticket locks is to take tickets for 2 (or 64K) nested locks,
and then wait for them both (all), so the cost is N*lock + longest spin,
rather than N*lock + N*avg spin.

That would mean even at the worst case of a huge amount of contention
on all 64K locks, it should only take a couple of ms to take all of
them (assuming max spin time isn't ridiculous).

Probably not the kind of feature we want to expose widely, but for
really special things like the scheduler, it might be a neat hack to
save a few cycles ;) Traditional implementations would just have
#define spin_lock_async	      spin_lock
#define spin_lock_async_wait  do {} while (0)

Sorry it's offtopic, but if I didn't post it, I'd forget to. Might be
a fun quick hack for someone.
