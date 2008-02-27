Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbYB0QBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbYB0QBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYB0QBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:01:01 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33857 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYB0QA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:00:59 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH -mm 3/4] Audit: start not to use SELinux exported symbols
Date: Wed, 27 Feb 2008 11:00:57 -0500
User-Agent: KMail/1.9.7
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20080226232229.GA12059@ubuntu> <20080226232808.GD12059@ubuntu>
In-Reply-To: <20080226232808.GD12059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271100.57487.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 6:28:08 pm Ahmed S. Darwish wrote:
> Remove the following exported SELinux interfaces:
> selinux_get_inode_sid(inode, sid)
> selinux_get_ipc_sid(ipcp, sid)
> selinux_get_task_sid(tsk, sid)
> selinux_sid_to_string(sid, ctx, len)
>
> and substitue them with following generic LSM equivalents
> respectively:
> security_inode_getsecid(inode, secid)
> security_ipc_getsecid*(ipcp, secid)
> security_task_getsecid(tsk, secid)
> security_sid_to_secctx(sid, ctx, len)
>
> Let the security_task_getsecid(tsk, secid) LSM hook set
> the secid to 0 by default if CONFIG_SECURITY is not defined
> or if the hook is set to NULL (dummy). This is done to
> notify the caller that no valid secid exists.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

In the future, such patches should probably also be CC'd to the audit 
list.

> ---
>
>  include/linux/security.h |    5 ++++-
>  kernel/audit.c           |   14 +++++++-------
>  kernel/auditfilter.c     |    5 +++--
>  kernel/auditsc.c         |   37
> ++++++++++++++++++------------------- security/dummy.c         |    4
> +++-
>  6 files changed, 36 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index a7fb136..35c98f0 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -621,6 +621,7 @@ struct request_sock;
>   * @task_getsecid:
>   *	Retrieve the security identifier of the process @p.
>   *	@p contains the task_struct for the process and place is into
> @secid.
> + *      In case of failure, @secid will be set to zero

This is a nit, but you used spaces between the "*" and "In case ..." 
where the rest of the files uses tabs.  When in doubt, try and stick 
with whatever formatting the rest of the source file uses.

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 8316a88..2bd4124 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -259,13 +259,13 @@ static int audit_log_config_change(char
> *function_name, int new, int old, char *ctx = NULL;
>  		u32 len;
>
> -		rc = selinux_sid_to_string(sid, &ctx, &len);
> +		rc = security_secid_to_secctx(sid, &ctx, &len);
>  		if (rc) {
>  			audit_log_format(ab, " sid=%u", sid);
>  			allow_changes = 0; /* Something weird, deny request */
>  		} else {
>  			audit_log_format(ab, " subj=%s", ctx);
> -			kfree(ctx);
> +			security_release_secctx(ctx, len);
>  		}
>  	}
>  	audit_log_format(ab, " res=%d", allow_changes);
> @@ -543,12 +543,12 @@ static int audit_log_common_recv_msg(struct
> audit_buffer **ab, u16 msg_type, audit_log_format(*ab, "user pid=%d
> uid=%u auid=%u",
>  			 pid, uid, auid);
>  	if (sid) {
> -		rc = selinux_sid_to_string(sid, &ctx, &len);
> +		rc = security_secid_to_secctx(sid, &ctx, &len);
>  		if (rc)
>  			audit_log_format(*ab, " ssid=%u", sid);
>  		else
>  			audit_log_format(*ab, " subj=%s", ctx);
> -		kfree(ctx);
> +		security_release_secctx(ctx, len);
>  	}
>
>  	return rc;

This next part isn't your fault, but you're touching the code so I'm 
going to point it out and suggest you fix it while you are at it :)

If you look at how kfree()/security_release_secctx() is called in the 
above two functions you notice how it is inconsistent: it is only 
called on success in the first case, but called regardless in the 
second.  Make this consistent, preferably using the approach taken in 
the first case (only call it on success).

> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 2f2914b..894e3bd 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -28,6 +28,7 @@
>  #include <linux/netlink.h>
>  #include <linux/sched.h>
>  #include <linux/inotify.h>
> +#include <linux/security.h>
>  #include <linux/selinux.h>
>  #include "audit.h"
>
> @@ -1515,11 +1516,11 @@ static void audit_log_rule_change(uid_t
> loginuid, u32 sid, char *action, if (sid) {
>  		char *ctx = NULL;
>  		u32 len;
> -		if (selinux_sid_to_string(sid, &ctx, &len))
> +		if (security_secid_to_secctx(sid, &ctx, &len))
>  			audit_log_format(ab, " ssid=%u", sid);
>  		else
>  			audit_log_format(ab, " subj=%s", ctx);
> -		kfree(ctx);
> +		security_release_secctx(ctx, len);
>  	}
>  	audit_log_format(ab, " op=%s rule key=", action);
>  	if (rule->filterkey)

Same comment about security_release_secctx() applies here.

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index d07fc4a..631c044 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -885,11 +885,11 @@ void audit_log_task_context(struct audit_buffer
> *ab) int error;
>  	u32 sid;
>
> -	selinux_get_task_sid(current, &sid);
> +	security_task_getsecid(current, &sid);
>  	if (!sid)
>  		return;
>
> -	error = selinux_sid_to_string(sid, &ctx, &len);
> +	error = security_secid_to_secctx(sid, &ctx, &len);
>  	if (error) {
>  		if (error != -EINVAL)
>  			goto error_path;
> @@ -897,7 +897,7 @@ void audit_log_task_context(struct audit_buffer
> *ab) }
>
>  	audit_log_format(ab, " subj=%s", ctx);
> -	kfree(ctx);
> +	security_release_secctx(ctx, len);
>  	return;

Same thing.

>  error_path:
> @@ -951,7 +951,7 @@ static int audit_log_pid_context(struct
> audit_context *context, pid_t pid,
>
>  	audit_log_format(ab, "opid=%d oauid=%d ouid=%d oses=%d", pid, auid,
>  			 uid, sessionid);
> -	if (selinux_sid_to_string(sid, &s, &len)) {
> +	if (security_secid_to_secctx(sid, &s, &len)) {
>  		audit_log_format(ab, " obj=(none)");
>  		rc = 1;
>  	} else

You forgot to convert the matching kfree() call to a 
security_release_secctx() call.  Also it might be nice to change the 
context variable name from "s" to "ctx", but some ornery folks might 
whine about that ...

> @@ -1268,14 +1268,14 @@ static void audit_log_exit(struct
> audit_context *context, struct task_struct *ts if (axi->osid != 0) {
>  				char *ctx = NULL;
>  				u32 len;
> -				if (selinux_sid_to_string(
> +				if (security_secid_to_secctx(
>  						axi->osid, &ctx, &len)) {
>  					audit_log_format(ab, " osid=%u",
>  							axi->osid);
>  					call_panic = 1;
>  				} else
>  					audit_log_format(ab, " obj=%s", ctx);
> -				kfree(ctx);
> +				security_release_secctx(ctx, len);
>  			}
>  			break; }

Only call the release routine on success.

> @@ -1389,13 +1389,13 @@ static void audit_log_exit(struct
> audit_context *context, struct task_struct *ts if (n->osid != 0) {
>  			char *ctx = NULL;
>  			u32 len;
> -			if (selinux_sid_to_string(
> +			if (security_secid_to_secctx(
>  				n->osid, &ctx, &len)) {
>  				audit_log_format(ab, " osid=%u", n->osid);
>  				call_panic = 2;
>  			} else
>  				audit_log_format(ab, " obj=%s", ctx);
> -			kfree(ctx);
> +			security_release_secctx(ctx, len);
>  		}

Here too.

> @@ -2432,16 +2431,16 @@ void audit_core_dumps(long signr)
>  	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
>  	audit_log_format(ab, "auid=%u uid=%u gid=%u ses=%u",
>  			auid, current->uid, current->gid, sessionid);
> -	selinux_get_task_sid(current, &sid);
> +	security_task_getsecid(current, &sid);
>  	if (sid) {
>  		char *ctx = NULL;
>  		u32 len;
>
> -		if (selinux_sid_to_string(sid, &ctx, &len))
> +		if (security_secid_to_secctx(sid, &ctx, &len))
>  			audit_log_format(ab, " ssid=%u", sid);
>  		else
>  			audit_log_format(ab, " subj=%s", ctx);
> -		kfree(ctx);
> +		security_release_secctx(ctx, len);
>  	}
>  	audit_log_format(ab, " pid=%d comm=", current->pid);
>  	audit_log_untrustedstring(ab, current->comm);

One last time.

-- 
paul moore
linux security @ hp
