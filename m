Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbZDQKv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbZDQKv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZDQKvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:51:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZDQKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:51:46 -0400
Date: Fri, 17 Apr 2009 06:51:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined
 size  support
In-Reply-To: <1239964774.23397.4363.camel@laptop>
Message-ID: <alpine.DEB.2.00.0904170649130.20429@gandalf.stny.rr.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>  <1239912812.23397.3432.camel@laptop>  <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com>  <1239949360.23397.4065.camel@laptop>  <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com>
  <1239960548.23397.4282.camel@laptop>  <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com> <1239964774.23397.4363.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Peter Zijlstra wrote:

> On Fri, 2009-04-17 at 06:10 -0400, Steven Rostedt wrote:
> 
> > When I replied to Frederic, I thought I could come up with a way to do 
> > something like you are proposing. Instead, I only ended up with the 
> > variant that Frederic implemented.
> > 
> > I've done what you are suggesting several times in tracing. Logdev does 
> > this in its tracing.
> > 
> > The problem that we have, is that we don't have actual code. We have a 
> > TRACE_EVENT macro that is doing the work for us. This, unfortunately, 
> > limits what we can do.
> 
> Can't you do things like:
> 
> #define __string(x) unsigned long length_##x, offset_##x;
> 
>   TP_STRUCT__entry
> 
>   size = sizeof(struct foo);
> 
> #define __string(x) length_##x = strlen(x) + 1; size += length_##x;
> 
>   TP_STRUCT__entry
> 
>   entry = ring_buffer_lock_reserve(size);
>   offset = sizeof(stuct foo);
> 
> #define __string(x) \
> 	__entry->x = offset_##x = offset; offset += length_##x;
> 
>   TP_STRUCT__entry
> 
>   TP_fast_assign
> 
> #define _string(x) strcpy(&entry->data[offset_##x], x);
> 
>   TP_STRUCT__entry
> 
>   ring_buffer_unlock();
> 
> also, you don't need that __ending_string() thing, you can always end a
> struct with char data[0], its 0 size ;-)
> 

This looks very similar to what I suggested in the cross email.

Frederic,

You want to take a crack at implementing this. I think my description had 
a bit more details, but is basically the same as what Peter is describing 
here.

I'd just make __string become an offset (as described in my email)

Then the user could just index directly. They only need to worry about the 
print, the assignment would be automated.

-- Steve

