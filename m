Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbXLJV3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbXLJV3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXLJV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:28:59 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:45718 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbXLJV25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:28:57 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <25572.1197320887@redhat.com>
References: <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com>  <25572.1197320887@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 10 Dec 2007 16:27:48 -0500
Message-Id: <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-10 at 21:08 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Otherwise, only other issue I have with this interface is it won't
> > generalize to dealing with nfsd, where we want to set the acting context
> > to a context we obtain from or determine based upon the client.
> 
> Are you speaking of security_kernel_act_as() and security_create_files_as()
> specifically?  Or the task_struct::act_as override pointer in general?

security_kernel_act_as()

> I don't really know how nfsd wants to obtain and set its LSM context, so it's
> a bit difficult for me to make something that works for nfsd as well as
> cachefiles.

It would get a context from the client or from a local configuration
that would map security-unaware clients to a default context, and then
want to assume that context for the particular operation.  No transition
involved.

> > Why can't cachefilesd just push a context into the kernel and pass that
> > into the hook as the acting context,
> 
> How does cachefilesd come up with such a context?  Grab it from
> /etc/cachefilesd.conf?

>From a config file whose pathname would be provided by libselinux (ala
the way in which dbusd imports contexts), or directly as a context
returned by a libselinux function.  Has to be done that way so that it
can be set differently for different policy types (strict, targeted,
mls).

Naturally, cachefiles (the kernel module) would invoke a security hook
to check whether the daemon is allowed to set the specified context.

> I use to do that, but someone objected...  Possibly Karl MacMillan.

Yes, but I think I disagreed then too.

> > and then nfsd can do likewise using the context provided by the client or
> > obtained locally from exports for ordinary clients?  Avoids the transition
> > SID computation altogether within the kernel and makes this more generic.
> 
> I seem to remember that I was told that it should be done this way, possibly
> by Karl MacMillan, but I don't remember exactly.
> 
> Now it's configured by cachefilesd.te:
> 
> 	type_transition cachefilesd_t kernel_t : process cachefiles_kernel_t;

It doesn't fit with how other users of security_kernel_act_as() will
likely want to work (they will want to just set the context to a
specified value, whether one obtained from the client or from some local
source), nor with how type transitions normally work (exec, with the
program type as the second type field).  I think it will just cause
confusion and subtle breakage.

-- 
Stephen Smalley
National Security Agency

