Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYJBJUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYJBJUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYJBJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:20:04 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:49789 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbYJBJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:20:02 -0400
Message-ID: <48E4923E.7000006@weinigel.se>
Date: Thu, 02 Oct 2008 11:19:58 +0200
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] RFC: Low-latency SDIO
References: <20080930102313.418263345@zoo.weinigel.se> <20081002103257.3b2f7c5d@mjolnir.drzeus.cx>
In-Reply-To: <20081002103257.3b2f7c5d@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 30 Sep 2008 12:23:13 +0200
> Christer Weinigel <christer@weinigel.se> wrote:
>> Here is a cleaned up patch that implements the low-latency SDIO stuff
>> I mailed about a couple of weeks ago.  Basically the patches adds
>> asynchronous SDIO operations and makes it possible to register a
>> "hard" SDIO interrupt handler which will be called directly from
>> interrupt context (mmc_signal_sdio_irq).
> 
> Did you see the response I sent to the previous thread?

Yes, i think so.  My previous post was mostly handwaving and some claims 
of a performance improvement, I wanted to clean up my low latency 
patches first and show a concrete implementation of what I was thinking 
about before asking for more feedback.

This patch mostly adds things, the asynchronous API is available for for 
those that need it, but old drivers will still work as before.  There is 
a difference for host drivers, drivers that sleep in their request 
function will not work, but I believe request shouldn't do that anyway.

Anyway, is this the response you're thinking of:

September 5, Pierre Ossman wrote:
> The latency improvement is indeed impressive, but I am not convinced it
> is worth it. An asynchronous API is much more complex and difficult to
> work with (not to mention reading and trying to make sense of existing
> code), and SDIO is not even an asynchronous bus to begin with.

> I do like the idea of reducing latencies (and generally improving the
> performance of the MMC stack). The primary reason I haven't done
> anything myself is lack of stuff to test and proper instrumentation.
> 
> There are really two issues here, which aren't necessarily related;
> actual interrupt latency and command completion latency.
> 
> The main culprit in your case is the command completion one. Perhaps
> there is some other way of solving that inside the MMC core? E.g. we
> could spin instead of sleeping while we wait for the request to
> complete. Most drivers never use process context to handle a request
> anyway. We would need to determine when the request is small enough
> (all non-busy, non-data commands?) and that the CPU is slow enough. I
> also saw something about a new trigger interface that could make this
> efficient.

There are actually three issues I think, interrupt latency, command 
completion latency, and CPU load.

Using a busy-wait for command completion would both reduce the load and 
latency (because there will be no interrupt or wakeup overhead).  But it 
only helps for quick commands, for any commands that transfer data, 
we'll have to use an interrupt and get the wakeup latencies.  And for me 
  any latency, initial interrupt latency or latency after the data 
transfer, are killers, so that's what I'm trying to solve.

I did google a bit for a Linux trigger interface and for some reason (I 
can't remember exactly why now), I did not think that it would be 
suitable for what I want to do.

So I still would like to get something like this low-latency thing into 
the kernel.

  /Christer

