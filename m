Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZFVO1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZFVO1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZFVO1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:27:31 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61307 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZFVO1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=S5cKjAhAY1vUay23zTTwpqM+Q3GexMNyZRNhq9b/uLg9iPgpD3emUCQiYl6VmtCpFc
         hi3tQg8XjU7ahPLQQvDg+4Sl2ySmL755VA1PTuNqSC02edwpLQirSB5fDcuPQZoPkfpD
         vO6ip1B7ZFP9Lzx4N/YweGQ5gVwQ75k5+BnNI=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090622115703.GM24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115703.GM24366@elte.hu>
Date: Mon, 22 Jun 2009 16:27:31 +0200
Message-ID: <7c86c4470906220727l2a50753eg93c44006b8c2c589@mail.gmail.com>
Subject: Re: II.1 - Fixed counters on Intel
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 1:57 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> II/ X86 comments
>>
>>  1/ Fixed counters on Intel
>>
>> You cannot simply fall back to generic counters if you cannot find
>> a fixed counter. There are model-specific bugs, for instance
>> UNHALTED_REFERENCE_CYCLES (0x013c), does not measure the same
>> thing on Nehalem when it is used in fixed counter 2 or a generic
>> counter. The same is true on Core.
>
> This could be handled via a model specific quirk, if the erratum is
> serious enough.

Better demonstrated with an actual example on a 2.4GHz Quad: 10s noploop

$ pfmon -v --us-c
-eunhalted_core_cycles,unhalted_reference_cycles,cpu_clk_unhalted:bus
-u noploop 10
[FIXED_CTRL(pmc16)=0xaa0 pmi0=1 en0=0x0 pmi1=1 en1=0x2 pmi2=1 en2=0x2]
UNHALTED_CORE_CYCLES UNHALTED_REFERENCE_CYCLES
[PERFEVTSEL0(pmc0)=0x51013c event_sel=0x3c umask=0x1 os=0 usr=1 en=1
int=1 inv=0 edge=0 cnt_mask=0] CPU_CLK_UNHALTED
noploop for 10 seconds
23,833,577,042 UNHALTED_CORE_CYCLES
23,853,100,716 UNHALTED_REFERENCE_CYCLES
 2,650,345,853 CPU_CLK_UNHALTED:BUS

0x013c on fixed counter2 = unhalted_reference_cycles
0x013c on generic counter = cpu_clk_unhalted:bus

Difference is significant, isn't it?

And the question becomes: how do I express that I want the fixed counter version
of the event using the current PCL API, given both have the same encoding?


>
>> You cannot simply look at the event field code to determine
>> whether this is an event supported by a fixed counters. You must
>> look at the other fields such as edge, invert, cnt-mask. If those
>> are present then you have to fall back to using a generic counter
>> as fixed counters only support priv level filtering. As indicated
>> above, though, programming UNHALTED_REFERENCE_CYCLES on a generic
>> counter does not count the same thing, therefore you need to fail
>> if filters other than priv levels are present on this event.
>
> Agreed, we'll fix this.
>
