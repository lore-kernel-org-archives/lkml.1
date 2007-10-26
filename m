Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbXJZFTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbXJZFTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbXJZFTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:19:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4606 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbXJZFTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:19:22 -0400
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1193370092.26695.32.camel@localhost>
References: <20071024195847.GE27248@parisc-linux.org>
	 <1193255992-14385-1-git-send-email-matthew@wil.cx>
	 <200710261211.01423.rusty@rustcorp.com.au>
	 <1193370092.26695.32.camel@localhost>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 22:05:57 -0700
Message-Id: <1193375157.26695.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps have an sb_alloc function and a failure mode that
uses printk when sb_alloc fails or sb_append is passed null?

Perhaps something like:

stringbuf *sb_alloc(char* level, gfp_t priority)
{
	stringbuf *sb = kmalloc(sizeof(*sb), priority);
	if (sb)
		sb>len = sprintf(sb->buf, "%s", level);
	else
		printk(level);
	return sb;
}
EXPORT_SYMBOL(sb_alloc);

/**
 * sb_append - append to a stringbuf
 * @sb: a pointer to the stringbuf
 * @fmt: printf-style format
 */
void sb_append(struct stringbuf *sb, const char *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	if (sb)
		sb->len += vscnprintf(&sb->buf[len], sizeof(sb->buf) - sb->len, fmt, args);
	else
		vprintk(fmt, args);
	va_end(args);
}
EXPORT_SYMBOL(sb_append);

void sb_printk(struct stringbuf *sb)
{
	if (sb && sb->len > 0) {
		printk(sb->buf);
		sb->len = 0;
	}
}
EXPORT_SYMBOL(sb_printk);

void sb_free(stringbuf *sb)
{
	kfree(sb);
}
EXPORT_SYMBOL(sb_free);


