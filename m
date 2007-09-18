Return-Path: <linux-kernel-owner+w=401wt.eu-S932269AbXIRR7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbXIRR7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761467AbXIRR7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:59:16 -0400
Received: from highlandsun.propagation.net ([66.221.212.168]:4456 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761444AbXIRR7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:59:15 -0400
Message-ID: <46F010B1.5060502@symas.com>
Date: Tue, 18 Sep 2007 10:53:53 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9a8pre) Gecko/2007091708 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com>	<86802c440709141012w1e85e4caue0d2c7f849dba1cb@mail.gmail.com>	<46ED54EF.3040209@symas.com>	<86802c440709161053x7f549e84u815c6494d921d393@mail.gmail.com> <m1lkb6xxl2.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lkb6xxl2.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> but Andi and Eric said resetting mtrr is not good... when someone from
>> intel try to trim the MTRR for intel CPU.
> 
> There are a couple issues with changing the MTRR configuration.
> - You may not have perfect information on the cpu, the AMD revF is a good
>   example.
> - Code in SMM mode may actually depend on the current mtrr configuration.
> - The BIOS's need to fixed to setup MTRRs properly.

Well the BIOS is definitely doing it wrong here. As I mentioned before, it was 
setting up
	0-0x100000000 WB
	0xc0000000 - 0x100000000 UC
	0xc0000000 - 0xd0000000 WC

But the Intel Architecture Software Developer's Manual states that whenever 
any variable MTRR range overlaps with an UC MTRR range, the range remains UC. 
(Section 9.12.2.3). So in fact what I needed to set was
	0-2GB WB
	2-3GB WB
	3-3.25GB WC
and delete the 3-4GB UC range to get the behavior that the BIOS seems to have 
been intending to set up. (Relying on the default of UC for the unspecified 
ranges.)

> So the sanest approach appears to be.
> - In linux only use ram that is mapped by a write-back mtrr.
>   This preserves performance and is always safe.
> - If you need write-combining set it up in the page tables with PAT.
> 
> There is some difficulty there but software can always do those things
> safely.

Hm. Section 9.5.1 of the doc (table 9-5) says that anything marked UC is 
always UC regardless of the bits in the page table. So with the MTRR setup 
that the BIOS left me with, this is still a no-go. There's no way to get the 
desired effect without completely reinitializing the MTRRs.

Of course, this isn't the only problem with these Asus BIOSs...
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP     http://www.openldap.org/project/
