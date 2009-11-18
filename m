Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZKRXVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZKRXVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbZKRXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:21:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbZKRXVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:21:08 -0500
Date: Thu, 19 Nov 2009 00:15:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091118231532.GA13039@redhat.com>
References: <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com> <4AF84E2F.3010305@gmail.com> <20091109173654.GA8809@redhat.com> <4B040A03.2020508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B040A03.2020508@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Jiri Slaby wrote:
>
> On the last point: I added explicit ACCESS_ONCE all over there. If you
> don't like I will trash it.

Just curious, why?

I mean, do you have any example of the "bad" behaviour which is
fixed by ACCESS_ONCE() ?

> The only remaining weird user is in
> kernel/acct.c:
>         /*
>          * Accounting records are not subject to resource limits.
>          */
>         flim = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
>         current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
>         file->f_op->write(file, (char *)&ac,
>                                sizeof(acct_t), &file->f_pos);
>         current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
>
> It means that threads of the process with PACCT caps have unlimited file
> size for a short while. If there is setrlimit in between, it gets wiped
> out as well.

This is called when the whole thread-group exits, there are no
live threads except current.

We don't care if the new rlimit is lost afaics, but if RLIMIT_FSIZE
is changed in between ->write() can fail. Not sure what can we do,
perhaps just ignore this problem ;)

At least, given that do_acct_process() does override_creds(), an
ordinary user can't fool the accounting.

Oleg.

