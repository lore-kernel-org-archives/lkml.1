Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0CDPv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:51:56 -0500
Received: from fn.samba.org ([216.83.154.106]:37124 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0CDPvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:51:54 -0500
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission
 checking
From: simo <idra@samba.org>
To: Jon Severinsson <jon@severinsson.net>
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <201003041621.44577.jon@severinsson.net>
References: <201003041150.08341.jon@severinsson.net>
	 <1267710262.2375.280.camel@localhost>
	 <201003041621.44577.jon@severinsson.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Samba Team
Date: Thu, 04 Mar 2010 10:51:53 -0500
Message-ID: <1267717913.2375.298.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 16:21 +0100, Jon Severinsson wrote:
> Den Thursday 04 March 2010 14:44:22 skrev du:
> > although you did a good job with the code itself, I have to say that I
> > think the approach is just wrong. Checking ACLs on the client is simply
> > the wrong way to go. It is just racy and it is not authoritative anyway.
> 
> The problem with this approach is that the server checks the permissions using 
> the credentials of the user doing the mount, not the user trying to access the 
> file. This leaves a big gaping security hole on any multiuser system, and even 
> on single user systems you sill loose any benefits from privilege separation 
> (such as running system daemons as an unprivileged user).

Letting a different user access the mount point *is* a security
violation in itself. The CIFS security model lies in per user sessions.
The right way to fix the problem is multi-session mounts. Allowing a
different user to use a user session is a violation of the security
model of CIFS.

Trying to put a bandaid on a gross policy and security violation is not
really useful :)

> So while it is possible to do it that way (by including the noperm mount 
> option when mounting), it is generally a bad idea to do so.
> 
> As you are going to do permission checking on the client side anyway,

This is the problem, you shouldn't. CIFS is not NFS, you are abusing
your access credentials simply because they are stored in the kernel.

>  I do not 
> see the problem consulting the acl when doing so. As not consulting the acl 
> only restricts access to files I'm supposed to have access to (and indeed has 
> access to if using smbclient), it only results in me being forced to use the 
> uid, gid, file_mode, and/or dir_mode mount options, at witch point I can't see 
> whether I have access or not other than by trying to do the access, as it will 
> always look as if I have access.

Sorry, but just piling up errors on top of other errors does not really
make the situation better.

> > And we are not counting the problem that with CIFS (and samba in
> > particular) the client have no way to know what are the real credentials
> > assigned to the session and that the client may have no idea what the
> > users and groups in the ACL are (if client and server do not use exactly
> > the same user database).
> 
> Of course this only works as intended if the client and server shares the same 
> user database. In my case that is through ldap, but could as well be nis, 
> winbind or some other similar nss module. However, that is the case already, 
> without any acl, as UNIX permission bits have exactly the same problem. If you 
> are mounting something from a server with a different user database, you'll 
> need to use the uid, gid, file_mode, and/or dir_mode mount options, but that is 
> no different from the situation without this patch.

Yes, the current situation is not right either, and definitely need
fixing.

> > The right way is to let the server enforce ACLs, and use multisessions
> > mounts if multiple users are involved. Time would be better spent
> > working in that direction IMO.
> 
> If by multisession mounts you mean something like nfs, where the client tells 
> the server what user is trying to do the access, that can only work if either 
> the server blindly trusts the client (as in nfs3) or with some complex 
> cryptographic token infrastructure (as in nfs4 with kerberos authentication). 

No, you cannot "tell" the server who you are like in NFS, this is the
main point. CIFS has a security model that is different from (old) NFS.
In CIFS each session is authenticated, that's why you should have
multi-session if you want to access the same mount point as different
users. Like NFSv4 you should authenticate each user first, create it's
own session and then let him in, or deny access completely (or degrade
access to the guest user if the remote server allow you so).

> The first case is simply not very secure,

The first case is simply not possible with CIFS.

>  and a cryptographic token infrastructure is needlessly complex.

Yet there is no real alternative, short of changing the CIFS model to
allow the server to trust the client machine.

> If someone were to work on making 
> setting up a cryptographic token infrastructure simpler I would love that, but 
> I'm not even remotely qualified to do so, and in the meantime the current samba 
> infrastructure fulfils all my need, except that the cifs module erroneously 
> refuses me the rights I'm granted through an acl.

We already have the cifs.upcall thing, which is the prerequisite to get
multi-session work at least with kerberos. And it can be easily extended
to allow also to use NTLM cached credentials.

That is a goal that would be better pursuing.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo@samba.org>
Principal Software Engineer at Red Hat, Inc. <simo@redhat.com>

