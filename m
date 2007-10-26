Return-Path: <linux-kernel-owner+w=401wt.eu-S1763547AbXJZDmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763547AbXJZDmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXJZDl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:41:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4554 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbXJZDl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:41:57 -0400
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <200710261211.01423.rusty@rustcorp.com.au>
References: <20071024195847.GE27248@parisc-linux.org>
	 <1193255992-14385-1-git-send-email-matthew@wil.cx>
	 <200710261211.01423.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 20:41:32 -0700
Message-Id: <1193370092.26695.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 12:11 +1000, Rusty Russell wrote:
> On Thursday 25 October 2007 05:59:49 Matthew Wilcox wrote:
> > Consecutive calls to printk are non-atomic, which leads to various
> > implementations for accumulating strings which can be printed in one call.
> > This is a generic string buffer which can also be used for non-printk
> > purposes.

> This just seems like more optimization and complexity that we need.
> Interfaces using vsnprintf don't seem like good candidates for
> optimization.

Perhaps just tie stringbuf to printk and make stringbuf->buf
the same 1K size as the printk buffer?

no reallocs, no in-place out-of-memory handling
normal kzalloc and kfree of stringbuf * or add sb_alloc & sb_free

struct stringbuf {
	int len;
	char buf[1024];
}

/**
 * sb_printf_append - append to a stringbuf
 * @sb: a pointer to the stringbuf
 * @fmt: printf-style format
 */
void sb_printf_append(struct stringbuf *sb, const char *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	sb->len += vscnprintf(&sb->buf[len], sizeof(sb->buf) - sb->len, fmt, args);
	va_end(args);
}
EXPORT_SYMBOL(sb_printf_append);


