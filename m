Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXBDPNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXBDPNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 10:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbXBDPNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 10:13:04 -0500
Received: from delta.idt.cz ([81.0.223.58]:4736 "EHLO delta.idt.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbXBDPNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 10:13:02 -0500
Date: Sun, 4 Feb 2007 16:33:21 +0100
From: Michal Hocko <mstsxfx@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm: how to check for kernel pages
Message-ID: <20070204153321.GC10477@curandero.marconia.cz>
References: <20070204110256.GA10477@curandero.marconia.cz> <1170597450.3073.1127.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170597450.3073.1127.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 02:57:30PM +0100, Arjan van de Ven wrote:
> On Sun, 2007-02-04 at 12:02 +0100, Michal Hocko wrote:
> > Hi,
> > is there any effective and fast way how to find out whether page
> > given by its page frame number is currenly used by (mapped by) kernel?
> 
> what do you want to use this for? The answer to your question greatly
> depends on that...

Sorry for not being more precise. As a part of my thesis work I need to
migrate pages. I greatly use mm/migrate.c code.  
I assume that not all pages can be migrated - especially those used by
kernel (where direct virtual to physical mapping is used).
So I intended something like following code:

/* Returns 0 if page is suitable to be migration source */
int check_migrate_page(struct page * page)
{
	return PageBuddy(page) || PageCompound(page) || ... 
		kernel_page(page);
}

/* Steals pfn page from its current user(s) and replace it by newly
 * allocated page. pfn page structure is returned if page was migrated
 * to new location (can be reused by caller) or NULL otherwise.
 */
struct page * steal_page(unsigned long pfn)
{
	int ret;
	struct page *page, *target_page;

	page = pfn_to_page(pfn);
	if(!page)
		goto bad_page;

	ret = check_migrate_page(page);
	if(ret)
		goto bad_page;

	target_page = alloc_pages(flags, 0);
	/* uses migrate_pages function internally */
	ret = do_migration(page, target_page);
	if(ret)
		goto bad_page;

	/* TODO clear page frame data. */
	return page;
bad_page:
	return NULL;
}

Please add me to Cc, because I am not the list member.
Best regards
-- 
Michal Hocko

