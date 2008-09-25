Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYIYSwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYIYSwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYIYSwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:52:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57033 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYIYSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:52:38 -0400
Message-Id: <20080925185154.230259579@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 25 Sep 2008 14:51:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 0/2 v3] Unified trace buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ NOTE function comments have not been updated. Comments within the
 code has.]


This version I change the event header to what Peter Zijlstra requested.
The buffer alignment is now 4 from 8.  The minimum event is 8 bytes.
The event header is now:

struct event_header {
	u32	type:2, len:3, time_delta:27;
	u32	array[];
};

The length of the record is determined as:

  if (data size > 28 bytes)
	lenght = event->array[0] + sizeof(event_header);
  else
  	length = event->len << 4 + sizeof(event_header);

For data

  if (date size > 28 bytes)
	data = &event->array[0];
  else
  	data = &event->array[1];


There are now only 4 internal data types:

0 - Padding
1 - time extent
2 - time stamp
3 - data

This is for internal buffer management only. Other event types should be
pushed to a higher layer, and stored in the data field.

The timing is basically the same as v2 but I added a reader side
ring_buffer_normalize_time_stamp() operation. As a test, I mult the
timestamp to -1, in both set and normalize operations. Whether this
actually tests anything is another story ;-)


I actually like this header and structure the best. And this may be
what I start working on for real.

So please speak up on this one.

I'm going to take a break from this and start doing my real work.
This will let others soak it up for a bit.

-- Steve


