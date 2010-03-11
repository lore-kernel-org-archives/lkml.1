Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0CKUfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:35:24 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:45795 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab0CKUfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:35:22 -0500
X-Greylist: delayed 2213 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 15:35:22 EST
Message-ID: <4B994B5A.4020708@polymtl.ca>
Date: Thu, 11 Mar 2010 14:58:18 -0500
From: Michel Dagenais <michel.dagenais@polymtl.ca>
Organization: Ecole Polytechnique Montreal
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tasneem Brutch - SISA <t.brutch@sisa.samsung.com>
CC: rostedt@goodmis.org, "Spear, Aaron" <aaron_spear@mentor.com>,
       dsdp-tcf-dev@eclipse.org, ltt-dev@lists.casi.polymtl.ca,
       Linux Tools developer discussions 
	<linuxtools-dev@eclipse.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [linuxtools-dev] Standard	protocols/interfaces/formats
 forperformance tools (TCF, LTTng, ...)
References: <D86DB60C62D82A4792CAEC7F58CA04E706C13BB6@NA1-MAIL.mgc.mentorg.com>	<20100224154021.GA9692@Krystal>	<D86DB60C62D82A4792CAEC7F58CA04E706C13E65@NA1-MAIL.mgc.mentorg.com>	<1267072349.24271.8209.camel@gandalf.stny.rr.com> <D75C33A4DAF4F347A09A09B97BF978B00D783231@SMAIL.sisa.samsung.com>
In-Reply-To: <D75C33A4DAF4F347A09A09B97BF978B00D783231@SMAIL.sisa.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (saorge.dgi.polymtl.ca [132.207.169.35]) at Thu, 11 Mar 2010 19:58:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I proposed, and currently chair the newly formed Multicore Association,
> Tool Infrastructure work group (TIWG).  The work group welcomes
> opportunities to better understand other efforts, that TIWG can
> leverage, and learn from.  I will be at the Multicore Expo, where I am
> presenting, and I also plan on attending the EclipseCon.  

Great! it may be a good idea to start accumulating pointers, identified 
shortcomings, ideas... in preparation for this and LinuxCon.

>>>> Along those lines, we (Mentor) have a need for a protocol 
>>> to connect to remote trace collectors and configure trace 
>>> triggering/collection, and then efficiently download lots of binary trace data.  
>>> Sound familiar?
...
>>>> Mentor has a file format we use that was 
>>> inspired by LTTng's format but is optimized for extremely large real-time trace 
>>>> logs.  I intend to throw this into the mix.
...
>>> It would be good to ask if the Ftrace team is interested to 
>>> participate in this standardization effort. Proposing 
>>> modifications to the Ftrace file format is on my roadmap.

This is indeed the problem I currently see with Ftrace, suitability for 
huge live/realtime traces. For this you need an extremely compact format 
and a good way to pass and update metadata along with the trace. 
Otherwise, Ftrace and Perf offer a large number of exciting features.

In LTTng, following some feedback from Google among others, quite a bit 
of information is implicit: per cpu files and scheduling events obviate 
the need for pid and cpu id; event ids implicitly tells the event size 
and format... Similarly, event ids are scoped by channel using little 
space, and timestamps do not store all the most significant bits. Since 
new modules may be loaded at any time with new event types, the dynamic 
allocation of event ids and update of associated metadata is something 
which must be handled properly.

Other approaches are possible to achieve the same result. Aaron Spear 
mentioned "contexts" to qualify node/cpu/pid, I am eager to learn more 
about that... You could have "define context" events, where a context id 
would be associated with a number of attributes (CPU, pid, event 
name...) and could be reused at any time simply by issuing another 
"define context" event with the same id but different attributes. The 
important part is that each event should use little more than its 
specific payload (typical event has a payload of 4 bytes and occupies a 
total of 8 to 12 bytes on LTTng). Ftrace currently has a large number of 
common fields and was thus not optimised for this; this rapidly turns a 
10GB trace into a 30GB one.

The second important missing feature is dynamic updates of the metadata 
as new event types are added when modules are loaded. In LTTng, metadata 
is received as events of a predefined type in a dedicated channel. I am 
sure that something similar could be possible for Ftrace.

>> We believe that the future will be heavily multi-core, and it is
>> a difficult problem to solve figuring out graceful ways to partition a
>> complex "application" across these cores effectively.  E.g. a system
>> with SMP Linux on a couple of cores, a low level RTOS on another core,
>> and then some DSP's as well.  Today you often use totally different
>> tools for all of those cores.  How do you understand what the heck is
>> happening in this system, never mind figuring out how to optimize the
>> system as a whole...   I think a good first step is some level of
>> interoperability in data formats so that event data collected from
>> different sources and technologies (e.g. LTTng for Linux and real-time
>> trace for the DSP's) can be correlated and analyzed side by side. 

We have some neat and fairly sophisticated tools in LTTV now to 
correlate traces taken on distributed systems with non synchronized 
clocks simply by looking at messages exchanges.
