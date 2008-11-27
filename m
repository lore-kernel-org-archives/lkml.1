Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYK0BL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYK0BL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYK0BIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:08:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbYK0BIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:08:10 -0500
Date: Wed, 26 Nov 2008 20:08:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
 trace output
In-Reply-To: <c62985530811261657t6ba9c8cbwc21fa9d09627e110@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811262001270.1501@gandalf.stny.rr.com>
References: <492DEDE9.9010109@gmail.com> <c62985530811261657t6ba9c8cbwc21fa9d09627e110@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> 
> One detail. If you get a trace through the "trace" file, you will have
> no problem.
> But if you cat trace_pipe, leaf functions are considered as nested.
> 
> This is because iter->buffer_iter[iter->cpu]; is very often (always?)
> false by using this file.
> I don't know why yet....
> But it makes the tracer unable to check the next entry to verify if it
> matches its own return.

That's because trace_pipe does not use an iterator ;-)  It is live stream.

There's two cases: static read and consume.  On static read we can take 
our time and we iterate over the data in the file. The data does not get 
consumed so we use an iterator to traverse the data.

The consume read will consume each entry as it reads it. We do not need an 
iterator for this because we are always reading the head of the file. 
After we read the data, that data is consumed and we read the next item.

Hmm, I may need to make this apparent to the plugins like yours. This way 
you can do different things whether it is a static read or a consuming 
read.

Perhaps the info now is what you already found out. 
"iter->buffer_iter[iter->cpu] will always be NULL when it is a consuming 
read. Intead you need to use:

ring_buffer_peek instead of ring_buffer_iter_peek

and

ring_buffer_consume instead of ring_buffer_read

This is the way you can use it:

entry = ring_buffer_peek(iter->tr->buffer, iter->cpu, NULL);
entry = ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);

-- Steve

