Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbXL1Lmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbXL1Lmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 06:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXL1Lml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 06:42:41 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33704 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752137AbXL1Lml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 06:42:41 -0500
Message-ID: <398842168.09386@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 28 Dec 2007 19:42:36 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shaggy@austin.ibm.com, jfs-discussion@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
References: <E1J8AC5-0002BE-RP@localhost> <1198841626.6821.92.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198841626.6821.92.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J8Dbo-0001e2-1T@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 12:33:46PM +0100, Peter Zijlstra wrote:
> 
> On Fri, 2007-12-28 at 16:03 +0800, Fengguang Wu wrote:
> > Andrew,
> > 
> > This patch fixed the 'pdflush stuck in D state' bug
> >         http://bugzilla.kernel.org/show_bug.cgi?id=9291
> > and should be pushed to mainline ASAP.
> > ---
> > 
> > When JFS decides to drop a dirty metapage, it simply clears the META_dirty bit
> > and leave alone the PG_dirty and PAGECACHE_TAG_DIRTY bits.
> > 
> > When such no-write page goes to metapage_writepage(), the `relic'
> > PAGECACHE_TAG_DIRTY tag should be cleared, to prevent pdflush from
> > repeatedly trying to sync them.
> > 
> > Also, avoid the redirty when a bio submission is planned.
> > 
> > Tested-by: Markus Rehbach <Markus.Rehbach@gmx.de>
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 
> > ---
> 
> > +++ b/fs/jfs/jfs_metapage.c
> 
> > @@ -449,9 +450,15 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
> >  			goto dump_bio;
> >  
> >  		submit_bio(WRITE, bio);
> > -	}
> > -	if (redirty)
> > +	} else if (redirty) {
> >  		redirty_page_for_writepage(wbc, page);
> > +	} else {
> > +		write_lock_irq(&mapping->tree_lock);
> > +		radix_tree_tag_clear(&mapping->page_tree,
> > +				page_index(page),
> > +				PAGECACHE_TAG_DIRTY);
> > +		write_unlock_irq(&mapping->tree_lock);
> > +	}
> 
> I'm not liking this open-coded tag_clear, although I currently fail to
> come up with a nice solution.

Another option is to release/drop such pages ASAP. But what if the
metapage_writepage() is called even before we have the chance to
release it?

