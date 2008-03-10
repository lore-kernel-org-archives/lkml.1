Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYCJS21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYCJS21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYCJS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:28:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYCJS2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:28:16 -0400
Message-ID: <47D57D28.7070100@redhat.com>
Date: Mon, 10 Mar 2008 14:25:44 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ia64 <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH -mm] kprobes: kprobe-booster for ia64
References: <47D166E7.2050803@redhat.com> <1205120600.20271.3.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1205120600.20271.3.camel@sli10-desk.sh.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shaohua,

Thank you for reviewing!

Shaohua Li wrote:
> On Sat, 2008-03-08 at 00:01 +0800, Masami Hiramatsu wrote:
>> From: Masami Hiramatsu <mhiramat@redhat.com>
>> +
>> +/* Prepare long jump bundle and disables other boosters if need */
>> +static void __kprobes prepare_booster(struct kprobe *p)
>> +{
>> +       unsigned long addr = (unsigned long)p->addr & ~0xFULL;
>> +       unsigned int slot = addr & 0xf;
> slot = (unsigned long)p->addr & 0xf ?

You are correct. I'll fix that.

> 
>> +       struct kprobe *other_kp;
>> +
>> +       if (can_boost(&p->ainsn.insn[0].bundle, slot, addr)) {
>> +               set_brl_inst(&p->ainsn.insn[1].bundle, (bundle_t
>> *)addr + 1);
>> +               p->ainsn.inst_flag |= INST_FLAG_BOOSTABLE;
>> +       }
>> +
>> +       /* disables boosters in previous slots */
>> +       for (; addr < (unsigned long)p->addr; addr++) {
>> +               other_kp = get_kprobe((void *)addr);
>> +               if (other_kp)
>> +                       other_kp->ainsn.inst_flag &=
>> ~INST_FLAG_BOOSTABLE;
>> +       }
>> +}
>> +
> There is no lock to protect the flag. If one cpu invokes other_kp and
> the other cpu is changing the flag, what's the result?

I think that other cpu never change the flag, because the caller of this
function(__register_kprobe) locks kprobe_mutex in kernel/kprobes.c.

> Thanks,
> Shaohua

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

