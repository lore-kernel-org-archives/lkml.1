Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYG2PYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYG2PYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYG2PYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:24:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:55837 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYG2PYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=FsoyHxAgkh0GkaQrsbF5ggrT+FmpEskiW8zA/ddmFXGnj9bGWQPm7dA2+IleXXkwpW
         b8FNcQLBsKegUVEgnT1uJsgXe1jcA5s/OFkqgu/1PQp9bjRmYpMrrSb4JID4rJlulfhD
         VQej4zrROie8hwzqqb0CaXzstfOteCmMNDShM=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
Date: Tue, 29 Jul 2008 17:24:09 +0200
In-Reply-To: <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 28 Jul 2008 08:48:41 -0700 (PDT)")
Message-ID: <m3vdyok92e.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 28 Jul 2008, Vitaly Mayatskikh wrote:
>>
>> Reduce protection faults count in copy_user_handle_tail routine by
>> limiting clear length to the end of page as was suggested by Linus.
>
> No, you did it wrong.
>
> The page _clearing_ has to be to the end of the copy. Yes, in practice, I 
> don't think the kernel actually very often does "copy_from_user()" calls 
> that are page crossers in the kernel, but they do happen.
>
> It's the _copy_ part that needn't cross pages, because we know that 
> something faulted, and we _know_ that it wasn't the clearing.
>
> Really: the clearing should be just a "memset()" with no limitations. It 
> can never fault without it being a serious bug, and then we should not fix 
> it up, but we should oops!

Right. I will take your code discussed previously. The only question is:
what will be a good place for *_IS_USERSPACE and CLEAR_REMAINDER flags
definitions and assembly macro ALIGN_DESTINATION (common for
copy_user_64.S and copy_user_nocache_64.S)? I have a new file
include/asm-x86/copy_user.h at the moment, but not sure if you will
think it's ok to put that stuff here:

include/asm-x86/copy_user.h:
#ifndef _COPY_USER_H
#define _COPY_USER_H

/* Flags for copy_user_handle_tail */
#define CLEAR_REMAINDER         1
#define DEST_IS_USERSPACE       2
#define SOURCE_IS_USERSPACE     4

/* Align destination */
#define FIX_ALIGNMENT 1

#define BYTES_LEFT_IN_PAGE(ptr) \
        (unsigned long)((PAGE_MASK & ((long)(ptr) + PAGE_SIZE)) - (long)(ptr))

#ifdef __ASSEMBLY__
        .macro ALIGN_DESTINATION
...
#endif /* FIX_ALIGNMENT */
        .endm
#endif /* __ASSEMBLY__ */
#endif /* _COPY_USER_H */

-- 
wbr, Vitaly
