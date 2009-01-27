Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZA0VAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZA0VAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZA0VAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:00:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZA0VAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:00:37 -0500
Date: Tue, 27 Jan 2009 16:00:19 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       crash-utility@redhat.com, Mike Snitzer <snitzer@gmail.com>
Message-ID: <1457226967.823651233090019084.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
In-Reply-To: <952123357.823421233089955989.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Subject: Re: BISECTED: Re: source line numbers with x86_64 modules?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.19.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Eric W. Biederman" <ebiederm@xmission.com> wrote:

> Mike Snitzer <snitzer@gmail.com> writes:
> 
> > [I've trimmed the wide cc distribution that was inherited when I
> > forked a different thread]
> >
> > On Mon, Jan 12, 2009 at 10:19 PM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
> >> "Mike Snitzer" <snitzer@gmail.com> writes:
> >>>
> >>> Now if only I could fix line numbers when debugging crashes in x86_64
> >>> modules with the crash utility! :)
> >>
> >> It's a userspace problem...
> >>
> >> All of the little usability things are userspace problems.
> >>
> >> I won't claim that it is trivial because it is a userspace problem, at the same
> >> time there is no reason to wait for any kernel features to merge etc.  Someone
> >> just has to scratch an itch and go fix it.
> >
> > Yes, the crash utility (userspace) is clearly having problems getting
> > line number for symbols in x86_64 modules.  But I finally took some
> > time to bisect the point in the kernel where the crash utility first
> > started to fail, it appears to be:
> >
> > commit 7460ed2844ffad7141e30271c0c3da8336e66014
> > Author: john stultz <johnstul@us.ibm.com>
> > Date:   Fri Feb 16 01:28:21 2007 -0800
> >
> > I used version 4.0-7.6 of the crash utility to test if each commit was
> > good or bad.  I simply checked if ext3's module had correct line
> > number info for the ext3_get_blocks_handle symbol with: sym
> > ext3_get_blocks_handle
> 
> Weird.  That patch doesn't appear to affect anything in that area.
> So my stab in the dark is that there is something in vmlinux that
> crash doesn't know how to cope with.

Actually it's not a problem with the vmlinux file, but rather with kernel
module object files.  The crash utility has an embedded gdb module which
is invoked as "gdb vmlinux", and to get line numbers, the crash utility
simply uses the relevant built-in gdb function to get them.  And line
numbers work fine with the base kernel code from the vmlinux file.

The debuginfo data of kernel modules can be subsequently added to the
crash session by doing a gdb "add-symbol-file" command for any or all
kernel modules.  But getting correct line number information for kernel
modules has been a crap-shoot in the past, depending upon architecture
and/or kernel version.  For example, they don't work with 2.6.9-based
RHEL4 x86_64 kernel modules, but work fine with 2.6.18-based RHEL5 x86_64
kernels.

Looking at Mike's suspect kernel patch list, I don't see anything that
would have any relationship to the issue.  Perhaps there was a build tool
change during the same timeframe? 
 
Dave


