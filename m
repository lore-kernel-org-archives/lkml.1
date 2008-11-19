Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYKSJXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYKSJXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYKSJXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:23:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:17204 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYKSJXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:23:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=tIbBbbhFEdxI3II+mCcsnztI3RESFD3ikxk98bD4375Hn1hwNYpKJiOdKae5NPWXb6
         9vD0aeQwIjA92eUAowCKlEz1txiqGNl3yxn3JdNTLzQqkRZticTGWdPM0XeSJCFMCoLS
         m1qZ63TZFsNc/tvijGGE92Z2vZu5tlFOg0xuY=
From: Eric Lacombe <goretux@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] do_arch_prctl - bug?
Date: Wed, 19 Nov 2008 10:23:16 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.5; KDE/4.1.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200811181835.07360.goretux@gmail.com> <200811190044.11566.goretux@gmail.com> <492366CB.8020905@goop.org>
In-Reply-To: <492366CB.8020905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811191023.16358.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 novembre 2008 02:07:23 Jeremy Fitzhardinge, vous avez écrit :
> Eric Lacombe wrote:
> > I look at the Intel docs (vol. 3A) again, and see that in 64 bits mode
> > the hidden field gs.base are physically mapped to the MSR, so it seems
> > that in order to load gs.base we don't need to load gs (like in 32 bits
> > mode), but rather we only need to load the MSR.
> >
> > So I don't understand the purpose of load_gs_index in that context :
> >
> > if (doit) {
> > 	load_gs_index(0);
> > 	ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
> > }
> >
> > Why don't we only load the MSR ?
> > What is the purpose of calling load_gs_index with 0 as parameter ?
>
> Because %gs of 0 means "base too large, go to MSR".  If you have a
> 32-bit base, then loading it into the gdt and loading %gs with the right
> selector is faster.  wrmsr/rdmsr are slow instructions.

Ok, thanks, so I suppose now that only doing :
asm volatile("movl %0,%%gs" :: "r" (0));
could corrupt the address of the PDA that resides actually in the MSR_GS_BASE. 
And that's why load_gs_index is used as it contains "swapgs" before and after 
the "mov to gs".

Is that correct?

Regards,

	Eric
