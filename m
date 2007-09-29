Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbXI2JQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbXI2JQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXI2JQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:16:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:50720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXI2JQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:16:27 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Out of memory management in embedded systems
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Daniel =?ISO-8859-1?Q?Sp=E5ng?= <daniel.spang@gmail.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 29 Sep 2007 11:15:59 +0200
References: <98nC1-6aM-9@gated-at.bofh.it> <98nVg-6QQ-21@gated-at.bofh.it> <98oeB-7gA-9@gated-at.bofh.it> <98oHC-8ai-5@gated-at.bofh.it> <98oRk-8mt-21@gated-at.bofh.it> <98pNu-1pp-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IbYQZ-0000eu-Gp@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+F381q4YJinr/RChY5jFq3XEZjWTPWy2xIi3n
 6JuHNlLWUJjeYA05OA3fN/R5HEVuvnfBq6eRU5f7/T4odbT5ru
 t1OyWE1xcT3v3dxcpsh6Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> On Fri, 28 Sep 2007, [iso-8859-1] Daniel SpÂng wrote:
>> On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>> On Fri, 28 Sep 2007, [iso-8859-1] Daniel SpÂng wrote:
>>>> On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:

>>>>> But an embedded system contains all the software that will
>>>>> ever be executed on that system! If it is properly designed,
>>>>> it can never run out of memory because everything it will
>>>>> ever do is known at design time.
>>>>
>>>> Not if its input is not known beforehand. Take a browser in a mobile
>>>> phone as an example, it does not know at design time how big the web
>>>> pages are. On the other hand we want to use as much memory as
>>>> possible, for cache etc., a method that involves the kernel would
>>>> simplify this and avoids setting manual limits.

>>> Any networked appliance can (will) throw data away if there are
>>> no resources available.
>>>
>>> The length of a web-page is not relevent, nor is the length
>>> of any external data. Your example will buffer whatever it
>>> can and not read anything more from the external source until
>>> it has resources available unless it is broken.

And reload the web page whenever the suser scrolls up.

>> And how do you determine when no resources are availabe? We are using
>> overcommit here so malloc() will always return non null.

> A networked appliance using embedded software is not your daddy's
> Chevrolet. Any task that is permanent needs to allocate all its
> resources when it starts. That's how it knows how much there are,
> and incidentally, it doesn't do it blindly. The system designer
> must know how much memory is available in the system and how much
> is allocated to the kernel.

So if I design a mobile phone and want the user to be able to listen to
music and to browse the web and use the camera, I must

- allocate the web cache on start
- allocate the mp3 cache on start
- allocate the video/photo buffer on start
- leave enough RAM for other applications
- waste much of the memory most of the time
- reduce the capabilities of the camera in order to reduce used memory
  (e.g. reduce the video resolution to match the slow flash speed instead
   of allowing short high-res clips or reduce the number of pictures for
   automatic sequences)
- costly reload parts of web pages that could have been stored in 
  the currently unused RAM
- increase the realtime constraints of the mp3 player in order to
  conserve memory, making the music stutter while performing
  other operations.

instead of just telling the system "Hey' I'm the web browswer, I need
2 MB of RAM to work correctly, 4 MB to show a nice performance and
if you ask me nicely, I'll release memory", because nobody could possibly
want this feature?

IMO, even desktop systems would perform better having this feature.
Imagine no more GIMP images pushing out X's mouse driver ...

> The fact that you can give a fictitious value to malloc() is not
> relevant. If you don't provide resources for malloc(), like
> (ultimately) a swap file, then you can't assume that it can do
> any design work for you.
> 
> An embedded system is NOT an ordinary system that happens to
> boot from flash. An embedded system requires intelligent design.

Yeah, you should know all apllications your users will put on their phones!

Maybe you can do this for industry embedded single-task systems, but
multi-purpose systems will benefit from 

> It is important to understand how a virtual memory system
> operates. The basics are that the kernel only "knows" that
> a new page needs to be allocated when it encounters a trap
> called a "page fault." If you don't have any memory resources
> to free up (read no swap file to write a seldom-used task's
> working set), then you are screwed --pure and simple. So,
> if you don't provide any resources to actually use virtual
> memory, then you need to make certain that virtual memory
> and physical memory are, for all practical purposes, the same.

The system should notify the applications before reaching that point,
e.g. when the cache is reduced below a theresold.

> With embedded servers, it's usually very easy to limit the
> number of connections allowed, therefore the amount of
> dynamic resources that must be provided.

And it's easy to limit the size and number of images on web pages
that need to be cached.

> With clients
> it should be equally easy, but generic software won't
> work because,

... it will ignore the signal.

> for instance, Mozilla doesn't keep track
> of the number of "windows" you have up and the number
> of connections you have.

about:config network.http.max-connections

> HOWEVER, remember that malloc()
> is a library call. You can substitute your own using
> LD_PRELOAD, they keeps track of everything if you must
> use generic software.

Knowing one's memory usage - possibly not counting stack, code and data,
is only half of the trick. You need to know the current memory pressure,
too.


Imagine mozilla asks if it may use the whole lotta 4 GB RAM for it's memory
cache, and it may. The user is stupid enough to download an 2,3 GB ISO, save
it, burn it, deletes the file, finds out the disc was damaged and reloads
it - not from the net, but from the RAM cache. User is happy.

Now the user starts a game, the game would need 2 GB of RAM, and either
mozilla or the game is killed. User is unhappy. But if the system does
not kill one of them, but nicely asks mozilla to free 2 GB of RAM, the
user will not be able to reload the ISO from RAM, but being able to still
use the browser while pausing the game, he won't care.


I'm not arguing on how this should be implemented, but if and why it should
be implemented. Maybe it's as simple as having a signal each second if the
cache is below x MB, maybe you'll want a memory manager helper application
in userspace. Maybe you want both options ... or something completely
different. But without kernel support, it won't work as well as it could.
-- 
Funny quotes:
39. Ever wonder about those people who spend $2.00 apiece on those little
    bottles of Evian water? Try spelling Evian backwards: NAIVE
Friﬂ, Spammer: sw@ouZI.7eggert.dyndns.org LajGqWfh@pp.7eggert.dyndns.org
