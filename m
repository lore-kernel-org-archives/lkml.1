Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZJTRdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZJTRdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZJTRdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:33:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9897 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZJTRdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FNSe5cHvmKMIfg5HCTRccvJkv7LZMQG3iqp0sdwgcNoL6ySKMmblpL+NKDZOm1HCTb
         /pt9o5YmJ2MptON+52ZFMQKgUeJgHtsBaqLADON7gtwTkWJkMqouLsoajmelMfgPzoQN
         D8O3YEo+qEQWF5GbpAhd61oQTLJAaFuU3tj3Q=
Date: Tue, 20 Oct 2009 19:33:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly skip
	records
Message-ID: <20091020173338.GB4906@nowhere>
References: <1256054439-24386-1-git-send-email-jolsa@redhat.com> <20091020171147.GA4906@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020171147.GA4906@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 07:11:54PM +0200, Frederic Weisbecker wrote:
> > NOTE:
> > 
> > AFAIK patch does not affect "trace_pipe" handling, since the change is
> > on the ring_buffer_iter level. However the "trace_pipe" suffers from
> > the same issue -> when the read buffer is filled up, the current trace
> > entry is not copied to it. Following read will continue with next entry.
> > It might be harder to fix this, since "trace_pipe" in order to see next
> > record has to eat the current one... 
> > 
> > I'll look at possible solution, but any ideas are welcome.. :)
> > 


Yeah, dealing with the ring buffer consuming mode is more tricky.
Actually I would feel more comfortable with a generic solution that
solves consuming and iter modes.

We have a private field in struct trace_iterator so I guess
we can store useful things inside.

Say we have that in the ring buffer:

f1 entry
f1 return
f2 entry

If we know we are a leaf call, we need to store a copy of the
f1 entry/f1 return couple in struct trace_iterator::private
So that we can check that on the next processing and call
print_graph_entry_leaf() directly.

What remains is the need to check the status of the last
processing. Was it TRACE_TYPE_HANLED,TRACE_TYPE_PARTIAL_LINE..?

We probably need this info in trace_iterator...

