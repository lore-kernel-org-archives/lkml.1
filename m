Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZCOJHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZCOJHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZCOJGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:06:52 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:34643 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752553AbZCOJGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:06:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rOdXXJRw9EemywURmGfJD3H/GxiYrhON+LPyRPNRdSyG2DiNn/VeyXyjjwlTZ/oIlfOfsz4XUDCP1rDJso3Uj6kpyUagxYIoY1k11Up8tCr7k2VtSSSe9rzs2nCYCb4HO+j0QLq5K68QgZYEUvJjc3h8uVH7cSnp5ULmQiQQJro=  ;
X-YMail-OSG: i_EvRswVM1lQwItWhslDBmh13anMg5ejuOmasi1Q9JSnP6P.15nd_rjosLyRAMvthYtZRs2Q2rJIe2LIAUtdmV8B7X8HYZ53wV9BID7xXDuZtyonHbZT9kHJCTCAGHE8nxc.gvPTeEaw2ckgAYrBv1xAcVfu8g5fSD_64480PIjVBtjNJao4JObjUfau3HCj_ga2KQbXIP9QWHr0DAVIcBwVo0buVQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate reclaim context (__GFP_NOFS), fix SLOB)
Date: Sun, 15 Mar 2009 20:06:20 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-tip-commits@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
References: <20090128135457.350751756@chello.nl> <tip-bf722c9d324864b4256edaa330751b77f2a19861@git.kernel.org> <20090315064818.GA1193@elte.hu>
In-Reply-To: <20090315064818.GA1193@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152006.21160.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 17:48:18 Ingo Molnar wrote:

> > Cc: Nick Piggin <npiggin@suse.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <20090128135457.350751756@chello.nl>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> and with this fixed, and with SLOB now being tested in -tip, the
> new lockdep assert attached below (followed by a real lockup)
> pops up.
>
> Seems like a genuine SLOB bug, probably present upstream as
> well.

Hmmf. debugobjects calls back into the slab allocator from the page
allocator. The following patch would improve SLOB, but I think it
would be a good idea to avoid a dependency in that direction. Can
debugobjects defer this freeing?

---
 mm/slob.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c
+++ linux-2.6/mm/slob.c
@@ -390,13 +390,14 @@ static void slob_free(void *block, int s
 	spin_lock_irqsave(&slob_lock, flags);
 
 	if (sp->units + units == SLOB_UNITS(PAGE_SIZE)) {
+		spin_lock_irqrestore(&slob_lock, flags);
 		/* Go directly to page allocator. Do not pass slob allocator */
 		if (slob_page_free(sp))
 			clear_slob_page_free(sp);
 		clear_slob_page(sp);
 		free_slob_page(sp);
 		free_page((unsigned long)b);
-		goto out;
+		return;
 	}
 
 	if (!slob_page_free(sp)) {

