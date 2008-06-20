Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYFTUqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYFTUqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYFTUbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:31:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35623 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762146AbYFTUbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:31:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>
	<485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>
	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>
	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>
	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>
	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>
	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>
	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>
	<485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
Date: Fri, 20 Jun 2008 13:25:06 -0700
In-Reply-To: <485BFFC5.6020404@sgi.com> (Mike Travis's message of "Fri, 20 Jun
	2008 12:06:45 -0700")
Message-ID: <m1skv7onvh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
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

Mike Travis <travis@sgi.com> writes:

> Jeremy Fitzhardinge wrote:
>>
>> 
>> BTW, I think __per_cpu_load will cause trouble if you make a relocatable
>> kernel, being an absolute symbol.  But I have relocation off at the moment.
>> 
> ...
> Here's where it's defined (in include/asm-generic/vmlinux.lds.h):
>
> #ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
> #define PERCPU(align)                                                   \
>         . = ALIGN(align);                                               \
>         percpu : { } :percpu                                            \
>         __per_cpu_load = .;                                             \
>         .data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {             \
>                 *(.data.percpu.first)                                   \
>                 *(.data.percpu.shared_aligned)                          \
>                 *(.data.percpu)                                         \
>                 *(.data.percpu.page_aligned)                            \
>                 ____per_cpu_size = .;                                   \
>         }                                                               \
>         . = __per_cpu_load + ____per_cpu_size;                          \
>         data : { } :data
> #else
>
> Can we generate a new symbol which would account for LOAD_OFFSET?

Ouch.  Absolute symbols indeed.  On the 32bit kernel that may play havoc
with the relocatable kernel, although we have had similar absolute logic
for the last year. With __per_cpu_start and __per_cpu_end so it may
not be a problem.

To initialize the percpu data you do want to talk to the virtual address
at __per_coup_load.  But it is absolute Ugh.  

It might be worth saying something like.
.data.percpu.start : AT(.data.percpu.dummy - LOAD_OFFSET) {
	DATA(0)                   
	. = ALIGN(align);
        __per_cpu_load = . ;                   
}
To make __per_cpu_load a relative symbol. ld has a bad habit of taking
symbols out of empty sections and making them absolute.  Which is why
I added the DATA(0).

Still I don't think that would be the 64bit problem.

Eric

