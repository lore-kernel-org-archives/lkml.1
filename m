Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZHBVl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZHBVl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZHBVl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:41:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbZHBVl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:41:56 -0400
Date: Sun, 2 Aug 2009 23:35:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Possible memory leak via alloc_pid()
Message-ID: <20090802213528.GA18795@redhat.com>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com> <20090729170315.f62066c0.akpm@linux-foundation.org> <20090730212956.GA26863@redhat.com> <1249035398.29967.8.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249035398.29967.8.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Catalin Marinas wrote:
>
> On Thu, 2009-07-30 at 23:29 +0200, Oleg Nesterov wrote:
> >
> > Since you can reproduce the problem easily, perhaps you can use the
> > hack above to track get/put ?
> >
> > 	$ echo pid_of_Xorg > /proc/sys/kernel/xxx
>
> Below is the minicom capture. By the time Xorg dies, the count is 2.

Thanks a lot Catalin.

> When logging out, there are two counter incrementing events via
> sys_wait4 and sys_ioctl, thoush I'm not sure whether they are
> unbalanced.

wait4() is right, ioctl() looks fine too.

> pgrep Xorg
> 1519
> 10:~# pgrep Xorg > /proc/sys/kernel/xxx 
> XXXXX(1519) ==22

Unfortunately there is nothing which looks like a leak. I gueess it is
too late to start the tracking.

I'm afraid this won't really help too, but since nobody has a better
idea for now, perhaps you can do another test?

Pleas rename Xorg to Xorg.origin, and make a simple Xorg script which
does something like

	#!/bin/sh

	echo $$ >> /proc/sys/kernel/xxx
	exec /path/to/Xorg.origin $*

perhaps even this is too late, gdm can do a lot before execing.

Please avoid pgrep/ps/etc, proc adds a lot of noise. Better yet, it
would be nice to start/stop Xorg with /proc unmounted, but I don't
know is this can work without /proc.

Oleg.

