Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYCKBTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYCKBTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYCKBT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:19:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:7633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYCKBT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,477,1199692800"; 
   d="scan'208";a="261805424"
Subject: Re: [PATCH -mm] kprobes: kprobe-booster for ia64
From: Shaohua Li <shaohua.li@intel.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ia64 <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <47D57D28.7070100@redhat.com>
References: <47D166E7.2050803@redhat.com>
	 <1205120600.20271.3.camel@sli10-desk.sh.intel.com>
	 <47D57D28.7070100@redhat.com>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 09:20:17 +0800
Message-Id: <1205198417.24178.10.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Tue, 2008-03-11 at 02:25 +0800, Masami Hiramatsu wrote:
> Shaohua Li wrote:
> > On Sat, 2008-03-08 at 00:01 +0800, Masami Hiramatsu wrote:
> >> From: Masami Hiramatsu <mhiramat@redhat.com>
> >> +
> >> +/* Prepare long jump bundle and disables other boosters if need */
> >> +static void __kprobes prepare_booster(struct kprobe *p)
> >> +{
> >> +       unsigned long addr = (unsigned long)p->addr & ~0xFULL;
> >> +       unsigned int slot = addr & 0xf;
> > slot = (unsigned long)p->addr & 0xf ?
> 
> You are correct. I'll fix that.
> 
> >
> >> +       struct kprobe *other_kp;
> >> +
> >> +       if (can_boost(&p->ainsn.insn[0].bundle, slot, addr)) {
> >> +               set_brl_inst(&p->ainsn.insn[1].bundle, (bundle_t
> >> *)addr + 1);
> >> +               p->ainsn.inst_flag |= INST_FLAG_BOOSTABLE;
> >> +       }
> >> +
> >> +       /* disables boosters in previous slots */
> >> +       for (; addr < (unsigned long)p->addr; addr++) {
> >> +               other_kp = get_kprobe((void *)addr);
> >> +               if (other_kp)
> >> +                       other_kp->ainsn.inst_flag &=
> >> ~INST_FLAG_BOOSTABLE;
> >> +       }
> >> +}
> >> +
> > There is no lock to protect the flag. If one cpu invokes other_kp
> and
> > the other cpu is changing the flag, what's the result?
> 
> I think that other cpu never change the flag, because the caller of
> this
> function(__register_kprobe) locks kprobe_mutex in kernel/kprobes.c.
I mean if one cpu is doing register_kprobe, which will change other_kp's
flag. Another cpu is running into other_kp's break point, which will
look at the flag, there is a window (between the second cpu looks at the
flag and doing boost) the first cpu can change the flag in the window.
It appears we will lose one probe, but not sure if this is over
thinking.

Thanks,
Shaohua

