Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbYEGP1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbYEGP1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYEGP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:27:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755169AbYEGP1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:27:38 -0400
Date: Wed, 7 May 2008 08:26:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/6] gcov: add gcov profiling infrastructure
Message-Id: <20080507082618.bed9a8b3.akpm@linux-foundation.org>
In-Reply-To: <48218B1D.2040808@de.ibm.com>
References: <481F26BE.2060706@de.ibm.com>
	<20080505224333.d3299a28.akpm@linux-foundation.org>
	<48218B1D.2040808@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 12:57:33 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> >> +unsigned int gcov_version;
> >> +
> >> +void __gcov_init(struct gcov_info *info)
> >> +{
> >> +	mutex_lock(&gcov_lock);
> >> +	/* Check for compatible gcc version. */
> >> +	if (gcov_version == 0) {
> >> +		gcov_version = info->version;
> >> +		printk(KERN_INFO TAG "gcc version %x\n", gcov_version);
> > 
> > hm, what does the output from this look like?  "gcc version 42", which is
> > really gcc version 66 only we didn't tell the user that we printed it in
> > hex?
> > 
> > Might need a bit more thought here?
> 
> Quote from gcc/gcov-io.h:
> 
>    The version number
>    consists of the single character major version number, a two
>    character minor version number (leading zero for versions less than
>    10), and a single character indicating the status of the release.
>    [...]
>    For gcc 3.4 experimental, it would be '304e' (0x33303465).
> 
> This number really is meant for debugging purposes: when a user
> encounters problems, a copy of this line can tell exactly which version
> of gcc's gcov data structures were used during compilation.
> 
> Maybe a modified message text "gcov data version magic: %x" would be
> more descriptive.

"0x%x" would reduce confusion.

> >> +static inline int within(void *addr, void *start, unsigned long size)
> >> +{
> >> +        return (addr >= start && (void *) addr < start + size);
> >> +}
> > 
> > That is at least our fourth implementation of within(), and not all of them
> > have the same semantics.
> 
> I'll see if these can be merged. What would be the right place,
> linux/kernel.h?

Yeah.  Although you'd be forgiven for retaining the private implementation.
"[patch] consolidate all the within() implementations" is a separate work
and it'd be wrong to say this-is-a-prerequisite.

> >> +/* Profiling data types used for gcc 3.4 and above. */
> >> +
> >> +#define GCOV_COUNTERS		5
> >> +#define GCOV_DATA_MAGIC		((unsigned int) 0x67636461)
> >> +#define GCOV_TAG_FUNCTION	((unsigned int) 0x01000000)
> >> +#define GCOV_TAG_COUNTER_BASE	((unsigned int) 0x01a10000)
> >> +#define GCOV_TAG_FOR_COUNTER(count)					\
> >> +	(GCOV_TAG_COUNTER_BASE + ((unsigned int) (count) << 17))
> >> +
> >> +#if BITS_PER_LONG >= 64
> >> +typedef long gcov_type;
> >> +#else
> >> +typedef long long gcov_type;
> >> +#endif
> > 
> > Can we zap gcov_type completely and use u64?
> 
> gcc defines these types so I don't think there's another way to stay
> compatible than to copy their definitions.

hm, sad.  u64 is long on some 64-bit architectures and long long on others.

> >> +
> >> +	list_for_each_entry(node, &parent->children, list) {
> >> +		if (strcmp(node->name, name) == 0)
> >> +			return node;
> >> +	}
> >> +
> >> +	return NULL;
> >> +}
> > 
> > I trust this won't be called very frequently.
> 
> get_child_by_name() will be called multiple times for each gcov data
> structure when it is initialized. I don't see a problem with that
> though..

OK.  It just looks rather slow...

> Anyway, thanks for the extensive comments. I'll get back with a modified
> version of this patch set.

np.

The increase in kenrel size is pretty shocking.  From a sample of 1
(mm/swap.o) it really does increase text and data by about a factor of
three.  I assume that this means that distributors will be unable to enable
this feature, which makes it a kernel-developers-only thing.  Which is OK,
I guess.  But a shame.
