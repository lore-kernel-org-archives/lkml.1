Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbXEWBHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbXEWBHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 21:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXEWBH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 21:07:28 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59902 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273AbXEWBH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 21:07:27 -0400
Date: Wed, 23 May 2007 10:06:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, Bryan Wu <bryan.wu@analog.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
Message-ID: <20070523010635.GA28301@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Bryan Wu <bryan.wu@analog.com>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1179742180228-git-send-email-bryan.wu@analog.com> <200705211035.08380.rgetz@blackfin.uclinux.org> <20070521143730.GA18110@linux-sh.org> <8bd0f97a0705221728p1c4761bbi83e58245cfca48f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0705221728p1c4761bbi83e58245cfca48f9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:28:28PM -0400, Mike Frysinger wrote:
> On 5/21/07, Paul Mundt <lethal@linux-sh.org> wrote:
> >On Mon, May 21, 2007 at 10:35:08AM -0400, Robin Getz wrote:
> >> On Mon 21 May 2007 06:09, Bryan Wu pondered:
> >> > Lots of update for 2.6.22-rc2 and tested on STAMP537 board.
> >> >
> >>
> >> One of the things I noticed when trying out 2.6.22-rc1, on blackfin was:
> >>
> >>  CALL    scripts/checksyscalls.sh
> >[snip syscalls]
> >>
> >> since there is noMMU, are we better:
> >>  - putting stubs (return ENOSYS - give runtime errors), or
> >>  - just ignore the errors - and give compile errors? (Is there any way 
> >to put
> >> something into the syscall table, as not to get the warnings?)
> >
> >No, you'd be better of figuring out which ones you can support and which
> >ones you have to -ENOSYS. CONFIG_MMU=n is not a "get out of syscalls
> >free" card. Many of these have no dependency on CONFIG_MMU, anyways.
> 
> when you say -ENOSYS, do you mean we need sys_foo() that simply does
> return -ENOSYS or do we just let the default syscall code go "__NR_foo
> is not registered, return -ENOSYS"

The checksyscalls.sh errors come from the fact you have missing
definitions in asm-blackfin/unistd.h, however, you still have reserved
slots for most of these syscalls (and explicit sys_ni_syscall wrapping in
the syscall table), just no __NR_foo definition.

It's also not clear which of these you are explicitly never going to
support versus the ones that simply haven't been implemented yet (ie,
kexec support, restartable system calls -- how do you even do
ppoll/pselect6 without supporting these?, and so on).

I would suggest simply defining the __NR_foo values based on the reserved
slots that they already occupy in order to silence these warnings, at
least that's a closer approximation of "we've actually looked at these
syscalls" than "new or otherwise unintentionally unimplemented", which is
what the script aims to help with.
