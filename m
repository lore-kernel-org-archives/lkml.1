Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYCTTDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYCTTDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYCTTCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:02:55 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:46501 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbYCTTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:02:54 -0400
Date: Thu, 20 Mar 2008 12:02:40 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: Re: [patch 4/4] x86: apic_is_clustered_box to indicate unsynched TSC's on multiboard vSMP systems
Message-ID: <20080320190240.GB6085@localdomain>
References: <20080320073740.GA9414@localdomain> <20080320074508.GE9414@localdomain> <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 12:53:25AM -0700, Yinghai Lu wrote:
>On Thu, Mar 20, 2008 at 12:45 AM, Ravikiran G Thirumalai
><kiran@scalex86.org> wrote:
>> Indicate TSCs are unreliable as time sources if the platform is
>>  a multi chassi ScaleMP vSMPowered machine.
>>
>>  Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>>
>>  Index: linux.git.trees/arch/x86/kernel/apic_64.c
>>  ===================================================================
>>  --- linux.git.trees.orig/arch/x86/kernel/apic_64.c      2008-03-19 20:42:28.187659497 -0700
>>  +++ linux.git.trees/arch/x86/kernel/apic_64.c   2008-03-19 21:24:17.705515003 -0700
>>  @@ -1208,7 +1208,7 @@ __cpuinit int apic_is_clustered_box(void
>>          * will be [4, 0x23] or [8, 0x27] could be thought to
>>          * vsmp box still need checking...
>>          */
>>  -       if (!is_vsmp_box() && (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
>>  +       if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
>>                 return 0;
>
>why?
>
>>
>>         bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
>>  @@ -1248,6 +1248,12 @@ __cpuinit int apic_is_clustered_box(void
>>                         ++zeros;
>>         }
>>
>>  +       /* ScaleMP vSMPowered boxes have one cluster per board and TSCs are
>>  +        * not guaranteed to be synced between boards
>>  +        */
>>  +       if (is_vsmp_box() && clusters > 1)
>>  +               return 1;
>
>you still call that for intel box.

Yes.  The first call is to state that TSC's are synced if it is an  AMD box
and if it is _not_ a vSMPowered box (for the apic id lifting case on Sun
boxes), the second call is for _any_ vSMPowered system with more than one
board -- TSC's are not guaranteed to be synched in that case.  Both these
calls are needed.

Thanks,
Kiran
