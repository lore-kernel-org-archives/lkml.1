Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYEVXPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYEVXPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYEVXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:14:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:9307 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYEVXOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VL1kCGUk6eGp0D16N0b660wky1ncTAjVnzhkA1cO5PaBH5HD02YDAYbQIfWDLiLULI08MMYT8B+6kWsubRkpjKKSTbTIGd9Vu8kh1LdVsD6g0zruKTNlZ0812rr+5NLmXaySNJpX/8JMtnsRga+M0yEpjhHVxYR0hnFbhsSq3m8=
Subject: Re: [PATCH][RFC]fix soft lock up at NFS mount by per-SB LRU-list
	of unused dentries
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Chinner <dgc@sgi.com>
Cc: Kentaro Makita <k-makita@np.css.fujitsu.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <20080522225608.GZ173056135@sgi.com>
References: <4834D8DA.30907@np.css.fujitsu.com>
	 <20080522225608.GZ173056135@sgi.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 16:14:38 -0700
Message-Id: <1211498078.6888.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 08:56 +1000, David Chinner wrote:
> On Thu, May 22, 2008 at 11:22:18AM +0900, Kentaro Makita wrote:
> > +/*
> > + * Shrink the dentry LRU on a given superblock.
> > + * @sb   : superblock to shrink dentry LRU.
> > + * @count: If count is NULL, we prune all dentries on superblock.
> > + * @flags: If flags is non-zero, we need to do special processing based on
> > + * which flags are set. This means we don't need to maintain multiple
> > + * similar copies of this loop.
> > + */
> > +static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
> > +{
> > +	LIST_HEAD(referenced);
> > +	LIST_HEAD(tmp);
> > +	struct dentry *dentry;
> > +	int cnt = 0;
> > +
> > +	BUG_ON(!sb);
> > +	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
> > +	spin_lock(&dcache_lock);
> > +	if (count != NULL)
> > +		/* called from prune_dcache() and shrink_dcache_parent() */
> > +		cnt = *count;
> 
> I'd convert all the 'if (count == NULL)' to 'if (!count)' and same
> for 'if (count != NULL)' to 'if (count)'....

It's a small thing, but in this case it almost makes sense to have the
explicit null to remind people it's a pointer....whenever people see
a variable named count, it's easy to assume it's an integer.

YMMV

Harvey

