Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXH2XCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXH2XCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbXH2XCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:02:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbXH2XCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:02:01 -0400
Message-ID: <46D5FAE5.3020401@redhat.com>
Date: Wed, 29 Aug 2007 18:01:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
References: <46D5F462.9010401@redhat.com> <9a8748490708291553j4c21bdf0ueae0b51c99c8190a@mail.gmail.com>
In-Reply-To: <9a8748490708291553j4c21bdf0ueae0b51c99c8190a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:

>> Any suggestions for ways around this?  The warning is somewhat helpful,
>> and I guess the obvious option is to lighten up the dump_stack path, but
>> it's still effectively reducing precious available stack space by some
>> amount.
>>
> A first step could be to allocate those two char arrays with kmalloc()
> instead of on the stack, but then I guess that dump_stack() gets
> called from places where we may not really want to be calling
> kmalloc(). I guess we could allocate the buffers earlier (like at boot
> time) and store pointers somewhere where dump stack can get to them
> later when it needs them.

Yep, I thought about something like that... and I assume you'd need a
bit of locking around them too.

>> With CONFIG_DEBUG_STACK_USAGE, we could print at oops time: "oh, and by
>> the way, you blew your stack" if there is no zeroed stack space left, as
>> a post-mortem.  Even without that option, I think we could still check
>> whether the *current* %esp at oops time has gone too far?  But if we
>> blew the stack, returned, and *then* oops, I think it'd be hard to know
>> without the DEBUG_STACK_USAGE option that we ran out of room.
>>
> 
> We could also simply have it warn at a higher limit, like 1024 bytes
> instead of 512. But I guess then we would get too many false positives
> and make it less useful.

Yes, but if you happen to warn deeper anyway, just because you got
"lucky" with IRQ timing, you'll still explode.  Regardless of where the
threshold is, there's still a risk of starting the warning deeper than
that.  Whatever stack the warning takes effectively reduces the useable
stack size.

-Eric
