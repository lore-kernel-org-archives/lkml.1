Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751803AbYLQS2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbYLQS2Y (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYLQS2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:28:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYLQS2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:28:13 -0500
Subject: Re: [PATCH 11/15] fixing audit rule ordering mess, part 1
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <E1LCoiI-0000Eu-Ty@ZenIV.linux.org.uk>
References: <E1LCoiI-0000Eu-Ty@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 13:28:08 -0500
Message-Id: <1229538488.3384.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 05:12 +0000, Al Viro wrote:
> Problem: ordering between the rules on exit chain is currently lost;
> all watch and inode rules are listed after everything else _and_
> exit,never on one kind doesn't stop exit,always on another from
> being matched.
> 
> Solution: assign priorities to rules, keep track of the current
> highest-priority matching rule and its result (always/never).
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


> @@ -1258,6 +1258,9 @@ static int audit_add_watch(struct audit_krule *krule, struct nameidata *ndp,
>  	return ret;
>  }
>  
> +static u64 prio_low = ~0ULL/2;
> +static u64 prio_high = ~0ULL/2 - 1;
> +
>  /* Add rule to given filterlist if not a duplicate. */
>  static inline int audit_add_rule(struct audit_entry *entry,
>  				 struct list_head *list)
> @@ -1319,6 +1322,14 @@ static inline int audit_add_rule(struct audit_entry *entry,
>  		}
>  	}
>  
> +	entry->rule.prio = ~0ULL;
> +	if (entry->rule.listnr == AUDIT_FILTER_EXIT) {
> +		if (entry->rule.flags & AUDIT_FILTER_PREPEND)
> +			entry->rule.prio = ++prio_high;
> +		else
> +			entry->rule.prio = --prio_low;
> +	}
> +
>  	if (entry->rule.flags & AUDIT_FILTER_PREPEND) {
>  		list_add_rcu(&entry->list, list);

I don't see why prio is only important on AUDIT_FILTER_EXIT.  Couldn't I
end up with stupidity with entry,never  ?

-Eric

