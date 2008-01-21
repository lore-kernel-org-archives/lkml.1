Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYAUVZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYAUVZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYAUVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:25:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYAUVZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:25:35 -0500
Message-ID: <47950DBA.9080906@redhat.com>
Date: Mon, 21 Jan 2008 16:25:14 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: The SMP alternatives code breaks exception fixup?
References: <479504F6.4080005@redhat.com>
In-Reply-To: <479504F6.4080005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2008 03:47 PM, Chuck Ebbert wrote:
> Looking at the oops report from this bug:
> 
> [bugzilla]  https://bugzilla.redhat.com/show_bug.cgi?id=429412
> [oops]      https://bugzilla.redhat.com/attachment.cgi?id=292260
> 
> It was an unhandled page fault (protection violation.)
> 
> I tracked it down to the cmpxchg in this code:
> 
> include/asm-x86/futex_32.h::futex_atomic_cmpxchg_inatomic()
>          __asm__ __volatile__(
>                  "1:     " LOCK_PREFIX "cmpxchgl %3, %1          \n"
>                  "2:     .section .fixup, \"ax\"                 \n"
>                  "3:     mov     %2, %0                          \n"
>                  "       jmp     2b                              \n"
>                  "       .previous                               \n"
>                  "       .section __ex_table, \"a\"              \n"
>                  "       .align  8                               \n"
>                  "       .long   1b,3b                           \n"
>                  "       .previous                               \n"
> 
> There is a fixup, so this should never happen. But the lock instruction
> was replaced with a nop by the altinstruction code, and that makes the fixup
> address wrong. AFAICT we don't fix up the exception table when we replace
> a lock with a nop, which makes the fixup table point to the nop instead
> of the cmpxchg instruction and causes us to miss the fixup.
> 

The bug reporter has confirmed that booting with "noreplace-smp" prevents
the kernel oops.
