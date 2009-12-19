Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZLSRlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZLSRlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 12:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZLSRlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 12:41:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZLSRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 12:41:09 -0500
Date: Sat, 19 Dec 2009 09:40:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/2] SYSCTL: Make bin_table not const
In-Reply-To: <20091219145832.A0424B158A@basil.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0912190929180.3712@localhost.localdomain>
References: <20091219358.549678091@firstfloor.org> <20091219145832.A0424B158A@basil.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 19 Dec 2009, Andi Kleen wrote:
> 
> Turn all the bin_tables from const to non-const. This is needed for the next
> patch. Unfortunately there were a lot of them, so the patch is rather 
> large, but it is completely mechanic. 

Ouch. I hate this.

I'd much rather have a constant sysctl bin_table.

If the _only_ thing you want to do is to do a "warn-on-once" logic, I 
would seriously suggest you use a small hash-table instead of turning 
bin_table non-const.

IOW, d something like this:

	#define WARN_ONCE_HASH_BITS (10)
	#define WARN_ONCE_HASH_SIZE (1<<WARN_ONCE_HASH_BITS)

	static DECLARE_BITMAP(warn_once_bitmap, WARN_ONCE_HASH_SIZE);

	/*
	 * NOTE! We don't use the SMP-safe bit tests. We simply
	 * don't care enough. 
	 */
	static void warn_on_bintable(const int *name, int nlen)
	{
		unsigned int hash = full_name_hash(name, nlen);
		hash = hash_32(hash, WARN_ONCE_HASH_BITS);
		if (__test_and_set_bit(warn_once_bitmap, hash))
			return;
		deprecated_sysctl_warning(name, nlen);
	}

which should do the right thing in all practical circumstances.

(The above is obviously totally untested, I wrote it in the mail reader, 
but it's obvious enough what the intent is).

			Linus
