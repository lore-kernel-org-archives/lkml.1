Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbXJXWFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbXJXWFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbXJXWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:04:53 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:50822 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757409AbXJXWEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:04:51 -0400
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Simon Arlott <simon@fire.lp0.eu>,
       Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <153904.68258.qm@web36609.mail.mud.yahoo.com>
References: <153904.68258.qm@web36609.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 18:04:47 -0400
Message-Id: <1193263487.30930.101.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 14:58 -0700, Casey Schaufler wrote:
> --- "David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:
> 
> > On Wed, 2007-10-24 at 21:04 +0200, Jan Engelhardt wrote:
> > > On Oct 24 2007 19:59, Simon Arlott wrote:
> > > >On 24/10/07 19:51, Jan Engelhardt wrote:
> > > >> On Oct 24 2007 19:11, Simon Arlott wrote:
> > > >>>
> > > >>>* (I've got a list of access rules which are scanned in order until one
> > of 
> > > >>>them matches, and an array of one bit for every port for per-port
> > default 
> > > >>>allow/deny - although the latter could be removed.
> > > >>>http://svn.lp0.eu/simon/portac/trunk/)
> > > >> 
> > > >> Besides the 'feature' of inhibiting port binding,
> > > >> is not this task of blocking connections something for a firewall?
> > > >
> > > >The firewall blocks incoming connections where appropriate, yes, but it 
> > > >doesn't stop one user binding to a port that another user expected to be
> > able 
> > > >to use. "Ownership" of ports (1-1023) shouldn't be something only root
> > (via 
> > > >CAP_NET_BIND_SERVICE) has. Lots of services also don't have standard ports
> > 
> > > >below 1024 and it's useful to be able to prevent users from binding to
> > them 
> > > >too.
> > > 
> > > Indeed.
> > > 
> > > 
> > > There has been a feature in the security framework that probably did
> > > not get much attention. It looks like YAGNI first, but on a closer look,
> > > it becomes useful pretty quick - secondary_register.
> > > 
> > > As more and more simple LSM plugins pop up, stacking/chaining by means
> > > of secondary_register becomes attractive again, especially if these LSMs
> > > target different actions. This is probably the most useful thing why
> > > the LSM interface should remain modular:
> > > 
> > > # Secure my files
> > > modprobe apparmor
> > > # -*- assuming apparmor implemented secondaries -*-
> > > # Secure my ports
> > > modprobe portac
> > > # More rights to users
> > > modprobe multiadm
> > > # -*- whatever else comes along -*-
> > 
> > There is an issue that you overlook here and it is the successful
> > composition of security models. While your idea is appealing it presents
> > several problems. In your example you have 3 models with 3 policies.
> > AppArmor which has its own port security mechanisms is a MAC model that
> > from what I have seen appears to have a targeted least privilege policy.
> > This means that AppArmor picks applications it wishes to secure and
> > makes sure it can't do anything except what it needs to get its job
> > done. Your module multiadm takes a user which is completely orthogonal
> > to the concepts that AppArmor uses and gives him extra privileges. From
> > what I have read and correct me if I am wrong portac deals with users
> > instead of programs. Now lets try to reconcile this in a way that is
> > sane to the user/administrator.
> > 
> > Apparmor wants to lock down some application, it gives the application
> > access to a particular port, and the minimal set of privileges needed to
> > execute the application. Since Apparmor is "easy to use" (note the
> > quotes are to indicate they aren't my words not sarcasm) and SUSE comes
> > with a targeted policy the user isn't concerned with it. Now multiadm
> > comes along and an administrator wishes to grant extra rights to a user.
> > This is fine with multiadm alone since it is the main security module,
> > however we now have to compose this with AppArmor. So an administrator
> > runs into an error running his application. Is this because his user
> > isn't granted the proper escalated privileges? Is it because AppArmor
> > needs an extra rule to run the application?  It could also be that our
> > third module has blocked the application because it determined that even
> > though multiadm specified that the user should have the elevated
> > privileges to run the application that user shouldn't be able to bind to
> > that port. 
> > 
> > There might be a better example to illustrate the problem however, this
> > simple example shows the interdependency of three seemingly simple
> > modules. Imagine what happens when people really let loose and implement
> > all sorts of crazy ideas and stack them on top of each other. Stacking
> > works in things such as file systems because we have a clearly defined
> > interface with fixed solid semantics. You could attempt to do that but
> > once you have modules that step on each others toes you have to figure
> > out a way to reconcile that. It seems to me that you're going to
> > introduce usability problems that are hard to deal with.
> > 
> > Dave Quigley
> 
> Two very important things to consider:
> 
> The LSM is designed to be a restrictive mechanism. An LSM module
> is not allowed to grant access that would be denied by usual
> mechanisms. There are composition problems, but nothing that is
> worse than the problems you have to deal with when a filesystem
> is mounted read-only. True, one LSM module could muck with the
> data used by another, but that's something you can do today with
> setxattr() calls in an application.
> 
> Which brings up the second important point. The argument above
> has nothing whatever to do with mechanisms provided by the kernel
> and everything to do with the privileged applications used to
> administer a system. Those applications need to be written so as
> to deal properly with unexpected access failures, such as might
> be induced by a filesystem mounted read-only or being full. I
> am aware of the Holy Grail of a security package that does not
> interfere with the operation of "normal" administration. How close
> you can come to that in independent of wether your kernel is
> an integrated "security solution" or a collection of composed
> modules.
> 
> This discussion is amazingly disconnected from the issues of LSM.

This branch of the tree seems to have gone in a direction similar to the
stackable netfilter like architecture that was suggested by someone last
time this came up.

> 
> 
> Casey Schaufler
> casey@schaufler-ca.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

