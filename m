Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYCNLFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYCNLFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYCNLFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:05:25 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:35402 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYCNLFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:05:24 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 07:05:23 EDT
Message-ID: <47DA5B36.9060209@mail.aitel.hist.no>
Date: Fri, 14 Mar 2008 12:02:14 +0100
From: Helge Hafting <helgehaf@mail.aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>,
       Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
       linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
       Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
Subject: Re: Swap makes X unfair (was Re: Keys get stuck)
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net> <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net> <20080313120238.GA3860@localhost.ift.unesp.br> <47D937A2.9070305@aitel.hist.no> <20080313151354.GA5252@localhost.ift.unesp.br>
In-Reply-To: <20080313151354.GA5252@localhost.ift.unesp.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos R. Mafra wrote:
> On Thu 13.Mar'08 at 15:18:10 +0100, Helge Hafting wrote:
>   
>> Carlos R. Mafra wrote:
>>     
>>> On Thu 13.Mar'08 at 12:28:13 +0100, Mike Galbraith wrote:
>>>   
>>>       
>>>> [...]
>>>> Swap can definitely keep X off the cpu for extended periods,
>>>> [...]
>>>>     
>>>>         
>>> So I would like to ask if swap letting X (and everything else
>>> in my experience) out of the cpu for extended periods is
>>> considered normal behaviour, in the sense that nobody is
>>> trying to "fix" it (due to it being considered impossible
>>> to fix)...?
>>>   
>>>       
>> Yes, this is perfectly normal. A heavily swapping machine
>> will swap out parts of X.
>>     
>
> Right, but making the mistake of not being very precise
> I would not say my desktop was "heavily swapping". 
>
>   
>> Now, if X has a need for low-latency for keyboard handling,
>> then the X developers can use mlock to lock
>> the X keyboard service in memory, and make it a real-time
>> (or at least high priority) process too.  This should
>> avoid the problem even with extreme swapping and/or
>> high cpu load.
>>     
>
> That would be a great thing for me. But why one wouldn't
> want this behaviour to be default for a desktop? I mean
> it should be like that already for a desktop experience.
>   
Normally, memory that is used all the time does not get
swapped out. If you use X while the machine is swapping,
you will normally see lots of little delays, not
one longe freeze.  So this may have been something else.

This scenario seems to require only moderate swap. There
may be another explanation, that require more X knowledge
than I have:

Some windowing systems give apps the opportunity of
blocking the entire windowing system while doing stuff.
This is usually only used for "system modal dialogs" and
for very quick operations that need to stop all other user interaction.

I don't know to what extent this is possible in X, but if
it is, then the door is open for badly written apps to
to stupid things like load a 380M file while the user interface
is blocked. A well-designed app should do such lengthy jobs
without blocking everything else, so the user can do other stuff
while the machine works.  Note that any io-operation _might_ be
lengthy - even a 50-byte file could reside on a network file
system on a server located in a different continent.

You may want to write to xjed developers, perhaps they
can do something about this. Like loading the
file in the background, perhaps.
[...]
> But it appears that it is something related to the
> scheduling of what to read/write from/to swap and when.
>
> Of course that's just what I think, and I would like
> to learn more from knowleadgeble lkml people. Maybe
> in trying to explain things to me, some hacker may
> find that something could be made better, or point
> me to some /sys tunnable which makes my experience
> better.
>   
The interesting question is whether this is a swapping problem that can 
be solved
by kernel fixing, or if it merely is a problem with the design of the X 
server.
In the latter case you need to contact x.org developers instead. xjed 
developers
can probably work around the problem too, although that would to be 
unnecessary
if both the kernel and the x server were ideal.

A test you can do:
* Start up X as usual and log in
* Switch to the console (ctrl+alt+F2)
* Log in on the console, with the same user as you have in the X session.
* Give the command "export DISPLAY=:0"  (without the quotes)
*  Start xjed with the big file, from the console. You won't see it there,
   it will show itself in the X session instead. Make sure you start it 
in the
   background, i.e.:   "xjed bigfile & "

The machine should now start using the disk, loading the big file and 
swap as usual.
Now try doing stuff in the console shell. Try various commands like
ls, view some text files in "vim", things like that.

Now, if your console session is just as blocked and sluggish as the X 
session usually
gets - then it is a kernel/swapping problem.

If console usage is fine (or perhaps jerky uneven response but no 
prolonged freeze)
then the kernel is ok and your problem is in the X server.

You can switch back to X after the test, usually something like ALT+F7.

Helge Hafting
