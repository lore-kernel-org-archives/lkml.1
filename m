Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYIOTNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYIOTNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYIOTNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:13:22 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60758 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYIOTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:13:22 -0400
Subject: Re: [RFC v5][PATCH 2/8] General infrastructure for
	checkpoint	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <48CEAEF2.1050901@cs.columbia.edu>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu>
	 <1221501750.16561.15.camel@nimitz>  <48CEAEF2.1050901@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 12:13:18 -0700
Message-Id: <1221505998.16561.34.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-15 at 14:52 -0400, Oren Laadan wrote:
> Dave Hansen wrote:
> > On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
> >> +void *cr_hbuf_get(struct cr_ctx *ctx, int n)
> >> +{
> >> +       void *ptr;
> >> +
> >> +       BUG_ON(ctx->hpos + n > CR_HBUF_TOTAL);
> >> +       ptr = (void *) (((char *) ctx->hbuf) + ctx->hpos);
> >> +       ctx->hpos += n;
> >> +       return ptr;
> >> +}
...
> > I really do detest having a memory allocator BUG_ON() when it runs out
> > of space.  
> 
> The BUG_ON() statement asserts that we don't run out of buffer space.
> Buffer usage is a function of the checkpoint/restart logic, and does
> not depend on user input, hence not susceptible to DoS.

OK, that's fair enough.  But, can we document it as such?  "Only headers
and things of known, static sizes can go in here.  We don't use
kmalloc() instead of this because..."

> In other words, if the code is correct, this should never happen (much
> like a kernel stack overflow), and if it happens it's a kernel bug. I
> think it was Arnd who recommended with regard to this to crash loudly
> if there is a bug in the kernel ...

Yes, it does mean that there is a bug because someone either made a
structure bigger, PAGE_SIZE smaller, or a call path got deeper than we
expected.  I'm just having visions of the email hitting my inbox in 18
months. :)

The structures are sized consistently across all architectures and
configurations.  However, PAGE_SIZE and the size of that buffer are not.
The buffer will be 8k on x86, but 128k on most ppc64 configurations.

Can we at least make it sized in numbers of bytes rather than pages?
Also, please remember that using kmalloc() buys you lots of fun stuff on
top of get_free_pages(), like redzones and easier debugging.

-- Dave

