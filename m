Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZKBE7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZKBE7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 23:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZKBE7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 23:59:14 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:33157 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZKBE7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 23:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UVWENZWXSKjwW+oTt8Y95YSQpw1vmweG/HE43EDn8EJsN0WUACITuKQe9neAPrCHjc
         NKMD54ltIFaAhhl4sReb/BWl1UUY29L/HQY1X73hP+D4TeEZJ/yU0E+Jnu6AMmE6rUw6
         Ro821q9pXrRzB1m8/yb7wc1X0tJM0Oz9cTvv4=
Date: Mon, 2 Nov 2009 13:56:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: OOM killer, page fault
Message-Id: <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
In-Reply-To: <20091102005218.8352.A69D9226@jp.fujitsu.com>
References: <20091030063216.GA30712@gamma.logic.tuwien.ac.at>
	<20091102005218.8352.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Nov 2009 13:24:06 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi,
> 
> (Cc to linux-mm)
> 
> Wow, this is very strange log.
> 
> > Dear all,
> > 
> > (please Cc)
> > 
> > With 2.6.32-rc5 I got that one:
> > [13832.210068] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0
> 
> order = 0

I think this problem results from 'gfp_mask = 0x0'.
Is it possible?

If it isn't H/W problem, Who passes gfp_mask with 0x0?
It's culpit. 

Could you add BUG_ON(gfp_mask == 0x0) in __alloc_pages_nodemask's head?

---

/*
 * This is the 'heart' of the zoned buddy allocator.
 */
struct page *
__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
                        struct zonelist *zonelist, nodemask_t *nodemask)
{
        enum zone_type high_zoneidx = gfp_zone(gfp_mask);
        struct zone *preferred_zone;
        struct page *page;
        int migratetype = allocflags_to_migratetype(gfp_mask);

+	BUG_ON(gfp_mask == 0x0);
        gfp_mask &= gfp_allowed_mask;

        lockdep_trace_alloc(gfp_mask);

        might_sleep_if(gfp_mask & __GFP_WAIT);

        if (should_fail_alloc_page(gfp_mask, order))
                return NULL;


-- 
Kind regards,
Minchan Kim
