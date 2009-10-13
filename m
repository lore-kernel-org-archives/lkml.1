Return-Path: <linux-kernel-owner+w=401wt.eu-S933732AbZJMIA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbZJMIA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933594AbZJMIAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:00:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572AbZJMIAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:00:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PhBVqBddwJgCORZL64KJsHL060AuqZcxnamdCrkcCHn1sE1kO9iAFEQWhT+F8Ca7a
	6GP7Wd9ccshfCE8oT3vcw==
Date: Tue, 13 Oct 2009 00:59:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <20091013070713.GD31483@elte.hu>
Message-ID: <alpine.DEB.1.00.0910130057570.14973@chino.kir.corp.google.com>
References: <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu>
 <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <alpine.DEB.1.00.0910121853050.26949@chino.kir.corp.google.com>
 <20091013070713.GD31483@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Ingo Molnar wrote:

> > > diff --git a/Makefile b/Makefile
> > > index 927d7a3..5dab509 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -963,8 +963,6 @@ localver = $(subst $(space),, $(string) \
> > >  # .scmversion is used when generating rpm packages so we do not loose
> > >  # the version information from the SCM when we do the build of the kernel
> > >  # from the copied source
> > > -ifdef CONFIG_LOCALVERSION_AUTO
> > > -
> > >  ifeq ($(wildcard .scmversion),)
> > >          _localver-auto = $(shell $(CONFIG_SHELL) \
> > >                           $(srctree)/scripts/setlocalversion $(srctree))
> > > @@ -972,7 +970,14 @@ else
> > >          _localver-auto = $(shell cat .scmversion 2> /dev/null)
> > >  endif
> > >  
> > > +ifdef CONFIG_LOCALVERSION_AUTO
> > >  	localver-auto  = $(LOCALVERSION)$(_localver-auto)
> > > +else
> > > +	ifeq ($_localver-auto,)
> > > +		localver-auto = $(LOCALVERSION)
> > > +	else
> > > +		localver-auto = $(LOCALVERSION)+
> > > +	endif
> > >  endif
> > >  
> > >  localver-full = $(localver)$(localver-auto)
> > 
> > I don't see where the `+' is dropped between -rc tags; 
> > scripts/setlocalversion should return -00000-rc5 for v2.6.32-rc5, for 
> > example, so _localver-auto will always be non-NULL and the `+' is 
> > appended.
> > 
> > I think scripts/setlocalversion should also be modified as I earlier 
> > suggested to suppress output when git-describe shows no additional 
> > commits beyond the tag.  Then, CONFIG_LOCALVERSION_AUTO would not be 
> > v2.6.32-rc4-00000-rc4, for example, when 2.6.32-rc4 is released.
> > 
> > Your patch also adds the make LOCALVERSION= string to the version 
> > without requiring CONFIG_LOCALVERSION_AUTO.  That's a change from 
> > prior behavior, but I think it's helpful for user-specified version 
> > tags.
> 
> Good points - the patch is defective in its current form. Anyone 
> interested in fixing it? I'll be busy with other things.
> 

The patch itself is good, it just needs a change to 
scripts/setlocalversion to suppress output when at a tagged commit.



scripts: suppress setlocalversion output if at tagged commit

It's unnecessary, even for CONFIG_LOCALVERSION_AUTO configs, to append
the "git describe" output to the version string if there are no revisions
beyond a tagged commit.

When the git respository was at the v2.6.32-rc4 tagged commit, for
example, the previous code would output "-00000-rc4," which is
unnecessary.

The comment in scripts/setlocalversion pertaining to this behavior need
not be changed since the implementation now conforms to the description.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 scripts/setlocalversion |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -26,7 +26,8 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 		# If we are past a tagged commit (like "v2.6.30-rc5-302-g72357d5"),
 		# we pretty print it.
 		if atag="`git describe 2>/dev/null`"; then
-			echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+			echo "$atag" | awk -F- 'int($(NF-1)) > 0	\
+					{printf("-%05d-%s", $(NF-1),$(NF))}'
 
 		# If we don't have a tag at all we print -g{commitish}.
 		else
