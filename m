Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbZADSeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbZADSeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZADSdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:33:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbZADSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:33:47 -0500
Date: Sun, 4 Jan 2009 10:33:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
In-Reply-To: <20090104092857.5fbf6b2d@infradead.org>
Message-ID: <alpine.LFD.2.00.0901041024360.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org> <20090104092857.5fbf6b2d@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> +
> +typedef u64 async_cookie_t;
> +typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
> +
> +extern void async_schedule(async_func_ptr *ptr, void *data);
> +extern void async_synchronize_full(void);
> +extern void async_synchronize_cookie(async_cookie_t cookie);

Hmm. The cookie use doesn't seem to make much sense.

Why do you pass in the cookie to the async function, but don't return it 
to the caller? That seems backwards - you'd normally expect that it is the 
_caller_ that wants the cookie (to synchronise with a specific async 
call), not the callee. But now the only one who knows the cookie is the 
wrong entry - just the callee, not the caller.

Yes, yes, I read the explanation in the comments, and it says that the 
callee should do it to guarantee its own ordering, and your acpi port 
thing does that in order to apparently start a sequence that is 
asynchronous only wrt the synchronous code, but not wrt itself. That's a 
_very_ odd model, but whatever works. But wouldn't it still make sense to 
let the caller wait for individual events too?

IOW, I'd just suggest changing the interface so that "async_schedule()" 
also returns the cookie. 

			Linus
