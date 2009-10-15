Return-Path: <linux-kernel-owner+w=401wt.eu-S934724AbZJOHiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934724AbZJOHiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932925AbZJOHiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:38:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21491 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbZJOHiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:38:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UHbFU6soWIGKM/tjPWB6xTkdwQ1LhFt7HVIGxmP6PZusbnEfNzTZxor2vnIgmNMof
	PbsIcckACD6ebFzcn/Vcg==
Date: Thu, 15 Oct 2009 00:37:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frans Pop <elendil@planet.nl>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <200910150143.18755.elendil@planet.nl>
Message-ID: <alpine.DEB.1.00.0910150029450.10850@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <20091014073306.GB22778@elte.hu> <alpine.DEB.1.00.0910140037140.29264@chino.kir.corp.google.com> <200910150143.18755.elendil@planet.nl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Frans Pop wrote:

> That is fine for custom kernels. I still maintain that it is hopelessly
> wrong for distro kernels.
> 
> Distro kernels generally have their own naming schemes.
> Debian uses: 2.6.30-2-amd64 (<version>-<ABI>-<flavor>)
> Fedora uses: 2.6.30.5-43.fc11.i586
> 
> And those kernel versions implicitly already contain the information that
> they are not vanilla kernels. So a "+" suffix is totally redundant.
> 

And that's why I suggested, in addition to my patch, that we allow "make 
LOCALVERSION=" to override the `+' suffix for kernels compiled without 
CONFIG_LOCALVERSION_AUTO.  In your examples, they would pass 
LOCALVERSION=-2-amd64 or LOCALVERSION=-43.fc11.i586, respectively, to 
make.

> My main argument is that if they build kernels from an SCM, which is quite
> likely, they should not suddenly get a "+" appended to those versions.
> And IMO they should also not have to patch the Makefile to avoid it.
> If this change is made, it should be made in such a way that old version
> naming schemes are still possible.
> 

They are, with my suggestion to allow make LOCALVERSION= to override the 
`+'.  The question I posed directly to you was this: how does adding a 
unique string passed by the user for a more descriptive kernel version 
interact poorly with certain packaging requirements?  You've given two 
examples that are _perfect_ use cases for my suggestion.

> > We could easily go with my suggestion of allowing "make LOCALVERSION="
> > to override all additions to the kernel version when
> > CONFIG_LOCALVERSION_AUTO is disabled.  For such configurations, kernels
> > would be built with this variable to specify how it's different from the
> > vanilla version and would suppress the `+'.
> 
> Using LOCALVERSION= for that would be wrong as it is on a different level
> from AUTOVERSION. They should be independent. However, that basic approach
> of using an environment variable is certainly an option.
> 

Now I'm confused, because currently LOCALVERSION= can only be used when 
CONFIG_LOCALVERSION_AUTO is defined; in other words, it's completely 
dependent on it.  My patch changes that and seems to be your desire as 
well?

> So I propose the following patch on top of the patch proposed by David.
> It offers a clean out for users who explicitly do not want *any* SCM-based
> suffix added to their kernel version, and is IMO both 1) obvious enough
> for expert users and 2) obscure enough that regular users are unlikely to
> abuse it. Is that acceptable?
> 

No, it actually makes things much worse because now instead of forcing the 
user to post his .config to determine the setting of 
CONFIG_LOCALVERSION_AUTO to intepret the version string, it forces them to 
recall what their KBUILD_NO_LOCALVERSION_EXTRA environment variable 
happened to be at the time of build.
