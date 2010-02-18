Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0BRKMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:12:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35911 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab0BRKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:11:59 -0500
Date: Thu, 18 Feb 2010 11:11:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, hpa@zytor.com,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if
	available
Message-ID: <20100218101156.GE5964@basil.fritz.box>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-10-git-send-email-luca@luca-barbieri.com> <87eikj54wp.fsf@basil.nowhere.org> <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 10:53:06AM +0100, Luca Barbieri wrote:
> > You seem to have forgotten to add benchmark results that show this is
> > actually worth while? And is there really any user on 32bit
> > that needs 64bit atomic_t?
> perf is currently the main user.
> On Core2, lock cmpxchg8b takes about 24 cycles and writes the
> cacheline, while movlps takes 1 cycle.
> clts/stts probably wipes out the savings if we need to use it, but we
> can keep TS off and restore it lazily on return to userspace.

s/probably/very likely/

CR changes are slow and synchronize the CPU. The later is always slow.

It sounds like you didn't time it?

> > I'm also suspicious of your use of global register variables.
> > This means they won't be saved on entry/exit of the functions.
> > Does that really work?
> I think it does.
> The functions never change the global register variables, and thus
> they are preserved.

Sounds fragile.

It'll generate worse code because gcc can't use these registers
at all in the C code. Some gcc versions also tend to give up when they run
out of registers too badly.

> Calls are done in inline assembly, which saves the variables if they
> are actually used as parameters (the global register variables are
> only visible in a portion of the C file, of course).

So why don't you simply use normal asm inputs/outputs?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
