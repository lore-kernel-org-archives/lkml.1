Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYKMNzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYKMNzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYKMNzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:55:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbYKMNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:54:59 -0500
Date: Thu, 13 Nov 2008 08:54:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
In-Reply-To: <20081113131939.GA2669@elte.hu>
Message-ID: <alpine.DEB.1.10.0811130848450.7458@gandalf.stny.rr.com>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org> <20081113084040.GD25479@elte.hu> <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com> <20081113131939.GA2669@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Ingo Molnar wrote:
> 
> the obvious solution is to add this to ring_buffer_resize():
> 
> 	if (!buffer)
> 		return size;

Having a NULL buffer return a successful resize is a bit worrisome to me.

And looking at the code I was trying to make sure could never be called
if there are no max_tr users:

in update_max_tr

	buf = tr->buffer;
	tr->buffer = max_tr.buffer;
	max_tr.buffer = buf;

Should all the ring buffer API return success on NULL pointers?

> 
> resizing a non-existent buffer should succeed. A two-liner patch. Not 
> 160 lines of flux.
> 
> Really, you need to think _hard_ how to avoid invasive-looking changes 
> in late -rc's, because every extra line to review uses up precious 
> review resources.

I appreciate the goal of minimal change, but I also want to keep things 
robust.

Right now I'm thinking my other suggestion is the best. Just allocate the 
max_tr.buffer and get rid of the CONFIG. This solution is very small, and 
covers all corner cases.

-- Steve

