Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbZDWWQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbZDWWQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbZDWWQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:16:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53232 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759158AbZDWWQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V3MotB0vnTv3j27brQTBBRtFFSt4L88wwAUVlCZanNG11rPO1MAczUQwKVAYTTJ84n
         Jqefg0E7lB0zeT+kgWsNvvprsyIKjTAMyPGsq84+zwuHNHG1NQQLQZelF+qo6h9Si1Ip
         y3aTGzdasuRva7iwFPZFlkFSM6c8lfWVGwuhU=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904231807370.7545@blonde.anvils>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
	 <1240439073.12721.23.camel@earth> <20090423082704.GD599@elte.hu>
	 <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com>
	 <Pine.LNX.4.64.0904231807370.7545@blonde.anvils>
Date: Fri, 24 Apr 2009 00:16:35 +0200
Message-ID: <b647ffbd0904231516x576c7ae4y36fedc9bc4fcf0f@mail.gmail.com>
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
	synchronization logic
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/23 Hugh Dickins <hugh@veritas.com>:
> On Thu, 23 Apr 2009, Dmitry Adamushko wrote:
>> [ ... ]
>> - change update_match_revision() in microcode_intel.c in a way that
>> allows loading of a ucode with a revision == the current revision
>> (rev. 0x57 in my case). From the POV of the microcode module it
>> nevertheless looks like an update;
>
> My P4 Xeon and Core2s and Atom all want newer microcode from the
> latest microcode.dat, and your version seems to work fine on them.

Thanks for the tests and review!

> [ ... ]
>
> That SYSTEM_RUNNING test you've flagged with "--dimm. Review this case":
> yes, that's still necessary for when CONFIG_MICROCODE=y (and no initrd?),
> as I have - trying to get the firmware at that point will hang.  I did
> try changing module_init(microcode_init) to late_initcall(microcode_init),
> but that didn't solve it.  And skipping out at that point does leave CPU0
> not updated.  But you've not made anything worse there, and most people
> will have CONFIG_MICROCODE=m.

Yeah. Then at least for the sake of consistency it makes sense to
consider doing some kind of delayed update for CPU0 in this case. Will
check.

>>
>> p.s. argh... just noticed that the following line is redundant in
>> microcode_core.c (forgot to remove it)
>>
>> +enum { UCODE_UPDATE_ERR, UCODE_UPDATE_OK, UCODE_UPDATE_NAVAIL };
>
> A couple of things that worried me.
>
> I guess your mutex Synchronization works out, but are interrupts
> still disabled around the critical wrmsr()s, wherever they're getting
> called from?

Yes, *msr() calls are only done from functions that are now being
called via smp_call_function_single(). The later seems to always do it
with disabled interrupts. The only exception is mc_sysdev_resume()
calling  ->apply_microcode() directly but this one in turn is always
called with disabled interrupts.

But now that you mentioned it I wonder if we may actually need a
spinlock there... can we have multi-threaded cpus/cores with (all |
some) shared msr registers?


> And you've a habit of returning -1 in error cases, which later gets
> muddled in with errnos, so that it would amount to -EPERM, which is
> probably not what you want.

Indeed, will fix. Thanks!


>
> Hugh
>

-- 
Best regards,
Dmitry Adamushko
