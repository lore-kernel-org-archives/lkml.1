Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYIRNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYIRNLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYIRNL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:11:28 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:45781 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYIRNL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:11:27 -0400
Subject: Re: [Bug #11500] /proc/net bug related to selinux
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul.moore@hp.com>,
       jmorris@namei.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <m17i9axv1q.fsf@frodo.ebiederm.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <1221483926.30816.18.camel@moss-spartans.epoch.ncsc.mil>
	 <20080917125053.1f9ecf37.akpm@linux-foundation.org>
	 <200809171724.36269.paul.moore@hp.com>
	 <20080917144842.7df59f9e.akpm@linux-foundation.org>
	 <m17i9axv1q.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 18 Sep 2008 08:38:41 -0400
Message-Id: <1221741521.24048.17.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-09-17 at 15:32 -0700, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > We don't even know the extent of the damage yet.  Which distros were
> > affected? With which versions of which userspace packages?
> 
> This seems to me to be an extremely fragile selinux user space policy.
> In their code that derives security labels from path names.
> Why don't we have AppArmor in the kernel again?

I think I explained that one before - in the case of /proc, the only
stable basis we have for deducing the security properties / protection
requirements for a given entry is its name, and its name can be reliably
constructed from the kernel's internal proc_dir_entry tree w/o any
ambiguity or potential for userspace manipulation (unlike the pathname
returned by d_path for a normal file).  I'd agree that it isn't optimal,
but it is what we have.

> Further I don't see how we could have possibly have supported that user space
> policy.  How can we apply a user space defined label required by the selinux
> policy to a symlink that did not exist?

I'm not blaming anyone here, or trying to argue that the /proc/net
changes should be reverted.  What happened here is that a kernel
interface (/proc/net) changed in a subtle way that had a side effect on
permission checking, and we tried to hide that change at the time (in
terms of ensuring that the new /proc/self/net tree would still be
labeled correctly), and we missed the fact that there would still be a
new check on the symlink read that wouldn't be covered by existing
policy.

> Everything here sounds to me like that selinux policy is impossibly brittle.
> And anything that is that brittle I have no intention in claiming is a bug
> in proc.

I'm not arguing that this is a bug in proc or in selinux for that
matter.

I do however think that the mantra that we can't require users to update
policy for kernel changes is unsupportable in general.  The precise set
of permission checks on a given operation is not set in stone and it is
not part of the kernel/userland interface/contract.  Policy isn't
"userspace"; it governs what userspace can do, and it has to adapt to
kernel changes.

Users who are willing/able to run the latest kernel on their own w/o
waiting for a coordinated update of kernel and policy from their
distribution ought to be able to create a local policy module - it isn't
rocket science, and they can always fall back on audit2allow if they
need to do so.

-- 
Stephen Smalley
National Security Agency

