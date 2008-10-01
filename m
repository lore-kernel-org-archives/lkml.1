Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYJAPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYJAPdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYJAPd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:33:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbYJAPd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:33:26 -0400
Subject: Re: [PATCH] capability: WARN when invalid capability is requested
	rather than BUG/panic
From: Eric Paris <eparis@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, morgan@kernel.org,
       selinux@tycho.nsa.gov
In-Reply-To: <20080930102840.1dbd0c48@infradead.org>
References: <1222782946.28251.63.camel@localhost.localdomain>
	 <alpine.LRH.1.10.0810010008130.2068@tundra.namei.org>
	 <1222785389.28251.83.camel@localhost.localdomain>
	 <20080930153820.GA28616@us.ibm.com>
	 <1222790843.28251.92.camel@localhost.localdomain>
	 <20080930162830.GB31779@us.ibm.com>
	 <1222795350.28251.98.camel@localhost.localdomain>
	 <20080930102840.1dbd0c48@infradead.org>
Content-Type: text/plain
Date: Wed, 01 Oct 2008 11:32:40 -0400
Message-Id: <1222875160.28251.133.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 10:28 -0700, Arjan van de Ven wrote:
> On Tue, 30 Sep 2008 13:22:30 -0400
> Eric Paris <eparis@redhat.com> wrote:
> > 
> > No argument from me that patching up for buggy drivers sucks.  Yours
> > would be less overhead, and it would return the cap system back to
> > pre-2.6.25 operation (garbage in garbage out but no panic).  Since we
> > already have the branch in SELinux its no 'extra' overhead to EPERM
> > there instead of here (garbage in EPERM out).
> 
> to be honest, this is really a case of 
> panic("This stuff is really borken")
> 
> if it passes some random value, what other api's does it pass a random
> value to ?
> 
> (and in addition, random values to security critical APIs deserve a
> process kill, because it could well be an exploit attempt at guessing
> something. At least by not letting it live it's harder to get such type
> of exploits to be able to guess things. So imo, BUG() is the right
> answer)

Do we have any concern of a module being compiled against a new kernel
say with cap number 35 defined and then loaded into a kernel with only
34 capabilities?  Do we care about that forward compatibility?  If we
care BUG is scary.  EPERM would be the right thing since clearly on this
kernel the process can't possibly have cap #35.

We really have 4 options (in the order I like them).

1) do nothing (garbage in garbage out, sometimes panic sometimes not)
2) mask CAP_TO_INDEX (garbage in garbage out, no panic)
3) BUG_ON(!cap_valid(flag)) (garbage in BUG out, no panic)
4) WARN_ON/EPERM (garbage in EPERM out, no panic)

SELinux already sorta does #3 and #4 (we will panic if cap > 64 and will
EPERM between the max cap and 64) but I really don't like being blamed
when it's not my fault.  SELinux takes enough crap when people's systems
don't work and this time its clearly not my fault, which is why I'm
pushing this.

If we believe the capability system should take path's 1, 2, or 4 I'm
going to take path 4 in SELinux.  If capabilities wants to take path 3,
I'm ok with that too.  Its going to break a lot of people's machines I'm
afraid, but it would force ATI to fix their crap....

-Eric

