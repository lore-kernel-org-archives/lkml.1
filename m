Return-Path: <linux-kernel-owner+w=401wt.eu-S968673AbYD1XNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968673AbYD1XNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968024AbYD1XHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:07:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968229AbYD1XHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:07:19 -0400
Message-ID: <48165866.5060403@zytor.com>
Date: Mon, 28 Apr 2008 16:06:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu>
In-Reply-To: <20080428224438.GA6974@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> What I'm proposing is:
>>
>>>   [ .... fastpath head ......     ]
>>>   [ ....   5-byte CALL .......... ]  ---> NOP-ed out
>>>   [ .... fastpath tail .......... ]
>>>   [ ............................. ]
>> The call site is created with an asm() statement as opposed to a gcc 
>> function call; it is up to the logging function to take the state and 
>> mangle it into whatever format it wants to; the debugging information 
>> (e.g. DWARF) should tell it all it needs to know about how the 
>> register/memory state maps onto the C state.  This mapping can either 
>> be done online, with a small piece of dynamic code, or offline 
>> (although offline makes it tricky to know what memory tems to gather.)
> 
> that would be rather impractical as we'd force DEBUG_INFO builds on 
> anyone (it's HUGE) just to do some trivial tracing. Look at the ftrace 
> plugin usage model - it wants to be widely available and easy to use.
> 

Otherwise you're forcing everyone to take the cost of additional cache 
footprint, plus optimizer interference, just because they might want to 
possibly do some trivial tracing.  DEBUG_INFO is The Right Thing for 
this, as it carries all the information you may want in a well-defined 
format.  You don't necessarily have to keep all this information around, 
of course; you can distill out the information for the trace sites at 
compile time and keep a tracer information file, after which you can 
strip the information.

There is actually yet another alternative, though, which is to build the 
tracer at compile time.  The tricky part of this is that it almost 
requires inserting a preprocessor before the assembler, and use really 
ugly asm() macros to extract the very information that the debug format 
is designed explicitly to extract!

Personally, I think requiring DEBUG_INFO is a helluva lot less ugly than 
these branch hacks.

	-hpa
