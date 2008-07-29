Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYG2Eaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYG2Eaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYG2EaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:30:22 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:35725 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751055AbYG2EaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:30:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uUsj1oLSv+iS+51saYZOK0x2ABCLWm0cjhYL5XkJA45K8Oc7z+22kSsjMgLQ3Ryxd5A/nhyd/ttjn2gCmya3UvevuT5bubriwx0zNQnlL5xu+/9Ze8iTrxj+0CJoCqhyv/43lY5sOpbOQH0WdV6dEuj5U6l7qDvAijTz6pUsKyo=  ;
X-YMail-OSG: OC5WhOkVM1kN0scPV8WH7WFUWzxVNyBuz9urBkWif4lS9_po70VCJfgDC64BPe1y30o7R9xZGeK2StqnPPtSFPzYxxaLi6di6Nk1rGo5IXVgBSqCnliRJ0bv6P.TbNGPlfk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Date: Tue, 29 Jul 2008 14:30:07 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <488E534F.2030204@goop.org> <20080728233455.GA2919@elte.hu>
In-Reply-To: <20080728233455.GA2919@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291430.08220.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 09:34, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Now that normal smp_function_call is no longer an enormous bottleneck,
> > is there still value in having a specialised IPI vector for tlb
> > flushes?  It seems like quite a lot of duplicate code.
> >
> > The 64-bit tlb flush multiplexes the various cpus across 8 vectors to
> > increase scalability. If this is a big issue, then the smp function
> > call code can (and should) do the same thing.  (Though looking at it
> > more closely, the way the code uses the 8 vectors is actually a less
> > general way of doing what smp_call_function is doing anyway.)

It definitely is not a clear win. They do not have the same characteristics.
So numbers will be needed.

smp_call_function is now properly scalable in smp_call_function_single
form. The more general case of multiple targets is not so easy and it still
takes a global lock and touches global cachelines.

I don't think it is a good use of time, honestly. Do you have a good reason?


> yep, and we could eliminate the reschedule IPI as well.

No. The rewrite makes it now very good at synchronously sending a function
to a single other CPU.

Sending asynchronously requires a slab allocation and then a remote slab free
(which is nasty for slab) at the other end, and bouncing of locks and
cachelines. No way you want to do that in the reschedule IPI.

Not to mention the minor problem that it still deadlocks when called with
interrupts disabled ;)
