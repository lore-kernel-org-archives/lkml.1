Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYHHX3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYHHX3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYHHX3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:29:22 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:42275 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYHHX3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:29:22 -0400
Message-ID: <489CD64D.7030500@cs.columbia.edu>
Date: Fri, 08 Aug 2008 19:27:09 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
References: <20080807224033.FFB3A2C1@kernel>	 <20080807224034.735B1F84@kernel> <200808081146.54834.arnd@arndb.de>	 <1218221451.19082.36.camel@nimitz>  <489CB3CA.6050304@cs.columbia.edu> <1218233855.19082.52.camel@nimitz>
In-Reply-To: <1218233855.19082.52.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Hansen wrote:
> On Fri, 2008-08-08 at 16:59 -0400, Oren Laadan wrote:
>> To avoid repetitive malloc/free, ctx->hbuf is a buffer to host headers
>> as they are read;
> 
> kmalloc/kfree() area really, really fast.  I wonder if the code gets
> easier or harder to read if we just alloc/free as we need to.

The ctx->hbuf interface is a pair of cr_hbuf_get(ctx, length) and a
matching cr_hbuf_put(ctx, length), almost like using kmalloc/kfree().
The main difference is that cleanup in error paths is implicit (the
whole buffer is freed when the ctx is deallocated).

> How large are these allocations, usually?  Will stack allocation work in
> most cases?

That depends on how we construct the headers. In Zap there are some
headers that use relatively long structures to be put on the stack,
and it wouldn't make much sense to divide them into smaller headers
artificially.

However, I forgot to mention earlier that an important reason to use
this construct is actually in anticipation for a future optimization:
during application downtime the checkpoint state will be aggregated
into an in-memory buffer, and only after the application is allowed
to continue execution (unfrozen) the buffer will be written-back to
the FD. In that scenario, we will allocate a larger buffer in the ctx
(eg based on some heuristics) and cr_hbuf_get() will return the next
location in that buffer, while cr_hbuf_put() will do nothing.

Oren.

