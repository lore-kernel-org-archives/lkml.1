Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYGAIlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYGAIlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYGAIlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:41:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38376 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYGAIlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:41:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>
	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>
	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>
	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>
	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>
	<485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
Date: Tue, 01 Jul 2008 01:40:02 -0700
In-Reply-To: <48694B3B.3010600@goop.org> (Jeremy Fitzhardinge's message of
	"Mon, 30 Jun 2008 14:08:11 -0700")
Message-ID: <m1skuuov4t.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> No, the original crash being discussed was a GP fault in head_64.S as it tries
> to initialize the kernel segments.  The cause was that the prototype GDT is all
> zero, even though it's an initialized variable, and inspection of vmlinux shows
> that it has the right contents.  But somehow it's either 1) getting zeroed on
> load, or 2) is loaded to the wrong place.
>
> The zero-based PDA mechanism requires the introduction of a new ELF segment
> based at vaddr 0 which is sufficiently unusual that it wouldn't surprise me if
> its triggering some toolchain bug.

Agreed.  Given the previous description my hunch is that the bug is occurring
during objcopy.  If vmlinux is good and the compressed kernel is bad.

It should be possible to look at vmlinux.bin and see if that was generated
properly.

> Mike: what would happen if the PDA were based at 4k rather than 0?  The stack
> canary would still be at its small offset (0x20?), but it doesn't need to be
> initialized.  I'm not sure if doing so would fix anything, however.

I'm dense today.  Why are we doing a zero based pda?  That seems the most
likely culprit of linker trouble, and we should be able to  put a smaller
offset in the segment register to allow for everything to work as expected.

Eric
