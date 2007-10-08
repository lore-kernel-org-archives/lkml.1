Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXJHSHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXJHSHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXJHSH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:07:29 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:32957 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752328AbXJHSH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:07:28 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Oct 2007 14:07:28 EDT
X-YMail-OSG: 8_tHcnMVM1mqzvSEKMI_mHM6AnDHfOtsc3UmHA.Dx2igFKUvatWVJXjXvH1amjnTv6Nwsa3.qFTDQXklY1tJ0WjQk3BhSjz33V5uChI7K3OnBq91nm0UsA--
Date: Mon, 8 Oct 2007 13:00:38 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
	Access Control Kernel
Message-ID: <20071008180038.GC7106@vino.hallyn.com>
References: <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org> <4703126D.70703@tmr.com> <alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org> <m17im2pc7x.fsf@ebiederm.dsl.xmission.com> <15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com> <m1zlyymaoy.fsf@ebiederm.dsl.xmission.com> <20071008160611.GA7106@vino.hallyn.com> <m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> Also I'm thinking towards what do we have to do isolate the security
> module stuff in the context of a namespace.  So that a person in
> a container can setup their own rules that further restrict the
> system.

In the selinux example I plan to do set up soon, that will be done
using the '.' namespace separator.

Every object/subject in vserver1 will have a type 'vserver1.whatever'.
'vserver1.root_t', 'vserver1.etc_t', etc.

I don't know how far the policy tools have gotten, but they are
*supposed* to implement constraints at policy compile time such that
every type which is a child of 'vserver1' would have no more access than
what is granted to type 'vserver1'.  So this provides a pretty nice
conceptual way to set up security for a vserver.

Then using the userspace policy server and metapolicy (this would be a
step or two beyond my first example) the policy could define rules about
what sort of policy could be added by a process of type
'vserver1.root_t'.  So we can allow the container admin to introduce
policy changes affecting only his own container, and subject to all
constraints placed by the host admin on vserver1.

> So far I'm not ready to do anything yet but I'm keeping a weather eye
> on the situation so I have a clue what I'm go.
> 
> > If 1, an selinux policy should cover you.  So you can then skip to 3.
> > Or, alternatively, I do plan - as soon as my free time clears up a bit -
> > on demonstrating how to write some selinux policy to create a secure
> > container based on current -mm + your experimental network namespace
> > patches.
> 
> Thanks that sounds interesting.
> 
> > If 3, then selinux policy modules may actually help you, else either
> > a new LSM (maybe like LIDS) or a userspace tool which is a front-end to
> > selinux policy, emulating the iptables rules formats, may be what you
> > want?
> 
> I don't want to have to choose my LSM at compile time.  I want to
> add support into the kernel at compile time and be able to configure
> it before I go multi-user.  I know this kind of architecture is
> achievable because iptables allows it.
> 
> When I conceive as the security modules as just a firewall between
> applications on my own box I think, oh yeah this is no big deal,
> I might want to limit something that way some time.  These are just
> some additional rules on when to return -EPERM.  So I ask myself why
> is this situation much less flexible and much harder to use then our
> network firewall code?

It actually used to be far more flexible than it is now.  The consensus
appears to be that it's just too hard - at times impossible - to
properly label every object or subject at some point after they've all
been created (processes created, inodes read from disk, etc).  Two
examples:

	1. you've got pid 777.  How was it created?  Can you trust it's
	history?  In my DTE module I solved this by keeping track of the
	*full* invocation history until a policy was loaded.  I think
	tomoyo may do something similar.  But it's really not
	sufficient, especially since you don't even want a LSM loaded
	at all.  So you can't reduce it to 'boot_t executd init_t
	executed login_t executed shell_t', you have to keep track of
	every inode executed

	2. how do you reliably re-evaluate, for some file, what label
	to assign to it?  Do you guess at a pathname?  Do you trust that
	the inodes have been pre-labeled for every LSM, so when you load
	the LSM you can grab the xattrs?

So it's a valid question - do we address these sorts of concerns in
order to add flexibility, or do we keep things as simple as possible
and say that it's up to the distro, for instance, or a site local
security administrator, to define policy, so that flexibility really
is of very limited use?

> >> My impression is that selinux is one monolithic blob that doesn't
> >> allow me to incrementally add matching or action features that I
> >> find interesting.
> >
> > Actually with policy modules it gets much much better.  I have in fact
> > been able to pretty easily write a short policy module to, say, create
> > an selinux user which ran as root and had full access to the system to
> > do system setup for automated testing.  There is a learning curve in
> > having to look at existing modules for maybe a few days to get started,
> > but once you get started the policy modules do make it very easy to
> > add to current policy.
> 
> Ok. Interesting.  Are these kernel modules?

Policy modules, loaded through selinuxfs at any time using 'semodule'.

> Still while I get the general impression that selinux seems to be
> very close to a generic solution, and that selinux more or less has
> the architecture we might want.  I don't get the impression that
> selinux does this at a level that is open to other people doing
> interesting things.
> 
> So I still ask the question can we move this functionality down to
> the LSM in a way that will solve the composition problem between
> multiple security modules?

I've tried :)  At a less semantic and more purely technical level, using
the stacker module.  After a few years it was finally decided (at
ksummit 2006) that it simply wasn't useful.

Now perhaps the problem was that I didn't address semantic issues.
But it does sound to me like what you want is a particular flexible LSM.
Be it LIDS or SELinux, or something new.

> It really seems to me that the LSM as currently structured creates
> a large barrier to entry for people who have just this little thing
> they want to do that is not possible with any existing security
> module.

Yes and it's been made increasingly so far particularly because of the
perceived potential for 'abuse'.  So to be curt, allowing people like
you describe to do something small and interesting is deemed far less
important than making sure that the small thing they want to do fits
within the LSM mandate and is not a non-upstream module.

So that is the concern you would need to address before any other.

Still, I do think that selinux policy modules may do just what you want.
The main obstacle appears to be that the 'base' policy is so huge that
it's tough to get started to do something small.

You also might want to check out LIDS, as its rules are set up pretty
much the way you seem to want.

-serge
