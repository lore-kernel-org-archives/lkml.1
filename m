Return-Path: <linux-kernel-owner+w=401wt.eu-S1161006AbXBVOrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006AbXBVOrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161106AbXBVOrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:47:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52379
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161006AbXBVOrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:47:05 -0500
Date: Thu, 22 Feb 2007 06:47:04 -0800 (PST)
Message-Id: <20070222.064704.71093028.davem@davemloft.net>
To: mingo@elte.hu
Cc: johnpol@2ka.mipt.ru, arjan@infradead.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hch@infradead.org, akpm@zip.com.au, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070222143145.GA3246@elte.hu>
References: <20070222123929.GA5208@2ka.mipt.ru>
	<20070222.054127.104035694.davem@davemloft.net>
	<20070222143145.GA3246@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 22 Feb 2007 15:31:45 +0100

> Firstly, i dont think you are fully applying the syslet/threadlet model. 
> There is no reason why an 'idle' client would have to use up a full 
> thread! It all depends on how you use syslets/threadlets, and how 
> (frequently) you queue back requests from cachemiss threads back to the 
> primary thread. It is only the simplest queueing model where there is 
> one thread per request that is currently blocked. Syslets/threadlets do 
> /not/ force request processing to be performed in the async context 
> forever - the async thread could very much queue it back to the primary 
> context. (That's in essence what Tux did.) So the same state-machine 
> techniques can be applied on both the syslet and the threadlet model, 
> but in much more natural (and thus lower overhead) points: /between/ 
> system calls and not in the middle of them. There are a number of 
> measures that can be used to keep the number of parallel threads down.

Ok.

> Secondly, even assuming lots of pending requests/async-threads and a 
> naive queueing model, an open request will eat up resources on the 
> server no matter what. So if your point is that "+4K of kernel stack 
> pinned down per open, blocked request makes syslets and threadlets not a 
> very good idea", then i'd like to disagree with that: while it wont be 
> zero-cost (4K does cost you 400MB of RAM per 100,000 outstanding 
> threads), it's often comparable to the other RAM costs that are already 
> attached to an open connection.

The 400MB is extra, and it's in no way commensurate with the cost
of the TCP socket itself even including the application specific
state being used for that connection.

Even if it would be _equal_, we would be doubling the memory
requirements for such a scenerio.

This is why I dislike the threadlet model, when used in that way.

The pushback to the primary thread you speak of is just extra work in
my mind, for networking.  Better to just begin operations and sit in
the primary thread(s) waiting for events, and when they arrive push
the operations further along using non-blocking writes, reads, and
accept() calls.  There is no blocking context really needed for these
kinds of things, so a mechanism that tries to provide one is a waste.

As a side note although Evgeniy likes M:N threading model ideas, they
are a mine field wrt. signal semantics.  Solaris guys took several
years to get it right, just grep through the Solaris kernel patch
readme files over the years to get an idea of how bad it can be.  I
would therefore never advocate such an approach.

The more I think about it, a reasonable solution might actually be to
use threadlets for disk I/O and pure event based processing for
networking.  It is two different handling paths and non-unified,
but that might be the price for good performance :-)
