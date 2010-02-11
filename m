Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0BKIpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 03:45:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:55799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab0BKIpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 03:45:34 -0500
Message-ID: <4B73C535.7020405@kernel.org>
Date: Thu, 11 Feb 2010 17:52:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net,
       Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 2.6.33-rc6] idr: revert misallocation bug fix
References: <4B6A8C01.5020403@kernel.org> <1265317104.11442.29.camel@nimitz>
In-Reply-To: <1265317104.11442.29.camel@nimitz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 08:45:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/05/2010 05:58 AM, Dave Hansen wrote:
> Bah.  I just ran into and bisected the X startup problem. :)
> 
> Let me know when you have a proper fix.  I can test on my machine for
> you.

Can you please test the following against the current mainline?

Thanks.

diff --git a/lib/idr.c b/lib/idr.c
index 1cac726..0dc7822 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -156,10 +156,12 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (!(p = pa[l])) {
+			if (id >= 1 << (idp->layers * IDR_BITS)) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
+			p = pa[l];
+			BUG_ON(!p);
 
 			/* If we need to go up one layer, continue the
 			 * loop; otherwise, restart from the top.


-- 
tejun
