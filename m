Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbXHWJdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbXHWJdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbXHWJdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:33:16 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:43506 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759015AbXHWJdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:33:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=PPdlAJmiJaI8OenunQyM5e7tm7yUQ1iZKXl7Z6hFGWdsSz2Kh9LXLCsGz0Rn/5WR;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7e569$023fa240$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "\"Ingo Molnar\"" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       <linux-mm@kvack.org>
Subject: [RFC]  : mm : / Patch / Suggestion : Add 1 order or agressiveness to wakeup_kswapd() : 1 line / 1 arg change
Date: Thu, 23 Aug 2007 02:35:46 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79e0251c42b1b2cc4a4083ae4884e8190d350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.93.34
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Group,

    On the infrequent condition of failing to recieve a page from the
    freelists, one of the things you do is call wakeup_kswapd()(exception of
    NUMA or GFP_THISNODE).

    Asuming that wakeup_kswapd() does what we want, this call is
    such a high overhead call that you want to make sure that the
    call is infrequent.
    My initial guess is that it REALLY needs to re-populate the
    freelists just before they/it is used up. However, the simple change
    is being suggested NOW.

    Assuming that on avg that the order value will be used, you should
    increase the order to cover two allocs of that same level of order,
    thus the +1. If on the chance that later page_alloc() calls need
    fewer pages (smaller order) then the extra pages will be available
    for more page_allocs(). If later calls have larger orders, hopefully
    the latency between the calls is great enough that other parts of
    the system will respond to the low memory / on the freelist(s).

    Line 1265 within function __alloc_pages(), mm/page_alloc.c

wakeup_kswapd(*z, order);
      to
wakeup_kswapd(*z, order + 1);

In addition, isn't a call needed to determine that the
freelist(s) are almost empty, but are still returning a page?

Thus,  a lightweight call be done after a NORMAL
 page is recieved at line 1250 if (page) from the
 get_page_from_freelist()?  Or it could be embedded within the
 function call path that get_page_from_freelist() uses?

We could call  wakeup_kswapd()
 or equiv pro-actively?  The idea is that the call should check for
 2x of LOW_MEMORY equiv of the freelists and to re-populate them.
Then, HOPEFULLY the 2nd time calling get_page_from_freelist() would
then be obsolete.

When I come up with it, I will suggest it to the group.

Mitchell Erblich
FYI: My kernel is different enough that I can not validate this change
for the 2.6.2x git.

