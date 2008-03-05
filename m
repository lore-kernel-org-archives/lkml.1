Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbYCEETd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbYCEETd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYCEETP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:19:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497AbYCEETN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:19:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] introduce ptrace_reparented() helper
In-Reply-To: Oleg Nesterov's message of  Monday, 3 March 2008 10:21:23 +0300 <20080303072123.GA25282@tv-sign.ru>
References: <20080303041751.GA18914@tv-sign.ru>
	<20080303072123.GA25282@tv-sign.ru>
X-Windows: let it get in *your* way.
Message-Id: <20080305041858.8FBD927010A@magilla.localdomain>
Date: Tue,  4 Mar 2008 20:18:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Somehow the patch I sent misses the change in ptrace.c, it can use the
> new helper too.

Actually, my pedantic streak prefers that to be in a separate patch.

I think the ptrace_reparented cleanup is fine, it is purely cosmetic and
improves readability.  

> -	if (!list_empty(&child->ptrace_list)) {
> +	if (ptrace_reparented(child)) {

This is changing the test from list_empty(&child->ptrace_list)
to child->parent == child->real_parent.  It should indeed be
impossible for those tests not to match.  But, paranoia is its
own reward.  I don't object to the change, but it should be
separate so bisect distinguishes it should it ever turn out to
matter in some way we are now overlooking.  I'd even be a
little inclined towards:

	if (child->real_parent == child->parent) {
		BUG_ON(!list_empty(&child->ptrace_list));
		return 0;
	} else {
		BUG_ON(list_empty(&child->ptrace_list));
		return 1;
	}

except of course you couldn't use that in the reparent_thread case.


Thanks,
Roland
