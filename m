Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917Ab0AZB1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0AZB1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786Ab0AZB1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:27:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab0AZB1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:27:11 -0500
Date: Mon, 25 Jan 2010 17:26:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/37] move round_up/down to kernel.h
Message-Id: <20100125172616.85c9eff2.akpm@linux-foundation.org>
In-Reply-To: <4B5E3E22.6030401@zytor.com>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
	<1263611228-6751-23-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.00.1001191155540.22304@router.home>
	<4B57675E.7070309@kernel.org>
	<20100125164032.330be0e6.akpm@linux-foundation.org>
	<4B5E3E22.6030401@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 16:58:10 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 01/25/2010 04:40 PM, Andrew Morton wrote:
> > 
> > The problem is that arch/x86/include/asm/proto.h implements private
> > rounding macros.  The right way to fix that is to convert each x86
> > "call site" over to using the standard macros from kernel.h, then
> > finally remove the private definitions from
> > arch/x86/include/asm/proto.h.  Don't just copy them over to kernel.h
> > and make things muddier than they already are!
> > 
> > If during that conversion it is found that the standard macros for some
> > reason don't suit the x86 usage sites then please propose
> > enhancements/fixes to the existing kernel.h facilities.
> > 
> 
> They don't.
> 
> The kernel-global alignment macros assume that either the alignment
> datum (divisor) is a constant, or that it is acceptable to take the hit
> of a division.  Unfortunately, we have real use cases where the
> alignment (guaranteed to be a power of two) is variable, but we don't
> want to take the hit of a full-blown division.
> 
> I suspect the global kernel tree has those, too, but it would seem to be
> a dramatic change to change to change the existing facilities to assume
> power of two alignment...
> 

OK.  And yes, rounding up or down to a power-of-two alignment is surely
a common case.  The rounding-up case is already handled by ALIGN(), is it
not?

round_up() is a quite poor name for a facility which will quietly
fail if passed a non-power-of-2 argument!

So I'd suggest that we see a standalone patch which adds the
suitably-named and suitably-documented features to kernel.h.  I'd be OK
with merging such a patch into 2.6.33-rc, btw.

As there is probably a lot of code which would benefit from being
janitorially converted to these factilities, the patch should be
well-reviewed and not hidden in an x86 patchbomb!

There might be merit in adding a debug-only runtime check to ensure
that the alignment mask really is a power-of-two, to assist such
janitorial conversions, dunno.

