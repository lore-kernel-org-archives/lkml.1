Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZFCTh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZFCTh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZFCThu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:37:50 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:12441
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753053AbZFCThu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:37:50 -0400
X-SpamScore: -35
X-BigFish: VPS-35(zz1803O1432R98dR1805M1804Kzz1202hzzz2fh17ch6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
Message-ID: <4A26D0D9.9020609@am.sony.com>
Date: Wed, 3 Jun 2009 12:36:57 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] ring-buffer: try to discard unneeded timestamps
References: <20090603141605.001049251@goodmis.org> <20090603141651.231310727@goodmis.org> <4A26C6EC.30609@am.sony.com> <alpine.DEB.2.00.0906031510470.14994@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906031510470.14994@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 19:36:58.0572 (UTC) FILETIME=[A8CDF0C0:01C9E482]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 3 Jun 2009, Tim Bird wrote:
>> Is this new routine only for discarding uncommitted events,
>> or can it be used on committed events?
>>
>> I assume the former, since I see nothing about adjusting the
>> commit position.
> 
> Only uncommitted events.
OK.

>> In the ring_buffer API I see that there's a function for
>> discarding events (committed ones), but not for free-ing them.
>> In function duration filtering, it is desirable to free the
>> last committed event, which for a function exit of short
>> duration will be it's entry event 99% of the time.
> 
> In filtering we deside before commiting if we want to discard or not. 
> (Note, this is only in tip right now.)  Once we commit it, there is no way 
> to safely remove it from the ring buffer. Additions of items are not under 
> a lock (only the moving from page to page is).
> 
> For the event tracer we check if we want to disard it or not before we 
> commit.

Yeah - that's what I thought.  I have duration filtering working
(well, the user interface is not done yet), but with the above
limitations, I can only free the exit from the trace, and mark
the entry event as discarded.  It would save a whole lot more
space to free the entry event as well.

I'm experimenting with free-ing only the last committed event,
when no other write has occurred in the buffer.  But I'm still
not sure I can make it safe.  Under normal conditions this
would be sufficient to catch 99% of the cases.  I did this
in KFT, but under locks, and I know you want to be lockless with
ftrace.

Are writes the only issue, or is it a problem with readers?
I was thinking of experimenting with allowing it when no readers
were active (or were on a different page).

>> P.S. I'm very sorry about the missing '>' on the Signed-off-by line.
>> I ran checkpatch and got a passing score, but missed this.
> 
> No prob, you only made me spam LKML (and others) with about 10 garbage 
> emails ;-)
LOL.  Sorry again. ;-)

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

