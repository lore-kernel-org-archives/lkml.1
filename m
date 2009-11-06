Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbZKFXuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbZKFXuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZKFXuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:50:15 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42521 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZKFXuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:50:14 -0500
Message-ID: <4AF4B636.9010107@canonical.com>
Date: Fri, 06 Nov 2009 15:50:14 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: john.johansen@canonical.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch 0/12] AppArmor security module
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com> <200911040441.nA44fxms062617@www262.sakura.ne.jp> <4AF25E51.1010609@canonical.com> <200911050549.nA55nQt1094958@www262.sakura.ne.jp>
In-Reply-To: <200911050549.nA55nQt1094958@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
> 
> I browsed using lxr.
> 
> 
> 
>> static int aa_audit_caps(struct aa_profile *profile, struct aa_audit_caps *sa)
> ...snipped...
>> 	ent = &get_cpu_var(audit_cache);
>> 	if (sa->base.task == ent->task && cap_raised(ent->caps, sa->cap)) {
> 
> 		put_cpu_var(audit_cache); ?
> 
yep thanks for the catch

>> 		if (PROFILE_COMPLAIN(profile))
>> 			return 0;
>> 		return sa->base.error;
>> 	} else {
>> 		ent->task = sa->base.task;
>> 		cap_raise(ent->caps, sa->cap);
>> 	}
>> 	put_cpu_var(audit_cache);
> ...snipped...
> 
> 
> 
> Regarding unpack_*(), I'm not sure, but e seems to be no longer used after once
> unpack_*() failed. If so, we can remove
> 
>> 	void *pos = e->pos;
> 
> and
> 
>>  fail:
>>  	e->pos = pos;
> 
actually it is used sometimes for optional elements.  However this could be
cleaned up some because optional elements should only ever fail on the
name or type tags, not the actual data it self.

It is also used in reporting failure position to user space but that only
gets the tag location, it might be better to return the true location of
failure, I'll have a look.

> 
> 
> Also, please add comments regarding
> 
>   memory allocated here is released by ...
> 
>   refcount obtained here is released by ...
> 
>   the caller of this function need to hold ... lock
> 
will do

> as it is difficult for me to track memleak/refcounter/locking bugs.
> For example, in function apparmor_dentry_open(), from
> 
> 	fcxt->profile = aa_get_profile(profile);
> 
> to something like
> 
> 	/* released by ... */
> 	fcxt->profile = aa_get_profile(profile);
> 
> (Oh, is it correct to get refcount even if aa_path_perm() failed?)
> 
yes as long as the refcount is put, there are several possible reasons for 
grabbing a refcount, like passing the object to auditing, or just optimizing the success path.

Of course it could also just be a bug or code that could use some cleaning up
too.

Thanks again Tetsuo

john
