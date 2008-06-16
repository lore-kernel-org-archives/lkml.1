Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFPRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFPRAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYFPRAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:00:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:65036 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYFPRAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cWHIvtNSBqGxPYKMgmBlq0+2+XVppiKWMptMj4GMw5OpHfBrOf7pAGhQ6qY2zl8gtw
         Mo+AGB4O2JQ4yxeVPU4ohrSDHfadZgTjQKo5Uolcer8ypSObRtnYXaeI4w9xwZslJQfB
         cRsLPksNl7CR7LZQV0xY8yqPLbmCS8vPv3AdQ=
Date: Mon, 16 Jun 2008 21:00:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
Message-ID: <20080616170000.GC7273@cvg>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Mon, Jun 16, 2008 at 12:49:00AM +0100]
| On Tue, 10 Jun 2008, Cyrill Gorcunov wrote:
| 
| > On 64bit mode nmi_watchdog=NMI_NONE by default (in case if APIC enabled).
| > On 32bit mode nmi_watchdog=NMI_DEFAULT was by default (in any case,
| > but could be set to NMI_NONE in check_timer(), but we don't take
| > this case now).
| 
|  I haven't tracked the 64-bit port, but for plain i386 the watchdog used
| to be on by default, then proved problematic with too many broken pieces
| of equipment (typically because of bugs in the SMM firmware) and thus set
| to off.
| 
| > So lets take a look on touch_nmi_watchdog().
| > There is the condition
| > 
| > 	if (nmi_watchdog > 0)
| > 		...tell to reset counters in nmi_watchdog_tick()
| > 
| > this condition is not taken on 64bit mode, but *was* taken on
| > 32bit mode by default! So who was right then? 64bit version or 32bit?
| > 
| > Maciej, could you take a look please? Maybe I just missing figure
| > in general - ie how nmi_watchdog _should_ work.
| 
|  Well, values >= NMI_INVALID are never used, so the condition is correct.  
| It is meant to be positive whenever a working watchdog has been selected.  
| Obviously nmi_watchdog should be a signed int though, so there is a bug
| there.  You better audit all the uses of the variable...
| 
|   Maciej
| 

Maciej, I think nmi_watchdog could (and probably should) be defined as
unsigned. Here my points of why (fix me please if I'm wrong):

- if we remain it as unsigned we could simplify setup_nmi_watchdog() to
  just check for 'if (nmi >= NMI_INVALID)'
- current code does check for NMI_NONE _and_ NMI_DISABLED at once in most
  cases (only the case it dont is - proc_nmi_enabled() wich could be simplified too)
- the only affected of such sign/unsign contention I found is
  touch_nmi_watchdog() for which I suggested the patch (already in Ingo's tip tree)
  http://lkml.org/lkml/2008/6/12/200
  So there could be some 'useless counters resetting' but it could happen for
  quite short time while APIC in initialization phase.

So I think the only problem could be is - simplification. Maybe some checks
should be isolated in helper functions. Will take a look (and of course will
keep community in touch ;)

		- Cyrill -
