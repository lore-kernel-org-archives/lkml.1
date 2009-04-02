Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbZDBFxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbZDBFxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZDBFxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:53:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbZDBFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:53:40 -0400
Date: Wed, 1 Apr 2009 22:48:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/4] ring-buffer: add ring_buffer_discard_commit
Message-Id: <20090401224814.a1c533ba.akpm@linux-foundation.org>
In-Reply-To: <20090402053522.594497414@goodmis.org>
References: <20090402052721.013878388@goodmis.org>
	<20090402053522.594497414@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Apr 2009 01:27:24 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The ring_buffer_discard_commit is similar to ring_buffer_event_discard
> but it can only be done on an event that has yet to be commited.
> Unpredictable results can happen otherwise.
> 
> The main difference between ring_buffer_discard_commit and
> ring_buffer_event_discard is that ring_buffer_discard_commit will try
> to free the data in the ring buffer if nothing has addded data
> after the reserved event. If something did, then it acts almost the
> same as ring_buffer_event_discard followed by a
> ring_buffer_unlock_commit.
> 
> Note, either ring_buffer_commit_discard and ring_buffer_unlock_commit
> can be called on an event, not both.
> 
> This commit also exports both discard functions to be usable by
> GPL modules.
> 
> ...
>
> +/*
> + * ring_buffer_event_discard can discard any event in the ring buffer.
> + *   it is up to the caller to protect against a reader from
> + *   consuming it or a writer from wrapping and replacing it.
> + *
> + * No external protection is needed if this is called before
> + * the event is commited. But in that case it would be better to
> + * use ring_buffer_discard_commit.
> + *
> + * Note, if an event that has not been committed is discarded
> + * with ring_buffer_event_discard, it must still be committed.
> + */
>  void ring_buffer_event_discard(struct ring_buffer_event *event);
>  
> ...
>
>  /**
> + * ring_buffer_event_discard - discard any event in the ring buffer
> + * @event: the event to discard
> + *
> + * Sometimes a event that is in the ring buffer needs to be ignored.
> + * This function lets the user discard an event in the ring buffer
> + * and then that event will not be read later.
> + *
> + * Note, it is up to the user to be careful with this, and protect
> + * against races. If the user discards an event that has been consumed
> + * it is possible that it could corrupt the ring buffer.
> + */
> +void ring_buffer_event_discard(struct ring_buffer_event *event)
> +{
> +	event->type = RINGBUF_TYPE_PADDING;
> +	/* time delta must be non zero */
> +	if (!event->time_delta)
> +		event->time_delta = 1;
> +}
> +EXPORT_SYMBOL_GPL(ring_buffer_event_discard);

Seems a bit cumbersome to document the interface partly in the .h file
and partly in the .c file?

Doing all of it in the .c file would be typical.
