Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZEVEHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZEVEHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZEVEHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:07:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46505 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZEVEHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:07:04 -0400
Date: Fri, 22 May 2009 05:07:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com
Subject: Re: p used before making sure it is not NULL in kernel/auditsc.c
Message-ID: <20090522040704.GW8633@ZenIV.linux.org.uk>
References: <20090522022241.GA3350@helight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522022241.GA3350@helight>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 10:22:41AM +0800, Zhenwen Xu wrote:
> p used before making sure it is not NULL in kernel/auditsc.c
> 
> here we should make sure the p is not NULL then use it.

NAK.  ->tree_count can become non-zero only after we had set ->trees
non-NULL.  It's "how much free slots is left in current->trees".
If it's zero, we might have an empty chain (->trees is NULL, we bugger
off and caller tries to allocate) *or* we might be at the end of the
chain (->trees->next is NULL, same as previous) *or* we have more
allocated blocks in the chain, so we move to the next block and
store in there.

As a general note,

	if (foo) {
		...
		dereference p;
		...
	} else if (p) {
		...
		dereference p;
		...
	}

is a perfectly sane code, if foo is true only when p != NULL.
