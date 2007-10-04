Return-Path: <linux-kernel-owner+w=401wt.eu-S1761216AbXJDSW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216AbXJDSW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbXJDSWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:22:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:57519 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756530AbXJDSWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:22:47 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18rwCsW4+Qr2Kv2lhIyc1IlDGyV07I++dIXTICy+s
	cKPOJCHT11+XO6
Message-ID: <47052EC9.1080604@gmx.net>
Date: Thu, 04 Oct 2007 20:19:53 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Matti Aarnio <matti.aarnio@zmailer.org>
CC: Davide Libenzi <davidel@xmailserver.org>, rdunlap@xenotime.net,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       geoff@gclare.org.uk, tglx@linutronix.de, david@hardeman.nu,
       Ulrich Drepper <drepper@redhat.com>, subrata@linux.vnet.ibm.com,
       corbet@lwn.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Man page for revised timerfd API
References: <46FA0657.20700@gmx.net> <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com> <20070927103531.184550@gmx.net> <Pine.LNX.4.64.0709270944300.763@alien.or.mcafeemobile.com> <47033BA1.7070901@gmx.net> <20071003081453.GS6372@mea-ext.zmailer.org>
In-Reply-To: <20071003081453.GS6372@mea-ext.zmailer.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matti,

Matti Aarnio wrote:
> On Wed, Oct 03, 2007 at 08:50:09AM +0200, Michael Kerrisk wrote:
>> Davide Libenzi wrote:
>>> On Thu, 27 Sep 2007, Michael Kerrisk wrote:
>>>
>>>> Davide,
>>>>
>>>> A further question: what is the expected behavior in the
>>>> following scenario:
>>>>
>>>> 1. Create a timerfd and arm it.
>>>> 2. Wait until M timer expirations have occurred
>>>> 3. Modify the settings of the timer
>>>> 4. Wait for N further timer expirations have occurred
>>>> 5. read() from the timerfd
>>>>
>>>> Does the buffer returned by the read() contain the value
>>>> N or (M+N)?  In other words, should modifying the timer
>>>> settings reset the expiration count to zero?
>>> Every timerfd_settime() zeroes the tick counter. So in your scenario it'll 
>>> return N.
>> Thanks Davide.
>>
>> I modified the first para of the read description to make this clear:
>>
>>        read(2)
>>               If the timer has already expired one or more times
>>               since   its  settings  were  last  modified  using
>>               timerfd_settime(), or since  the  last  successful
>>               read(2),  then the buffer given to read(2) returns
>>               an unsigned 8-byte integer  (uint64_t)  containing
>>               the number of expirations that have occurred.
> 
> When returning multi-byte long numeric values via read(2) as byte streams,
> my default question is:
> 
>    Can you explicitely state what is the byte order ?
> 
> It _probably_ is the host-byte-order as kernel- and userspaces can hardly
> run with different ones and this does not sound like an API to be used
> over the network, but nevertheless...

As you correctly surmise, the uint64_t returned by read() is in host byte
order.  But I almost wonder if adding this detail would create confusion,
with some readers less familiar with network programming asking: "what's
host byte order?".  (It never occurred to me that it could be anything
else, until I saw your note.)   Anyway to eliminate possible confusion, I
added this sentence to the eventfd.2 and timerfd_create.2 pages:

    (The returned value is in host byte order, i.e., the native
    byte order for integers on the host machine.)


> In the code-example:
> 
>     for (tot_exp = 0; tot_exp < max_exp;) {
>         s = read(fd, &exp, sizeof(uint64_t));
>         if (s != sizeof(uint64_t))
>             die("read");
>         tot_exp += exp;
>         print_elapsed_time();
>         printf("read: %llu; total=%d\\n", exp, tot_exp);
>     }
> 
> If I may suggest some alterations:
> 
>     for (tot_exp = 0; tot_exp < max_exp;) {
>         s = read(fd, &exp, sizeof(exp));
>         if (s < 0) {
>             /* add: EINTR etc. processing */
>             continue;
>         }
>         if (s != sizeof(exp))
>             die("read");
>         tot_exp += exp;
>         print_elapsed_time();
>         printf("read: %lu; total=%d\\n", (unsigned long) exp, tot_exp);
>     }
> 
> The "die if surprised" -strategy is not nice.
> Somebody will take example out of that code.
> 
> Indeed defining all possible error modes may be impossible, but it may
> be possible to define those errors that result in so severe dysfunction
> that closing and re-creating the timer-handle may be your only choice.
> (About the impossibility:  Solaris STREAMS based network accept() does/did
>  yield all kinds of odd errors out from the STREAMS stack in addition to
>  those listed in the syscall man-page.  Reacting on all unknown errors
>  by dying is not really a smart thing on a program.)

I agree that it's not a smart thing to do in a real-world program.  I'm
just not sure whether each man page example is the right place to teach
those skills.  The problem is that decent error handling can require quite
a bit of code, and the details of error handling can drown out the concepts
being demonstrated by the example code.  So, I'm inclined not to do this.
(I have to draw the line somewhere -- to some extent arbitrarily -- and my
line is this: example programs should always at least check every system to
see whether an error occurred (a surprising number of real-world programs
do not even do that); I leave it to the reader to actually master enough
programming skills to realize that a program should behave robustly in the
face of errors.)

But, if you are prepared to make a good case for specific that should  be
handled, send ti to me with a patch.

Cheers,

Michael


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

