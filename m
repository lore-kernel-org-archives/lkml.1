Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbYE1Sci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbYE1Sci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYE1Sca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:32:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29736 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYE1Sc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Iu+tyv5JFLimWUbLDzglxyan7CuDNWnsYKne8df5AzfJ4c7aXaycSmXcGgsWBKhF6hhb361AyQPqE3sBO+4XlEfxXVueHYmveApGW7sjzDFDYCSd1GgzRSv/UFF47/ecpgmBdc0cltCkaH1Zywwivudc3cZjqo1b1LOTE9/5eoI=
Date: Wed, 28 May 2008 22:32:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead
	of apic_write
Message-ID: <20080528183212.GD6910@cvg>
References: <20080524153630.669797039@gmail.com>> <48383740.0407560a.4764.7d1b@mx.google.com> <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl> <20080528160413.GA6910@cvg> <Pine.LNX.4.55.0805281712200.29522@cliff.in.clinika.pl> <20080528162527.GB6910@cvg> <Pine.LNX.4.55.0805281755370.29522@cliff.in.clinika.pl> <20080528171620.GC6910@cvg> <Pine.LNX.4.55.0805281828210.29522@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805281828210.29522@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, May 28, 2008 at 06:47:56PM +0100]
| On Wed, 28 May 2008, Cyrill Gorcunov wrote:
| 
| > Thanks a lot, Maciej!!! Could you please explain me how did you find
| > that? 'cause reporter said that with nmi_watchdog=2 it works and with
| > nmi_watchdog=1 it stalls? Maybe I should better make this function
| > the same as 64bit version has? I.e. set nmi_watchdog = NMI_NONE by default?
| 
|  Well, nmi_watchdog=1 is the I/O APIC watchdog and if no watchdog has been
| specified at the command line, the piece of code you have moved selects
| between the local and the I/O APIC watchdog based on availability of the
| former.  So in this case the local watchdog must have been unavailable as
| it works if requested explicitly.
| 
|  No piece of code in nmi_watchdog_default() touches peripheral hardware
| and native_smp_prepare_cpus() is called early enough the system is still
| running UP and no APIC setup has happened yet, so any interference with
| running hardware can be excluded.
| 
|  Random lock-ups are a typical symptom of the NMI watchdog interfering
| with SMM firmware -- of course in the context of the watchdog being
| suspected in the first place -- there may be plenty of other reasons of
| random lock-ups.  Obviously this is the SMM firmware asking for trouble
| explicitly, because NMIs are disabled by the processor upon entering the
| SMM and it is the SMI handler that unmasks the NMI explicitly (with an
| IRET, which shouldn't be used in the SMM mode at all) -- otherwise it
| wouldn't even notice the watchdog running, but there you go.
| 
|  As a rule of thumb any piece of firmware that has a possibility to run
| from an OS context should not use interrupts of any kind, because it is
| quite likely it cannot handle them in the way the OS expects them to be
| handled.  It is as simple as that, but perhaps too simple for some to
| comprehend. :(
| 
|   Maciej
| 

oh... :( i think i just restore old behaviour for now. Thanks for explanation!

		- Cyrill -
