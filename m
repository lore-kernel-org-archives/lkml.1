Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbXIRSSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbXIRSSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbXIRSSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:18:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52518 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbXIRSSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:18:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Howard Chu <hyc@symas.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com>
	<86802c440709141012w1e85e4caue0d2c7f849dba1cb@mail.gmail.com>
	<46ED54EF.3040209@symas.com>
	<86802c440709161053x7f549e84u815c6494d921d393@mail.gmail.com>
	<m1lkb6xxl2.fsf@ebiederm.dsl.xmission.com>
	<46F010B1.5060502@symas.com>
Date: Tue, 18 Sep 2007 12:18:12 -0600
In-Reply-To: <46F010B1.5060502@symas.com> (Howard Chu's message of "Tue, 18
	Sep 2007 10:53:53 -0700")
Message-ID: <m1fy1bq1ln.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Howard Chu <hyc@symas.com> writes:

> Eric W. Biederman wrote:
>>> but Andi and Eric said resetting mtrr is not good... when someone from
>>> intel try to trim the MTRR for intel CPU.
>>
>> There are a couple issues with changing the MTRR configuration.
>> - You may not have perfect information on the cpu, the AMD revF is a good
>>   example.
>> - Code in SMM mode may actually depend on the current mtrr configuration.
>> - The BIOS's need to fixed to setup MTRRs properly.
>
> Well the BIOS is definitely doing it wrong here. As I mentioned before, it was
> setting up
> 	0-0x100000000 WB
> 	0xc0000000 - 0x100000000 UC
> 	0xc0000000 - 0xd0000000 WC

Ok.  I do agree that is wrong, and really weird to.

> But the Intel Architecture Software Developer's Manual states that whenever any
> variable MTRR range overlaps with an UC MTRR range, the range remains
> UC. (Section 9.12.2.3). So in fact what I needed to set was
> 	0-2GB WB
> 	2-3GB WB
> 	3-3.25GB WC
> and delete the 3-4GB UC range to get the behavior that the BIOS seems to have
> been intending to set up. (Relying on the default of UC for the unspecified
> ranges.)

Which is certainly a good way to go if your hole sizes allow and you
have enough MTRRs.

>> So the sanest approach appears to be.
>> - In linux only use ram that is mapped by a write-back mtrr.
>>   This preserves performance and is always safe.
>> - If you need write-combining set it up in the page tables with PAT.
>>
>> There is some difficulty there but software can always do those things
>> safely.
>
> Hm. Section 9.5.1 of the doc (table 9-5) says that anything marked UC is always
> UC regardless of the bits in the page table. So with the MTRR setup that the
> BIOS left me with, this is still a no-go. There's no way to get the desired
> effect without completely reinitializing the MTRRs.

Please look a little more closely.  WC is a flavor of UC.  There is a
specific exception that allows page tables to promote UC to WC.

I don't seem to have the same version of this document so I can't
refer you to specific sections.  But I have looked it up several
times and every time I have looked I have found the exception that
allows PAT to promote UC to WC.

> Of course, this isn't the only problem with these Asus BIOSs...

Sure.

My point was that when we try to solve the general problem rather then
a specific case there are some very practical limits on what can be
done.

Now it should be mentioned that you can go in with /proc/mtrr and fix
things manually on a specific machine.


Eric
