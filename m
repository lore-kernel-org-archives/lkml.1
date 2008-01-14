Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476AbYANPT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbYANPT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYANPTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:19:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYANPTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:19:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <929556.69990.qm@web36606.mail.mud.yahoo.com>
References: <929556.69990.qm@web36606.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Daniel J Walsh <dwalsh@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 14 Jan 2008 15:19:12 +0000
Message-ID: <22553.1200323952@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> Yes, and I would recommend doing so to avoid permission races.
> You're going to have to deal with the case where step (2) fails
> even if you have step (1), so the "test and set" mindset seems
> prudent to me.

Looking at SELinux, that doesn't get rid of the permission race because there's
no locking.  This may be different for other models.

I was thinking of having steps (2) and (4) not do any checking, but rather
assume that the caller has done the checks before calling the set routines,
possibly by calling the hooks mentioned in (1) and (3).

My main problem is that I don't know how NFSd wants to do things.  I suppose
there *ought* to be rules that say what NFSd is allowed to do.

> > and condense (3) and (4) into a single op.  That, however, might make
> > the ops unusable by nfsd,
> > which may well want to bypass the checks or do them elsewhere.
> 
> Again, I don't think you're doing yourself any favors with a separate
> test operation.

It doesn't matter to cachefiles, but it might matter to other users:-/

> On (4) are you suggesting a third attribute value? There's the secid
> of the task originally, the secid you're going to use to do the access
> checks, and the secid you're going to set the file to on creation.

That's correct.  Let me summarise:

 (1) The daemon has an active process security ID (say A).  When the daemon
     nominates an override process security ID (say B) to be used by the
     kernel, the cachefiles module asks the LSM to check that A is allowed to
     nominate B for this purpose.

 (2) The cachefiles module is given a path under which its cache exists.  The
     directory at the base of this path has its own security ID (say C).
     cachefiles wants to create new files in the cache with the same security
     ID as that directory (ie. C).

     However, when cachefiles is creating files in the cache, the security of
     whatever process is doing the access will be overridden with B, so
     cachefiles asks the LSM to check that B is allowed create files as C.

     Note that this is an instantaneous check in the cache startup stage.  This
     allows caching to be aborted early if the security policy does not permit
     B to create Cs.  Technically this check is superfluous as it's re-checked
     each time a vfs_mkdir() or vfs_create() are called.

> > Any thoughts?
> 
> Let me see if I understand your current scheme.
> 
> You want a (object) secid that is used to access the task.

That depends on what you mean.  cachefilesd (the daemon) will be run with a
security label because there's a security model in place.

I don't actually need to access the daemon, but the daemon does need to do
things for which it requires permission grants.

> You want a (subject) secid that the task uses to accesses objects.

Correct.  This is used as an override by any task that accesses the cache
indirectly through the cachefiles module.

The cachefilesd daemon has its own secid with which it accesses the cache
directly.  The sets of permissions that must be granted by the module's
override subjective secid and by the daemon's subjective secid aren't
identical.

> You want a (newobject) secid that an object gets on creation.

File and directory objects, yes.  The cache is stored on disk as a collection
of files and directories, each of which needs labelling.

> And you want them all to be distinct and settable.

Well, they don't technically have to be different.  The daemon and the module
can be given the same secid, for instance.  However, that secid then grants the
daemon permission to anything the module can, and vice versa.

The third secid is a file label rather than a process label, and so may or may
not have to be different anyway, depending on the model.

David
