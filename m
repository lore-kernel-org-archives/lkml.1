Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYI2TzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYI2TzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYI2TzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:55:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37626 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYI2TzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:55:01 -0400
Date: Mon, 29 Sep 2008 15:54:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
In-Reply-To: <alpine.DEB.1.10.0809291452180.8145@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0809291548390.8145@gandalf.stny.rr.com>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal> <alpine.DEB.1.10.0809291224470.5493@gandalf.stny.rr.com> <20080929183833.GA17490@Krystal>
 <alpine.DEB.1.10.0809291452180.8145@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 29 Sep 2008, Steven Rostedt wrote:
>   We do not need to worry about SMP for writes.
>   That is, if you reserve data and atomically push the head forward
>    if the head goes past the end of page, One, you check if your
>    start of head (head - length) is still on the page. If it is
>    you add your padding (you already reserved it), then you atomically
>    push the head forward. Then you start the process again.
>   If the start of the head (head - length) is not on the page, that
>    means that an IRQ or NMI came in and pushed it before you.

I forgot to mention one important detail. The "head" index will stay
on the page frame. That way we do not need to figure out which 
head_page we are on. We grab the head_page, we atomically 
(local_inc_return) the head pointer on that page. If the return value is 
still on the page, we succeeded. We can also increment a value on this 
page frame that will prevent recording if we somehow overflowed the buffer 
before relinquishing the stack.

That is

  reserve_event()

     IRQ->
            reserve_event();

      [...]

     IRQ->reserve_event() came back to original head!

      Here we do not have a big enough buffer, and this is just stupid ;-)
      We would drop packets in this case, and should drop the guy on his
      head who came up with the too small buffer.

-- Steve

