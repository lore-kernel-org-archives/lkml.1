Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbZFPSjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbZFPSjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZFPSjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:39:36 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:31416 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbZFPSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:39:35 -0400
X-Trace: 213026266/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.37.104/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.37.104
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEGACWEN0pPRSVo/2dsb2JhbACBT9RFhAsF
X-IronPort-AV: E=Sophos;i="4.42,230,1243810800"; 
   d="scan'208";a="213026266"
Date: Tue, 16 Jun 2009 19:38:39 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
In-Reply-To: <20090616181325.GC23969@random.random>
Message-ID: <Pine.LNX.4.64.0906161930050.24878@sister.anvils>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Andrea Arcangeli wrote:
> On Tue, Jun 16, 2009 at 09:05:27PM +0300, Izik Eidus wrote:
> > So the question is: is this thing is by desgin? (that kernel thread cant 
> > call get_user_pages???), should i use something like switch_mm()??
> 
> I think switch_mm trick should be used for page faults, but gup
> shouldn't require it because it gets the 'mm' as parameter and the
> current->mm has to be irrelevant. current->mm is only relevant for
> gup-fast (obviously :). So I think the only bit that needs fixing is
> grab_swap_token to not run if current->mm is null.

Looks like Izik and I hit the same problem (otherwise running well):
I too decided we needn't do more than avoid the issue in grab_swap_token.
(I've a feeling someone has hit this issue before with some other thread,
though I've no idea which - does RHEL include a patch like this perhaps?).

[PATCH] mm: grab_swap_token back out if no mm

If a kthread happens to use get_user_pages() on an mm (as KSM does),
there's a chance that it will end up trying to read in a swap page,
and oops in grab_swap_token() because the kthread has no mm:
nothing clever, just avoid that case.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/thrash.c |    3 +++
 1 file changed, 3 insertions(+)

--- 2.6.30-mm1/mm/thrash.c	2007-07-09 00:32:17.000000000 +0100
+++ linux/mm/thrash.c	2009-06-15 19:44:53.000000000 +0100
@@ -30,6 +30,9 @@ void grab_swap_token(void)
 {
 	int current_interval;
 
+	if (!current->mm)	/* kthread doing get_user_pages on an mm */
+		return;
+
 	global_faults++;
 
 	current_interval = global_faults - current->mm->faultstamp;
