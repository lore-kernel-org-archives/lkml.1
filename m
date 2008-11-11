Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYKKFEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYKKFEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYKKFEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:04:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbYKKFEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:04:13 -0500
Date: Mon, 10 Nov 2008 21:04:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 05/11] Memory and pathname
 management functions.
Message-Id: <20081110210405.d43458f3.akpm@linux-foundation.org>
In-Reply-To: <49180E29.2060004@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
	<20081104060949.942652091@nttdata.co.jp>
	<20081105151217.4e8d11a9.akpm@linux-foundation.org>
	<49180E29.2060004@nttdata.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 19:34:17 +0900 Kentaro Takeda <takedakn@nttdata.co.jp> wrote:

> 
> ...
>
> > > +/**
> > > + * tmy_alloc - Allocate memory for temporal purpose.
> > > + *
> > > + * @size: Size in bytes.
> > > + *
> > > + * Returns pointer to allocated memory on success, NULL otherwise.
> > > + */
> > > +void *tmy_alloc(const size_t size)
> > > +{
> > > +	void *p = kzalloc(size, GFP_KERNEL);
> > > +	if (p)
> > > +		atomic_add(ksize(p), &dynamic_memory_size);
> > > +	return p;
> > > +}
> > 
> > Note that I said "kmalloc", not "kzalloc".  This function zeroes
> > everything all the time, and surely that is not necessary.  It's just a
> > waste of CPU time.
> > 
> Callers of tmy_alloc assume that allocated memory is zeroed.

That isn't the point.  For programmer convenience we could make
__alloc_pages() and kmalloc() zero all the memory too.  But we don't
because it is slow.

> > > +/**
> > > + * tmy_read_memory_counter - Check for memory usage.
> > > + *
> > > + * @head: Pointer to "struct tmy_io_buffer".
> > > + *
> > > + * Returns memory usage.
> > 
> > In what units?  Megabytes?
> > 
> In bytes.

Let me rephrase:

The comment over tmy_read_memory_counter() fails to tell the reader
what units are used for the return value.  It should do so.

> > Again, we would like to see a complete decription of the proposed
> > userspace ABI.  This one looks fairly ugly.  Do I really have to write
> > 'S' 'h' 'a' 'r' 'e' 'd' ':' ' ' into some pseudo file?
> > 
> > A better interface would be two suitably-named pseudo files each of
> > which takes a bare integer string.  None of this funny colon-based
> > prefixing stuff.
> > 
> Creating pseudo files for each variables is fine, though I don't see
> advantage by changing from
> "echo Shared: 16777216 > /sys/kernel/security/tomoyo/meminfo" to
> "echo 16777216 > /sys/kernel/security/tomoyo/quota/shared_memory".

Well for starters, the existing interface is ugly as sin and will make
kernel developers unhappy.

There is a pretty strict one-value-per-file rule in sysfs files, and
"multiple tagged values in one file" violates that a lot.

