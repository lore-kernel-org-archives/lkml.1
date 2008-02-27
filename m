Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYB0RPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYB0RPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYB0RO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:14:56 -0500
Received: from hu-out-0506.google.com ([72.14.214.235]:51368 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYB0ROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=GCJbm1ZFJMhwmJFkb+OQHxgvVkWcMROw3qzzVt75mTyYYYRRh9NGL9nSv8VbWdQU2p6bGAWMavsyYtafxwlHLfmCziVa3iqesD8En0qC2CZ6tzrSWMpwfW0Re48NJj1/VdVxGJcn5AiEnguXSrTeibN6XCkOlpqaoYRGOHLkWHc=
Date: Wed, 27 Feb 2008 19:11:58 +0200
To: Paul Moore <paul.moore@hp.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 3/4] Audit: start not to use SELinux exported
	symbols
Message-ID: <20080227171158.GB27965@ubuntu>
References: <20080226232229.GA12059@ubuntu> <20080226232808.GD12059@ubuntu> <200802271100.57487.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802271100.57487.paul.moore@hp.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!,

On Wed, Feb 27, 2008 at 11:00:57AM -0500, Paul Moore wrote:
> On Tuesday 26 February 2008 6:28:08 pm Ahmed S. Darwish wrote:
...
> >
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> 
> In the future, such patches should probably also be CC'd to the audit 
> list.
> 

No problem.

> > ---
> >
> >  include/linux/security.h |    5 ++++-
> >  kernel/audit.c           |   14 +++++++-------
> >  kernel/auditfilter.c     |    5 +++--
> >  kernel/auditsc.c         |   37
> > ++++++++++++++++++------------------- security/dummy.c         |    4
> > +++-
> >  6 files changed, 36 insertions(+), 32 deletions(-)
> >
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index a7fb136..35c98f0 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -621,6 +621,7 @@ struct request_sock;
> >   * @task_getsecid:
> >   *	Retrieve the security identifier of the process @p.
> >   *	@p contains the task_struct for the process and place is into
> > @secid.
> > + *      In case of failure, @secid will be set to zero
> 
> This is a nit, but you used spaces between the "*" and "In case ..." 
> where the rest of the files uses tabs.  When in doubt, try and stick 
> with whatever formatting the rest of the source file uses.
> 

I'll find a way to teach emacs how to print a tab ;). Will do.

> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 8316a88..2bd4124 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -259,13 +259,13 @@ static int audit_log_config_change(char
> > *function_name, int new, int old, char *ctx = NULL;
> >  		u32 len;
> >
> > -		rc = selinux_sid_to_string(sid, &ctx, &len);
> > +		rc = security_secid_to_secctx(sid, &ctx, &len);
> >  		if (rc) {
> >  			audit_log_format(ab, " sid=%u", sid);
> >  			allow_changes = 0; /* Something weird, deny request */
> >  		} else {
> >  			audit_log_format(ab, " subj=%s", ctx);
> > -			kfree(ctx);
> > +			security_release_secctx(ctx, len);
> >  		}
> >  	}
> >  	audit_log_format(ab, " res=%d", allow_changes);
> > @@ -543,12 +543,12 @@ static int audit_log_common_recv_msg(struct
> > audit_buffer **ab, u16 msg_type, audit_log_format(*ab, "user pid=%d
> > uid=%u auid=%u",
> >  			 pid, uid, auid);
> >  	if (sid) {
> > -		rc = selinux_sid_to_string(sid, &ctx, &len);
> > +		rc = security_secid_to_secctx(sid, &ctx, &len);
> >  		if (rc)
> >  			audit_log_format(*ab, " ssid=%u", sid);
> >  		else
> >  			audit_log_format(*ab, " subj=%s", ctx);
> > -		kfree(ctx);
> > +		security_release_secctx(ctx, len);
> >  	}
> >
> >  	return rc;
> 
> This next part isn't your fault, but you're touching the code so I'm 
> going to point it out and suggest you fix it while you are at it :)
> 
> If you look at how kfree()/security_release_secctx() is called in the 
> above two functions you notice how it is inconsistent: it is only 
> called on success in the first case, but called regardless in the 
> second.  Make this consistent, preferably using the approach taken in 
> the first case (only call it on success).
> 

My pleasure. You'll find them consistent in the next send.

[Same release_ctx() consistency point]
...

> 
> > @@ -951,7 +951,7 @@ static int audit_log_pid_context(struct
> > audit_context *context, pid_t pid,
> >
> >  	audit_log_format(ab, "opid=%d oauid=%d ouid=%d oses=%d", pid, auid,
> >  			 uid, sessionid);
> > -	if (selinux_sid_to_string(sid, &s, &len)) {
> > +	if (security_secid_to_secctx(sid, &s, &len)) {
> >  		audit_log_format(ab, " obj=(none)");
> >  		rc = 1;
> >  	} else
> 
> You forgot to convert the matching kfree() call to a 
> security_release_secctx() call.  Also it might be nice to change the 
> context variable name from "s" to "ctx", but some ornery folks might 
> whine about that ...
> 

Nice spot, will do. 's' will be changed too, context is already
used as 'ctx' in the whole file anyway.

[...]
> 
> Only call the release routine on success.
> 
[...]
> 
> Here too.
> 
[...]
> 
> One last time.
> 

Thanks a lot for such a deep review :). I'll modify spotted problems
as suggested, reorder the patch in a non compilation-breaking order, 
and keep you informed.

Modified patches will be sent with the new ones that will complete 
the separation not to add too much noise in LKML.

Warm regards

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

