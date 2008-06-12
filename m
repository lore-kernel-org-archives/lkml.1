Return-Path: <linux-kernel-owner+w=401wt.eu-S1761821AbYFLNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761821AbYFLNTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761267AbYFLNS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:18:58 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:48030 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761102AbYFLNS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:18:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OhOsVvhBNd1m/ZLpOWNQhKaxdMU35QEG9TUaDAjRayTRRvgM+CCUH+ZjLhOJCJUoyZ0d9sTZebK6sYlNtONBSStnJv4QqiHBzYWW0/OGP/d1wBsNYKFBclbOiP3Fl5DcAUH8EvFWW8wihuxCNQYzXXy+unqBHAWbcR3G31Vv4hA=  ;
X-YMail-OSG: z.pxqIIVM1nx0QU8Vje3wKVtq4AXtquZOcXof75RxYKt2bNdzvQSSna5mApMJe0KD81SJXpyhcWJVXjfwMEo_ykuRIoJY4VRG.EHpVRR4Bn0vABLX18BlRD6odD.49TBEkw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Cliff Wickman <cpw@sgi.com>
Subject: Re: [PATCHv4] SGI UV: TLB shootdown using broadcast assist unit
Date: Thu, 12 Jun 2008 23:18:45 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <E1K6lqI-0006pX-JQ@eag09.americas.sgi.com> <200806122235.29888.nickpiggin@yahoo.com.au> <20080612125605.GA26760@sgi.com>
In-Reply-To: <20080612125605.GA26760@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806122318.45397.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 22:56, Cliff Wickman wrote:
> Hi Nick,
>
> On Thu, Jun 12, 2008 at 10:35:29PM +1000, Nick Piggin wrote:
> > On Thursday 12 June 2008 22:23, Cliff Wickman wrote:

> > For someone not too familiar with low level x86 (or UV) code, can
> > you explain why you are hooking at this point? I mean, what it
> > looks like is either a performance improvement, or for some reason
> > UV does not support send_IPI_mask out to CPUs "not on the local node".
>
> Yes, a performance improvement.  The UV machine has hardware for
> broadcasting messages to a set of nodes (represented in a bit mask).  The
> messages will raise interrupts at each of the target nodes and provide
> the message - all in one step.
> (IPI is supported.  In fact this patch falls back to the IPI method
>  if all the cpus on the remote nodes do not respond.)

Thanks, that makes it perfectly clear to me now (the intent, not
the details of the code :))

So long as this raises a maskable interrupt on each target CPU, it
doesn't break x86's lockless get_user_pages :)


> > If the former, what sort of improvement to you expect / see?
>
> Good question.  The hardware does not exist yet.  But using IPI there
> would be one set of packets exchanged to deliver the interrupts and
> another set to pull over the flush address, just to start the operation.
> I expect the improvement to be significant.

Ah, so you can send a small message with the IPI, and that can be
decoded and used by the target without invoking the cc protocol.
Seems like pretty sweet functionality.

I guess TLB flushing is an obvious candidate, but it could be
quite useful for other operations as well. I wonder if it couldn't
be used to create a slightly more advanced API (than send_IPI)
which other platforms can just implement using cache coherency for
the payload...

For example, some classes of smp_call_function could use this too.

But for now I don't see anything wrong with getting this patch
upstream and looking to generalise it later.
