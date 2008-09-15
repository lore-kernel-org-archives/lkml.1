Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYIOROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYIOROU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYIOROL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:14:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43177 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752838AbYIOROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:14:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=ExpYM+ru8oFTYHLxHLAmEcup5rDMeocsnyluFysCMBbI0QTGAsQml0RwYZzqnCn1k
	PRudzlrIPxO397riPUfVQ==
Subject: Re: 2.6.27-rc6-mmotm0913 build error - suspect
	itimers-fix-itimer-many-thread-hang.patch
From: Frank Mayhar <fmayhar@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <48922.1221496161@turing-police.cc.vt.edu>
References: <48922.1221496161@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8
Organization: Google, Inc.
Date: Mon, 15 Sep 2008 10:13:24 -0700
Message-Id: <1221498804.19012.13.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-15 at 12:29 -0400, Valdis.Kletnieks@vt.edu wrote:
> Trying to build rc6-mmotm0913 dies:
> 
>   CC      security/selinux/hooks.o
> security/selinux/hooks.c: In function â€˜selinux_bprm_committing_credsâ€™:
> security/selinux/hooks.c:2325: error: â€˜struct task_structâ€™ has no member named â€˜it_prof_expiresâ€™
> make[2]: *** [security/selinux/hooks.o] Error 1
> make[1]: *** [security/selinux] Error 2
> make: *** [security] Error 2
> 
> I suspect that itimers-fix-itimer-many-thread-hang.patch has a merge issue
> against linux-next.patch, causing selinux_bprm_commiting_creds to be missing
> an update.  The code as it appears in my tree (end of that function
> in security/selinux/hooks.c):
> 
>        if (rc) {
>                 for (i = 0; i < RLIM_NLIMITS; i++) {
>                         rlim = current->signal->rlim + i;
>                         initrlim = init_task.signal->rlim+i;
>                         rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
>                 }
> 
>                 if (current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
>                         /*
>                          * This will cause RLIMIT_CPU calculations to be
>                          * refigured.
>                          */
>                         current->it_prof_expires = jiffies_to_cputime(1);
>                 }
>         }
> }

As it happens, my top-of-tree snapshot is missing this routine.  I'm
re-snapping it now but I think you're right that it's a merge issue with
linux-next.  The fix, however, is trivial:  Replace the entire if block
with the line:
	update_rlimit_cpu(rlim->rlim_cur);

The above snippet becomes:

       if (rc) {
                for (i = 0; i < RLIM_NLIMITS; i++) {
                        rlim = current->signal->rlim + i;
                        initrlim = init_task.signal->rlim+i;
                        rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
                }
                update_rlimit_cpu(rlim->rlim_cur);
        }

And double-check that linux/posix-timers.h is being #included around
line 80.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

