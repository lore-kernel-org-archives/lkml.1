Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXIPSlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXIPSlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXIPSlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:41:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44333 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbXIPSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:41:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Howard Chu" <hyc@symas.com>, "Andi Kleen" <ak@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com>
	<86802c440709141012w1e85e4caue0d2c7f849dba1cb@mail.gmail.com>
	<46ED54EF.3040209@symas.com>
	<86802c440709161053x7f549e84u815c6494d921d393@mail.gmail.com>
Date: Sun, 16 Sep 2007 12:40:57 -0600
In-Reply-To: <86802c440709161053x7f549e84u815c6494d921d393@mail.gmail.com>
	(Yinghai Lu's message of "Sun, 16 Sep 2007 10:53:28 -0700")
Message-ID: <m1lkb6xxl2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On 9/16/07, Howard Chu <hyc@symas.com> wrote:
>> Yinghai Lu wrote:
>> > On 9/14/07, Howard Chu <hyc@symas.com> wrote:
>> >> Hi, was wondering if anyone else has been tripped up by this... I've got
> 4GB of
>> >> RAM in my Asus A8V Deluxe and memory hole mapping enabled in the BIOS. By
>> >> default, my system boots up with these MTRR settings:
>> >>
>> >> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>> >> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>> >> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>> >> reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
>
> if rev F before cpu aka Rev E is installed, and 8G RAM installed, it will be
>> >> reg00: base=0x00000000 (   0MB), size=8192MB: write-back, count=1
>> >> reg01: base=0x100000000 (8192MB), size=1024MB: write-back, count=1
>> >> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>> >> reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
> and you will have problem...
>
> So good way is get the ram top, and hole size...and reset the whole
> set ot var mtrr.
>
> you could refer the code in LinuxBIOS about setting that...
> http://www.openbios.org/viewvc/trunk/LinuxBIOSv2/src/cpu/x86/mtrr/mtrr.c?revision=2616&view=markup
> esp the part about CONFIG_VAR_MTRR_HOLE...
>
> but Andi and Eric said resetting mtrr is not good... when someone from
> intel try to trim the MTRR for intel CPU.

There are a couple issues with changing the MTRR configuration.
- You may not have perfect information on the cpu, the AMD revF is a good
  example.
- Code in SMM mode may actually depend on the current mtrr configuration.
- The BIOS's need to fixed to setup MTRRs properly.

So the sanest approach appears to be.
- In linux only use ram that is mapped by a write-back mtrr.
  This preserves performance and is always safe.
- If you need write-combining set it up in the page tables with PAT.

There is some difficulty there but software can always do those things
safely.

Eric
