Return-Path: <linux-kernel-owner+w=401wt.eu-S1161102AbXBUAFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161102AbXBUAFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965304AbXBUAFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:05:37 -0500
Received: from pat.uio.no ([129.240.10.15]:56211 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271AbXBUAFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:05:36 -0500
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion
	event
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Zach Brown <zach.brown@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <528148DD-0533-4D82-A242-25A4C5D1A977@oracle.com>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net>
	 <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411>
	 <20070219215048.GI6133@think.oraclecorp.com>
	 <20070220002109.GG31205@kvack.org>
	 <1171987310.6271.23.camel@heimdal.trondhjem.org>
	 <20070220160854.GO6133@think.oraclecorp.com>
	 <1171988988.6271.26.camel@heimdal.trondhjem.org>
	 <528148DD-0533-4D82-A242-25A4C5D1A977@oracle.com>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 19:05:19 -0500
Message-Id: <1172016319.6421.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 29398A973BBC397859222161B7E7F5120E236B74
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 42 total 591324 max/h 2803 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 10:40 -0800, Zach Brown wrote:
> >> There are some strange O_DIRECT corner cases in here such that the  
> >> 'last
> >> writer' may actually be a 'last reader' and winning can mean have  
> >> a copy
> >> of the page in page cache older than the copy on disk.
> >
> > As long as it is marked dirty so that it eventually gets synced to  
> > disk,
> > it shouldn't matter.
> 
> No, Chris is pointing out that an an O_DIRECT write can leave clean  
> read pages in the page cache.
>
> All it takes is giving a source buffer for the write which is an mmap 
> ()ed apeture of the region that is being written to.  If you get the  
> offsets right you can get the get_user_pages() down in fs/direct-io.c  
> will populate the page cache before the actual O_DIRECT write gets to  
> it.


With invalidate_inode_pages2()? That is supposed to wait until the page
lock is taken -> read is done. It then calls unmap_mapping_range() which
will remove the offending page from any existing mappings. Sure an
application could get stale data, but if it is reading while an O_DIRECT
write is proceeding, then it gets what it deserves.

Trond

