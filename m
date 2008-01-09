Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYAIQvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYAIQvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYAIQva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:51:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYAIQv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:51:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
References: <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>, kmacmill@redhat.com
Cc: dhowells@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 09 Jan 2008 16:51:24 +0000
Message-ID: <17868.1199897484@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay.  I can:

 (1) Have cachefilesd (the daemon) pass a security context string to the
     cachefiles kernel module, which can then convert it to a secID.  It'll
     require a security_secctx_to_secid() function, but I'm fairly certain I
     have a patch to add such kicking around somewhere.

 (2) Make security_task_kernel_act_as() take a task_security struct and a
     secID and just assign the latter to the former.  I'm not sure it makes
     sense to do any checks here, other than checking that under SELinux the
     secID is of SECCLASS_PROCESS class.

However, I need to write a check that the cachefilesd daemon is permitted to
nominate the secID it did.  Can someone tell me how to do this?  The obvious
way to do this is to add another PROCESS__xxx security permit specifically for
cachefiles, but that seems like a waste of a bit when there are only two spare
bits.

	avc_has_perm(daemon_tsec->sid, nominated_sid,
		     SECCLASS_PROCESS, PROCESS__CACHEFILES_USE, NULL);

Now, I recall the addition of another security class being mentioned, which
presumably would give something like:

	avc_has_perm(daemon_tsec->sid, nominated_sid,
		     SECCLASS_CACHE, CACHE__USE_AS_OVERRIDE, NULL);

And I assume this doesn't care if one, the other or both of the two SIDs
mentioned are of SECCLASS_PROCESS rather than of SECCLASS_CACHE.

David
