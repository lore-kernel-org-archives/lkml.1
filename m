Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbZELVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbZELVxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZELVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:53:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49967 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZELVxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:53:23 -0400
Subject: Re: [PATCH] IMA: do not measure everything opened by root bydefault
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       Dave Safford <safford@watson.ibm.com>
In-Reply-To: <1242163638.3142.8.camel@dhcp231-142.rdu.redhat.com>
References: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
	 <1242163111.8494.23.camel@dyn9002018117.watson.ibm.com>
	 <1242163638.3142.8.camel@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 17:53:21 -0400
Message-Id: <1242165201.8494.36.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 17:27 -0400, Eric Paris wrote:
> On Tue, 2009-05-12 at 17:18 -0400, Mimi Zohar wrote:
> > On Tue, 2009-05-12 at 15:14 -0400, Eric Paris wrote:
> > > The IMA default policy measures every single file opened by root.  This is
> > > terrible for most users.  Consider a system (like mine) with virtual machine
> > > images.  When those images are touched (which happens at boot for me) those
> > > images are measured.  This is just way too much for the default case.
> > > 
> > > Signed-off-by: Eric Paris <eparis@redhat.com>
> > 
> > The question of what to measure is a major issue. If you measure too
> > much, performance is affected, but if you measure too little, then the
> > measurement list will not contain everything that could affect the
> > Trusted Computing Base(TCB), such as configuration files and scripts.
> > 
> > The solution is not to remove the rule that measures everything read
> > by root, but to replace the default IMA configuration file with an LSM
> > specific one, which should be done early in the etc init scripts or
> > initrd.  LTP contains a sample script to replace the default IMA policy
> > (testcases/kernel/security/integrity/ima/tests/ima_policy.sh).
> > 
> > The following SELinux integrity rule, prevents /var/log/messages from
> > being measured. (Dependent on "integrity: lsm audit rule matching fix"
> > patch in the security-testing tree.)
> > 
> > dont_measure func=PATH_CHECK mask=MAY_READ obj_type=var_log_t
> > 
> > By defining an equivalent SELinux integrity rule for each virtual
> > machine image type, the virtual machine images will not be measured.
> > This is far better than not measuring everything in the TCB.
> > 
> > Mimi Zohar
> 
> While the TCB might be interesting to you I'm going to guess that 99% of
> users don't care at all.  I don't think the kernel should ship with such
> an overhead just to make the options available to the few.
> 
> Every distro that wants to ship with IMA compiled in the kernel is going
> to need to carry their own ima policy and they are going to have to
> change userspace so they can load that policy by default.  This is turn
> means that every distro is going to, by default, leave ima
> uncustomizable since we can only load a single policy.

I'm not sure I understand the problem here. Although the policy can only
be loaded once per boot, it could be based on a configuration file
like /etc/measure, which the distro could define. Any system specific
changes could be made to this file.

Mimi Zohar

> Maybe we'd like to allow multiple policy loads?  That doesn't seem great
> to me...
> 
> If the 'right default' for every distro's common user is to not read and
> measure every single file root touches it's the 'right default' in the
> kernel.  Any distro owner want to disagree?
> 
> -Eric
> 

