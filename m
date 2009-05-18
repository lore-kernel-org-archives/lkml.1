Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZERSIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZERSIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZERSIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:08:02 -0400
Received: from claw.goop.org ([74.207.240.146]:33456 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZERSIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:08:01 -0400
Message-ID: <4A11A3F8.1010202@goop.org>
Date: Mon, 18 May 2009 11:07:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org> <20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org> <20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu>
In-Reply-To: <20090518085902.GE10687@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Here Xen invades an already fragile piece of upstream code 
> (/proc/mtrr) that is obsolete and on the way out. If you want a 
> solution you should add PAT support to Xen and you should use recent 
> upstream kernels. Or you should emulate /proc/mtrr in _Xen the 
> hypervisor_, if you really care that much - without increasing the 
> amount of crap in Linux.
>   

That's a gross mis-characterisation of what we're talking about here.

arch/x86 already defines an mtrr_ops, which defines how to manipulate 
the MTRR registers.  There are currently several implementations of that 
interface.  In Xen the MTRR registers belong to the hypervisor, but it 
allows a privileged kernel to modify them via hypercalls.  I simply 
added a new, straightforward mtrr_ops implementation to do that.  It 
adds about 120 lines of new code, in a single mtrr/xen.c file.

That's it.  I could add any number of bizarre convolutions to achieve 
the same effect, but given that there's an existing interface that is 
exactly designed for what we want to achieve, I have to admit it didn't 
occur to me to do anything else.

MTRR may well be on its way out, and PAT is the proper way to achieve 
the same effect from now on.  But MTRR is still a widely used 
kernel-internal API as well as usermode ABI, and it seems just 
gratuitous to not support it when doing so is such a low-impact change.  
And if/when it comes to be time to completely deprecate/remove mtrr 
support, we can delete it along with everything else.

I'm honestly at a loss to explain the vehemence of your objection to 
these changes given their nature.

We're also working on making PAT support work where possible.  But that 
doesn't mean we want to do without anything in the meantime.

But more generally, we need to work out how to move things forward.

That said, we can live without.  If these MTRR patches are your biggest 
concern, drop them, pull the rest so we can get them seen, tested, in 
linux-next, etc, ready for the next merge window.  You know, like you 
said you wanted to do the last time you blocked the Xen patches.

I would prefer to move them through tip.git: I appreciate your 
(constructive) comments and reviews, the testing infrastructure has 
proved very valuable in the past, and they'll generally get wider 
exposure than my pool of testers.  And its just the right way to do it.

But if you're so concerned that they'll simply give Linus more 
ammunition to beat you up with, to the extent that you're 
second-guessing yourself, then I'm perfectly happy to submit them 
myself.  I don't think it would be an overall better outcome, but it 
keeps the heat off you, and we'd be making some progress.

    J
