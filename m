Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZKEFt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZKEFt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZKEFt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:49:27 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61387 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZKEFt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:49:26 -0500
Message-Id: <200911050549.nA55nQt1094958@www262.sakura.ne.jp>
Subject: Re: [Patch 0/12] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.johansen@canonical.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Nov 2009 14:49:26 +0900
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com> <200911040441.nA44fxms062617@www262.sakura.ne.jp> <4AF25E51.1010609@canonical.com>
In-Reply-To: <4AF25E51.1010609@canonical.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05112009 #2900046, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I browsed using lxr.



> static int aa_audit_caps(struct aa_profile *profile, struct aa_audit_caps *sa)
...snipped...
> 	ent = &get_cpu_var(audit_cache);
> 	if (sa->base.task == ent->task && cap_raised(ent->caps, sa->cap)) {

		put_cpu_var(audit_cache); ?

> 		if (PROFILE_COMPLAIN(profile))
> 			return 0;
> 		return sa->base.error;
> 	} else {
> 		ent->task = sa->base.task;
> 		cap_raise(ent->caps, sa->cap);
> 	}
> 	put_cpu_var(audit_cache);
...snipped...



Regarding unpack_*(), I'm not sure, but e seems to be no longer used after once
unpack_*() failed. If so, we can remove

> 	void *pos = e->pos;

and

>  fail:
>  	e->pos = pos;



Also, please add comments regarding

  memory allocated here is released by ...

  refcount obtained here is released by ...

  the caller of this function need to hold ... lock

as it is difficult for me to track memleak/refcounter/locking bugs.
For example, in function apparmor_dentry_open(), from

	fcxt->profile = aa_get_profile(profile);

to something like

	/* released by ... */
	fcxt->profile = aa_get_profile(profile);

(Oh, is it correct to get refcount even if aa_path_perm() failed?)



Regards.
