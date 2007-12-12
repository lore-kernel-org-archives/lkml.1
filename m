Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbXLLSiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbXLLSiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXLLSin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:38:43 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:63589 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbXLLSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:38:42 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <336290.70309.qm@web36603.mail.mud.yahoo.com>
References: <336290.70309.qm@web36603.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 12 Dec 2007 13:12:54 -0500
Message-Id: <1197483174.1125.103.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 08:51 -0800, Casey Schaufler wrote:
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > On Tue, 2007-12-11 at 15:04 -0800, Casey Schaufler wrote:
> > > --- David Howells <dhowells@redhat.com> wrote:
> > > 
> > > > Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > > > 
> > > > > All your code has to do is invoke a function provided by libselinux.
> > > > 
> > > > Calling libselinux means it's a special case for a specific LSM.
> > > > 
> > > > I think the best way to do this, then, has to be to dlopen the
> > appropriate
> > > > LSM
> > > > library.  That way I don't need to do any conditional compilation or
> > linking,
> > > > but can build all the bits in to cachefilesd and have the appropriate one
> > > > selected by the /etc/cachefilesd.conf.
> > > > 
> > > > So, what do I invoke in libselinux, how do I configure it, and how do I
> > > > integrate the config into my RPM and install it?
> > > > 
> > > > And then what does it give me that I can hand to the kernel (a context
> > string
> > > > for SELinux, I presume), how do I get the kernel to make a check on it,
> > how
> > > > do
> > > > I configure the check and how do I install that config from my RPM (I
> > presume
> > > > I just need to modify the .fc, .if and .te files that I have already)?
> > > 
> > > That seems like an awful lot of work. I suggest that what you
> > > put in /etc/cachefilesd.conf is a line like:
> > > 
> > >    security_context:"<whatever>"
> > > 
> > > and have your daemon pass "<whatever>" into the kernel using
> > > a cachefile mechanism. The kernel code can call
> > > security_secctx_to_secid("<whatever>") to determine if it's valid.
> > > No need to invoke LSM specific code in your daemon. You may need
> > > to have an application, say cachefileselinuxcontext, that will
> > > read the current policy and spit out an appropriate value of
> > > "<whatever>", but that can be separate and LSM specific without
> > > mucking up your basic infrastructure applications. 
> > 
> > That sounds workable, although I think he will want a more specific hook
> > than security_secctx_to_secid(), or possibly a second hook call, that
> > would not only validate the context but authorize the use of it by the
> > cachefilesd process.
> 
> What sort of authorization are you thinking of? I would expect
> that to have been done by cachefileselinuxcontext (or
> cachefilesspiffylsmcontext) up in userspace. If you're going to
> rely on userspace applications for policy enforcement they need
> to be good enough to count on after all.

In Smack, I'd expect that you'd want to apply a CAP_MAC_OVERRIDE check.
In SELinux, we'd apply a permission check between the task's security
context and the specified security context so that we can control the
pairwise relationship between them via allow rules and constraints.

The kernel has no way of knowing whether the context was determined by
cachefileselinuxcontext or not; it only knows that some task is trying
to write some value to /cachefiles/context or whatever the kernel
interface is, and it needs to apply some authorization check there,
where that check is security-module-specific.

> > And then the security_task_kernel_act_as() hook
> > just takes the secid as input rather than the task struct of the daemon,
> > and applies it.  At that point, nfsd can use the same mechanism for
> > setting the acting SID based on the client process after doing its own
> > authorization.
> 
> good points all, in spite of my personal distaste for secids.

-- 
Stephen Smalley
National Security Agency

