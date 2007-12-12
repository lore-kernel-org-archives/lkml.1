Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXLLQvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXLLQvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbXLLQve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:51:34 -0500
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:38401 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755921AbXLLQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:51:33 -0500
X-YMail-OSG: _Evh4QAVM1nxEc6lsujoExfOPRHa9v3ZXw2PKTh6
X-RocketYMMF: rancidfat
Date: Wed, 12 Dec 2007 08:51:31 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <1197473127.1125.50.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <336290.70309.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Tue, 2007-12-11 at 15:04 -0800, Casey Schaufler wrote:
> > --- David Howells <dhowells@redhat.com> wrote:
> > 
> > > Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > > 
> > > > All your code has to do is invoke a function provided by libselinux.
> > > 
> > > Calling libselinux means it's a special case for a specific LSM.
> > > 
> > > I think the best way to do this, then, has to be to dlopen the
> appropriate
> > > LSM
> > > library.  That way I don't need to do any conditional compilation or
> linking,
> > > but can build all the bits in to cachefilesd and have the appropriate one
> > > selected by the /etc/cachefilesd.conf.
> > > 
> > > So, what do I invoke in libselinux, how do I configure it, and how do I
> > > integrate the config into my RPM and install it?
> > > 
> > > And then what does it give me that I can hand to the kernel (a context
> string
> > > for SELinux, I presume), how do I get the kernel to make a check on it,
> how
> > > do
> > > I configure the check and how do I install that config from my RPM (I
> presume
> > > I just need to modify the .fc, .if and .te files that I have already)?
> > 
> > That seems like an awful lot of work. I suggest that what you
> > put in /etc/cachefilesd.conf is a line like:
> > 
> >    security_context:"<whatever>"
> > 
> > and have your daemon pass "<whatever>" into the kernel using
> > a cachefile mechanism. The kernel code can call
> > security_secctx_to_secid("<whatever>") to determine if it's valid.
> > No need to invoke LSM specific code in your daemon. You may need
> > to have an application, say cachefileselinuxcontext, that will
> > read the current policy and spit out an appropriate value of
> > "<whatever>", but that can be separate and LSM specific without
> > mucking up your basic infrastructure applications. 
> 
> That sounds workable, although I think he will want a more specific hook
> than security_secctx_to_secid(), or possibly a second hook call, that
> would not only validate the context but authorize the use of it by the
> cachefilesd process.

What sort of authorization are you thinking of? I would expect
that to have been done by cachefileselinuxcontext (or
cachefilesspiffylsmcontext) up in userspace. If you're going to
rely on userspace applications for policy enforcement they need
to be good enough to count on after all.

> And then the security_task_kernel_act_as() hook
> just takes the secid as input rather than the task struct of the daemon,
> and applies it.  At that point, nfsd can use the same mechanism for
> setting the acting SID based on the client process after doing its own
> authorization.

good points all, in spite of my personal distaste for secids.


Casey Schaufler
casey@schaufler-ca.com
