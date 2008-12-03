Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYLCMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYLCMBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYLCMBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:01:09 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:58292 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYLCMBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:01:08 -0500
X-BigFish: VPS-40(zz146fK1432R62a3L98dR936eQ1805Mzzzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBAUP9-02-1UD-01
Date: Wed, 3 Dec 2008 12:59:54 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <ak@linux.intel.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] oprofile: fix CPU unplug panic in ppro_stop()
Message-ID: <20081203115954.GH11656@erda.amd.com>
References: <4934D3E1.1000507@cosmosbay.com> <20081202081729.GA5424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081202081729.GA5424@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Dec 2008 12:00:31.0593 (UTC) FILETIME=[BDB61590:01C9553E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.12.08 09:17:29, Ingo Molnar wrote:
> 
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > If oprofile statically compiled in kernel, a cpu unplug triggers
> > a panic in ppro_stop(), because a NULL pointer is dereferenced.
> >
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > ---
> > arch/x86/oprofile/op_model_ppro.c |    4 ++++
> > 1 files changed, 4 insertions(+)
> 
> > diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> > index 716d26f..e9f80c7 100644
> > --- a/arch/x86/oprofile/op_model_ppro.c
> > +++ b/arch/x86/oprofile/op_model_ppro.c
> > @@ -156,6 +156,8 @@ static void ppro_start(struct op_msrs const * const msrs)
> >  	unsigned int low, high;
> >  	int i;
> >  
> > +	if (!reset_value)
> > +		return;
> >
> > 	for (i = 0; i < num_counters; ++i) {
> >  		if (reset_value[i]) {
> >  			CTRL_READ(low, high, msrs, i);

The patch fixes the null pointer access and this ok. But the root
cause seems to be in the cpu hotplug and initialization
code. xxx_start() should not be called before xxx_setup_ctrs() or
after xxx_shutdown(). Also, running only xxx_start() and xxx_stop() in
the cpu notifier functions is not sufficient. There is at least some
on_each_cpu code in nmi_setup() that should be called also in the cpu
notifier functions. I have to review that code.

[...]

> It was absolutely unnecessary to add kmalloc to this rarely executed 
> codepath - and the way it was added was absolutely horrible as well, it 
> was tacked on in the middle of an existing codepath, instead of factoring 
> it out nicely. Perfmon will eventually replace PMC management anyway, so 
> there was no "this way it's cleaner" argument either. So this code should 
> have been changed minimally, instead of slapping in a full kmalloc for a 
> simple array extension from 2 to 4 entries ...

Ingo, you are right that using kmalloc is unnecessary for
reset_value. So, Andi, maybe you could make this code easier?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

