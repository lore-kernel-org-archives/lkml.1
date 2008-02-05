Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbYBEVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbYBEVh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYBEVhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:37:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbYBEVhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:37:11 -0500
Date: Tue, 5 Feb 2008 22:36:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
Message-ID: <20080205213650.GB14708@elte.hu>
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ingo, Thomas,
>  should we not do this?
> 
> Otherwise, it seems we generate a section that isn't allocated?
> 
> I think toolchain should add the right flags automatically for 
> sections that start with ".[ro]data" and ".text", but not for the 
> kernel-specific ".init.*" sections.

>  #ifndef CONFIG_HOTPLUG_CPU
> -	.pushsection .init.data
> +	.pushsection .init.data,"aw"
>  #endif

hm, did you get linker errors due to an unallocated section discarded 
from the vmlinux?

Sam says that forgetting the "aw" attribute means it's .init.data.1, so 
the standard vmlinux.lds rule does not pick it up:

  .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
        _sinittext = .;
        INIT_TEXT
        _einittext = .;
  }

as INIT_TEXT is defined as:

#define INIT_TEXT                                                       \
        *(.init.text)                                                   \

which wouldnt pick up .init.text.1, and the linker would thus discard 
the section?

i'm wondering whether it's possible to add a wildcard, something like 
this:

#define INIT_TEXT                                                       \
        *(.init.text*)                                                  \

? That way even if we forget the attribute, it gets picked up.

	Ingo
