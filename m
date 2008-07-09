Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYGIUcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYGIUcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYGIUb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:31:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52920 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYGIUb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:31:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org>
	<4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>
	<487502FB.3090106@sgi.com> <487507A1.2020100@goop.org>
Date: Wed, 09 Jul 2008 13:22:06 -0700
In-Reply-To: <487507A1.2020100@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 09 Jul 2008 11:46:57 -0700")
Message-ID: <m1r6a2yfip.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> It's just the stack canary.  It isn't library accesses; it's the code gcc
> generates:
>
> foo:	subq	$152, %rsp
>        movq    %gs:40, %rax
>        movq    %rax, 136(%rsp)
> ...
>        movq    136(%rsp), %rdx
>        xorq    %gs:40, %rdx
>        je      .L3
>        call    __stack_chk_fail
> .L3:
>        addq    $152, %rsp
>        .p2align 4,,4
>        ret
>
>
> There are two irritating things here:
>
> One is that the kernel supports -fstack-protector for x86-64, which forces us
> into all these contortions in the first place.  We don't support stack-protector
> for 32-bit (gcc does), and things are much easier.

How does gcc know to use %gs instead of the usual %fs for accessing
the stack protector variable?  My older gcc-4.1.x on ubuntu always uses %fs.

> The other somewhat orthogonal irritation is the fixed "40".  If they'd generated
> %gs:__gcc_stack_canary, then we could alias that to a per-cpu variable like
> anything else and the whole problem would go away - and we could support
> stack-protector on 32-bit with no problems (and normal usermode could define
> __gcc_stack_canary to be a weak symbol with value "40" (20 on 32-bit) for
> backwards compatibility).
>
> I'm close to proposing that we run a post-processor over the generated assembly
> to perform the %gs:40 -> %gs:__gcc_stack_canary transformation and deal with it
> that way.

Or we could do something completely evil.  And use the other segment
register for the stack canary.

I think the unification is valid and useful, and that trying to keep
that stupid stack canary working is currently more trouble then it is
worth.

Eric
