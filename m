Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYFJS60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYFJS60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYFJS6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:58:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:61773 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYFJS6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XsyLoI1pLUiUeGAyhSdaNpahYRxZpk8oldnNR7AeyTo9jyC+MFWzaO57U1JN3vgAZH
         YEF46BEWDLui2fxk9h0jdPIuBW+Vq3GHI/qBfAoQjgtgSMKBgr8XDtvMTgSImW56nRVB
         vhRzU2JVoBHo7gfhsSx/x/U7PU27XMKXk2sRw=
Date: Tue, 10 Jun 2008 22:57:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: nmi_watchdog suspicious
Message-ID: <20080610185759.GA7353@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Maciej, I've a really bad suspicious about commit

---
commit 3ed3f06295e69700fa808396f7b350bff2b69de0
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Wed Jun 4 01:00:47 2008 +0400

    x86: nmi - consolidate nmi_watchdog_default for 32bit mode
    
    64bit mode bootstrap code does set nmi_watchdog to NMI_NONE
    by default and doing the same on 32bit mode is safe too.
    Such an action saves us from several #ifdef.
    
    Btw, my previous commit
    
    commit 19ec673ced067316b9732bc6d1c4ff4052e5f795
    Author: Cyrill Gorcunov <gorcunov@gmail.com>
    Date:   Wed May 28 23:00:47 2008 +0400
    
        x86: nmi - fix incorrect NMI watchdog used by default
    
    did not fix the problem completely, moreover it
    introduced additional bug - nmi_watchdog would be
    set to either NMI_LOCAL_APIC or NMI_IO_APIC
    _regardless_ to boot option if being enabled thru
    /proc/sys/kernel/nmi_watchdog. Sorry for that.
    Fix it too.
---

actually it changed nmi behaviour much more then I thought.
Look, since by default nmi_watchdog now becomes NMI_NONE it
does mean nmi.c:touch_nmi_watchdog() will not reset apic timers
anymore even being requested by some other code.

This commit does affect 32bit mode _only_. So now I'm guessing
what mode was implemented in correct way originally.

On 64bit mode nmi_watchdog=NMI_NONE by default (in case if APIC enabled).
On 32bit mode nmi_watchdog=NMI_DEFAULT was by default (in any case,
but could be set to NMI_NONE in check_timer(), but we don't take
this case now).

So lets take a look on touch_nmi_watchdog().
There is the condition

	if (nmi_watchdog > 0)
		...tell to reset counters in nmi_watchdog_tick()

this condition is not taken on 64bit mode, but *was* taken on
32bit mode by default! So who was right then? 64bit version or 32bit?

Maciej, could you take a look please? Maybe I just missing figure
in general - ie how nmi_watchdog _should_ work.

		- Cyrill -
