Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZDONpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZDONpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZDONp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:45:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41911 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZDONp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:45:26 -0400
Subject: Re: [PATCH] ring_buffer: enlarge RB_MAX_SMALL_DATA
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49E5A593.6090605@cn.fujitsu.com>
References: <49E2AAB3.9010801@cn.fujitsu.com>
	 <1239633781.21121.25.camel@localhost.localdomain>
	 <49E5A593.6090605@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 15 Apr 2009 09:45:01 -0400
Message-Id: <1239803101.21121.69.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-04-15 at 17:14 +0800, Lai Jiangshan wrote:

> 
> How about this method:
> 
> {u32 type_len:5, time_delta:27;};
> 
> time_delta is still 27bits, but RB_MAX_SMALL_DATA is increased to 112,
> it is larger than 60 in my patch.
> 
> type_len  actual type                actual len
> 0         RINGBUF_TYPE_DATA,         array[0]
> 1 ~ 28    RINGBUF_TYPE_DATA          4*1 ~ 4*28
> 29        RINGBUF_TYPE_TIME_STAMP    
> 30        RINGBUF_TYPE_TIME_EXTEND
> 31        RINGBUF_TYPE_PADDING       array[0] if it's not the last event
>                                      in the buffer_page(discarded event)
> If you like this method, I will implement it.

I like the idea a lot. The only issue I have with it is that these types
are used a lot in switch statements, and in fast paths.

But the compression may be a better win.

We could do this in the switches.

	switch (event->type_len) {
	case RINGBUF_TYPE_TIME_STAMP:
		/**/
		break;
	case RINGBUF_TYPE_TIME_EXTEND:
		/**/
		break;
	case RINGBUF_TYPE_PADDING:
		/**/
		break;
	default: /* RINGBUF_TYPE_DATA */

	}

But before any of this goes in. I would like to export the interface.
Yes it is suppose to be OK to be able to change the interface, but the
binary output made it into 30. I doubt this change will make it before
31. If that's the case. We must have the format listed. 30 is expected
to be used by many distros. There's already tools using ftrace. If we
make a change that can not be caught, then it will break many tools.

We could ask Linus to pull this into 30 because it is a API change.

-- Steve


