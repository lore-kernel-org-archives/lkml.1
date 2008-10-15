Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYJOMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYJOMbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYJOMbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:31:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35331 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276AbYJOMbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:31:10 -0400
Date: Wed, 15 Oct 2008 13:30:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
 mechanism
Message-ID: <20081015133045.1639b72b@lxorguk.ukuu.org.uk>
In-Reply-To: <20081015075246.2e1610f3@infradead.org>
References: <20081012194427.2e21c22e@infradead.org>
	<20081015014117.faff3a61.akpm@linux-foundation.org>
	<20081015075246.2e1610f3@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it's very simple. Take the case of doing each sata port probe as an
> asynchronous item. In order to keep a stable device naming/ordering,
> all the sata probes need to be done in sequence

Not really, you need the results to be ordered which simply means you
need a rendezvous and ordered dispatch from that point.

For ATA stability the only serialization points are handling out ataxx:
numbers and handing out device identifiers. You can find all the ports in
parallel and you can probe them all for disks in parallel (Power supply
permitting).

In fact in both those cases you could do it entirely in parallel as you
can order the probe sequence at start time. That in turn means that
you can defer assignation of names, but that might make the boot messages
a bit confusing.

I'd also question call_async as we don't have infinite thread resources
(or anywhere near sufficient) so in fact what you have is
queue_async(arguments)/complete_async_work(result). Also the async call
is exactly that so we need to be very careful people realise that and
don't pass pointers to local stack objects or we will have some truely
hellish debugging to do. In fact I suspect passing a single
'private_data' object as we do for irqs and other async event handlers is
far safer.

Implementing the queue_async_sequenced(arguments) /
complete_async_sequenced() / finalize_sequenced() model would make life a
lot easier for stuff like device probing with ordering as well.

	queue_async_sequenced(sequence, call, finalize, private_data)

queue asynchronous task and if resources exist start it as call(sequence,
private_data)

	complete_async_sequenced - finish this task, store result and if
possible despatch the next one

	finalize_sequenced - wait for all completions in this sequence
then run the finalize method of each strictly in the order that they were
added orginally by queue_async_sequenced.

gives us exactly what is needed for stuff like SATA probe. After the
finalize the ability to restart_async_sequenced() with a new
call/finalize function would be elegant but not essential ...


Alan
