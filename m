Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYHZIZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYHZIZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYHZIZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:25:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbYHZIZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:25:04 -0400
Date: Tue, 26 Aug 2008 01:24:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Ryan Hope" <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [-mmotm] BUG: scheduling while atomic: swapper
Message-Id: <20080826012458.abe3bbba.akpm@linux-foundation.org>
In-Reply-To: <b647ffbd0808260111r2aed706cvc4c5d483912ec8c2@mail.gmail.com>
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
	<b647ffbd0808260111r2aed706cvc4c5d483912ec8c2@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 10:11:24 +0200 "Dmitry Adamushko" <dmitry.adamushko@gmail.com> wrote:

> 2008/8/26 Ryan Hope <rmh3093@gmail.com>:
> > BUG: scheduling while atomic: swapper/1/0x00000002
> > Modules linked in:
> > Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc4-zenmmotm1 #4
> >  [<c057a0c7>] schedule+0x287/0x6d0
> >  [<c03672e6>] vsnprintf+0x3a6/0x6c0
> >  [<c057a92d>] schedule_timeout+0x7d/0xb0
> >  [<c021e0c8>] __wake_up+0x38/0x50
> >  [<c057a74a>] wait_for_common+0x8a/0x130
> >  [<c0220ab0>] default_wake_function+0x0/0x10
> >  [<c0237743>] call_usermodehelper_exec+0xc3/0xf0
> >  [<c0362ede>] kobject_uevent_env+0x37e/0x3a0
> >  [<c03d5921>] device_add+0x551/0x630
> >  [<c03d5ac3>] device_create_vargs+0xb3/0xd0
> >  [<c06ccc47>] microcode_intel_module_init+0x0/0x39
> 
> It doesn't look like Linus's tree... there is no
> microcode_intel_module_init() in .27+. So what is it?

mmotm is linux-next plus -mm stuff

> Anyway, your trace might be explained by a bug that has been already
> fixed in Ingo's -tip.
> 
> Here is the commit:
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=8343ef2437c599d30568e6b5a257a40bf2f4902b

Yes, an unbalanced get_cpu() would explain it.

However that patch is already in current -mm.  Ryan, can you please
check to see if it's in the version you tested?  The "fixed" version
looks like this:

static int __init microcode_intel_module_init(void)
{
	struct cpuinfo_x86 *c = &cpu_data(get_cpu());

	if (c->x86_vendor == X86_VENDOR_INTEL)
		return microcode_init(&microcode_intel_ops, THIS_MODULE);
	else
		return -ENODEV;
}

