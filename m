Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYAYDh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYAYDh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYAYDhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:37:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41272 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbYAYDhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:37:17 -0500
Date: Thu, 24 Jan 2008 19:37:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Shaohua Li <shaohua.li@intel.com>
cc: lkml <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] some page can't be migrated
In-Reply-To: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
Message-ID: <Pine.LNX.4.64.0801241931500.32043@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, Shaohua Li wrote:

> +
> +	/*
> +	 * See truncate_complete_page(). Anonymous page might have
> +	 * fs-private metadata, the page is truncated. Such page can't be
> +	 * migrated. Try to free metadata, so the page can be freed.
> +	 */

Well maybe you should change the comment to refer to an orphaned page. 
That is what Nick used. Also change the comment in truncate_complete_page. 
Anonymous page is confusing here because you check that it is *not* an 
anonymous page.

> +	if (!page->mapping && !PageAnon(page) && PagePrivate(page)) {
> +		try_to_release_page(page, GFP_KERNEL);
> +		goto unlock;
> +	}
> +


Could you move that into the corner case handling that follows?

So it would be something like

if (!page->mapping) {
	if (!PageAnon(page) && PagePrivate(page))
		try_to_relase_page(page, GFP_KERNEL);
	goto rcu_unlock;
}

?

