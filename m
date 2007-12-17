Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbXLQVaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbXLQVaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934871AbXLQV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:29:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934712AbXLQV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:29:24 -0500
Message-ID: <4766E9FC.7050101@redhat.com>
Date: Mon, 17 Dec 2007 16:28:28 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: FInal kprobes rollup patches
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>	 <20071217142235.GA21379@linux.vnet.ibm.com> <1197919234.23402.5.camel@brick>
In-Reply-To: <1197919234.23402.5.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> On Mon, 2007-12-17 at 19:52 +0530, Srikar Dronamraju wrote:
>> * Ingo Molnar <mingo@elte.hu> [2007-12-15 14:12:04]:
>>
>>
>> Hi Ingo, Harvey
>>
>> In file include/asm-x86/kprobes_32.h
>> typedef u8 kprobe_opcode_t;
>> hence sizeof(kprobe_opcode_t) turns out to be 1.
>>
>> Hence
>>
>> memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
>> is correct.
>>
> 
> OK, but this would be much clearer to adopt the X86_64 way, define
> MAX_INSN_SIZE one smaller and make this line:
> 
> /* Copy original instruction plus space for 1 byte relative jump */
> memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE + sizeof(kprobe_opcode_t));
>
> See the first patch of my cleanup work that unified MAX_INSN_SIZE
> and you'll see why this jumped out.
>
> Harvey

If you mention about a relative jump which is inserted by
resume_execution(), I think you might misunderstand that relative jump.

The size of that relative jump, which will be embedded by kprobe-booster, is
5-bytes(not 1 byte). So it needs 5 bytes space.
And we decided not to expand MAX_INSN_SIZE when we developed the booster.
The reasons are:
 - it is supplemental feature(just accelerating kprobes), if we have no space,
   we can disable it.
 - 5 bytes are big enough compared with 15(=MAX_INSN_SIZE)
 - the lengths of most of instructions are less than 10 bytes.

Additionally, MAX_INSN_SIZE is used in kernel/kprobes.c to allocate an
instruction buffer which will be assigned to p->ainsn.insn. Since the
instruction buffer size is MAX_INSN_SIZE, you can not copy instructions
more than MAX_INSN_SIZE.

BTW, in my patch, I unified MAX_INSN_SIZE to bigger one(16).
I think it is enough for us.

Thanks,

Best Regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

