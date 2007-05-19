Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXESRRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXESRRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXESRRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:17:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:22118 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXESRRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PAqf9yMe5s1zWFqX0/XcYvnZPr+AjUL6i+3HmfXioIKdUcBf2nYKRdcHyu58ZWT4eXhcxFyKWb8oaSPkntC6Zxlop7S1o3F/t6FdANGM5eiBqeq8m24+rJKmgMY/0hiFXyRUiZnu3zUTD+7t38PLYRDMhFSpSZKlLHt8FNNFMp4=
Message-ID: <6bffcb0e0705191017n1d1e6eb7k1370d5ce5cf17fb9@mail.gmail.com>
Date: Sat, 19 May 2007 19:17:37 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Mattia Dongili" <malattia@linux.it>
Subject: Re: 2.6.22-rc1 regression: tifm prevents suspending [was: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR]
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Alex Dubov" <oakad@yahoo.com>,
       "Pierre Ossman" <drzeus@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070519151110.GA3393@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070518071523.GA3195@inferi.kami.home>
	 <20070518002240.bc08e811.akpm@linux-foundation.org>
	 <20070519064829.GA15518@inferi.kami.home>
	 <20070519000413.75badb6f.akpm@linux-foundation.org>
	 <20070519151110.GA3393@inferi.kami.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19/05/07, Mattia Dongili <malattia@linux.it> wrote:
> On Sat, May 19, 2007 at 12:04:13AM -0700, Andrew Morton wrote:
> > On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:
> >
> > > On Fri, May 18, 2007 at 12:22:40AM -0700, Andrew Morton wrote:
> > > > On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > > >
> > > > > Hello,
> > > > >
> > > > > After finally catching fw-{ohci,core} to be problematic during resume,
> > > > > I'm now experiencing an immediate resume after suspending.
> > > > >
> > > > > 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> > > > > kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> > > > > 2.6.21-rc6-mm* after the cpuidle fixes).
> > > > >
> > > > > my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> > > > > and a str cycle with PM_DEBUG=y:
> > > > > http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt
> > > ...
> > > > > Any idea where to start from? (bisecting is ok, but it'll take some
> > > > > time...)
> > > >
> > > > Bisecting isn't that bad ;) I'd pick git-acpi.patch as the starting point.
> > >
> > > ok, git-acpi.patch is not the bad boy :)
> > > Anyway what we have is a regression in 2.6.22-rc1 since the laptop can't
> > > suspend (it sits on the "Stopping tasks" console screen) while 2.6.21
> > > can.
> > > I'm now bisecting this, will come to -mm1 later when done with this one.
> >
> > OK, thanks.
> >
> > > Who is the regression-guy?
> >
> > Len, usually ;)    But I think you meant Michal, cc'ed here.
>
> LOL, not this time. We have the responsible commit for 2.6.22-rc1 (Cc
> added):
>
> 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5 is first bad commit
> commit 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5
> Author: Alex Dubov <oakad@yahoo.com>
> Date:   Thu Apr 12 16:59:15 2007 +1000
>

Subject    : Broken suspend on SMP with tifm
References : http://lkml.org/lkml/2007/5/13/161
Submitter  : Rafael J. Wysocki <rjw@sisk.pl>
Status     : patch was suggested

Actually should be "a few patches was suggested"

Rafael, please point me the right patch.

>     tifm: replace per-adapter kthread with freezeable workqueue
>
>     Freezeable workqueue makes sure that adapter work items (device insertions
>     and removals) would be handled after the system is fully resumed. Previously
>     this was achieved by explicit freezing of the kthread.
>
>     Signed-off-by: Alex Dubov <oakad@yahoo.com>
>     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
>
> I'm now seeing if avoiding the tifm stuff in -mm1 fixes the
> immediately-resumes-after-str problem (unfortunately the commint doesn't
> revert cleanly).
> --
> mattia
> :wq!
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
