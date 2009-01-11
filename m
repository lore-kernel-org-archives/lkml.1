Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbZAKJt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbZAKJt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZAKJtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:49:17 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:55126 "EHLO
	smarthost1.samage.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200AbZAKJtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:49:16 -0500
Message-ID: <35454.58.169.129.127.1231667354.squirrel@secure.greenhost.nl>
In-Reply-To: <1231168176.15476.6.camel@localhost.localdomain>
References: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl>
    <1230536044-14847-1-git-send-email-indan@nul.nu>
    <1231168176.15476.6.camel@localhost.localdomain>
Date: Sun, 11 Jan 2009 10:49:14 +0100 (CET)
Subject: Re: [PATCH] Fix race in ring_buffer_consume(): Replace 
     ring_buffer_consume and ring_buffer_peek with ring_buffer_get_event
From: "Indan Zupancic" <indan@nul.nu>
To: "Steven Rostedt" <srostedt@redhat.com>
Cc: "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 76f3589a93270604ea078d468a2051b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, January 5, 2009 16:09, Steven Rostedt wrote:
> I just hate public functions that have flags that can get confusing.
> Looking at code where I see:
>
> 	ring_buffer_get_event(buffer, cpu, ts, 0);
>
> I find it hard to know if the ",0" is correct or should be a ",1"
> instead.

That's what I didn't like about the original patch either.
Sent a new patch against tip doing the above, as well as doing
the same for rb_iter_peek (ignore the first one, see try 2).

Slightly different topic, there are quite a few unused functions,
e.g. ring_buffer_read_page(). Should those be removed until they
are actually used, or are there things in the pipeline that will
use them?

I'm not sure if rb_event_length() is safe as it is, returning -1
for RINGBUF_TYPE_PADDING, for an unsigned return value. That
easily overflows into a low value in e.g. rb_advance_iter().
Wouldn't it be better to return the maximum possible size?

rb_advance_reader() calls rb_get_reader_page() and rb_reader_event(),
but rb_get_event(), which is the only caller of rb_advance_reader,
does that as well, which seems a bit more of the same.

Further, rb_get_reader_page() takes cpu_buffer->lock, but all callers
of rb_get_event() take the cpu_buffer->reader_lock. As rb_get_event()
always calls rb_get_reader_page(), both locks will be taken for each
of those calls. Doesn't that make the cpu_buffer->lock redundant?
Getting rid of it and moving the locking into rb_get_event() would
simplify things (except that ring_buffer_read_page() is a bit funny).

Greetings,

Indan


