Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZG3TsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZG3TsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZG3TsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:48:06 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:53217 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZG3TsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:48:04 -0400
Subject: Re: [PATCH -v3 1/3] Capabilities: move cap_file_mmap to commoncap.c
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       jwcart2@tycho.nsa.gov, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, alan@lxorguk.ukuu.org.uk,
       kees@outflux.net, csellers@tresys.com,
       penguin-kernel@i-love.sakura.ne.jp
In-Reply-To: <1248978679.2771.24.camel@localhost>
References: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com>
	 <20090730051426.GA6082@us.ibm.com> <1248968428.2597.79.camel@localhost>
	 <20090730155403.GA13939@us.ibm.com>
	 <1248969492.11627.172.camel@moss-pluto.epoch.ncsc.mil>
	 <1248976252.2771.1.camel@localhost>  <1248978679.2771.24.camel@localhost>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 30 Jul 2009 15:47:47 -0400
Message-Id: <1248983267.11627.193.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 14:31 -0400, Eric Paris wrote:
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
> I just went through all of the cap_* function in commoncap.c to see
> which of them are being or are not being called from the selinux hooks.
> Only 3 of them look interesting.
> 
> cap_inode_setxattr
> cap_inode_removexattr
> cap_vm_enough_memory
> 
> All of the other functions are either called from hooks.c or SELinux
> does not define that LSM hook, so it just defaults to the cap_* hook.
> 
> These 3 are all a bit odd because the logic inside the cap_ hook is
> duplicated inside the selinux_ hook.  I'd much rather see the selinux_
> hook call the cap_ hook.  I'm going to think on that topic, but it's a
> different set of patches and I don't see missing checks today as the
> logic seems to line up.

Yes, those 3 aren't a problem.  I suppose selinux_inode_setotherxattr()
could be changed to call cap_inode_setxattr() before the SELinux setattr
check, as that would only happen in the non-selinux attribute case.

-- 
Stephen Smalley
National Security Agency

