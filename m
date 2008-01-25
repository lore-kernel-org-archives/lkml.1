Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYAYLMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYAYLMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:12:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYAYLLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:11:54 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45639 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYAYLLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:11:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	<47964B7B.9000905@zytor.com> <20080122203611.GA12892@elte.hu>
	<1201121530.30671.15.camel@cthulhu.hellion.org.uk>
	<4797E487.8010108@goop.org>
	<1201167544.30671.64.camel@cthulhu.hellion.org.uk>
	<47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org>
	<479913BA.8000506@zytor.com> <47991809.9060903@goop.org>
	<47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org>
	<479922D0.3010708@zytor.com> <4799248F.9080404@goop.org>
	<47992710.2060108@zytor.com> <47992948.60308@goop.org>
	<47992A3B.7000607@zytor.com> <47992DD9.8060604@goop.org>
	<47992F31.1070705@zytor.com>
	<m1d4rqipex.fsf@ebiederm.dsl.xmission.com> <47996895.3010703@goop.org>
Date: Fri, 25 Jan 2008 04:07:57 -0700
In-Reply-To: <47996895.3010703@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 24 Jan 2008 20:41:57 -0800")
Message-ID: <m163xii2nm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Note.  I don't believe we use either trampoline (cpu startup or acpi wakeup)
>> in the hypervisor case (esp Xen).  So we should be able to completely ignore
>> Xen and do the memcpy of pgd entries.
>>
>
> Indeed.  The alias mapping can be set up in native_pagetable_setup_done() and
> needn't involve Xen at all.

Good.  Then this case gets easy.

We just need a pgd that has pgd entries that duplicate the kernel pgd entries
at both address 0 and at the normal kernel address.

In 64bit mode we make this part of the trampoline because we need a pgt below
4G so that we can point a 32bit %cr3 value at it.  We can either use that
technique for the 32bit kernel (and be consistent) or we can have a single
trampoline/wakeup pgd that we use.  As all pgd entries must be below 4G in
32bit mode.

Although if we really wanted to be restrictive we could have a much more limited
set of identity page table entries that only map the low 1M, or possibly just
640K.

Eric
