Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYEWLv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYEWLv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYEWLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:51:19 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57989 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYEWLvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:51:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18486.44689.203792.818972@harpo.it.uu.se>
Date: Fri, 23 May 2008 13:46:25 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <48362FD0.9030104@zytor.com>
References: <18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
	<18482.60491.764019.292031@harpo.it.uu.se>
	<20080520175325.GE30034@linux-os.sc.intel.com>
	<4834BE39.2000904@zytor.com>
	<18485.13663.51624.694435@harpo.it.uu.se>
	<20080522205619.GB7998@linux-os.sc.intel.com>
	<4835DF64.6080104@zytor.com>
	<20080522212920.GC7998@linux-os.sc.intel.com>
	<4835E6F5.5010801@zytor.com>
	<20080523014855.GA18385@linux-os.sc.intel.com>
	<48362FD0.9030104@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > Michael, you wrote:
 > 
 > > Hmm, right now it seems this field has a de-facto ABI of being
 > > either 0xffff (plain) or 0x0000 (fxsr). Using other values would
 > > confuse at least one application I know of. Sad.
 > 
 > ... could you share what application that is?  This otherwise would be 
 > ideal.

It's the virtual machine for the Erlang/OTP concurrent functional
language. It's open-source and used extensively for telecom and
internet server applications.

The language doesn't allow non-finite FP values, so FP ops must
be checked. As an optimisation, the virtual machine groups FP ops
into blocks, enables FP exceptions, and has a SIGFPE handler that
just records that an FP exception has occurred in a per-thread flag.
After each FP block there's a single check for this flag, which if
set triggers a language-level "badarith" exception.

In order to resume from an SSE2 exception the SIGFPE handler must
update some parts of the sigcontext. But first the handler must detect
if the exception came from x87 or SSE2, which requires looking at the
mxcsr field, which requires looking at the magic field to detect the
fpstate's layout.

The magic field is described as follows in sigcontext.h:

>struct _fpstate {
>	...
>        unsigned short  magic;          /* 0xffff = regular FPU data only */
>	...
>};
>
>#define X86_FXSR_MAGIC          0x0000

While this in theory allows for other values than -1 and 0 in magic,
any such value would be != FXSR_MAGIC and therefore would not trigger
the application's "inspect the fxsr layout" logic.

/Mikael
