Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZDMTQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZDMTQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZDMTQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:16:00 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36672 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZDMTP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:15:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
Date: Mon, 13 Apr 2009 13:15:54 -0600
User-Agent: KMail/1.9.10
Cc: linux-acpi@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <49E065CF.6040408@tuffmail.co.uk> <49E1ADAE.2030103@tuffmail.co.uk> <49E1E89D.7040502@tuffmail.co.uk>
In-Reply-To: <49E1E89D.7040502@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904131315.55519.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 April 2009 07:11:57 am Alan Jenkins wrote:
> Alan Jenkins wrote:
> > Tzy-Jye Daniel Lin wrote:
> >> On Sat, Apr 11, 2009 at 5:41 AM, Alan Jenkins
> >> <alan-jenkins@tuffmail.co.uk> wrote:
> >>   
> >>> Regression #6 on latest git! (last known good is 2.6.29-rc8)

You mention that this occurs when booting off battery.  So I
assume everything works fine when the EEE is plugged in to the
wall socket?

> >>> Magic SysRQ keys work though.  ...
> > I was able to run SysRq-P, and found the following backtrace -
> >
> > Pid: 0
> > EIP is at acpi_idle_enter_bm+0x1df/0x208 [processor]

Can you figure out where this is in acpi_idle_enter_bm() or
maybe just email me your processor.ko module?

Does it always happen at the same point?

If you blacklist or rename the processor module to prevent it
from loading, does that keep the hang from occurring?

> > cpud_idle_call
> > cpu_idle
> > rest_init
> > start_kernel
> > i386_start_kernel
> 
> 7ec0a7290797f57b780f792d12f4bcc19c83aa4f is first bad commit
> commit 7ec0a7290797f57b780f792d12f4bcc19c83aa4f
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Mon Mar 30 17:48:24 2009 +0000

Ouch, sorry about that.  Thanks for doing all the bisection work.

>     ACPI: processor: use .notify method instead of installing handler
> directly
> 
>     This patch adds a .notify() method.  The presence of .notify() causes
>     Linux/ACPI to manage event handlers and notify handlers on our behalf,
>     so we don't have to install and remove them ourselves.
> 
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     CC: Zhang Rui <rui.zhang@intel.com>
>     CC: Zhao Yakui <yakui.zhao@intel.com>
>     CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>     CC: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> However, reverting this commit from v2.6.30-rc1 doesn't solve the hang.

I don't see the problem in that commit yet, and if there is a problem
with it, I would think that reverting it from 2.6.30-rc1 would solve
it.  But maybe it'd be useful to revert the whole .notify series to
make sure.  From 2.6.30-rc1, you should be able to revert these:

  7ec0a7290797f57b780f792d12f4bcc19c83aa4f processor
  373cfc360ec773be2f7615e59a19f3313255db7c button
  46ec8598fde74ba59703575c22a6fb0b6b151bb6 Linux/ACPI infrastructure

What happens with those commits reverted?

Bjorn
