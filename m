Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0BBPgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:36:49 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:37855 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454Ab0BBPgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:36:43 -0500
Subject: Re: [PATCH] nfs: clear_commit_release incorrectly handle truncated
 page
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <87eil3pszw.fsf@openvz.org>
References: <87hbpzhqlp.fsf@openvz.org> <1265123045.3177.21.camel@localhost>
	 <87eil3pszw.fsf@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 10:36:39 -0500
Message-ID: <1265124999.3177.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 3 sum rcpts/h 10 sum msgs/h 3 total rcpts 2337 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 0713B41CBA4FD5CDAD6BB74B0004C2A7C9C269B7
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 151 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 18:17 +0300, Dmitry Monakhov wrote: 
> Trond Myklebust <trond.myklebust@fys.uio.no> writes:
> 
> > On Tue, 2010-02-02 at 13:36 +0300, Dmitry Monakhov wrote: 
> >> After page was truncated it lost it's mapping, this result in null
> >> pointer dereference on bdi_stat update. In fact we have to decrement
> >> bdi_stat even for truncated pages, so let's pass correct mapping in
> >> function arguments. Patch against linux-2.6
> >> ##TEST_CASE
> >> /*
> >> Tast case for bug in nfs_clear_request_commit()
> >> caused by null pointer dereference in case of truncated page.
> >> It takes less than 10 minutes to reproduce the bug.
> >
> > Something is wrong here. nfs_release_page() returns '0' if the 
> > page has an associated write request (i.e. PagePrivate is set), and so
> > both invalidate_complete_page() and invalidate_complete_page2() will
> > fail.
> >
> > So what is truncating the page?
> truncate_inode_page()
>   truncate_complete_page()
>     if (page_has_private(page))
>        do_invalidatepage()
>          ->nfs_invalidate_page()

do_invalidate_page() is called before remove_from_page_cache(), so
page->mapping should still be set.

Trond

