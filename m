Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZJZIlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZJZIlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbZJZIlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:41:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54625 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbZJZIlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:41:05 -0400
To: Michael Sundius <msundius@cisco.com>
Cc: linux-kernel@vger.kernel.org, msundius@sundius.com
Subject: Re: [patch] delay panic during startup of kernel
From: Andi Kleen <andi@firstfloor.org>
References: <4ADF9B78.4060807@cisco.com>
Date: Mon, 26 Oct 2009 09:41:09 +0100
In-Reply-To: <4ADF9B78.4060807@cisco.com> (Michael Sundius's message of "Wed, 21 Oct 2009 16:38:32 -0700")
Message-ID: <874opmy2ca.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Sundius <msundius@cisco.com> writes:

> We've been, from time to time,  running into various problems early on
> the initialization of the kernel, encountering situations where we really
> should panic, but we can't because its too early to do so.
> (see * if you care to know why this is a problem for us). Anyhow, I've
> created this patch to have a little better way of orderly finishing the
> bring-up to the point where we can panic safely. Any comments?

It's (nearly) never too early to panic. The main problem is that you sometimes
cannot see it and sometimes panic requires some state (but that's usually
a bug in panic to be fixed)

I also don't think it makes much sense to continue just to panic later.
Such a continue path is likely untested and buggy.

Some time ago I had patches to do a early_panic() using early_printk,
but didn't end up submitting them because the caller I intended them
for disappeared.

Basically early_panic() is just

void early_panic(char *fmt, ...)
{
        char buf[256];
        va_list ap;
        va_start(ap, fmt);
        vsnprintf(buf, sizeof buf, fmt, ap);
        early_printk("PANIC : %s\n", buf); 
        va_end(ap);
        for (;;)
            safe_hlt();
}


However it might be better to fix panic to do that automatically.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
