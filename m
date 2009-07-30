Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZG3UBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZG3UBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZG3UBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:01:47 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35561 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZG3UBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:01:46 -0400
Date: Thu, 30 Jul 2009 15:01:44 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       jwcart2@tycho.nsa.gov, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, alan@lxorguk.ukuu.org.uk,
       kees@outflux.net, csellers@tresys.com,
       penguin-kernel@i-love.sakura.ne.jp, Andrew Morgan <morgan@kernel.org>
Subject: Re: [PATCH -v3 1/3] Capabilities: move cap_file_mmap to commoncap.c
Message-ID: <20090730200144.GB20292@us.ibm.com>
References: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com> <20090730051426.GA6082@us.ibm.com> <1248968428.2597.79.camel@localhost> <20090730155403.GA13939@us.ibm.com> <1248969492.11627.172.camel@moss-pluto.epoch.ncsc.mil> <1248976252.2771.1.camel@localhost> <1248982958.11627.187.camel@moss-pluto.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248982958.11627.187.camel@moss-pluto.epoch.ncsc.mil>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Thu, 2009-07-30 at 13:50 -0400, Eric Paris wrote:
> > On Thu, 2009-07-30 at 11:58 -0400, Stephen Smalley wrote:
> > > On Thu, 2009-07-30 at 10:54 -0500, Serge E. Hallyn wrote:
> > > > Quoting Eric Paris (eparis@redhat.com):
> > > > > On Thu, 2009-07-30 at 00:14 -0500, Serge E. Hallyn wrote:
> > > > > > Quoting Eric Paris (eparis@redhat.com):
> > > > > > > Currently we duplicate the mmap_min_addr test in cap_file_mmap and in
> > > > > > > security_file_mmap if !CONFIG_SECURITY.  This patch moves cap_file_mmap
> > > > > > > into commoncap.c and then calls that function directly from
> > > > > > > security_file_mmap ifndef CONFIG_SECURITY like all of the other capability
> > > > > > > checks are done.
> > > > > > 
> > > > > > It also
> > > > > > 
> > > > > > 	1. changes the return value in error case from -EACCES to
> > > > > > 	   -EPERM
> > > > > > 	2. no onger sets PF_SUPERPRIV in t->flags if the capability
> > > > > > 	   is used.
> > > > > > 
> > > > > > Do we care about these?
> > > > > 
> > > > > Personally, not really, but I'll gladly put them back if you care.   #2
> > > > > seems more interesting to me than number 1.   I actually kinda like
> > > > > getting EPERM from caps rather than EACCES since them I know if I was
> > > > > denied by selinux or by caps.....
> > > > > 
> > > > > -Eric
> > > > 
> > > > Yup, I asked bc I didn't particularly care myself.
> > > > 
> > > > I think I agree with you about -EPERM being better anyway.  However I
> > > > (now) think in this case PF_SUPERPRIV definately should be set, as this
> > > > is a clear use of a capability to do something that couldn't have been
> > > > done without it.
> > > 
> > > On a related but different note, we should consider all current uses of
> > > cap_capable(), as they represent capability checks that will not be
> > > subject to a further restrictive check by other security modules.  In
> > > this case and in the vm_enough_memory case, that is intentional, but not
> > > so clear for other uses in commoncap.c.
> > 
> > Most of commoncap.c is called either as a secondary hook from the active
> > lsm (aka selinux calls the commoncap.c functions) or in the !
> > CONFIG_SECURITY case.
> > 
> > I'll audit this afternoon to see which of them might not fit these
> > rules....
> 
> That isn't what I meant.  Most of the commoncap functions call capable()
> rather than directly calling cap_capable(), thereby causing:
> - PF_SUPERPRIV to be set, and
> - The primary security module (e.g. SELinux) to apply its own
> restrictive check.
> 
> That is useful as it allows SELinux or AppArmor or TOMOYO to veto e.g.
> CAP_SYS_PTRACE without replicating the same logic within its own hook.
> 
> The current exceptions are:
> cap_inh_is_capped() called from cap_capset(),
> cap_task_prctl() in the PR_SET_SECUREBITS case,
> cap_vm_enough_memory(),
> cap_file_mmap() after your patch.
> 
> The latter two are indeed cases where we made a conscious choice that
> SELinux would not apply its capability check against policy.  But the
> first two are unclear to me.

cap_inh_is_capped:

I'm not sure why it's cap_capable() instead of capable().  However, if we
switch to using capable(), then we should switch the conditions in the caller
around, since at the moment just because the capable() check returned true
doesn't mean that we actually end up needing it.

(CC:ing Andrew Morgan as I believe he wrote this and may have had a reason)

cap_task_prctl: I don't see any reason why that shouldn't be capable().

cap_vm_enough_memory(): I seem to recall we explicitly decided that we
did not want PF_SUPERPRIV set in this case.

cap_file_mmap(): well now that you mention it, it does seem like SELinux
would want a say in whether the task gets CAP_SYS_RAWIO here, so maybe
it should be capable() after all?

-serge
