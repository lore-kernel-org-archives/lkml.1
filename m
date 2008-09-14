Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYINBkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYINBkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 21:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYINBko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 21:40:44 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35118 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYINBkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 21:40:43 -0400
Date: Sat, 13 Sep 2008 20:40:24 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, vegard.nossum@gmail.com, ebiederm@xmission.com
Subject: Re: + utsname-completely-overwrite-prior-information.patch added
	to -mm tree
Message-ID: <20080914014024.GA18604@us.ibm.com>
References: <200809122211.m8CMBbAM007090@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809122211.m8CMBbAM007090@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> 
> The patch titled
>      utsname: completely overwrite prior information
> has been added to the -mm tree.  Its filename is
>      utsname-completely-overwrite-prior-information.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: utsname: completely overwrite prior information
> From: Vegard Nossum <vegard.nossum@gmail.com>
> 
> On sethostname() and setdomainname(), previous information may be retained
> if it was longer than than the new hostname/domainname.
> 
> This can be demonstrated trivially by calling sethostname() first with a
> long name, then with a short name, and then calling uname() to retrieve
> the full buffer that contains the hostname (and possibly parts of the old
> hostname), one just has to look past the terminating zero.
> 
> I don't know if we should really care that much (hence the RFC); the only
> scenarios I can possibly think of is administrator putting something
> sensitive in the hostname (or domain name) by accident, and changing it
> back will not undo the mistake entirely, though it's not like we can
> recover gracefully from "rm -rf /" either...  The other scenario is
> namespaces (CLONE_NEWUTS) where some information may be unintentionally
> "inherited" from the previous namespace (a program wants to hide the
> original name and does clone + sethostname, but some information is still
> left).
> 
> I think the patch may be defended on grounds of the principle of least
> surprise.  But I am not adamant :-)
> 
> (I guess the question now is whether userspace should be able to
> write embedded NULs into the buffer or not...)
> 
> At least the observation has been made and the patch has been presented.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: "Serge E. Hallyn" <serue@us.ibm.com>

Agreed it seems an implausible attack vector :)  But especially for
something as rare as setting a hostname, seems worthwhile.

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks, Vegard.

-serge

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/sys.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff -puN kernel/sys.c~utsname-completely-overwrite-prior-information kernel/sys.c
> --- a/kernel/sys.c~utsname-completely-overwrite-prior-information
> +++ a/kernel/sys.c
> @@ -1416,7 +1416,8 @@ asmlinkage long sys_sethostname(char __u
>  	errno = -EFAULT;
>  	if (!copy_from_user(tmp, name, len)) {
>  		memcpy(utsname()->nodename, tmp, len);
> -		utsname()->nodename[len] = 0;
> +		memset(utsname()->nodename + len, 0,
> +			sizeof(utsname()->nodename) - len);
>  		errno = 0;
>  	}
>  	up_write(&uts_sem);
> @@ -1462,7 +1463,8 @@ asmlinkage long sys_setdomainname(char _
>  	errno = -EFAULT;
>  	if (!copy_from_user(tmp, name, len)) {
>  		memcpy(utsname()->domainname, tmp, len);
> -		utsname()->domainname[len] = 0;
> +		memset(utsname()->domainname + len, 0,
> +			sizeof(utsname()->domainname) - len);
>  		errno = 0;
>  	}
>  	up_write(&uts_sem);
> _
> 
> Patches currently in -mm which might be from vegard.nossum@gmail.com are
> 
> origin.patch
> linux-next.patch
> ia64-avoid-invoking-irq-handlers-on-offline-cpus.patch
> utsname-completely-overwrite-prior-information.patch
> kernel-sysc-improve-code-generation.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
