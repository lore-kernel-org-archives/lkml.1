Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYKTQHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYKTQHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYKTQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:07:10 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:19099 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYKTQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:07:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bS5plNGUVPcBLOuyw3ArdGhDbVZ4pmjsxOV/9wfhiWBs9jwfd0CBWUqxW/DrLd35zY
         P1dBUV9hr0bv8PGvQTl3L1/IoG1vjKdnuRv2TouLlF3bbvQR8qr73mkYRxAV3NXMFBke
         ZKcRPefnb9cg+PfaSh9pOO0rqxWVKhs5nZ0Ic=
Date: Thu, 20 Nov 2008 19:07:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] x86: clean up after: move entry_64.S register saving
	out of the macros
Message-ID: <20081120160702.GB7363@localhost>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081120155744.GA4130@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120155744.GA4130@mailshack.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Thu, Nov 20, 2008 at 04:57:44PM +0100]
| On Thu, Nov 20, 2008 at 04:39:54PM +0100, Ingo Molnar wrote:
| > 
| > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
| > 
| > > On Thu, Nov 20, 2008 at 04:04:12PM +0100, Ingo Molnar wrote:
| > > > 
| > > > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
| > > > 
| > > > > This add-on patch to x86: move entry_64.S register saving out of the 
| > > > > macros visually cleans up the appearance of the code by introducing 
| > > > > some basic helper macro's. It also adds some cfi annotations which 
| > > > > were missing.
| > > > > 
| > > > > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| > > > > ---
| > > > >  arch/x86/kernel/entry_64.S |  220 ++++++++++++++++++++++----------------------
| > > > >  1 files changed, 112 insertions(+), 108 deletions(-)
| > > > > 
| > > > > Hello Ingo,
| > > > > 
| > > > > This patch improves the CFI-situation in entry_64.S, but restricted 
| > > > > mostly to the areas touched by "x86: move entry_64.S register saving 
| > > > > out of the macros". I'm sure there will be some small errors 
| > > > > somewhere, but it compiles and runs fine.
| > > > 
| > > > very nice cleanup! This is exactly what should be done. Applied to 
| > > > tip/x86/irq.
| > > > 
| > > > Note, i did a small rename:
| > > > 
| > > >     cfi_pushq  =>  pushq_cfi
| > > >     cfi_popq   =>  popq_cfi
| > > >     cfi_store  =>  movq_cfi
| 
| Does not work... But if you are attached to the underscores, I
| think we can force it to work by using CPP to convert it to
| something the assembler does parse right:
| 
| #define pushq_cfi pushq.cfi
| 
| etc?
| 
| Or is that just too ugly?
| 
| Alexander
| 
| > > > as the goal is to have the actual source code read mostly as regular 
| > > > assembly code. The fact that the macro is equivalent to a 
| > > > default-annotated pushq/popq/movq instruction is much more important 
| > > > than the fact that it also does CFI annotations.
| > > > 
| > > > Also, while cfi_store is correct as well, the usual x86 assembly term 
| > > > (and instruction used here) is movq.
| > > 
| > > Now I have a little problem with my next patch... I wanted to 
| > > introduce cfi_load. Guess what assembly instruction that maps to ;).
| > 
| > heh ;-)
| > 
| > the restore direction could be named movq_cfi_restore, and have the same 
| > order of arguments as the regular movq that it replaces. I.e.:
| > 
| >         movq 8(%rsp),%r11
| >         CFI_RESTORE r11
| > 
| > would map to:
| > 
| > 	movq_cfi_restore 8, r11
| > 
| > or so.
| > 
| > cfi_store has really a bad name: it's confusing whether it's the CFI 
| > info we are storing/registering (which we are), or a 'store' instruction 
| > (which this is too).
| > 
| > If then we should name it movq_cfi_store or movq_cfi_register - but 
| > that's too long.
| > 
| > movq_cfi for the frame construction direction and movq_cfi_restore for 
| > the frame deconstruction phase sounds like a good naming compromise, hm?
| > 
| > 	Ingo
| 
| -- 
| Alexander van Heukelum
| 

Hi,

I didn't check if it possible but maybe just put these CFI
annotations on right side like

	movq 8(%rsp),%r11		; CFI_RESTORE r11

Hmm? Yes I know -- it will not make 'auto' cfi annotations
but *anyway* if say I'm to write this kind of code I _have_
to know how CFI works (or at least read some specs about)
I guess.

		- Cyrill -
