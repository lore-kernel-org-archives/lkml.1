Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXFIH3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXFIH3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXFIH3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:29:15 -0400
Received: from bay0-omc2-s19.bay0.hotmail.com ([65.54.246.155]:2027 "EHLO
	bay0-omc2-s19.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488AbXFIH3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:29:14 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 03:28:22 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and
 manipulation,pathname matching
Message-Id: <20070609032822.bc420a84.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
	<200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
	<20070608232531.d68de09f.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
	<20070609011022.ac332fc7.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
	<20070609014454.2f1f2f91.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 07:29:13.0810 (UTC) FILETIME=[E1174320:01C7AA67]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 00:04:15 -0700 (PDT)
david@lang.hm wrote:


> if it was this easy just have SELinux set the label == path
> you first need to figure out what the path is. right now this can't be 
> done, the AA paches provide this capability.

The question is: why not just extend SELinux to include AA functionality
rather than doing a whole new subsystem.  What exactly about AA demands
an entire new infrastructure rather than just building on what already
exists in the kernel?

> second, the AA policies aren't based just on the path, they are based on 
> the program accessing the path, then the path. you can have two different 
> policies for two different programs accessing the same path, but for most 
> programs (although, not nessasarily most activity) there will be no 
> policy, and therefor no need to check the path.

It seems the main purported advantage of AA is it doesn't require maintaining
labels on files etc.  In fact, that's the only conceptual difference I can
see other than a simpler policy file format.  So why not just make an AA
extension to SELinux that implements this main difference (ie. create labels
on the fly).

Then have a userspace program that converts the pretty-peace-and-love
AA policy file format into the baby-killing SELinux format and feed it
into the kernel.

All of a sudden you've implemented the main features of AA with very
few changes to the kernel.  It should be more maintainable, and much
easier to get accepted into the kernel.

> but even if you did these things, why would it be an advantage to use a 
> mechanism to create a dummy label and pass it off to different code rather 
> then just decideing at that point? 

Because it requires you to reimplement much of what is already in the kernel.
It requires you to be able to understand an entire new policy mechanism
instead of just piggybacking on what already exists.

> once the AA code knows what the policy 
> for this path is for this program (which it would need to know to set the 

Again you're only looking at the way the AA code is _today_.   If it were
refactored to be an extension of SELinux, there would be no reason for the
AA kernel code to know any policy whatsoever.   All it would need to know
is a path-to-label mapping.   SELinux would then enforce the AA policy
that it received from your userspace tool that translates your native
AA policy format into SELinux-lingo.

> label) how is it a win to pass this off to another chunk of code? you 

It's a win because the policy enforcement code is already in the kernel.
All you have to do is extend SELinux to create labels on the fly and provide
a userspace tool to convert the nice AA policy files into something SELinux
can use.

> would also need to make sure that the SELinux code didn't try to cache the 
> label for future use either, becouse in the future the access may be from 
> another program and so the policy that's needed is different.

You seem to be quibbling over small little unimportant details and refusing
to part with your current implementation.   It would seem the easiest way to
get the functionality you want into the kernel is to be a bit more flexible
on implementation.

Sean
