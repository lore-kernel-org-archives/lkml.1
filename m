Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbXKUSJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbXKUSJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXKUSIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:08:54 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:61162 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751646AbXKUSIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:08:53 -0500
Subject: Re: +
	smack-version-11c-simplified-mandatory-access-control-kernel.patch added to
	-mm tree
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, morgan@kernel.org, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <383368.46196.qm@web36605.mail.mud.yahoo.com>
References: <383368.46196.qm@web36605.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 21 Nov 2007 13:02:02 -0500
Message-Id: <1195668122.759.94.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 09:21 -0800, Casey Schaufler wrote:
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > On Wed, 2007-11-21 at 09:48 -0600, Serge E. Hallyn wrote:
> > > Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> > > > +/*
> > > > + * There are not enough CAP bits available to make this
> > > > + * real, so Casey borrowed the capability that looks to
> > > > + * him like it has the best balance of similarity amd
> > > > + * low use.
> > > > + */
> > > > +#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
> > > 
> > > Hey Casey,
> > > 
> > > note that 64-bit capabilities are now in -mm, so you could grab your own
> > > capability.
> 
> A proposal with merit. I'll do it.
> 
> > Which brings up an interesting question - what to do with
> > security-module-specific capabilities? CAP_MAC_OVERRIDE is specific to
> > Smack - other MAC modules like SELinux won't honor it.  Maybe it should
> > be CAP_SMACK_OVERRIDE.
> 
> But what about the MAC modules like Smack that do honor it?
> They shouldn't be using a module specific capability, so
> calling it CAP_SMACK_OVERRIDE isn't right because then the
> SecureWare* port would have to introduce CAP_SECUREWARE_OVERRIDE
> and bam, there go all your shiny new capability values. Further,
> Smack isn't what's overridden by CAP_MAC_OVERRIDE, it's the
> access control check, which is not the same thing at all at all.
> SELinux ignoring CAP_MAC_OVERRIDE is perfectly within the
> restrictive model of the LSM. If someone ported the Trusted
> Irix 4 MLS system as an LSM** having CAP_MAC_OVERRIDE wouldn't
> have to allow read of higher labeled files, as the policy on that
> system never allowed that, even for privileged processes.

Well, I'd be surprised to see that SecureWare port to Linux.  Or really
any other label-based MAC implementations at all - how many different
ones does Linux need?

Meanwhile, SELinux does implement MAC checks, and those checks do not
require an external privilege mechanism like capabilities and won't be
overridden by your shiny new capability.  Which makes me uneasy about
calling it CAP_MAC_OVERRIDE.  Explain it to a user - this capability is
for overriding MAC checks, except for SELinux.  Or AppArmor or TOMOYO
or ... if you also count them as MAC (depending on your definition of
it).

What the capability does is override the MAC checks in Smack.  And since
you don't seem to need more than one such capability for Smack, calling
it CAP_SMACK_OVERRIDE makes sense to me.  

> SELinux has every right to make it's own choices regarding how
> it behaves relative to any specific capability because it is
> allowed to restrict access in any way it sees fit. I think that
> you would get in trouble if you changed the value of a capability
> on a task within the LSM, because that will impact the "usual"
> access checks, but I wouldn't expect to see you doing that.

Given that the capability module is implemented via LSM, the above makes
no sense - a LSM is free to tweak the capability bits or change what
capable() returns already.  The fact that we don't presently do so is
another matter.

> SELinux has gone in a different direction on privileged operations
> than capabilities, so it's not surprising that the two schemes
> don't look like they're meshing very well in this case.
> 
> ----
> *  SecureWare was an MLS "kit". The MLS version of HP/UX was based
>    on it, and the Macintosh version got the first ever CMW evaluation.
>    SELinux took many of the same design approaches as SecureWare,
>    and in it's early versions bore a somewhat frightening resemblence
>    to the earlier system.
> 
> ** Trix4 allowed a privileged process to write lower labeled files,
>    but not read higher labeled files. That way any files that got
>    created "by accident" were assured to be labeled at least as high
>    as the data they contained.
> 
> 
> Casey Schaufler
> casey@schaufler-ca.com
-- 
Stephen Smalley
National Security Agency

