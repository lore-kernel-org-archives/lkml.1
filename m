Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYFHWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYFHWE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbYFHWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 18:04:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbYFHWEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 18:04:20 -0400
Date: Sun, 8 Jun 2008 18:03:40 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Message-ID: <20080608180340.4abca025@bree.surriel.com>
In-Reply-To: <20080608135704.a4b0dbe1.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.291472052@redhat.com>
	<20080606180506.081f686a.akpm@linux-foundation.org>
	<20080608163413.08d46427@bree.surriel.com>
	<20080608135704.a4b0dbe1.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 13:57:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > If you want I'll get rid of CONFIG_NORECLAIM_LRU and make everything
> > just compile in always.
> 
> Seems unlikely to be useful?  The only way in which this would be an
> advantage if if we hae some other feature which also needs a page flag
> but which will never be concurrently enabled with this one.
> 
> > Please let me know what your preference is.
> 
> Don't use another page flag?

To explain in more detail why we need the page flag:

When we move a page from the active or inactive list onto the
noreclaim list, we need to know what list it was on, in order
to adjust the zone counts for that list (NR_ACTIVE_ANON, etc).

For the same reason, we need to be able to identify whether
a page is already on the noreclaim list, so we can adjust
the statistics for the noreclaim pages, too. We cannot afford
to accidentally move a page onto the noreclaim list twice, or
try to remove it from the noreclaim list twice.

We need to know how many pages of each type there are in
each zone, and we need a way to specify that a page has
just become noreclaim. If a page is sitting a pagevec
somewhere, and it has just become unreclaimable, we want
that page to end up on the noreclaim list once that
pagevec is flushed.

As far as I can see, this requires a page flag.

-- 
All rights reversed.
