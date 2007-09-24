Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbXIXJZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbXIXJZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 05:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXIXJZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 05:25:16 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:55182 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXIXJZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 05:25:14 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
       Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 24 Sep 2007 11:22:22 +0200
Message-Id: <1190625742.12666.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Sat, 2007-09-22 at 21:27 +0200, Vegard Nossum wrote:
> After recent discussions on LKML and a general dissatisfaction at the
> current printk() kernel-message logging interface, I've decided to
> write down some of the ideas for a better system.

Good luck :-)

[snip]

> Example: {
> 	struct kprint_buffer buf;
> 
> 	kprint_buffer_init(&buf, KPRINT_DEBUG);
> 	kprint_buffer(&buf, "Stack trace:");
> 
> 	while(unwind_stack()) {
> 		kprint_buffer(&buf, "%p %s", address, symbol);
> 	}
> 
> 	kprint_buffer_flush(&buf);
> }
> 

Together with the idea of not allowing multiple lines in the kprint_xxx
functions, that would go with our approach having message numbers to
identify a message. Multiple lines are combined explicitly to one
message. I think it is a good idea to be able to identify, which lines
of a message belong together.

[snip]

> With such a modular interface, message attributes (for example the
> current time) and arguments can be recorded separately from the actual
> format string, instead of written formatted to a ring buffer as a
> sequence of characters. Parameters would be formatted to their own
> strings (regardless of the original type) and saved in an array.
> 
> Example: {
> 	struct kprint_message {
> 		const char *format;
> 
> 		unsigned int argc;
> 		char **argv;
> 
> 	#ifdef KPRINT_TIMESTAMP
> 		unsigned long long timestamp;
> 	#endif
> 
> 	#ifndef KPRINT_LOCATION
> 		const char *file;
> 		unsigned int line;
> 
> 		const char *function;
> 	#endif
> 	};
> }

[snip]

> The message entry and a message's arguments are kept separately. Most
> likely, there will be a huge number of tiny allocations. I am not sure
> how well this is handled in the kernel. Or we could try to merge the
> allocation of the struct kprint_message and its arguments into a
> single allocation by looking at the arguments before they're
> formatted. After all, the arguments cannot exist without the message
> or vice versa. Alternatively, a statically-sized ring buffer of struct
> kprint_message objects could be used, and then only arguments would
> need to be allocated dynamically. Either way, I think it should be
> possible to come up with a fairly memory-efficient system even for
> this method of storing the kernel log.

Would be nice to have some code here. How do you want to implement that?
You have to allocate / preallocate memory for the argv array. Something
like:

kprint_err(const char* fmt, ...)
{
	va_list   ap;
	struct kprint_message *msg;

	msg = &message_arry[current];
	
	va_start(ap, fmt);
	msg->argv = kmalloc(sizeof(long) * argc, GFP_KERNEL);
	...
	for (i = 0; i < argc, i++) {
		msg->argv[i] = va_arg(ap, long);
	}

If you do it like that, you can't support "%s", since then you would
store only the pointer and not the whole string. I think, that we can't
live without %s.

Michael

