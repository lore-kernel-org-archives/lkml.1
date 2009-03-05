Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZCEABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZCEABR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 19:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZCEABE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 19:01:04 -0500
Received: from gw.goop.org ([64.81.55.164]:37913 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbZCEABD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 19:01:03 -0500
Message-ID: <49AF163A.8080701@goop.org>
Date: Wed, 04 Mar 2009 16:00:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [x86] warning: parameter has incomplete type
References: <200903042001.FBI26540.QFHLFSMJVFOOtO@I-love.SAKURA.ne.jp>
In-Reply-To: <200903042001.FBI26540.QFHLFSMJVFOOtO@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
>
> Is there a patch to suppress below warning messages (which are printed for every
> file when compiling kernel using gcc 3.3.5)?
>   

Hm, that's a very old compiler.  The warning is correct, I guess, but of 
no consequence.  It would be impossible to call the functions without a 
proper definition of the structure in scope, and the structure 
forward-declaration guarantees that the prototype and the eventual 
structure definition will be the same.

The simple fix, include pgtable_types.h, is undesireable because we're 
trying to untangle the headers rather than add more interdependencies.  
I think the fix is to put those prototypes somewhere else (asm/pat.h, 
perhaps?).

    J
> Regards.
> --------------------
> # cat ~/warn.sh
> #! /bin/sh
> make -s oldconfig
> touch init/main.c
> make init/main.o > /tmp/log 2>&1
> grep -qF "warning: parameter has incomplete type" /tmp/log && exit 1
> exit 0
> # git bisect start next-20090227 v2.6.29-rc6 --
> Bisecting: 4206 revisions left to test after this
> [617e8ed824f58c467b97d3c08ad3fc46efc9041c] Merge commit 'kvm/master'
> # git bisect run ~/warn.sh
> running /root/warn.sh
> #
> # configuration written to .config
> #
> In file included from /usr/src/all/linux-next/arch/x86/include/asm/page.h:8,
>                  from /usr/src/all/linux-next/arch/x86/include/asm/processor.h:18,
>                  from /usr/src/all/linux-next/arch/x86/include/asm/atomic_32.h:6,
>                  from /usr/src/all/linux-next/arch/x86/include/asm/atomic.h:2,
>                  from include/linux/crypto.h:20,
>                  from arch/x86/kernel/asm-offsets_32.c:7,
>                  from arch/x86/kernel/asm-offsets.c:2:
> /usr/src/all/linux-next/arch/x86/include/asm/page_types.h:54: warning: parameter has incomplete type
> /usr/src/all/linux-next/arch/x86/include/asm/page_types.h:56: warning: parameter has incomplete type
> In file included from /usr/src/all/linux-next/arch/x86/include/asm/page.h:8,
>                  from /usr/src/all/linux-next/arch/x86/include/asm/processor.h:18,
>                  from include/linux/prefetch.h:14,
>                  from include/linux/list.h:6,
>                  from include/linux/module.h:9,
>                  from init/main.c:13:
> /usr/src/all/linux-next/arch/x86/include/asm/page_types.h:54: warning: parameter has incomplete type
> /usr/src/all/linux-next/arch/x86/include/asm/page_types.h:56: warning: parameter has incomplete type
> (... snipped ...)
> Bisecting: 0 revisions left to test after this
> [e2f5bda94152fa567f6b48126741014123f982b8] x86: define pud_flags and pud_large properly to allow non-PAE builds
> running /root/warn.sh
> #
> # configuration written to .config
> #
> 54321d947ae9d6a051b81e3eccaf2d8658aeecc6 is first bad commit
> commit 54321d947ae9d6a051b81e3eccaf2d8658aeecc6
> Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date:   Wed Feb 11 10:20:05 2009 -0800
>
>     x86: move pte types into pgtable*.h
>
>     pgtable*.h is intended for definitions relating to actual pagetables
>     and their entries, so move all the definitions for
>     (pte|pmd|pud|pgd)(val)?_t to the appropriate pgtable*.h headers.
>
>     Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> :040000 040000 b7eda528704700c2e053ba659b4b6823d044d741 f169afe254054f023240ccc371def6774385e742 M      arch
> bisect run success
>   

