Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYKJKed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYKJKed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYKJKeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:34:23 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:50840 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbYKJKeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:34:22 -0500
Message-ID: <49180E29.2060004@nttdata.co.jp>
Date: Mon, 10 Nov 2008 19:34:17 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 05/11] Memory and pathname management
 functions.
References: <20081104060847.086543472@nttdata.co.jp>	<20081104060949.942652091@nttdata.co.jp> <20081105151217.4e8d11a9.akpm@linux-foundation.org>
In-Reply-To: <20081105151217.4e8d11a9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2008 10:34:16.0993 (UTC) FILETIME=[E1E88910:01C9431F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > +/**
> > + * round_up - Round up an integer so that the returned pointers are appropriately aligned.
> > + *
> > + * @size: Size in bytes.
> > + *
> > + * Returns rounded value of @size.
> > + *
> > + * FIXME: Are there more requirements that is needed for assigning value
> > + * atomically?
> > + */
> 
> Can PTR_ALIGN be used?
> 
> If not, please prefer to avoid implementing generic helpers down in
> specific code.  It is better to add the helpers in a kernel-wide
> fashion in an early patch, then to use those halpers in the
> subsyste-specific patches.

Replaced by "roundup(size, max(sizeof(void *), sizeof(long)))".

> > +/* Structure for string data. */
> > +struct name_entry {
> > +	struct list1_head list;
> > +	struct path_info entry;
> > +};
> > +
> 
> You didn't need to invent list1_head for this application.  This is
> *exactly* what the existing hlist_head is designed for.

hlist_head omits ->pprev, but hlist_node doesn't.
Since TOMOYO uses this list as Write-Once-Read-Many,
TOMOYO doesn't use ->pprev for list elements.

> > +/**
> > + * tmy_save_name - Allocate permanent memory for string data.
> > + *
> > + * @name: The string to store into the permernent memory.
> > + *
> > + * Returns pointer to "struct path_info" on success, NULL otherwise.
> > + *
> > + * The RAM is shared, so NEVER try to modify or kfree() the returned name.
> > + */
> 
> Nothing ever gets removed from fmb_list.  How odd.
> 
> If this is not a bug, I'd suggest that a code comment be added
> explaining what all this code does and why it does it and how it does
> it.

fmb contains memory reserved by TOMOYO for future requests.
fmb is removed from the fmb_list when fmb->len becomes 0.
So, this is not a bug. I added a comment.

> > +/* Memory allocated for temporal purpose. */
> > +static atomic_t dynamic_memory_size;
> 
> The correct word is "temporary".  This needs fixing in at least one
> other place.

Replaced "temporal" by "temporary". Thanks.

> Is this counter really useful?  If not, I'd suggest that it be removed
> and that all calls to tmy_alloc() simply be replaced by calls to
> kmalloc().
> 
This counter was introduced by user's request so that the administrator can
know how much memory is used by TOMOYO module. So, I want to keep this counter.

> A better way to perform memory accounting would be to create slab
> caches for commonly-used objects and to reply uponthe existing
> accounting in /proc/slabinfo.
> 
Hmm, memory allocated for temporary purpose is not a fixed size.

> > +/**
> > + * tmy_alloc - Allocate memory for temporal purpose.
> > + *
> > + * @size: Size in bytes.
> > + *
> > + * Returns pointer to allocated memory on success, NULL otherwise.
> > + */
> > +void *tmy_alloc(const size_t size)
> > +{
> > +	void *p = kzalloc(size, GFP_KERNEL);
> > +	if (p)
> > +		atomic_add(ksize(p), &dynamic_memory_size);
> > +	return p;
> > +}
> 
> Note that I said "kmalloc", not "kzalloc".  This function zeroes
> everything all the time, and surely that is not necessary.  It's just a
> waste of CPU time.
> 
Callers of tmy_alloc assume that allocated memory is zeroed.

> > +static int tmy_print_ascii(const char *sp, const char *cp,
> > +			   int *buflen0, char **end0)
> 
> I look at this and wonder "hm, does that duplicate any facility which
> the kernel provides"?  But I can't tell, because I don't know what this
> function does, and I shouldn't have to sit down with a pencil and paper
> decrypting it.
> 
I splitted this function into "prepend()" part and "convert a string to
TOMOYO's string representation rule" part. And I renamed the latter from
"tmy_print_ascii" to "tmy_encode".

> > +/* tmy_realpath_from_path2() for "struct ctl_table". */
> > +static int tmy_sysctl_path(struct ctl_table *table, char *buffer, int buflen)
> 
> Is this needed if CONFIG_SYSCTL=n?  Does it compile if CONFIG_SYSCTL=n?
> 
Added "#ifdef CONFIG_SYSCTL" and moved to security/tomoyo/tomoyo.c .

> > +/**
> > + * tmy_read_memory_counter - Check for memory usage.
> > + *
> > + * @head: Pointer to "struct tmy_io_buffer".
> > + *
> > + * Returns memory usage.
> 
> In what units?  Megabytes?
> 
In bytes.

> > +int tmy_read_memory_counter(struct tmy_io_buffer *head)
> 
> This (I assume) is part of an implementation of a userspace interface. 
> We care a lot about userspace interfaces.  Please describe the Tomoyo
> userspace interfaces so that we can review them for suitability and
> maintainability.
> 
I'll describe it in other posting.

> Surely this function should return a 64-bit quantity?
> 
I believe 32-bit is enough. TOMOYO uses only 1MB or so. Never 4GB or more.

> Again, we would like to see a complete decription of the proposed
> userspace ABI.  This one looks fairly ugly.  Do I really have to write
> 'S' 'h' 'a' 'r' 'e' 'd' ':' ' ' into some pseudo file?
> 
> A better interface would be two suitably-named pseudo files each of
> which takes a bare integer string.  None of this funny colon-based
> prefixing stuff.
> 
Creating pseudo files for each variables is fine, though I don't see
advantage by changing from
"echo Shared: 16777216 > /sys/kernel/security/tomoyo/meminfo" to
"echo 16777216 > /sys/kernel/security/tomoyo/quota/shared_memory".


