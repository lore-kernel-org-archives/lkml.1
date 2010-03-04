Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0CDPVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:21:55 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:49047 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab0CDPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:21:54 -0500
X-SMTPAUTH-B2: 
X-SENDER-IP: 83.227.31.74
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An46AOdej0tT4x9KPGdsb2JhbACHXpNgDAEBAQE3LbdhhHwE
X-IronPort-AV: E=Sophos;i="4.49,581,1262559600"; 
   d="scan'208";a="45772939"
From: Jon Severinsson <jon@severinsson.net>
To: linux-cifs-client@lists.samba.org
Subject: Re: [RFC PATCH] CIFS posix acl permission checking
Date: Thu, 4 Mar 2010 16:21:41 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo-r7; KDE/4.3.5; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201003041150.08341.jon@severinsson.net> <1267710262.2375.280.camel@localhost>
In-Reply-To: <1267710262.2375.280.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003041621.44577.jon@severinsson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Den Thursday 04 March 2010 14:44:22 skrev du:
> although you did a good job with the code itself, I have to say that I
> think the approach is just wrong. Checking ACLs on the client is simply
> the wrong way to go. It is just racy and it is not authoritative anyway.

The problem with this approach is that the server checks the permissions using 
the credentials of the user doing the mount, not the user trying to access the 
file. This leaves a big gaping security hole on any multiuser system, and even 
on single user systems you sill loose any benefits from privilege separation 
(such as running system daemons as an unprivileged user).

So while it is possible to do it that way (by including the noperm mount 
option when mounting), it is generally a bad idea to do so.

As you are going to do permission checking on the client side anyway, I do not 
see the problem consulting the acl when doing so. As not consulting the acl 
only restricts access to files I'm supposed to have access to (and indeed has 
access to if using smbclient), it only results in me being forced to use the 
uid, gid, file_mode, and/or dir_mode mount options, at witch point I can't see 
whether I have access or not other than by trying to do the access, as it will 
always look as if I have access.

> It is like trying to look up a path using a cached directory listing and
> then try to open by inode. It simply doesn't work, by the time you do
> that, things may have been completely changed on the server.

I'm afraid I'm not sure exactly what you mean by this section, could you 
please clarify.

> And we are not counting the problem that with CIFS (and samba in
> particular) the client have no way to know what are the real credentials
> assigned to the session and that the client may have no idea what the
> users and groups in the ACL are (if client and server do not use exactly
> the same user database).

Of course this only works as intended if the client and server shares the same 
user database. In my case that is through ldap, but could as well be nis, 
winbind or some other similar nss module. However, that is the case already, 
without any acl, as UNIX permission bits have exactly the same problem. If you 
are mounting something from a server with a different user database, you'll 
need to use the uid, gid, file_mode, and/or dir_mode mount options, but that is 
no different from the situation without this patch.

> The right way is to let the server enforce ACLs, and use multisessions
> mounts if multiple users are involved. Time would be better spent
> working in that direction IMO.

If by multisession mounts you mean something like nfs, where the client tells 
the server what user is trying to do the access, that can only work if either 
the server blindly trusts the client (as in nfs3) or with some complex 
cryptographic token infrastructure (as in nfs4 with kerberos authentication). 
The first case is simply not very secure, and a cryptographic token 
infrastructure is needlessly complex. If someone were to work on making 
setting up a cryptographic token infrastructure simpler I would love that, but 
I'm not even remotely qualified to do so, and in the meantime the current samba 
infrastructure fulfils all my need, except that the cifs module erroneously 
refuses me the rights I'm granted through an acl.

> Simo.

Regards
Jon Severinsson
