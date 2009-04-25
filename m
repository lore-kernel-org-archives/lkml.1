Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZDYKaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZDYKaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 06:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZDYKaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 06:30:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41061 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZDYKaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 06:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r0Zy3MmSgtJHhIhSAGYXso9WqsDVRUvfpL8A/bNPqiIXG0KpOU3E2Kcs+nzrBKuudW
         52XXp07li1Fg54G00EOhQyFPFBi4tW9SfrZFv5r02BEg5AIfw6jfA+UJ+fQic/to7q00
         wZZejtUtQw8pGGKv8e0Gb2MSzP0yAjcoFxhLQ=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904241816001.10674@blonde.anvils>
References: <1240258569.6195.8.camel@earth> <1240439073.12721.23.camel@earth>
	 <20090423082704.GD599@elte.hu>
	 <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com>
	 <Pine.LNX.4.64.0904231807370.7545@blonde.anvils>
	 <b647ffbd0904231516x576c7ae4y36fedc9bc4fcf0f@mail.gmail.com>
	 <Pine.LNX.4.64.0904241300340.21735@blonde.anvils>
	 <b647ffbd0904240711v6e6930f5ia438bdcd69a015a4@mail.gmail.com>
	 <b647ffbd0904241001u2d787931k99d12112e0b09ff@mail.gmail.com>
	 <Pine.LNX.4.64.0904241816001.10674@blonde.anvils>
Date: Sat, 25 Apr 2009 12:30:11 +0200
Message-ID: <b647ffbd0904250330gf2e909bt14b8fd702cda6bdc@mail.gmail.com>
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

2009/4/24 Hugh Dickins <hugh@veritas.com>:
> On Fri, 24 Apr 2009, Dmitry Adamushko wrote:
>> 2009/4/24 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>> > 2009/4/24 Hugh Dickins <hugh@veritas.com>:
>> >>
>> >> Good thinking, yes we can and do, unless I'm misinterpreting the
>> >> evidence.  Though P4 Xeon and Atom startup messages give the opposite
>> >> impression, claiming to update all cpus from lower revision, more
>> >> careful tests starting from "maxcpus=1" and then "echo 1 >online"
>> >> (which, unless you've fiddled around putting the microcode_ctl'ed
>> >> microcode.dat into /lib/firmware/intel-ucode/wherever, isn't able
>> >> to update at online time on Intel) shows that the later onlined
>> >> siblings already have the updated microcode applied to their
>> >> previously onlined siblings.  Which isn't surprising, but I'd
>> >> been lulled into thinking the opposite by the startup sequence.
> ...
>>
>> But then I wonder why behavior (the fact that all threads seem to
>> upgrade to a newer version during the startup but they seem to already
>> be 'up-to-date' if onlined later) during the startup is different...
>
> I believe it's because the module_init microcode_init() calls
> sysdev_driver_register(), which does mc_sysdev_add() of (all possible?)
> cpus, which for online cpus calls microcode_init_cpu(), which does
> collect_cpu_info() then, if SYSTEM_RUNNING, request_microcode_fw()
> and apply_microcode_on_target() (names with your patch applied).
>
> If the microcode driver is builtin (so gets here before SYSTEM_RUNNING),
> or if it's for Intel with no firmware in /lib/firmware/intel-ucode/X-X-X
> yet, the cpu_sig is thus obtained for all online cpus, before initscripts
> run /sbin/microcode_ctl to update from /etc/microcode.dat successfully:
> the "updated from revision" message shows uci->cpu_sig.rev as it
> was saved earlier, rather than reevaluating it just before update.
>
> That's confusing for us, and confusing when resume shows updated from
> high revision to same high revision (though, I think, the revision
> should in fact have reverted during suspend); but might be even more
> worrying to HT users if it were corrected (it would seem as if only
> half their cpus got updated, when before all were).  I don't know.

Perhaps, it doesn't make sense to cache 'cpu_sig' at all. I'll ponder
on it a bit and send a new patch.

Thanks a lot for your feedback!

>
>> Too pity that I can't see it with my setups (heh, I perhaps could play
>> with it by actually downgrading cpus to older ucode).
>
> Please, Intel, ship this man some out-of-date hardware!
>
> (You're sure your cpus really are up-to-date?  I thought several
> of my boxes were, but then discovered a modinfo line in openSUSE
> 11.1's /etc/init.d/microcode.ctl, which had been added since 10.3,
> which was now disabling it when microcode driver built into kernel.)
>

hmm, I downloaded - what seems to be - the recent .dat file from the
Intel's site and run microcode_ctl (a binary, no additional scripts
manually). I will check the site for updates again.

>
> Hugh
>

-- 
Best regards,
Dmitry Adamushko
