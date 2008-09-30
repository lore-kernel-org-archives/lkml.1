Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYI3Rkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYI3Rkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYI3Rkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:40:45 -0400
Received: from waste.org ([66.93.16.53]:35650 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYI3Rko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:40:44 -0400
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
From: Matt Mackall <mpm@selenic.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       penberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1222791638.2995.41.camel@castor.localdomain>
References: <1222787736.2995.24.camel@castor.localdomain>
	 <48E2480A.9090003@linux-foundation.org>
	 <1222791638.2995.41.camel@castor.localdomain>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 12:37:25 -0500
Message-Id: <1222796245.23159.38.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-30 at 17:20 +0100, Richard Kennedy wrote:
> Yes, using vprintk is better but you still have this path :
> ( with your patch applied)
> 
> 	object_err -> slab_bug(208) -> printk(216)
> instead of 
> 	object_err -> slab_bug_message(8) -> printk(216)
> 
> unfortunately the overhead for having var_args is pretty big, at least
> on x86_64. I haven't measured it on 32 bit yet.

That's fascinating. I tried a simple test case in userspace:

#include <stdarg.h>
#include <stdio.h>

void p(char *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	vprintf(fmt, args);
	va_end(args);
}

On 32-bit, I'm seeing 32 bytes of stack vs 216 on 64-bit. Disassembly
suggests it's connected to va_list fiddling with XMM registers, which
seems quite odd.

-- 
Mathematics is the supreme nostalgia of our time.

