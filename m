Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYGVBLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYGVBLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 21:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGVBLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 21:11:37 -0400
Received: from usmail2.us.checkpoint.com ([216.200.240.146]:45730 "EHLO
	us.checkpoint.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbYGVBLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 21:11:36 -0400
Message-ID: <488532E6.7050308@la.checkpoint.com>
Date: Mon, 21 Jul 2008 22:07:50 -0300
From: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@la.checkpoint.com>
Reply-To: rbranco@la.checkpoint.com
Organization: Check Point
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       greg@kroah.com, "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, "'Willy Tarreau'" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "'Alan Cox'" <alan@redhat.com>,
       caglar@pardus.org.tr, casey@schaufler-ca.com, spender@grsecurity.net,
       pageexec@freemail.hu, rodrigo@kernelhacking.com
Subject: Re: [stable] Linux 2.6.25.10 (resume)
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de> <200807021809.07679.caglar@pardus.org.tr> <005001c8e6f8$ac0955f0$a6181fac@ad.checkpoint.com> <20080716044905.GA9033@suse.de> <4880A3B1.3050103@la.checkpoint.com> <20080719221343.GA5578@suse.de> <20080720172847.GX28946@ZenIV.linux.org.uk>
In-Reply-To: <20080720172847.GX28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro escreveu:
> On Sat, Jul 19, 2008 at 03:13:43PM -0700, Greg KH wrote:
>
>   
>> I disagree with this and feel that our current policy of fixing bugs and
>> releasing full code is pretty much the same thing as we are doing today,
>> although I can understand the confusion.  How about this rewording of
>> the sentance instead:
>>
>> 	We prefer to fix and provide an update for the bug as soon as
>> 	possible.
>>
>> So a simple 1 line change should be enough to stem this kind of argument
>> in the future, right?
>>     
>
> 	Not quite...  OK, here's a story that might serve as a model
> of all that crap - it certainly runs afoul of a bunch of arguments on
> all sides of that.
>   
Ual, crap? :-)

> 	We all know that POSIX locks suck by design, in particular where it
> deals with close(2) semantics.  "$FOO is associated with process P having
> a descriptor refering to opened file F, $FOO disappears when any of such
> descriptors get removed" is bloody inconvenient in a lot of respects.  It
> also turns out to invite very similar kind of wrong assumptions in all
> implementation that have to deal with descriptor tables being possibly
> shared.  So far the victims include:
> 	* FreeBSD POSIX locks; used to be vulnerable, fixed.
> 	* OpenBSD POSIX locks; vulnerable.
> 	* Linux POSIX locks and dnotify entries; used to be vulnerable, fixed.
> Plan9 happily avoids having these turds in the first place and IIRC NetBSD
> simply doesn't have means for sharing descriptor tables.  Should such means
> appear it would be vulnerable as well.  Dnotify is Linux-only, er, entity
> (as in "non sunt multiplicandam").  I haven't looked at Solaris and I couldn't
> care less about GNU Turd.
>
> 	In all cases vulnerablities are local, with impact ranging from
> user-triggered panic to rather unpleasant privelege escalations (e.g.
> "any user can send an arbitrary signal to arbitrary process" in case of
> dnotify, etc.)
>
> 	The nature of mistaken assumption is exactly the same in all cases.
> An object is associated with vnode/dentry/inode/whatnot and since it's
> destroyed on any close(), it is assumed that we shall be guaranteed that
> such objects will not be able to outlive the opened file they are associated
> with or the process creating them.  It leads to the following nastiness:
> A and B share descriptor table.
> A: fcntl(fd, ...) trying to create such object; it resolves descriptor to
>    opened file, pins it down for the duration of operation and blocks
>    somewhere in course of creating the object.
> B: close(fd) evicts opened file from descriptor table.  It finds no objects
>    to be destroyed.
> A: completes creation of object, associates it with filesystem object and
>    releases the temporary hold it had on opened file.
>
> At that point we have an obvious leak and slightly less obvious attack vector.
> If no other descriptors in the descriptor table of A and B used to refer to
> the same file, the object will not be destroyed since there will be nothing
> that could decide to destroy it.  Unfortunately, it's worse than just a leak.
> These objects are supposed to be destroyed before the end of life of opened
> file.  As the result, nobody bothers to have them affect refcounts on the
> file/vnode/dentry/inode/whatever.  That's perfectly fine - the proper fix is
> to have fcntl() verify that descriptor still resolves to the same file before
> completing its work and destroy the object if it doesn't.  You don't need to
> play with refcounts for that.  However, without that fix we have a leak that
> leads to more than just an undead object - it's an undead object containing
> references to filesystem object that might be reused and to task_struct/proc/
> whatever you call it, again with the possibility of reuse.
>
> Getting from that point to the attack is a matter of simple (really simple)
> RTFS.  Details obviously depend on what the kernel in question is doing to
> these objects, but with that kind of broken assertions it's really not hard
> to come up with exploitable holes.
>
> Now, let us look at the history:
> 	* POSIX locks support predates shared descriptor tables; the holes
> in question opened as soon as clone(2)/rfork(2) had been merged into a kernel
> and grown support for shared descriptor tables.  For Linux it's 1.3.22 (Sep
> 1995), for OpenBSD it's a bit before 2.0 (Jan 1996) for FreeBSD - 2.2 (Feb
> 1996, from OpenBSD).
> 	* In 2002 dnotify had grown the same semantics (Linux-only thing,
> 2.5.15, soon backported to 2.4.19).  Same kind of race.
> 	* In 2003 FreeBSD folks had found and fixed their instance of that bug;
> commit message:
> "Avoid file lock leakage when linuxthreads port or rfork is used:
>   - Mark the process leader as having an advisory lock
>   - Check if process leader is marked as having advisory lock when
>     closing file
>   - Check that file is still open after lock has been obtained
>   - Don't allow file descriptor table sharing between processes
>     with different leaders"
> "Check that file is still open" bit refers to that race.  I have no idea
> whether they'd realized that what they'd closed had been locally exploitable
> or not.
> 	* In 2005 Peter Staubach had noticed the Linux analog of that sucker.
> The fix had been along the same lines as FreeBSD one, but in case of Linux
> we had extra fun with SMP ordering.  Peter had missed that and his patch
> left a hard to hit remnant of the race.  His commit message is rather long;
> it starts with
>     [PATCH] stale POSIX lock handling
>     
>     I believe that there is a problem with the handling of POSIX locks, which
>     the attached patch should address.
>     
>     The problem appears to be a race between fcntl(2) and close(2).  A
>     multithreaded application could close a file descriptor at the same time as
>     it is trying to acquire a lock using the same file descriptor.  I would
>     suggest that that multithreaded application is not providing the proper
>     synchronization for itself, but the OS should still behave correctly.
> ...
> I'm 100% sure that in this case the vulnerability had _not_ been realized.
> Bogus behaviour had been noticed and (mostly) fixed, but implications had
> been missed, along with the fact that the same scenario had played out in
> dnotify.
>   
That's common... We know that will occur from time to time and we are 
not discussing about that... Just about already known security issues 
being silently fixed without any mention. 
> 	* This April I'd caught dnotify hole during code audit.  The fix
> had been trivial enough and seeing that impact had been fairly nasty (any
> user could send any signal to any process, among other things) I'd decided
> to play along with "proper mechanisms".  Meaning vendor-sec.  _Bad_ error
> in judgement; the damn thing had not improved since I'd unsubscribed from
> that abortion.  A trivial patch, obviously local to one function and obviously
> not modifying behaviour other than in case when existing tree would've screwed
> itself.  Not affecting any headers.  Not affecting any data structures.
> _Obviously_ not affecting any 3rd-party code - not even on binary level.
> IOW, as safe as it ever gets.
> 	Alas.  The usual shite had played out and we had a *MONTH-LONG*
> embargo.  I would like to use this opportunity to offer a whole-hearted
> "fuck you" to that lovely practice and to vendor-sec in general.
>   
huahuahuahuahuhuahuahu, tks for share your felling about that...  Maybe 
the wrong people are dealing with that... What do you think? 
> 	* Very soon after writing the first version of a fix I started
> wondering if POSIX locks had the same hole - the same kind of semantics
> had invited the same kind of race there (eviction of dnotify entries and
> eviction of POSIX locks are called in the same place in close(2)).  Current
> tree appeared to be OK, checking the history had shown Peter's patch.
> A bit after that I'd noticed insufficient locking in dnotify patch, fixed
> that.  Checking for similar problems in POSIX locks counterpart of that crap
> had found the SMP ordering bug that remained there.
> 	* 2.6 -> 2.4 backport had uncovered another interesting thing -
> Peter's patch did _not_ make it to 2.4 3 years ago.
> 	* Checking OpenBSD (only now - I didn't get around to that back in
> April) shows that the same hole is alive and well there.
>
> Note that
> 	* OpenBSD folks hadn't picked the fix from FreeBSD ones, even though
> the FreeBSD version had been derived from OpenBSD one.  Why?  At a guess, the
> commit message had been less than noticable.  Feel free to toss yourself off
> screaming "coverup" if you are so inclined; I don't swing that way...
>   
I ever used this word... I know others did anyway.
> 	* Initial Linux fix _definitely_ had missed security implications
> *and* realization that somebody else might suffer from the same problem.
> FVO "somebody" including Linux itself, not to mention *BSD.
>   
That's the main problem of 'hidden' security bugs... Hidden here must be 
understood as:  normal bugs = security bugs
> 	* Even when the problem had been realized for what it had been in
> Linux, *BSD potential issues hadn't registered.  Again, the same wunch
> of bankers is welcome to scream "coverup", but in this case we even have
> the bleeding CVEs.
> 	* CVEs or no CVEs, OpenBSD folks hadn't picked that one.
>   
Yeah, they don't pay much attention to other projects I they should... 
That's why I always talk about 'copy and paste security bugs' as a real 
problem in open-source projects... Because the original code may be 
fixed and the 'copied' one not ;)
> 	* Going to vendor-sec is a mistake I won't repeat any time soon and
> I would strongly recommend everybody else to stay the hell away from that
> morass.  It creates inexcusable delays, bounds you to confidentiality and,
>   
Interesting... every people involved in this discussion told us to 
change our behaviour and try to improve things instead of be against 
it...  Why not change people involved in the vendor-sec in some way?  I 
have no idea who are there, but I'm sure it can be improved since I 
already worked with many vendors to coordinate vuln-disclousure and had 
no problems.

I'm sure the vendors involved are caring about 'marketing' and things 
like that, that's why there is a delay... They need to learn from others 
mistakes, like Microsoft.  The company now really knows how to deal with 
security problems.
> let's face it, happens to be the prime infiltration target for zero-day
> exploit traders.  In _this_ case exploit had been local-only.  Anything more
> interesting...
>   
That's true.  Mainly  because it takes longer to have a fix... I agree 
with the fix asap idea, just don't agree with 'change the message in the 
patch to not apper to be a security bug been fixed'.
> So where does that leave us?  Bugger if I know...  FWIW, I would rather see
> implications thought about *and* mentioned in the changelogs.  OTOH, the
> above shows the real-world cases when breakage hadn't even been realized to
> be security-significant.  
We ever said it's different otherwise...
> Obviously broken behaviour (leak, for example)
> gets spotted and fixed.  Fix looks obviously sane, bug it deals with -
> obviously real and worth fixing, so into a tree it goes...  IOW, one _can't_
> rely on having patches that close security holes marked as such.  
Sometimes no one will figure out that patch closed a security issue... 
We are talking in this thread about patches that are well-known to fix 
security holes... As the bugzilla explicitly says about a security 
problem and in the commit nothing mention that.
> For that
> the authors have to notice that themselves in the first place.  OTTH, nothing
> is going to convince the target audience of grsec, er, gentlemen that we are
> not a massive conspiracy anyway, the tinfoil brigade being what it is...
>   

There is no target audience involved here...  There is no 'marketing' or 
'media circus'... It's just a try to improve things. 


cya,


Rodrigo (BSDaemon).


PS:  Just my personal thoughts, not related to the company that I work for.
