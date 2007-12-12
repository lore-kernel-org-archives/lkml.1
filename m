Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXLLTe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXLLTe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXLLTet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:34:49 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:53557 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbXLLTes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:34:48 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: casey@schaufler-ca.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <32168.1197484170@redhat.com>
References: <1197473127.1125.50.camel@moss-spartans.epoch.ncsc.mil>
	 <81862.27432.qm@web36605.mail.mud.yahoo.com>  <32168.1197484170@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 12 Dec 2007 14:33:41 -0500
Message-Id: <1197488021.1125.138.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 18:29 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > That sounds workable, although I think he will want a more specific hook
> > than security_secctx_to_secid(), or possibly a second hook call, that
> > would not only validate the context but authorize the use of it by the
> > cachefilesd process.  And then the security_task_kernel_act_as() hook
> > just takes the secid as input rather than the task struct of the daemon,
> > and applies it.  At that point, nfsd can use the same mechanism for
> > setting the acting SID based on the client process after doing its own
> > authorization.
> 
> I thought using secids was verboten as it made things too specific.

Well, that has been Casey's objection in the past to it, but he seems to
have accepted their use now for certain purposes, and they are already
entrenched in the audit and labeled networking interfaces.

> Have you example code for the security hook you mention?  I'm not sure I
> understand why security_secctx_to_secid() is not sufficient.

security_secctx_to_secid() would just validate and map a context string
to a secid.  It wouldn't perform any permission check, as the caller
might a kernel-internal user that is just mapping back and forth like
current users of security_secid_to_secctx, or it might be something that
ultimately originated from userspace but the hook has no way of knowing
why or what set of checks would be appropriate.  You'd need a more
specific hook for the authorization, one that would perform a permission
check, e.g. an avc_has_perm() call.  Which likely requires defining a
new class and permissions for your cachefiles kernel interface.

> Or is it that I need something that takes a secctx, converts it to a secid and
> authorises its use all in one go?  If it's this, why can't that be rolles into
> security_task_kernel_act_as()?  That sets up a task_security struct which is
> then switched in and out without consultation of the LSM.

I was under the impression that security_task_kernel_act_as() was being
used to switch the current task to an acting context, not to initially
set up a struct for later use.  If you go with the latter approach, then
what is the lifecycle on that struct?

BTW, it gets a little confusing with your use of task_security for the
full task security state vs our existing use of task_security_struct
within SELinux for the task's LSM security blob.  I suppose ours could
be renamed to task_selinux.

-- 
Stephen Smalley
National Security Agency

