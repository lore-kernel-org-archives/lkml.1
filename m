Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZJBQ5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZJBQ5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZJBQ5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:57:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbZJBQ5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:57:32 -0400
Date: Fri, 2 Oct 2009 09:54:17 -0700
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [120/136] mm: munlock use follow_page
Message-ID: <20091002165417.GA3901@suse.de>
References: <20091002011548.335611824@mini.kroah.org>
 <20091002012426.002095979@mini.kroah.org>
 <Pine.LNX.4.64.0910021736540.20933@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910021736540.20933@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:46:40PM +0100, Hugh Dickins wrote:
> On Thu, 1 Oct 2009, Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > 
> > commit 408e82b78bcc9f1b47c76e833c3df97f675947de upstream.
> > 
> > Hiroaki Wakabayashi points out that when mlock() has been interrupted
> > by SIGKILL, the subsequent munlock() takes unnecessarily long because
> > its use of __get_user_pages() insists on faulting in all the pages
> > which mlock() never reached.
> > 
> > It's worse than slowness if mlock() is terminated by Out Of Memory kill:
> > the munlock_vma_pages_all() in exit_mmap() insists on faulting in all the
> > pages which mlock() could not find memory for; so innocent bystanders are
> > killed too, and perhaps the system hangs.
> > 
> > __get_user_pages() does a lot that's silly for munlock(): so remove the
> > munlock option from __mlock_vma_pages_range(), and use a simple loop of
> > follow_page()s in munlock_vma_pages_range() instead; ignoring absent
> > pages, and not marking present pages as accessed or dirty.
> > 
> > (Change munlock() to only go so far as mlock() reached?  That does not
> > work out, given the convention that mlock() claims complete success even
> > when it has to give up early - in part so that an underlying file can be
> > extended later, and those pages locked which earlier would give SIGBUS.)
> 
> Thanks a lot for including this fix in 2.6.31.2.
> 
> If I'd done my homework, I'd be asking you to include the equivalent
> in 2.6.30.9 (it's irrelevant to 2.6.27.36); but because of intervening
> changes, although it would appear to apply there, it would be wrong.
> 
> And it's more than a one-liner, so I'd need to retest properly.
> If there's ever a call for a 2.6.30.10, I ought to supply you with
> the proper patch; but for now, unless others disagree, let's not
> rush it for 2.6.30.9.

Thanks, but I really don't want to create a 2.6.30.10.  So if no one
needs it, I'd not want to make you do any extra work for this.

greg k-h
