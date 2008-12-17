Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754074AbYLQQRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYLQQRh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYLQQR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:17:27 -0500
Received: from eazy.amigager.de ([213.239.192.238]:55036 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYLQQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:17:26 -0500
Date: Wed, 17 Dec 2008 17:17:22 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Theodore Tso <tytso@mit.edu>
Subject: Re: Very slow header cache in mutt if the maildir is on ext3
Message-ID: <20081217161722.GA28303@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
References: <20081217001625.GA3250@x61> <20081217005210.GA889@dose.home.local> <20081217032517.GE10590@mit.edu> <20081217091003.GA26609@dose.home.local> <20081217123204.GO10590@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217123204.GO10590@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 07:32:04 -0500, Theodore Tso wrote:

[...]

> I just checked mutt 1.5.17 in Ubunty Hardy, and it sorts the inodes
> even if maildir_header_cache_verify is unset.  (It sorts it earlier if
> that option is set, but a little later in the function, if it wasn't
> sorted earlier, it sorts it then.)  Check for calls to maildir_sort()
> that use md_cmp_inode(); in my version of mutt, there are two such
> calls in mh.c:maildir_delayed_parsing().

I checked maildir_sort(), and it wasn't called with
maildir_header_cache_verify unset. In the source, it looks like this:

#if USE_HCACHE
    if (option(OPTHCACHEVERIFY))
    {
      DO_SORT();
      ret = stat(fn, &lastchanged);
    }

...

   if (ctx->magic == M_MH)
      data = mutt_hcache_fetch (hc, p->h->path, strlen);
    else
      data = mutt_hcache_fetch (hc, p->h->path + 3, &maildir_hcache_keylen);

...

#endif /* USE_HCACHE */

    DO_SORT();

So DO_SORT() is called _after_ reading the header cache if
maildir_header_cache_verify is unset, which is too late, because the
hard disk seeks to death if the cache is read with the unsorted inode
list.

Regards,
Tino
