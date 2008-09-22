Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYIVW20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYIVW20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYIVW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:28:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbYIVW17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:27:59 -0400
Message-ID: <48D81B5F.2030702@redhat.com>
Date: Mon, 22 Sep 2008 18:25:35 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>	 <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
In-Reply-To: <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Martin Bligh wrote:
>> I agree to integrate tracing buffer mechanism, but I don't think
>> your proposal is the simplest one.
>>
>> To simplify, I think the layered buffering mechanism is desirable.
>> - The lowest layer just provides named circular buffers(both per-cpu and
>>  uni-buffer in system) and read/write scheme.
>> - Next layer provides user/kernel interface including controls.
>> - Top layer defines packet(and event) formatting utilities.
>> - Additionally, it would better provide some library routines(timestamp,
>>  event-id synchronize, and so on).
>>
>> Since this unified buffer is used from different kind of tracers/loggers,
>> I don't think all of them(and future tracers) want to be tied down by
>> "event-id"+"parameter" format.
>> So, Sorry, I disagree about that the tracing buffer defines its *data format*,
>> it's just overkill for me.
> 
> I think you're right that we can layer this, and we didn't make a particularly
> good job of splitting those things out. I'll try to pull together
> another revision
> to reflect this and other suggested changes.

I'm happy to hear that. :-)

> One thing that I think is still important is to have a unified timestamp
> mechanism on everything, so we can co-ordinate different things back
> together in userspace from different trace tools, so I intend to keep
> that at a lower level, but I think you're right that the event id, etc can
> move up into separate layers.

I'm not so sure that the unified 'timestamp' must be required by all tracers.
If you just need to merge and sort per-cpu data, you can use an atomic
sequential number for it.
IMHO, the unified 'timestamp' would better be an option, because some
architectures can't support it. I think preparing timestamp-callback
function will help us.

By the way, systemtap uses two modes;

- single-channel mode
 In this mode, all cpus share one buffer channel to write and read.
 each writer locks spinlock and write a probe-local data to buffer.

- per-cpu buffer mode
 In this mode, we use an atomic sequential number for ordering data. If
 user doesn't need it(because they have their own timestamps), they can
 choose not to use that seq-number.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

