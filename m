Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZFTIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZFTIS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZFTISR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:18:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33817 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZFTISN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:18:13 -0400
To: "Nakajima\, Jun" <jun.nakajima@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Keir Fraser <keir.fraser@eu.citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>
References: <4A329CF8.4050502@goop.org>
	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
	<4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
	<4A3AC0C4.6060508@goop.org> <m17hz9djwn.fsf@fess.ebiederm.org>
	<4A3BEDD6.6070303@goop.org>
	<0B53E02A2965CE4F9ADB38B34501A3A188656507@orsmsx505.amr.corp.intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 20 Jun 2009 01:18:07 -0700
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A188656507@orsmsx505.amr.corp.intel.com> (Jun Nakajima's message of "Fri\, 19 Jun 2009 16\:44\:24 -0700")
Message-ID: <m163erpbcw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jun.nakajima@intel.com, lenb@kernel.org, tglx@linutronix.de, hpa@zytor.com, keir.fraser@eu.citrix.com, mingo@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xensource.com, jeremy@goop.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Nakajima\, Jun" <jun.nakajima@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nakajima, Jun" <jun.nakajima@intel.com> writes:

> Jeremy Fitzhardinge wrote on Fri, 19 Jun 2009 at 12:58:14:
>
>>> 
>>> Which if dom0 is to be redundant/restartable seems to make the
>>> argument for AML living in Xen.
>>> 
>>> Xen has everything except the AML interpreter.
>>> 
>> 
>> I assume that putting AML into Xen has been considered, but I don't
>> anything about those deliberations.  Keir? Jun?
>> 
>
> Yes, it was one of the options years ago. We did not do that because Linux and Solaris (as dom0) already had the AML interpreter and it's overkill and redundant to have such a large component in the Xen hypervisor. Since the hypervisor does most of the power management (i.e. P, C, S-state, etc.) getting the info from dom0 today, we might want to reconsider the option. 

In my brief investigation it looks as if Xen having the AML
interpreter would considerably simplify the complexity of the
dom0 interface.

What I am certain of is that the current Xen dom0 irq interface exposes
implementation details (aka the vector number) that if continued will prevent
Xen from scaling to machines with large amounts of I/O.  As YH has recently
demonstrated.

That interface needs to be fixed.

I think the path to fixing it and getting linux kernel support is.
- Merge pass through device support for domU.
- Move all of the irq setup from dom0 into Xen, making dom0 interrupt
  handling exactly the same as domU.
- Move all of ACPI handling into Xen, in support of irq handling
  and power management.  Things Xen already claims are interesting
  problems.

At that point I don't know what is left but in the area that I am
knowledge, irq handling, will be complete.  The incestuousness of
the interface is removed and Xen and the linux kernel can keep those
same interfaces for the foreseeable future.

In summary.  

In support of the Xen grand vision of all domains being equal.  I
don't think linux should ever merge dom0 support.  I think domU
support should be expanded, and the dom0 requirements simplified
until there are no differences left.

Eric
