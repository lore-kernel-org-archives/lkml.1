Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbYG1Pwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbYG1Pwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYG1Pwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:52:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYG1Pwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:52:30 -0400
Date: Mon, 28 Jul 2008 08:48:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
In-Reply-To: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jul 2008, Vitaly Mayatskikh wrote:
>
> Reduce protection faults count in copy_user_handle_tail routine by
> limiting clear length to the end of page as was suggested by Linus.

No, you did it wrong.

The page _clearing_ has to be to the end of the copy. Yes, in practice, I 
don't think the kernel actually very often does "copy_from_user()" calls 
that are page crossers in the kernel, but they do happen.

It's the _copy_ part that needn't cross pages, because we know that 
something faulted, and we _know_ that it wasn't the clearing.

Really: the clearing should be just a "memset()" with no limitations. It 
can never fault without it being a serious bug, and then we should not fix 
it up, but we should oops!

			Linus
