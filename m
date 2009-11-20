Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZKTCR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZKTCR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 21:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbZKTCR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 21:17:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193AbZKTCR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:17:56 -0500
Date: Fri, 20 Nov 2009 03:11:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: acct_file_reopen() && do_acct_process() (Was: [PATCH 0/3] extend
	get/setrlimit to support setting rlimits external to a process (v7))
Message-ID: <20091120021102.GA5603@redhat.com>
References: <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com> <4AF84E2F.3010305@gmail.com> <20091109173654.GA8809@redhat.com> <4B040A03.2020508@gmail.com> <20091118231532.GA13039@redhat.com> <4B056791.5090002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B056791.5090002@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Jiri Slaby wrote:
>
> On 11/19/2009 12:15 AM, Oleg Nesterov wrote:
> > On 11/18, Jiri Slaby wrote:
> >>
> >> kernel/acct.c:
> >>         /*
> >>          * Accounting records are not subject to resource limits.
> >>          */
> >>         flim = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
> >>         current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
> >>         file->f_op->write(file, (char *)&ac,
> >>                                sizeof(acct_t), &file->f_pos);
> >>         current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
> >>
> >> It means that threads of the process with PACCT caps have unlimited file
> >> size for a short while. If there is setrlimit in between, it gets wiped
> >> out as well.
> >
> > This is called when the whole thread-group exits, there are no
> > live threads except current.
>
> Not really, it is called from umount, sys_acct and other paths.

Hmm. you are right. Do you know why acct_file_reopen() does

	if (old_acct)
		do_acct_process();

???

This looks just strange. What is the point ? If the caller doesn't
exit, we shouldn't account it?

And this is just wrong, no? Even if we forget about rlim, since
do_acct_process() does override_creds() + revert_creds(), any
__task_cred() in between is fooled?

Probably I greatly misread something in acct.c, otherwise I can't
see why, say, mntput() should ever record the caller in acct file.

IOW: could someone explain why the patch below is wrong?

Oleg.

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -206,7 +206,6 @@ static void acct_file_reopen(struct bsd_
 	if (old_acct) {
 		mnt_unpin(old_acct->f_path.mnt);
 		spin_unlock(&acct_lock);
-		do_acct_process(acct, old_ns, old_acct);
 		filp_close(old_acct, NULL);
 		spin_lock(&acct_lock);
 	}

