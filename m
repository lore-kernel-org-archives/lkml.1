Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbXJXVh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbXJXVh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXJXVhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:37:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42399 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbXJXVhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:37:06 -0400
Date: Wed, 24 Oct 2007 16:37:04 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
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
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071024213704.GA2867@sergelap.austin.ibm.com>
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr> <471F9603.9080308@simon.arlott.org.uk> <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr> <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David P. Quigley (dpquigl@tycho.nsa.gov):
> On Wed, 2007-10-24 at 21:04 +0200, Jan Engelhardt wrote:
> > On Oct 24 2007 19:59, Simon Arlott wrote:
> > >On 24/10/07 19:51, Jan Engelhardt wrote:
> > >> On Oct 24 2007 19:11, Simon Arlott wrote:
> > >>>
> > >>>* (I've got a list of access rules which are scanned in order until one of 
> > >>>them matches, and an array of one bit for every port for per-port default 
> > >>>allow/deny - although the latter could be removed.
> > >>>http://svn.lp0.eu/simon/portac/trunk/)
> > >> 
> > >> Besides the 'feature' of inhibiting port binding,
> > >> is not this task of blocking connections something for a firewall?
> > >
> > >The firewall blocks incoming connections where appropriate, yes, but it 
> > >doesn't stop one user binding to a port that another user expected to be able 
> > >to use. "Ownership" of ports (1-1023) shouldn't be something only root (via 
> > >CAP_NET_BIND_SERVICE) has. Lots of services also don't have standard ports 
> > >below 1024 and it's useful to be able to prevent users from binding to them 
> > >too.
> > 
> > Indeed.
> > 
> > 
> > There has been a feature in the security framework that probably did
> > not get much attention. It looks like YAGNI first, but on a closer look,
> > it becomes useful pretty quick - secondary_register.
> > 
> > As more and more simple LSM plugins pop up, stacking/chaining by means
> > of secondary_register becomes attractive again, especially if these LSMs
> > target different actions. This is probably the most useful thing why
> > the LSM interface should remain modular:
> > 
> > # Secure my files
> > modprobe apparmor
> > # -*- assuming apparmor implemented secondaries -*-
> > # Secure my ports
> > modprobe portac
> > # More rights to users
> > modprobe multiadm
> > # -*- whatever else comes along -*-
> 
> There is an issue that you overlook here and it is the successful
> composition of security models. While your idea is appealing it presents
> several problems. In your example you have 3 models with 3 policies.
> AppArmor which has its own port security mechanisms is a MAC model that
> from what I have seen appears to have a targeted least privilege policy.
> This means that AppArmor picks applications it wishes to secure and
> makes sure it can't do anything except what it needs to get its job
> done. Your module multiadm takes a user which is completely orthogonal
> to the concepts that AppArmor uses and gives him extra privileges. From
> what I have read and correct me if I am wrong portac deals with users
> instead of programs. Now lets try to reconcile this in a way that is
> sane to the user/administrator.
> 
> Apparmor wants to lock down some application, it gives the application
> access to a particular port, and the minimal set of privileges needed to
> execute the application. Since Apparmor is "easy to use" (note the
> quotes are to indicate they aren't my words not sarcasm) and SUSE comes
> with a targeted policy the user isn't concerned with it. Now multiadm
> comes along and an administrator wishes to grant extra rights to a user.
> This is fine with multiadm alone since it is the main security module,
> however we now have to compose this with AppArmor. So an administrator
> runs into an error running his application. Is this because his user
> isn't granted the proper escalated privileges? Is it because AppArmor
> needs an extra rule to run the application?  It could also be that our
> third module has blocked the application because it determined that even
> though multiadm specified that the user should have the elevated
> privileges to run the application that user shouldn't be able to bind to
> that port. 
> 
> There might be a better example to illustrate the problem however, this

The scariest thing to consider is programs which don't appropriately
handle failure.  So I don't know, maybe the system runs a remote logger
to which the multiadm policy gives some extra privs, but now the portac
module prevents it from sending its data.  And maybe, since the authors
never saw this failure as possible, the program happens to dump
sensitive data in a public readable place.  I *could* be more vague but
it'd be tough :)  But you get the idea.

Or, a better example, a privileged program reads some sensitive data -
as allowed by multiadm, writes it to a file, but apparmor prevented it
from chowning the file to the right user before writing, the program
kept writing anyway, and now the calling user hallyn, rather than the
privileged user sensitive_log_t, owns the file.

I ran into examples of this with the stacker module.  For instance
suddenly the capability module had to be changed so that it would allow
selinux xattrs to be written - leaving that arbitration to selinux.
That hadn't been necessary before since selinux simply didn't explicitly
call the secondary->inode_setxattr() hook.

Note I'm not arguing for or against, only arguing for caution :)

-serge
