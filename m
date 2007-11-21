Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbXKUTTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbXKUTTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXKUTTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:19:43 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:32790 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752126AbXKUTTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:19:42 -0500
X-YMail-OSG: SPMiv7wVM1mzJiSuR5FSq8Bez4rYe4S.Y1EO7kh7NBWunR0z_dGwyRUFZ7mbatvWri1.6obrDg--
X-RocketYMMF: rancidfat
Date: Wed, 21 Nov 2007 11:19:40 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch added to -mm tree
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, morgan@kernel.org, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1195668122.759.94.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <739077.85064.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Wed, 2007-11-21 at 09:21 -0800, Casey Schaufler wrote:
> > --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > 
> > > On Wed, 2007-11-21 at 09:48 -0600, Serge E. Hallyn wrote:
> > > > Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> > > > > +/*
> > > > > + * There are not enough CAP bits available to make this
> > > > > + * real, so Casey borrowed the capability that looks to
> > > > > + * him like it has the best balance of similarity amd
> > > > > + * low use.
> > > > > + */
> > > > > +#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
> > > > 
> > > > Hey Casey,
> > > > 
> > > > note that 64-bit capabilities are now in -mm, so you could grab your
> own
> > > > capability.
> > 
> > A proposal with merit. I'll do it.
> > 
> > > Which brings up an interesting question - what to do with
> > > security-module-specific capabilities? CAP_MAC_OVERRIDE is specific to
> > > Smack - other MAC modules like SELinux won't honor it.  Maybe it should
> > > be CAP_SMACK_OVERRIDE.
> > 
> > But what about the MAC modules like Smack that do honor it?
> > They shouldn't be using a module specific capability, so
> > calling it CAP_SMACK_OVERRIDE isn't right because then the
> > SecureWare* port would have to introduce CAP_SECUREWARE_OVERRIDE
> > and bam, there go all your shiny new capability values. Further,
> > Smack isn't what's overridden by CAP_MAC_OVERRIDE, it's the
> > access control check, which is not the same thing at all at all.
> > SELinux ignoring CAP_MAC_OVERRIDE is perfectly within the
> > restrictive model of the LSM. If someone ported the Trusted
> > Irix 4 MLS system as an LSM** having CAP_MAC_OVERRIDE wouldn't
> > have to allow read of higher labeled files, as the policy on that
> > system never allowed that, even for privileged processes.
> 
> Well, I'd be surprised to see that SecureWare port to Linux.

As would I. We have seen the Addmax linux port, however, so 
don't expect me to bet a paycheck on SecureWare never coming in.

> Or really any other label-based MAC implementations at all - how many
> different ones does Linux need?

It's no sweat off my nose if we have a dozen. SELinux and Smack are
both general mechanisms. There are situations where very specific
mechanisms would be useful, Smack would be overkill and SELinux
massive overkill. Argue that those mechanisms would never make it
upstream if you like, but I'm not convinced that they don't have a
place.

> Meanwhile, SELinux does implement MAC checks, and those checks do not
> require an external privilege mechanism like capabilities and won't be
> overridden by your shiny new capability.  Which makes me uneasy about
> calling it CAP_MAC_OVERRIDE.

SELinux makes all sorts of checks, some of which fall into the
traditional notion of MAC and others (e.g. port binding) that are
not. SELinux has generally eschewed the capabilities paradigm in
favor of enforcing the loaded "policy" and the rules it defines.

> Explain it to a user - this capability is
> for overriding MAC checks, except for SELinux.  Or AppArmor or TOMOYO
> or ... if you also count them as MAC (depending on your definition of
> it).

How do you explain the SELinux behavior to a user today?
I have never figured out how to tell if running a given program
against a given file will succeed or fail with SELinux.
If couldn't be that much additional burden to explain.

Put a comment in the reference policy that says:

   #
   # Policy not affected by CAP_MAC_OVERRIDE
   #

> What the capability does is override the MAC checks in Smack.  And since
> you don't seem to need more than one such capability for Smack, calling
> it CAP_SMACK_OVERRIDE makes sense to me.

Yes, I understand that that makes some sense given your
assumption that there won't be any more LSMs that would use it.
But I want to be clear that the capability is not overriding
the entire LSM, it is telling the LSM that the process has
"appropriate privilege" and should act accordingly.

An LSM that implements a descretionary mechanism would have
the same opportunity to ignore CAP_DAC_OVERRIDE as SELinux
would to ignore CAP_MAC_OVERRIDE. I think you might have a tough
row to hoe if you're suggesting that CAP_DAC_OVERRIDE should
be changed to CAP_MODEBIT_OVERRIDE.

> > SELinux has every right to make it's own choices regarding how
> > it behaves relative to any specific capability because it is
> > allowed to restrict access in any way it sees fit. I think that
> > you would get in trouble if you changed the value of a capability
> > on a task within the LSM, because that will impact the "usual"
> > access checks, but I wouldn't expect to see you doing that.
> 
> Given that the capability module is implemented via LSM, the above makes
> no sense - a LSM is free to tweak the capability bits or change what
> capable() returns already.  The fact that we don't presently do so is
> another matter.

Methinks there's a difference between what's possible and what's
allowed here. It's possible for a file system to do the same thing,
but I don't see it being allowed.

That, and you seem to be arguing both sides of the coin. We're both
pointing out that the LSM treats the capabilities as it will. SELinux
restricts port binding even in the presence of the appropriate
capability there.

I really don't see anyone getting their knickers in a twist because
there's another capability that SELinux doesn't honor.

In the end we can call it CAP_LATE_FOR_DINNER if that's the only way
I can move forward. CAP_MAC_OVERRIDE is the obvious partner to
CAP_DAC_OVERRIDE, so that's still my preference. CAP_SMACK_OVERRIDE
unnecessarily ties it to one LSM, and in spite of what some people
still seem to think, I see more LSMs in the pipeline.


Casey Schaufler
casey@schaufler-ca.com
