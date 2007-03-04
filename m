Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXCDVRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXCDVRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 16:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXCDVRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 16:17:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34631 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXCDVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 16:17:41 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 Mar 2007 13:17:28 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kirk Kuchov <kirk.kuchov@gmail.com>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com>
References: <20070301131118.GA30228@elte.hu> <20070301141637.GA20006@elte.hu>
  <20070301145454.GB12684@2ka.mipt.ru>  <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
  <20070302081047.GA27122@2ka.mipt.ru>  <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
  <20070303100625.GA22557@2ka.mipt.ru>  <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
  <20070303203140.GA756@2ka.mipt.ru>  <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
 <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2007, Kirk Kuchov wrote:

> On 3/3/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > <snip>
> > 
> > Those *other* (tons?!?) interfaces can be created *when* the need comes
> > (see Linus signalfd [1] example to show how urgent that was). *When*
> > the need comes, they will work with existing POSIX interfaces, without
> > requiring your own just-another event interface. Those other interfaces
> > could also be more easily adopted by other Unix cousins, because of
> > the fact that they rely on existing POSIX interfaces.
> 
> Please stop with this crap, this chicken or the egg argument of yours is utter
> BULLSHIT!

Wow, wow, fella! You _deinitely_ cannot afford rudeness here.
You started bad, and you end even worse. By listing a some APIs that will 
work only with epoll. As I said already, and as it was listed in the 
thread I posted the link, something like:

int signalfd(...);  // Linus initial interface would be perfectly fine
int timerfd(...);   // Open ...
int eventfd(...);   // [1]

Will work *even* with standard POSIX select/poll. 95% or more of the 
software does not have scalability issues, and select/poll are more 
portable and easy to use for simple stuff. On top of that, as I already 
said, they are *confined* interfaces that could be more easily adopted by 
other Unixes (if they are 100-200 lines on Linux, don't expect them to be 
a lot more on other Unixes) [2]. We *already* have the infrastructure 
inside Linux to deliver events (f_op->poll subsystem), how about we use 
that instead of just-another way? [3]
As for why common abstractions like file are a good thing, think about why 
having "/dev/null" is cleaner that having a special plug DEVNULL_FD fd 
value to be plugged everywhere, or why I can use find/grep/cat/echo/... to 
look/edit at my configuration inside /proc, instead of using a frigging 
registry editor. But here the list could be almost endless.
And please don't start the, they don't scale or they need heavy file 
binding tossfeast. They scale as well as the interface that will receive 
them (poll, select, epoll). Heavy file binding what? 100 or so bytes for 
the struct file? How many signal/timer fd are you gonna have? Like 100K? 
Really moot argument when opposed to the benefit of being compatible with 
existing POSIX interfaces and being more Unix friendly.
As for the AIO stuff, if threadlets/syslets will prove effective, you can 
host an epoll_wait over a syslet/threadlet. Or, if the 3 lines of 
userspace code needed to do that, fall inside your definition of "kludge", 
we can even find a way to bridge the two.
Now, how about we focus on the topic of this thread?




[1] This could be an idea. People already uses pipes for this, but pipes 
    has some memory overhead inside the kernel (plus use two fds) that 
    could, if really felt necessary, be avoided.

[2] This is how those kind of interfaces should be designed. Modular,
    re-usable, file-based interfaces, whose acceptance is not linked into 
    slurping-in a whole new interface with tenths of sub, interface-only, 
    objects. And from this POV, epoll is the friendlier.

[3] Notice the similarity between threadlets/syslets and epoll? They 
    enable pretty darn good scalability, with *existing* infrastructure, 
    and w/out special ad-hoc code to be plugged everywhere. This translate 
    directly in easier to maintain code.



- Davide


