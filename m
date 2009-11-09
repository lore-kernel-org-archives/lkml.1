Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZKIP2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZKIP2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZKIP2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:28:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbZKIP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:28:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Date: Mon, 9 Nov 2009 16:28:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
References: <m1pr7siqjz.fsf@fess.ebiederm.org> <m1zl6vvpiv.fsf@fess.ebiederm.org> <20091109132830.GF26740@basil.fritz.box>
In-Reply-To: <20091109132830.GF26740@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091628.47003.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18DsT5supCnhZ9ijQuhqKxoiIlx44uJKFXk9zm
 agTDRphjzlTtq5zIdnMrEWk/xm4GE8u6No2iqr4ky9KktPId2R
 nI030L9q4K/JvYwgRAxhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Andi Kleen wrote:
> On Mon, Nov 09, 2009 at 04:41:44AM -0800, Eric W. Biederman wrote:

> > >> Not much slower, but slower. I just measured it in a case that favors
> > >> sysctl and the ration is about 5:2.  Or sysctl is about 2.5x faster.
> > >> About 49usec for open/read/close on proc and 19usec for sysctl.
> > >> In my emulation it is a bit slower than that.
> > >
> > > That's not good.
> > 
> > Why?
> 
> Because it slows down a very common path.

Can you name one binary sysctl value that gets accessed more
than a few times during the execution of a vaguely common
application? We're talking about microseconds for typically
write-once or read-once settings.

> > If you think we need something better additional patches to sysctl_binary.c
> > are welcome.  Just add your custom fast path before the through the
> > VFS.
> 
> I think sysctl_binary should be just stripped down for common sysctls
> (at least with a CONFIG)

It would technically be the same result, whether you add a fast
path for common ones, or leave the current code in place or leave
out the uncommon ones. In both cases, we'd still need the emulation
code that Eric did.

The question is just how many sysctl values you regard as both
common and performance critical.
Eric was implying 'none to very few', and that seems highly likely
to me. If you can come up with proof for the opposite (e.g. in form
of a list), that might make it sensible that stripping the current
code down would be easier.

Even then, Eric is likely the only person willing to do that job,
so he should be allowed to choose the implementation between
functionally equivalent solutions.

> > > Hmm? There's plenty of glibc code that uses the binary sysctl.
> > 
> > Where?  I grepped glibc today.  The only use in a recent glibc is
> > in glibc-ports for the support of arm inb/outb.  The only other
> > use in older glibc was checking to see if we ran on an SMP kernel.
> 
> That older glibc is widely deployed. And it won't go away next year.

So? Most users of old glibc are also using old kernels, and they
can still use the  config option for the compatibility code.
There wouldn't even be a performance penalty over new glibc with
new kernels which already use procfs.

> > >> Ultimately what drives me most is that people are still accidentally
> > >> adding binary sysctls, which no one uses or tests.  For a recent
> > >> example see:
> > >
> > > Yes I agree new binary sysctls should just be deprecated right now.
> > 
> > Good.  The only way to keep new ones from showing up is to that I know
> > of is to move everything into an emulation layer.  I have done the heavy
> > lifting there and everything is emulated using the exact same code.
> 
> I agree with that.
> 
> I just think you should have two flavours of emulation layer:
> full and "common sysctls". This can be probably done with the same
> code and some strategic ifdefs.

If it's just about code size, I totally wouldn't bother. Just put the
emulation code in loadable module and add a 'printk("Warning, %s is
using sysctl %s, wasting %d kb of kernel memory")' to it's module_init
function.

	Arnd <><
