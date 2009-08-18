Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZHRGyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZHRGyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZHRGya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:54:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZHRGya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:54:30 -0400
Message-ID: <4A8A50AD.7030004@redhat.com>
Date: Tue, 18 Aug 2009 14:56:45 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>	<20090817071011.5913.69970.sendpatchset@localhost.localdomain>	<1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>	<87prau5ld1.fsf@devron.myhome.or.jp>	<1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>	<873a7q441a.fsf@devron.myhome.or.jp>	<1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil>	<87fxbq19qs.fsf@devron.myhome.or.jp> <87my5yxidt.fsf@devron.myhome.or.jp>
In-Reply-To: <87my5yxidt.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Could you review this? I've added ATTR_TIMES_SET to check explicit
> utimes(), and tried it with minimum change.
>
> [I'm not sure this handles notify_change() usage of nfsd (and perhaps
> other network fs too) correctly, and whether selinux may want to check
> it. I guess network fs _may_ try to change the multiple attributes at a
> time. Well, even if it's true, it would be another topic...]
>
>   

Ah, according to the discussion here, I know I misunderstood 
ATTR_FORCE... sorry.
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
>
> From: Amerigo Wang <amwang@redhat.com>
>
> As suggested by OGAWA Hirofumi in thread: http://lkml.org/lkml/2009/8/7/132,
> we should let selinux_inode_setattr() to match our ATTR_* rules.
> ATTR_FORCE should not force things like ATTR_SIZE.
>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Eric Paris <eparis@redhat.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> [tweaks]
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>   

Great!

Some comments below.

> ---
>
>  security/selinux/hooks.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff -puN security/selinux/hooks.c~selinux-truncate-fix security/selinux/hooks.c
> --- linux-2.6/security/selinux/hooks.c~selinux-truncate-fix	2009-08-18 03:50:09.000000000 +0900
> +++ linux-2.6-hirofumi/security/selinux/hooks.c	2009-08-18 05:35:11.000000000 +0900
> @@ -2711,12 +2711,17 @@ static int selinux_inode_permission(stru
>  static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
>  {
>  	const struct cred *cred = current_cred();
> +	unsigned int ia_valid = iattr->ia_valid;
>  
> -	if (iattr->ia_valid & ATTR_FORCE)
> -		return 0;
> +	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
> +	if (ia_valid & ATTR_FORCE) {
> +		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_MODE);
> +		if (!ia_valid)
> +			return 0;
>   

So if I read this correctly, (ATTR_FORCE| ATTR_KILL_SUID|ATTR_MODE) will 
not return here, since 'ia_valid' will be ATTR_FORCE finally.

I think you forgot to clear ATTR_FORCE here...

> +	}
>  
> -	if (iattr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
> -			       ATTR_ATIME_SET | ATTR_MTIME_SET))
> +	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
> +			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
>  		return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
>  
>  	return dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
> _
>
>   
I am not sure about ATTR_TIMES_SET here, but looks fine. :-/


