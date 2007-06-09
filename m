Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbXFIIEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbXFIIEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXFIIER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:04:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51701
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbXFIIEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:04:13 -0400
Date: Sat, 9 Jun 2007 01:03:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname
 matching
In-Reply-To: <20070609032822.bc420a84.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706090030470.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
 <200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
 <20070608232531.d68de09f.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
 <20070609011022.ac332fc7.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
 <20070609014454.2f1f2f91.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm>
 <20070609032822.bc420a84.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Sean wrote:

> On Sat, 9 Jun 2007 00:04:15 -0700 (PDT)
> david@lang.hm wrote:
>
>
>> if it was this easy just have SELinux set the label == path
>> you first need to figure out what the path is. right now this can't be
>> done, the AA paches provide this capability.
>
> The question is: why not just extend SELinux to include AA functionality
> rather than doing a whole new subsystem.  What exactly about AA demands
> an entire new infrastructure rather than just building on what already
> exists in the kernel?
>
>> second, the AA policies aren't based just on the path, they are based on
>> the program accessing the path, then the path. you can have two different
>> policies for two different programs accessing the same path, but for most
>> programs (although, not nessasarily most activity) there will be no
>> policy, and therefor no need to check the path.
>
> It seems the main purported advantage of AA is it doesn't require maintaining
> labels on files etc.  In fact, that's the only conceptual difference I can
> see other than a simpler policy file format.  So why not just make an AA
> extension to SELinux that implements this main difference (ie. create labels
> on the fly).

becouse the SELinux people don't want to have this in their code for one 
thing.

you seem to be ignoring the SELinux people who say that pathnames are 
fundamentally different from labels, labels stay with the data if the file 
is renamed, path names do not. multiple hard-links to the same file will 
always have the same label for SELinux, but could have very different 
permissions with AA

labels are part of policy, policy is not supposed to be decided by the 
kernel.

SELinux treats all files with the same label the same. to have the same 
ability to treat every file differntly that AA has SELinux would have to 
give every file a different label.


> Then have a userspace program that converts the pretty-peace-and-love
> AA policy file format into the baby-killing SELinux format and feed it
> into the kernel.
>
> All of a sudden you've implemented the main features of AA with very
> few changes to the kernel.  It should be more maintainable, and much
> easier to get accepted into the kernel.

how will you know how many labels you need to put into your policy that 
you load into the kernel?

how will the kernel figure out what label to use for a file

and the userspace code that converts the policy needs to know the names 
when it feeds the policy into the kernel.

and you still need to implement the new LSM hooks that AA is asking for to 
figure out what the path to a file is.

>> but even if you did these things, why would it be an advantage to use a
>> mechanism to create a dummy label and pass it off to different code rather
>> then just decideing at that point?
>
> Because it requires you to reimplement much of what is already in the kernel.
> It requires you to be able to understand an entire new policy mechanism
> instead of just piggybacking on what already exists.

the policy mechanism is supposed to be the LSM hooks, and AA is trying to 
re-use them.

>> once the AA code knows what the policy
>> for this path is for this program (which it would need to know to set the
>
> Again you're only looking at the way the AA code is _today_.   If it were
> refactored to be an extension of SELinux, there would be no reason for the
> AA kernel code to know any policy whatsoever.   All it would need to know
> is a path-to-label mapping.   SELinux would then enforce the AA policy
> that it received from your userspace tool that translates your native
> AA policy format into SELinux-lingo.

after you change SELinux to be able to do everything that AA does then you 
can tell SELinux to act like AA, true but irrelavent.

>> label) how is it a win to pass this off to another chunk of code? you
>
> It's a win because the policy enforcement code is already in the kernel.
> All you have to do is extend SELinux to create labels on the fly and provide
> a userspace tool to convert the nice AA policy files into something SELinux
> can use.
>
>> would also need to make sure that the SELinux code didn't try to cache the
>> label for future use either, becouse in the future the access may be from
>> another program and so the policy that's needed is different.
>
> You seem to be quibbling over small little unimportant details and refusing
> to part with your current implementation.   It would seem the easiest way to
> get the functionality you want into the kernel is to be a bit more flexible
> on implementation.

first off, and for the record, it's not _my_ implementation. I have 
nothing to do with writing AA.

I am just someone who manages hundreds of servers for which AA would be a 
good fit. In the past I've gone to a lot of effort to get less security 
then AA would provide to implement seperate services in seperate chroot 
sandboxes. I'm looking for easier and better options, I've looked at 
SELinux and don't believe that I can produce a reasonable policy in a 
reasonable amount of time (and I don't trust distro vendors to do it for 
me, they have to allow a lot of things that don't make sense on my 
systems, and I occasionally need to allow something that wouldn't make 
sense in the general case, let alone all the software I run that the disto 
doesn't know anything about)

chroot sandboxes, virtual machines, containers all have the problem that 
when you need to have more then one application interacting they need to 
be put togeather and the basic mechanism doesn't provide you any security 
against each other.

SELinux is aiming for 'perfect' security, I'll readily admit that, just 
like I'll admit that AA is only aiming for 'good enough' security, but 
that 'good enough' security would help me and I don't see any way to get 
to SELinux's 'perfect' security.

I also don't care about the details of how it gets implemented, but when 
the AA people have a working implementation, and the SELinux people are 
strongly opposed to the concept, I don't see any advantage in trying to 
get the AA people to throw away a lot of their working code to try and get 
people (many of who have be very insulting frankly) to accept such 
fandamental changes.

if the SELinux people had responded to the announcement of AA with "that's 
a nice idea, if we add these snippits from your code to SELinux then we 
can do the same thing" it would be a very different story.

but as always patches talk louder then anything else, if you believe that 
the efforts should be combined so strongly why don't you start submitting 
the appropriate patches to SELinux to make it able to do what AA does?

David Lang
