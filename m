Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXCMTBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXCMTBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932893AbXCMTBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:01:39 -0400
Received: from densedata.com ([217.160.171.7]:4664 "EHLO densedata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800AbXCMTBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:01:37 -0400
Message-ID: <45F6F590.8030909@densedata.com>
Date: Tue, 13 Mar 2007 20:03:44 +0100
From: Johann Borck <johann.borck@densedata.com>
Reply-To: Johann Borck <johann.borck@densedata.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, David Miller <davem@davemloft.net>,
       Ulrich Drepper <drepper@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev <netdev@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chase Venters <chase.venters@clientec.com>,
       Johann Borck <johann.borck@densedata.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Jamal Hadi Salim <hadi@cyberus.ca>,
       Ingo Molnar <mingo@elte.hu>, Johann Borck <johann.borck@densedata.com>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: considering kevent - the kernel development process
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

if the next section seems obvious, please skip it
-------------------------------------------------------------------------
There is a need for a generic event handling mechanism in Linux - maybe 
it is enough to cite the current CGL Performance Requirements Definition
Version 4.0 at
http://developer.osdl.org/dev/cgl/cgl40/cgl40-performance.pdf , page 13:

 PRF.5.0     Efficient Low-Level Asynchronous Events  Priority P1                
 Description: OSDL CGL specifies that carrier grade Linux shall provide 
 an efficient capability for handling a large number of essentially 
 simultaneous asynchronous events arriving on multiple channels, such as
 multiple sockets or other similar paths. This mechanism is needed to 
 enforce system scalability and soft real-time responsiveness by
 reducing contentions appearing at the kernel level, especially under 
 high load.

Ulrich Drepper has written a paper  The Need for Aynchronous, 
Zero­Copy Network I/O,
http://people.redhat.com/drepper/newni-slides.pdf

A bit older but nice wrt performance-issues is APPLYING THE PROACTOR PATTERN TO 
HIGH-PERFORMANCE WEB SERVERS
at http://www.cs.wustl.edu/~schmidt/PDF/proactor-jaws.pdf along with 
many other research papers on that site.

---------------------------------------------------------------------------

So the question is not to be or not to be (at least not for an async 
event mechanism) - Linux needs  it. There have been approaches to this, 
the both I'm aware of are:
kevent by Evgeniy Polyakov
AEM by Frederic Rossi at http://aem.sourceforge.net/ , several years ago.

The discussion about kevent has stalled since Ulrich Drepper left the 
thread in November without commenting on many changes
Evgeniy did to the interface and implementation in response to 
requirements formulated by Drepper. The only further statement was this:

>> Evgeniy Polyakov wrote:
>>> I think that mean that everybody is happy with APi, design and set of
>>> features

>On Mon, Feb 12, 2007 at 06:59:17AM -0800, Ulrich Drepper wrote:
>> No comment means that I still have not been able to test anything since
>> regardless of what version I tried, it failed to build.

Evgeniy Polyakov wrote:
>I think if you would provide error message you saw, I fixed that in a
>couple of moments, doesn't it?
>
>I will send new patchset next week when rc1 will be out and your
>feedback is greatly appreciated.

This is hard to believe - the person that the whole process was blocking 
on (in a sane linux-world, hopefully for competence-reasons) wasn't able 
to build a kernel with that patch? And I was? With almost any version, 
without problems?  very hard to believe.
Then a thread about threadlets/syslets and aio came up - the kernel 
developers discussed some kevent-related stuff, Evgeniy brought up his 
project again, and after some discussion about benchmarks and behavior, 
it was gone again.
Somehow Evgeniy backed up then - and wrote 'eventfs' to make signal 
notifications epollable mentioning that he'd add Posix Timer support if 
the concept will be accepted - which wasn't commented at all, but 
instead Davide Libenzi came up with two patches for exactly the same 
purpose, which raised a lot of feedback.

It can't be more obvious.. Is the consideration of patches (in case of kevent
major contributions)  completely independent of content and intent?
Although Evgeniy showed remarkable productivity and dedication to his 
project,  included support for stuff that was requested even though he 
had objections(posix timers), redesigned parts on request (mainly asked for by U. Drepper), implemented example programs, implemented many different event-types and drafted network-aio support, wrote patches for lighttpd and libevent to show usability in real-life apps, which he was asked to do (because people would then be able to make up their mind), nothing happened.  

After the implementation of most of Dreppers requests for change the 
thread remained almost silent - at a stage where one would think that 
the work on details could start.

On Mon, Feb 12, 2007 at 09:13:35AM -0800, Andrew Morton wrote:

>> > > On Mon, 12 Feb 2007 13:35:10 +0300 Evgeniy Polyakov wrote:
>> > > Andrew, do you consider kevent for inclusion or declining?
>>     
> > 
> > I haven't had time to think about it in the past month or two, sorry.
> > 
> > However we might as well get it back in there for review-and-test - please
> > send a new patchset once 2.6.21-rc1 is released and copy me on it?
>   

I don't want to attack anyone here, but there is a problem in the way 
(at least) kevent is considered. As stated an asynchronous event 
mechanism is a crucial thing, and would be a major contribution to the 
kernel. It is easy to come to the conclusion that the main 
kernel-developers just don't want to accept such a contribution by 
someone not already inside that hall of fame. Otherwise, there would be 
arguments, discussion, there would be reasons. The attempts to explain 
it with lack of time, lack of ability to test or whatever are weak. They 
suffer from the evidence, that related stuff is discussed all over - 
compare eventfs vs. signalfd/timerfd threads and look at syslets/threadlets
thread. Of course one could argue that people with less reputation are 
treated differently, because one estimates the relevance of their 
contributions lower. But the relevance of the gap that kevent 
might fill, and therefore kevent itself, is tremendous. It is 
priority 1 as stated in the CGL Performance Requirements Definition - but it is not discussed.

So my questions are:

What in general is wrong with kevent?

What, in detail is wrong with kevent / its proposed interface?

What features are missing?

What are the (real) reasons for the way it is discussed?

One argument that can be read often in this context is that no one would 
use it. That's nonsense, or why is it P1 as stated in the CGL 
Performance Requirements Definition? It would be definitely  used, yes 
it would change the way people write and think about writing software for Linux.

To me this looks quite scary - though the need is there, and the needed functionality is simulated by many frameworks (ACE/Proactor/TProactor, Twisted, Boost::asio, libevent etc.) the discussion stops - as if it wouldn't matter. But it does, and so there are things wrong with the development process, as wrong as contributions like kevent are important for Linux. All big organizations adhere to institutionalized procedures and become dull wrt change. Their departments tend to preserve their influence. Is the institution that is in charge of the final decisions here (the core kernel developers) open enough to deal with major contributions from "outside", to discuss their *value* based on need, relevance, maturity? Or has the control over the process and isolation from mere mortals become more important than the functionality of the kernel itself? 
Don't get me wrong, this is *not* about inclusion, this is about *discussion*!

Johann Borck



