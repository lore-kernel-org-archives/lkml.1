Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbYD3Uj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbYD3Uj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbYD3Ujm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:39:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52898 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155AbYD3Ujk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:39:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       James.Bottomley@HansenPartnership.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <4815009C.2010809@garzik.org>
	<20080427.154620.177583216.davem@davemloft.net>
	<48150392.6040508@zytor.com>
	<20080427.155834.189904598.davem@davemloft.net>
	<48150667.90806@zytor.com>
Date: Wed, 30 Apr 2008 13:35:47 -0700
In-Reply-To: <48150667.90806@zytor.com> (H. Peter Anvin's message of "Sun, 27
	Apr 2008 16:04:07 -0700")
Message-ID: <m1od7rkrmk.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> David Miller wrote:
>> I think this is a reasonable course of action.
>>
>> That leaves one of Jeff's concerns, what to do with pci_iomap().  That
>> was designed to give mappings with caching enabled, and as a result we
>> probably should make it behave that way.
>
> Yes, it should.  Just be clear that *that* is a semantic change over what the
> code currently does; it would appear that that is what the code is *trying* to
> do.
>
> I believe on x86 it will still get clamped by the MTRRs, at least initially (I
> don't think we have flipped the default MTRR type to WB yet) but that would
> immediately change the behaviour on non-x86 architectures.

Flipping the default MTRR type to WB has the potential to break an SMM
monitor which does I/O and isn't using our page tables.  So we need to
be very careful about that direction.  Finally I remember what
the specific and really scary failure mode with SMM and mucking with
the MTRRs is.

There don't appear to be many bars that set IORESOURCE_CACHABLE for use
with pci_iomap so it doesn't appear to be much of an issue.

In addition it looks like we should map IORESOURCE_PREFETCH to ioremap_wc
in pci_iomap, for those places that can take advantage of it.  It
might not always work (hardware is like that) but semantically pci
prefetch is the same as the WC attribute (reads and writes have no
side effects).  I believe on x86 if we want to get cacheline sized
reads (read prefetch) there is special instruction in the latest
processors we need to use on a wc area.

Eric
