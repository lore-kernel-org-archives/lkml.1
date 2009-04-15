Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZDOOMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZDOOMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbZDOOMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:12:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52442 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbZDOOMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:12:34 -0400
Date: Wed, 15 Apr 2009 16:12:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: enlarge RB_MAX_SMALL_DATA
Message-ID: <20090415141221.GE12760@elte.hu>
References: <49E2AAB3.9010801@cn.fujitsu.com> <1239633781.21121.25.camel@localhost.localdomain> <49E5A593.6090605@cn.fujitsu.com> <1239803101.21121.69.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239803101.21121.69.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <srostedt@redhat.com> wrote:

> 
> On Wed, 2009-04-15 at 17:14 +0800, Lai Jiangshan wrote:
> 
> > 
> > How about this method:
> > 
> > {u32 type_len:5, time_delta:27;};
> > 
> > time_delta is still 27bits, but RB_MAX_SMALL_DATA is increased to 112,
> > it is larger than 60 in my patch.
> > 
> > type_len  actual type                actual len
> > 0         RINGBUF_TYPE_DATA,         array[0]
> > 1 ~ 28    RINGBUF_TYPE_DATA          4*1 ~ 4*28
> > 29        RINGBUF_TYPE_TIME_STAMP    
> > 30        RINGBUF_TYPE_TIME_EXTEND
> > 31        RINGBUF_TYPE_PADDING       array[0] if it's not the last event
> >                                      in the buffer_page(discarded event)
> > If you like this method, I will implement it.
> 
> I like the idea a lot. The only issue I have with it is that these types
> are used a lot in switch statements, and in fast paths.
> 
> But the compression may be a better win.
> 
> We could do this in the switches.
> 
> 	switch (event->type_len) {
> 	case RINGBUF_TYPE_TIME_STAMP:
> 		/**/
> 		break;
> 	case RINGBUF_TYPE_TIME_EXTEND:
> 		/**/
> 		break;
> 	case RINGBUF_TYPE_PADDING:
> 		/**/
> 		break;
> 	default: /* RINGBUF_TYPE_DATA */
> 
> 	}
> 
> But before any of this goes in. I would like to export the 
> interface. Yes it is suppose to be OK to be able to change the 
> interface, but the binary output made it into 30. I doubt this 
> change will make it before 31. If that's the case. We must have 
> the format listed. 30 is expected to be used by many distros. 
> There's already tools using ftrace. If we make a change that can 
> not be caught, then it will break many tools.

Yeah - format specifications are always good. They weaken ABI 
bindings and allow more flexibility both on the tool and the kernel 
side.

> We could ask Linus to pull this into 30 because it is a API 
> change.

Apps could assume if the format file is not there it's the .30 
format.

	Ingo
