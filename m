Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYFPXVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYFPXVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbYFPXVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:21:12 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63092 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbYFPXVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:21:11 -0400
Date: Tue, 17 Jun 2008 00:20:28 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
In-Reply-To: <20080616170000.GC7273@cvg>
Message-ID: <Pine.LNX.4.55.0806161819500.20218@cliff.in.clinika.pl>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl>
 <20080616170000.GC7273@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Cyrill Gorcunov wrote:

> Maciej, I think nmi_watchdog could (and probably should) be defined as
> unsigned. Here my points of why (fix me please if I'm wrong):
> 
> - if we remain it as unsigned we could simplify setup_nmi_watchdog() to
>   just check for 'if (nmi >= NMI_INVALID)'

 This is run once only at the boot if at all -- just to verify the range
is correct.  Other places are executed multiple times during normal
operation and it is them you should optimise for.

> - current code does check for NMI_NONE _and_ NMI_DISABLED at once in most
>   cases (only the case it dont is - proc_nmi_enabled() wich could be simplified too)

 Please note the intent is NMI_DISABLED is a bootstrap default to tell the
platform the user has not specified any override.  With the 32-bit
platform it used to be promoted automatically to NMI_IO_APIC or
NMI_LOCAL_APIC as appropriate, but it was removed because of stability
problems with many systems.  It looks it wasn't done in a particularly
fortunate way -- the new promotion should be to NMI_NONE, but instead it
was removed altogether.

 Preferably the initialization to NMI_NONE should be done as soon as it
has been determined there was no "nmi_watchdog=" option specified, but in
practice I think it can simply be done at the beginning of trap_init(),
before the gate descriptor has been set up for the NMI (after which point
the NMI handler can be reached).  This way no piece of code other than
setup_nmi_watchdog() would have to care about negative values of
nmi_watchdog.

> - the only affected of such sign/unsign contention I found is
>   touch_nmi_watchdog() for which I suggested the patch (already in Ingo's tip tree)
>   http://lkml.org/lkml/2008/6/12/200
>   So there could be some 'useless counters resetting' but it could happen for
>   quite short time while APIC in initialization phase.

 This is a sloppy coding practice which has led us to the current
situation with the APIC code -- there should be no "useless code
execution" unless absolutely unavoidable.  I'd feel more comfortable if
there was a separate variable like nmi_watchdog_active checked in the
handler instead of nmi_watchdog that would only be set once the watchdog
has actually been activated.

 The whole idea of touch_nmi_watchdog() itself is rather unfortunate too,
but that's apparently not an easy problem to solve.

  Maciej
