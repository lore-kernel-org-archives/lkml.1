Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZLCI01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZLCI01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZLCI01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:26:27 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:50169 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751590AbZLCI00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:26:26 -0500
Date: Thu, 3 Dec 2009 09:26:22 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: LKLM <linux-kernel@vger.kernel.org>
Subject: Re: Question about kmsg_dump for OOPS
Message-ID: <20091203092622.599b3814@marrow.netinsight.se>
In-Reply-To: <4B172ACE.7080806@np.css.fujitsu.com>
References: <4B172ACE.7080806@np.css.fujitsu.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin!

On Thu, 03 Dec 2009 12:04:46 +0900
Jin Dongming <jin.dongming@np.css.fujitsu.com> wrote:

> I have a question about kmsg_dump which needs your help.
> The question is as following:
>     Why not put the kmsg_dump() for OOPS into oops_end() and before the branch
>     of crash_kexec()?
> 
> The reason for the question is as following:
>     Now the kmsg_dump() for OOPS is added in oops_exit(). When OOPS happened,
>     kernel will call oops_end(). If the crash_kexec() is executed first in
>     oops_end(), the oops_exit() could not be called. And also the kmsg_dump()
>     for PANIC could not be executed. So I think that the kmsg_dump() for OOPS
>     will lose its real meaning.

It would be OK to move it for my part, I understand your reasoning.
How this is handled seems to vary a bit between architectures though.
ARM has (arch/arm/kernel/die.c)

  NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
  {
	[...]
	if (panic_on_oops)
		panic("Fatal exception");

	oops_exit();
	[...]

while x86 does (arch/x86/kernel/dumpstack.c):

  void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
  {
	if (regs && kexec_should_crash(current))
		crash_kexec(regs);
	[...]
	oops_exit();
	[...]
	if (in_interrupt())
		panic("Fatal exception in interrupt");
	if (panic_on_oops)
		panic("Fatal exception");


There was some additional discussion on this a while ago in these two
threads:

  http://lkml.org/lkml/2009/11/11/404

  http://lkml.org/lkml/2009/10/23/131

where there additionally was a request to move

  atomic_notifier_call_chain(&panic_notifier_list, 0, buf);

before kmsg_dump() and crash_kexec(). I can't immediately see any
problem with this approach, but I'm no expert on kexec. The discussion
didn't really conclude on this matter though.

// Simon
