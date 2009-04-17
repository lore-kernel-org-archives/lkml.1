Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZDQKkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZDQKkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbZDQKjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:39:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274AbZDQKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:39:52 -0400
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined
 size  support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
	 <1239912812.23397.3432.camel@laptop>
	 <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com>
	 <1239949360.23397.4065.camel@laptop>
	 <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com>
	 <1239960548.23397.4282.camel@laptop>
	 <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 12:39:34 +0200
Message-Id: <1239964774.23397.4363.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 06:10 -0400, Steven Rostedt wrote:

> When I replied to Frederic, I thought I could come up with a way to do 
> something like you are proposing. Instead, I only ended up with the 
> variant that Frederic implemented.
> 
> I've done what you are suggesting several times in tracing. Logdev does 
> this in its tracing.
> 
> The problem that we have, is that we don't have actual code. We have a 
> TRACE_EVENT macro that is doing the work for us. This, unfortunately, 
> limits what we can do.

Can't you do things like:

#define __string(x) unsigned long length_##x, offset_##x;

  TP_STRUCT__entry

  size = sizeof(struct foo);

#define __string(x) length_##x = strlen(x) + 1; size += length_##x;

  TP_STRUCT__entry

  entry = ring_buffer_lock_reserve(size);
  offset = sizeof(stuct foo);

#define __string(x) \
	__entry->x = offset_##x = offset; offset += length_##x;

  TP_STRUCT__entry

  TP_fast_assign

#define _string(x) strcpy(&entry->data[offset_##x], x);

  TP_STRUCT__entry

  ring_buffer_unlock();

also, you don't need that __ending_string() thing, you can always end a
struct with char data[0], its 0 size ;-)

