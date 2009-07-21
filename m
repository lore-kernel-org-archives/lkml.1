Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZGUP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZGUP7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZGUP7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:59:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59776 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbZGUP7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:59:17 -0400
Subject: Re: [PATCH 1/2] VM/SELinux: require CAP_SYS_RAWIO for all
 mmap_zero operations
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
In-Reply-To: <20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
	 <20090721160437.5bda68b4@lxorguk.ukuu.org.uk>
	 <1248189524.2654.301.camel@localhost>
	 <20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 11:57:13 -0400
Message-Id: <1248191833.2654.320.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 16:38 +0100, Alan Cox wrote:
> > turns it off for the whole system when you install WINE.  This patch
> > doesn't change that fact.  All it does is add that requirement to
> > SELinux systems that already exists on non-selinux systems.
> 
> Prior to this an SELinux system could implement sensible security. 

Sadly, it couldn't reasonably  :(

> > > Am I missing something here, this "solution" sounds completely brain
> > > dead ?
> > 
> > Well, with patch 2/2 you still get your SELinux protections (only for 1
> > page) even if you disable it for the whole system.  So in the end, you
> > have better protection than you have today with this series....
> 
> We know one page isn't sufficient. That has been seen from some exploit
> cases.

Yet another tunable is easy, and what I mentioned yesterday, i'd
probably put it in /selinux since it would be an selinux only thing.
This just seemed reasonable, since the Kconfig default is 4096 that's
what most people have anyway right?

> So this looks to me like a regression in features, that makes the system
> less secure and doesn't solve anything at all.
> 
> Whereas if you just set the default SELinux user confinement to allow
> everything but mapping low pages you wouldn't actually need to mess up
> the kernel ?

Herein lies the problem.  It sounds easy to do, but isn't.  Sure I can
remove mmap_zero from unconfined_t (and actually it should be that way
in rawhide by default by now) but like I said, it's not even a speed
bump to be that broad.  

runcon -t wine_t [my exploit]
win.

So now I have to stop allowing unconfined_t to specifically run things
as wine_t.  Easy enough to get around

chcon -t wine_exec_t [my exploit]
win.

Well crap, now I have to stop letting unconfined_t label things
wine_exec_t.  Easy enough to get around if you can load it as an rpm
(ok, this step is probably harder)

and hell, how do I know I can't just get wine some windows program to
get win to map the page for me?

Finding all of the contortions that an unconfined user can do is nearly
impossible.  It's one of the reasons a lot of selinux people argued
against the unconfined domain to begin with.  There are some analysis
tools used in high security environments to prove security goals but
unconfined is such a monstrosity it's too hard to get a handle on.  Make
everyone log in as user_t (man semanage) and you will be better (but I
haven't proven it is safe...)

> Currently I have low page protection and I don't have to run wine as
> CAP_SYS_RAWIO (which comes in the "sucidial ideas") category. I consider
> the loss of that ability a regression.

and you still could.  Just set mmap_min_addr = 0 and you get SELinux
protection for confined domains.  I'll gladly add an selinux tunable if
people like it so SELinux users who don't want to enforce the uid=0 rule
can do exactly everything they can do today.

Someone on this list has to know a wine guru.  Seems to me there has to
be a way that we can give wine CAP_SYS_RAWIO just long enough to map the
page so non-SELinux users aren't left in the lurch they are today.

