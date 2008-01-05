Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYAEJK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYAEJK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYAEJKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:10:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42284 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYAEJKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:10:14 -0500
Date: Sat, 5 Jan 2008 09:10:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Shaduri <ashaduri@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080105091012.GG27894@ZenIV.linux.org.uk>
References: <20080104213812.20268840@linux.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104213812.20268840@linux.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 09:38:12PM +0400, Alexander Shaduri wrote:
> 
> I got the following message, shortly followed by a system hang.
> BUG: unable to handle kernel paging request at virtual address 48464443
> 
> (see the oops below).

AFAICS, it's quicklist_alloc() called from pgd_alloc():

static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
{
        struct quicklist *q;
        void **p = NULL;

        q =&get_cpu_var(quicklist)[nr];
        p = q->page;
        if (likely(p)) {
                q->page = p[0];

and we have q->page == 0x48464443.  Seeing how we assign that sucker, that
smells like we've got a page on quicklist with {0x43, 0x44, 0x46, 0x48}
in its first 4 bytes.  Instead of having address of the next page stored
in there...

Do other oopsen of the same kind give the same value?  The shortest
scenario I can see for that is
	* something accidentally frees a page
	* pgd_alloc() grabs it
	* pgd_free() releases it and puts on quicklist; the first 4 bytes
are zeroed.
	* whatever used to hold that page modifies it, overwriting its
beginning
	* next pgd_alloc() grabs that page and advances quicklist - sets
it to the first 4 bytes of that page.  At that point we are well and truly
fucked - quicklist is corrupted and once we need more pgd we'll get that
oops.

The question is, what's losing and then overwriting that page in the
first place?
