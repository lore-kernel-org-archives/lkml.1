Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZDWSZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZDWSZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZDWSZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:25:33 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37928 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZDWSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:25:33 -0400
Date: Thu, 23 Apr 2009 19:03:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
 synchronization logic
In-Reply-To: <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904231807370.7545@blonde.anvils>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
  <1240439073.12721.23.camel@earth> <20090423082704.GD599@elte.hu>
 <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Dmitry Adamushko wrote:
> 2009/4/23 Ingo Molnar <mingo@elte.hu>:
> > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> >
> >> Version 3
> >>
> >> diff with v.2
> >>
> >> - use smp_call_function_single() instead of work_on_cpu() as suggested by Ingo;
> >> - add 'enum ucode_state' as return value of request_microcode_{fw,user}
> >> - minor cleanups
> >
> > This version looks really nice structurally.

Yes, it looks the right way to go to me too.

> > What type of testing have you done on the patch, on what CPU type?
> 
> Quite limited testing. It looks like there is no newer ucode availble
> for my dual-core Intel Core2 Duo (Thinkpad R60) so what I did is as
> follows:
> 
> - change update_match_revision() in microcode_intel.c in a way that
> allows loading of a ucode with a revision == the current revision
> (rev. 0x57 in my case). From the POV of the microcode module it
> nevertheless looks like an update;

My P4 Xeon and Core2s and Atom all want newer microcode from the
latest microcode.dat, and your version seems to work fine on them.

> 
> - update via /dev/microcode (CONFIG_MICROCODE_OLD_INTERFACE) with a .dat file;
> 
> - suspend -> resume (reload of ucode via cpu-callbacks)
> 
> These tests worked for me.

Yes, and I've also tried #if 0'ing the MICROCODE_OLD_INTERFACE code,
converting the microcode.dat to binary, and placing that in
/lib/firmware/intel-ucode/06-0f-0a or wherever: the firmware
interface seems to be working too.

> 
> Obviously, it'd be nice if more people could give it a try (e.g.
> update with a firmware image and also on AMD - although the changes in
> microcode_amd.c are quite straightforward).

But like you I don't have an AMD to test.

And just like last time I came here, I find there are more alternative
ways through all this than I'm familiar with, and have time to test:
device versus firmware, Intel versus AMD, startup versus resume versus
online, builtin versus modular.  I get easily confused without more
time to spend on it.

That SYSTEM_RUNNING test you've flagged with "--dimm. Review this case":
yes, that's still necessary for when CONFIG_MICROCODE=y (and no initrd?),
as I have - trying to get the firmware at that point will hang.  I did
try changing module_init(microcode_init) to late_initcall(microcode_init),
but that didn't solve it.  And skipping out at that point does leave CPU0
not updated.  But you've not made anything worse there, and most people
will have CONFIG_MICROCODE=m.

> 
> p.s. argh... just noticed that the following line is redundant in
> microcode_core.c (forgot to remove it)
> 
> +enum { UCODE_UPDATE_ERR, UCODE_UPDATE_OK, UCODE_UPDATE_NAVAIL };

A couple of things that worried me.

I guess your mutex Synchronization works out, but are interrupts
still disabled around the critical wrmsr()s, wherever they're getting
called from?

And you've a habit of returning -1 in error cases, which later gets
muddled in with errnos, so that it would amount to -EPERM, which is
probably not what you want.

Hugh
