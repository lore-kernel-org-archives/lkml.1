Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYIYRfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYIYRfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYIYRfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:35:09 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:35377 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYIYRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:35:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANVl20hMQWq+/2dsb2JhbACBXrlTgWU
Date: Thu, 25 Sep 2008 13:35:05 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/2 v2] Unified trace buffer
Message-ID: <20080925173505.GD29392@Krystal>
References: <20080925155807.158539649@goodmis.org> <20080925160048.641420646@goodmis.org> <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:27:24 up 112 days, 22:07, 10 users,  load average: 1.16, 1.41,
	1.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
[...]
> but the bigger issue is that I think the timestamp should be relative to 
> the _previous_ event, not relative to the page start. IOW, you really 
> should accumulate them. 
> 

How about keeping the timestamps absolute ? (but just keep 27 LSBs)

It would help resynchronizing the timestamps if an event is lost and
would not accumulate error over and over. It would event help detecting
bugs in the tracer by checking if timestamps go backward.

Also, it would remove inter-dependency between consecutive events; we
would not have to know "for sure" what the previous timestamp was when
we write the current event. Just knowing if we need to write the full
TSC is enough (which implies knowing an upper bound), which is a much
more relax constraint than having to know the _exact_ previous
timestamp.

Is there a reason to use delta between events rather than simply write
the 27 LSBs that I would have missed ?

Mathieu

> IOW, the base timestamp cannot be in the cpu_buffer, it needs to be in the 
> iterator data structure, since it updates as you walk over it.
> 
> Otherwise the extended TSC format will be _horrible_. You don't want to 
> add it in front of every event in the page just because you had a pause at 
> the beginning of the page. You want to have a running update, so that you 
> only need to add it after there was a pause.
> 
> 		Linus
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
