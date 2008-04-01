Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYDAMr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYDAMr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbYDAMrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:47:49 -0400
Received: from smtp.nokia.com ([192.100.105.134]:54021 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbYDAMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:47:48 -0400
Message-ID: <47F22DD3.4060003@yandex.ru>
Date: Tue, 01 Apr 2008 15:42:59 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 20/26] UBIFS: add VFS operations
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>         <1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010508k3099b2bagf2f1c0d2747a983@mail.gmail.com>
In-Reply-To: <84144f020804010508k3099b2bagf2f1c0d2747a983@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 12:46:52.0359 (UTC) FILETIME=[758ECD70:01C893F6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Artem,
> 
> On Thu, Mar 27, 2008 at 5:55 PM, Artem Bityutskiy
> <Artem.Bityutskiy@nokia.com> wrote:
>>  +static int ubifs_set_page_dirty(struct page *page)
>>  +{
>>  +       /*
>>  +        * An attempt to dirty a page without budgeting for it - should not
>>  +        * happen.
>>  +        */
>>  +       ubifs_assert(0);
>>  +       return __set_page_dirty_nobuffers(page);
>>  +}

In UBIFS pages must never become dirty without asking UBIFS if this is allowed or not.
This is needed because of budgeting - before making any page dirty we have to make
sure there is enough space to write it back. This is not usually an issue for
traditional FSes, because pages may be changed in-place. In UBIFS we cannot change
stuff in-place, so we have to be very careful when marking things dirty. This is why
we have the budgeting sub-system. The white-paper tells more about this.

Anyway, the requirement is that all the places where a page may become dirty
should be in UBIFS and the corresponding operations have to be budgeted for.

If this function is called, this means that someone made a page dirty without
budgeting for this. Which in turn may mean that there will be no space when
the page is written back. So basically, this implementation is just a guarding
check.

>>  +static int ubifs_releasepage(struct page *page, gfp_t unused_gfp_flags)
>>  +{
>>  +       /*
>>  +        * An attempt to release a dirty page without budgeting for it - should
>>  +        * not happen.
>>  +        */
>>  +       ubifs_assert(PageLocked(page));
>>  +       if (PageWriteback(page))
>>  +               return 0;
>>  +       ubifs_assert(PagePrivate(page));
>>  +       ubifs_assert(0);
>>  +       ClearPagePrivate(page);
>>  +       ClearPageChecked(page);
>>  +       return 1;
>>  +}

Yeah, this is also a guarding thing. When a dirty page is released
the budget which was allocated for it has to be freed. If this function
is called, then the budget was not freed, which must never happen.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
