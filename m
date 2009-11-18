Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZKROvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZKROvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZKROvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:51:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:17853 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327AbZKROvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Al0n8WfAa1kuDezLR7mbSe3mb8/zvjXNISAc1UzELdZPJqpi4YlqPtNAxfBpsfzJJ3
         poU6j9rDYWONyxBVJr38uFw9WfGz3fzTaAhnf6EJcHmCML9mLrPe1BX3/QgzIxXzBq30
         5Aa5JSmlyrkKLfh9YUMUnaU6U47IgTgC2Ey1I=
Message-ID: <4B040A03.2020508@gmail.com>
Date: Wed, 18 Nov 2009 15:51:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091117 SUSE/3.0.0-2.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com> <4AF84E2F.3010305@gmail.com> <20091109173654.GA8809@redhat.com>
In-Reply-To: <20091109173654.GA8809@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 06:36 PM, Oleg Nesterov wrote:
> We can call find_task_by_vpid() under rcu and do get_task_struct().
> Or, given that we need tasklist anyway we can do find_task_by_vpid()
> under tasklist and do not get() at all.

Thanks. I'll post patches as a reply to this email. They are on the top
of the previous series which were already in -next. They're here (on the
same thread level):
http://lkml.org/lkml/2009/9/3/296

All patches available as:
git://decibel.fi.muni.cz/~xslaby/linux writable_limits-testing
or on web:
http://decibel.fi.muni.cz/cgi-bin/gitweb.cgi?p=linux.git;a=shortlog;h=refs/heads/writable_limits-testing

If somebody would like to pick them up, I have also a -next based
version (fanotify+recvmsg syscalls collision).

What I did with the Neil's patches:
- changed syscall bodies according to comments and
- added entries to syscall_table_32.S
- implemented compat syscalls
- cleaned up rlim usage in posix cpu timers. Note that cpu and
  rttime are not guaranteed (concurrent setrlimit set might
  be overwritten by the stores there).
- reviewed rlim usages all over the tree

On the last point: I added explicit ACCESS_ONCE all over there. If you
don't like I will trash it. The only remaining weird user is in
kernel/acct.c:
        /*
         * Accounting records are not subject to resource limits.
         */
        flim = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
        current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
        file->f_op->write(file, (char *)&ac,
                               sizeof(acct_t), &file->f_pos);
        current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;

It means that threads of the process with PACCT caps have unlimited file
size for a short while. If there is setrlimit in between, it gets wiped
out as well. I don't know what to do with that.

Please review.

thanks,
-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
