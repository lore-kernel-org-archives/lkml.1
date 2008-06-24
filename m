Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYFXNEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYFXNEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYFXNEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:04:43 -0400
Received: from CPE-124-189-54-71.nsw.bigpond.net.au ([124.189.54.71]:39440
	"EHLO bunyip.billabong.weebeasite.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751254AbYFXNEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:04:42 -0400
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 09:04:42 EDT
Date: Tue, 24 Jun 2008 22:39:52 +1000
From: AP <ap@zip.com.au>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: /proc 2.6.24 changes for guest CPU accounting
Message-ID: <20080624123951.GJ2896@zip.com.au>
References: <485DFFB4.3080008@gmail.com> <1214210925.3838.7.camel@frecb07144> <cfd18e0f0806230351nd9eb54ei5e87734291ced9be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0806230351nd9eb54ei5e87734291ced9be@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:51:11PM +0200, Michael Kerrisk wrote:
> > You must also notes that "user time" includes "guest time", if you want
> > real "user time" you must subtract "guest time".
> > The "guest time" is included in "user time" to not loose it when the
> > "reader" is not aware of the "guest time".
> 
> Hi Laurent (and Christian)
> 
> So, I just want to confirm.  You are saying that guest_time and
> cguest_time are respectively also included in the following fields
> 
>               utime %lu
...
>               cutime %ld
...
> Right?

If this function in ./kernel/sched.c is anything to go by and I'm not
being a complete noob, yes:

/*
 * Account guest cpu time to a process.
 * @p: the process that the cpu time gets accounted to
 * @cputime: the cpu time spent in virtual machine since the last update
 */
static void account_guest_time(struct task_struct *p, cputime_t cputime)
{
        cputime64_t tmp;
        struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;

        tmp = cputime_to_cputime64(cputime);

        p->utime = cputime_add(p->utime, cputime);
        p->gtime = cputime_add(p->gtime, cputime);

        cpustat->user = cputime64_add(cpustat->user, tmp);
        cpustat->guest = cputime64_add(cpustat->guest, tmp);
}

As such, I'll follow up with a new version of my previous patch.

AP
