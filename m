Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXLMOvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXLMOvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbXLMOve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:51:34 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:61614 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbXLMOvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:51:33 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: casey@schaufler-ca.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <668.1197499783@redhat.com>
References: <1197488021.1125.138.camel@moss-spartans.epoch.ncsc.mil>
	 <1197473127.1125.50.camel@moss-spartans.epoch.ncsc.mil>
	 <81862.27432.qm@web36605.mail.mud.yahoo.com> <32168.1197484170@redhat.com>
	 <668.1197499783@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 13 Dec 2007 09:49:44 -0500
Message-Id: <1197557384.20226.21.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 22:49 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > > Have you example code for the security hook you mention?  I'm not sure I
> > > understand why security_secctx_to_secid() is not sufficient.
> > 
> > security_secctx_to_secid() would just validate and map a context string to a
> > secid.
> 
> Validate as in check it's a valid string?  Okay, I see that.

Yes.

> > It wouldn't perform any permission check, as the caller might a
> > kernel-internal user that is just mapping back and forth like current users
> > of security_secid_to_secctx, or it might be something that ultimately
> > originated from userspace but the hook has no way of knowing why or what set
> > of checks would be appropriate.  You'd need a more specific hook for the
> > authorization, one that would perform a permission check, e.g. an
> > avc_has_perm() call.  Which likely requires defining a new class and
> > permissions for your cachefiles kernel interface.
> 
> Hmmm...  This is sounding very not-simple.  I don't know how to do this.  I
> can probably guess the kernel side by looking at how SECCLASS_KEY is done, but
> it sounds like it involves changes to the userspace policy processing tools
> too.

Not the tools, just the policy definitions.  Dan can help with that.
You add the definitions to the policy, then there is a script to
regenerate the SELinux kernel headers that #define the SECCLASS_ and
permission values.

> It also sounds a bit like overkill, but if it's the right way then I guess it
> has to be done.
> 
> What does the security class represent in this case?  And can it be generalised
> to apply to non-cachefiles stuff too?

It is just a way of carving up the permission space, typically based on
object type, but it can essentially be arbitrary.  The check in this
case seems specific to cachefiles since it is controlling an operation
on the /dev/cachefiles interface that only applies to cachefiles
internal operations, so making a cachefiles class seems reasonable.

If this was instead just a generic "set my acting context to <value>"
operation, then it could be a generic /proc/self/attr/active interface
with an generic implementation and permission check, but here we aren't
setting the active context of the cachefilesd daemon but rather of the
cachefiles kernel module.

The other approach that I suggested a long time ago is to exempt the
cachefiles kernel module internal operations from SELinux permission
checks altogether by setting some task flag when performing those
operations and checking for that flag either on entry to the security_
static inlines, similar to the inode private flag, or within SELinux
itself.  Rationale being that the cachefiles kernel module can already
do what it wants and the SELinux permission checks are really about
controlling what userspace can do.  Then we don't have to invent a
context for the kernel module at all or worry about subtle breakage when
some permission is missing from its policy.

> > > Or is it that I need something that takes a secctx, converts it to a secid
> > > and authorises its use all in one go?  If it's this, why can't that be
> > > rolles into security_task_kernel_act_as()?  That sets up a task_security
> > > struct which is then switched in and out without consultation of the LSM.
> > 
> > I was under the impression that security_task_kernel_act_as() was being used
> > to switch the current task to an acting context, not to initially set up a
> > struct for later use.
> 
> Definitely the latter.  I guess I wasn't very clear in the patch description.
> It also sounds like I need to adjust the naming of certain functions.
> 
> > If you go with the latter approach, then what is the lifecycle on that
> > struct?
> 
>  (1) You create a new task_security struct
> 
>  (2) You fill in the fsuid, fsgid, etc.
> 
>  (3) You request that the LSM security pointer in it be set to point to the
>      context you want (at the moment this is done by attempting a transition
>      from the daemon's context):
> 
> 	ret = security_transition_sid(dtsec->sid, SECINITSID_KERNEL,
> 				      SECCLASS_PROCESS, &ksid);
> 
>      and, in the current code, it returns an error if you're not allowed to do
>      that.  But instead you'd ask it to set a specific context, and it'd set
>      that if you're permitted to do that, and give you an error if you're not.
> 
>  (4) You then use the task_security at will to override the task->act_as
>      pointer in whatever task(s) you're operating on behalf of at the moment.
> 
>  (5) When you cease operating on the behalf of a task, you revert its act_as
>      pointer and drop a reference to your task_security struct.
> 
>  (6) When the last ref to the task_security struct goes away, the LSM data
>      attached to it is released, as are its groups and keyrings.
> 
> > BTW, it gets a little confusing with your use of task_security for the full
> > task security state vs our existing use of task_security_struct within
> > SELinux for the task's LSM security blob.
> 
> I know.  I thought about it quite a bit, but the problem is there's so much
> overloading of various words (eg: security, context), and I wanted to avoid
> struct cred for various other reasons.
> 
> > I suppose ours could be renamed to task_selinux.
> 
> Better still, perhaps, would be to prefix things with selinux_ to make it
> namespace clean.

-- 
Stephen Smalley
National Security Agency

