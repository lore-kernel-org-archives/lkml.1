Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbXHRAFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbXHRAFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXHRAFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:05:18 -0400
Received: from gw.goop.org ([64.81.55.164]:44450 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbXHRAFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:05:16 -0400
Message-ID: <46C637B7.30200@goop.org>
Date: Fri, 17 Aug 2007 17:05:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
 issue
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de>
In-Reply-To: <20070809124132.C794A14F3B@wotan.suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Commit 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177 "x86: Fix alternatives
> and kprobes to remap write-protected kernel text" uses code which is
> being patched for patching.
>
> In particular, paravirt_ops does patching in two stages: first it
> calls paravirt_ops.patch, then it fills any remaining instructions
> with nop_out().  nop_out calls text_poke() which calls
> lookup_address() which calls pgd_val() (aka paravirt_ops.pgd_val):
> that call site is one of the places we patch.
>
> If we always do patching as one single call to text_poke(), we only
> need make sure we're not patching the memcpy in text_poke itself.
> This means the prototype to paravirt_ops.patch needs to change, to
> marshal the new code into a buffer rather than patching in place as it
> does now.  It also means all patching goes through text_poke(), which
> is known to be safe (apply_alternatives is also changed to make a
> single patch).
>   

Hi Andi,

This patch breaks Xen booting.  I get infinite recursive faults during
patching when this patch is present.  If I boot with
"noreplace-paravirt" it works OK, and it works as expected if I back
this patch out.  I haven't tracked down the exact failure mode; its a
little hard to debug because it overwrites all kernel memory with
recursive fault stackframes and then finally traps out to Xen when it
hits the bottom of memory.

I think we should back this one out before .23.

    J
