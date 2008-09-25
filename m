Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYIYSaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYIYSaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYIYSa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:30:27 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:35851 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYIYSaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:30:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAFtx20hMQWq+/2dsb2JhbACBXrokgWU
Date: Thu, 25 Sep 2008 14:25:17 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/2 v2] Unified trace buffer
Message-ID: <20080925182517.GA6263@Krystal>
References: <20080925155807.158539649@goodmis.org> <20080925160048.641420646@goodmis.org> <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org> <20080925173505.GD29392@Krystal> <alpine.DEB.1.10.0809251347000.29802@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809251347000.29802@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:09:31 up 112 days, 22:49,  9 users,  load average: 0.17, 0.88,
	1.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 25 Sep 2008, Mathieu Desnoyers wrote:
> > 
> > Is there a reason to use delta between events rather than simply write
> > the 27 LSBs that I would have missed ?
> 
> One answer is that your counter wrap problem is extended.
> 
> That is, you have 27 bits of time between each event to not worry about
> wraps. But if you go against the page itself, the last event on that page
> is more likely to suffer.
> 

You can do the exact same thing and manage to keep the absolute time.
You just have to adapt the reader like this : (this would be for
per-event cycle count in the 32 LSBs, slight bitmask adaptation needed
for 27 bits only).

keep a 64 bits TSC value in a per-buffer variable. The previous value is
always re-used for the next read.

let's call it :
tf->buffer.tsc  (u64)

read_event() would look like :

u32 timetamp = read_event_timetamp();

if(timestamp < (0xFFFFFFFFULL & tf->buffer.tsc)) {
    /* overflow */
    tf->buffer.tsc = ((tf->buffer.tsc & 0xFFFFFFFF00000000ULL)
                     + 0x100000000ULL) | (u64)timestamp;
} else {
    /* no overflow */
    tf->buffer.tsc = (tf->buffer.tsc & 0xFFFFFFFF00000000ULL)
                     | (u64)timestamp;
}

This will detect 32 bits overflow and keep the tf->buffer.tsc in sync
with the TSC representation on the traced machine as long as events are
less then 27 bits apart. A "full tsc" header can also be easily managed
with this by updating the tf->buffer.tsc value completely when such
event is met.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
