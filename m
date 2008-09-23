Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYIWAHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYIWAHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 20:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYIWAHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 20:07:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbYIWAHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 20:07:31 -0400
Message-ID: <48D832B6.3010409@redhat.com>
Date: Mon, 22 Sep 2008 20:05:10 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>	 <48D7F5E8.3000705@redhat.com>	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>	 <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
In-Reply-To: <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Martin Bligh wrote:
>>> One thing that I think is still important is to have a unified timestamp
>>> mechanism on everything, so we can co-ordinate different things back
>>> together in userspace from different trace tools, so I intend to keep
>>> that at a lower level, but I think you're right that the event id, etc can
>>> move up into separate layers.
>> I'm not so sure that the unified 'timestamp' must be required by all tracers.
>> If you just need to merge and sort per-cpu data, you can use an atomic
>> sequential number for it.
>> IMHO, the unified 'timestamp' would better be an option, because some
>> architectures can't support it. I think preparing timestamp-callback
>> function will help us.
> 
> An atomic sequential number is:
> 
> (a) far less meaningful than a timestamp for the user
> (b) more expensive to compute in many cases.

Sure, atomic counter might be more expensive but accurate for ordering.
(and it can use on almost all architectures)
The cost depends on the architecture and system configuration.

So, I think it is preferable user to choose their timestamp rather
than fix it. For example, calling callback when writing a log entry
as following;

write_log(struct buffer *buffer, char *data, int len)
{
    /* reserve a logging space */
    char *buf = reserve(buffer, len + buffer->timestamp.len);

    /* write a timestamp */
    buf = buffer->timestamp.write(buf);

    /* write a body */
    memcpy(buf, data, len);
}

And unified buffer prepares default timestamp.write callbacks.

char * timestamp_write(char * buf); // write arch-specific timestamp
char * seqnum_write(char * buf); // write an sequence number

What would you think about it?

> I think we came up with a way to approximate this, using a callback every
> ms or so as the higher order bits, and a sequential counter in the lower
> order for those broken platforms.

Sure, that will work.

> But perhaps it would be better if we started with a discussion of which
> platforms can't do global timestamps, and why not? I know some of them
> are fixable, but perhaps not all.

For example, my laptop (this machine/Core2Duo) doesn't return correct TSC. :-(

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

