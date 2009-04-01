Return-Path: <linux-kernel-owner+w=401wt.eu-S1765938AbZDAAXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765938AbZDAAXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765902AbZDAAXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:23:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765893AbZDAAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:23:13 -0400
Date: Tue, 31 Mar 2009 17:20:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on
 inode->dirtied_when checks (try #2)
Message-Id: <20090331172031.b2971f1e.akpm@linux-foundation.org>
In-Reply-To: <1238544239-31882-1-git-send-email-jlayton@redhat.com>
References: <1238544239-31882-1-git-send-email-jlayton@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 20:03:59 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> +		 * It's not sufficient to just do a time_after() check on
> +		 * dirtied_when. That assumes that dirtied_when will always
> +		 * change within a period of jiffies that encompasses half the
> +		 * machine word size (2^31 jiffies on 32-bit arch). That's not
> +		 * necessarily the case if an inode is being constantly
> +		 * redirtied. Since dirtied_when can never be in the future,
> +		 * we can assume that if it appears to be so then it is
> +		 * actually in the distant past.

so this really is a 32-bit-only thing.

I guess that isn't worth optimising for though.

otoh, given that all three comparisons are the same:

+			time_after(inode->dirtied_when, *older_than_this) &&
+			time_before_eq(inode->dirtied_when, jiffies))

(although one is inverted (i think?)), it might end up nicer if this was all done
in a little helper function?

That way we only need to comment what's going on at a single site, and
we could omit the additional test if !CONFIG_64BIT.
