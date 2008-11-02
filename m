Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbYKBSyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbYKBSyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbYKBSra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:47:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52169 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbYKBSr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:47:29 -0500
Date: Sun, 2 Nov 2008 18:47:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
Message-ID: <20081102184723.GE28946@ZenIV.linux.org.uk>
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk> <20081101191250.GA7588@x200.localdomain> <20081101191614.GA28946@ZenIV.linux.org.uk> <20081101192757.GA7622@x200.localdomain> <20081101211724.GA16941@uranus.ravnborg.org> <alpine.LFD.2.00.0811021008060.3483@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811021008060.3483@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 10:13:03AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 1 Nov 2008, Sam Ravnborg wrote:
> > 
> > For cpuinit/cpuexit the gain turned out to be minimal.
> 
> Quite frankly, I'm not convinced.
> 
> Yeah, yeah, most distro's end up always enabling CPU hotplug due to 
> suspend/resume, but:
> 
>  - desktop PC's aren't where most memory pressures are anyway
> 
>  - on UP, CONFIG_HOTPLUG_CPU isn't on even if you do have suspend/resume
> 
>  - we should still care about embedded devices, and while some of them are 
>    growing up (and having SMP and not caring about a few tens of kB of 
>    memory), I don't think that's a valid argument for the other ones.
> 
> So. I'd rather we try to keep our init sections, and continue to spend 
> effort on fixing them. If at all possible.

FWIW, I've tweaked that stuff yesterday for a while.  Results so far:
alpha, arm[*], s390, s390x, uml - all down to zero section conflicts;
amd64 (UP and SMP) - one conflict, and it looks like a real issue.
i386 - same + one false positive.
sparc32 - one potential real issue (cpuinit, BTW)
sparc64 - one conflict, again likely to be a real problem
m68k - 3 conflicts, one of them looking like a real bug
m32r - 4 conflicts, by the look of it boiling down to single misannotation
ppc, ppc64, ia64 - 7--10 conflicts on each, hadn't looked into them yet.

That - from one afternoon of hacking.  And I'm yet to look at ppc/ppc64/ia64;
I would be very surprised if these didn't have low-hanging fruits.

[*] 2 arm configs I have sitting around - didn't do all subarchitectures.

Now, what we *really* ought to do is taking that crap to sparse where it
really can be handled sanely, without "variable name ends on magical
string '_shp', so we won't complain about pointers to .init.text anywhere
in it" kind of "logics".

What we need is something along the lines of "->probe() in pci_driver
can be in .devinit.text and it can be called only if...".  Which is
much, _much_ easier for sparse to handle.  We need to figure out what
to do with *.S, but other than that... this is really not a job for
modpost.
