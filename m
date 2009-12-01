Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZLAJhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZLAJhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZLAJhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:37:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbZLAJhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:37:40 -0500
Date: Tue, 1 Dec 2009 10:37:38 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-ID: <20091201093738.GL30235@random.random>
References: <20091201093945.8c24687f.kamezawa.hiroyu@jp.fujitsu.com>
 <20091201091111.GK30235@random.random>
 <20091201181633.5C31.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201181633.5C31.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 06:28:16PM +0900, KOSAKI Motohiro wrote:
> This patch doesn't works correctly. shrink_active_list() use page_referenced() for
> clear young bit and doesn't use return value.

The whole point is that it's inefficient to clear all young bits just
to move it to inactive list in the hope that new young bits will be
set right before the page reaches the end of the inactive list.

> after this patch apply, shrink_active_list() move the page to inactive list although
> the page still have many young bit. then, next shrink_inactive_list() move the page
> to active list again.

yes it's not the end of the world, this only alter behavior for pages
that have plenty of mappings. However I still it's inefficient to
pretend to clear all young bits at once when page is deactivated. But
this is not something I'm interested to argue about... let do what you
like there, but as long as you pretend to clear all dirty bits there
is no way we can fix anything. Plus we should touch ptes only in
presence of heavy memory pressure, with light memory pressure ptes
should _never_ be touched, and we should only shrink unmapped
cache. And active/inactive movements must still happen even in
presence of light memory pressure. The reason is that with light
memory pressure we're not I/O bound and we don't want to waste time
there. My patch is ok, what is not ok is the rest, you got to change
the rest to deal with this.
