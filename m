Return-Path: <linux-kernel-owner+w=401wt.eu-S965106AbZLGVqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106AbZLGVqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965068AbZLGVqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:46:48 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42046 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092AbZLGVqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:46:47 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnd Bergmann <arnd@arndb.de>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 07 Dec 2009 13:46:42 -0800
In-Reply-To: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain> (Thomas Gleixner's message of "Sun\, 6 Dec 2009 18\:58\:27 +0100 \(CET\)")
Message-ID: <m1iqci4ful.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT pull] bkl core patches for 2.6.33
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> Linus,
>
> Please pull the latest bkl-core-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git bkl-core-for-linus
>
> Thanks,


Was this tree in linux-next?  I'm certain I would have remembered the
conflict in kernel/sysctl.c.  Among other things in my sysctl tree
lock_kernel() is gone.  The removal of lock_kernel() happened to fall
out of my other changes.  I remember having a conversation with Arnd
Bergmann about this, and the conclusion being was that my change
correct and superior to this patch.  So I'm surprised a sysctl change
made it into your tree.

Eric


> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 0d949c5..72040e5 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1848,6 +1848,8 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
>  			return -EFAULT;
>  	}
>  
> +	lock_kernel();
> +
>  	for (head = sysctl_head_next(NULL); head;
>  			head = sysctl_head_next(head)) {
>  		error = parse_table(name, nlen, oldval, oldlenp, 
> @@ -1858,6 +1860,8 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
>  			break;
>  		}
>  	}
> +
> +	unlock_kernel();
>  	return error;
>  }
>  
> @@ -1873,10 +1877,8 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
>  	if (error)
>  		goto out;
>  
> -	lock_kernel();
>  	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
>  			  tmp.newval, tmp.newlen);
> -	unlock_kernel();
>  out:
>  	return error;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
