Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbYGBFAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbYGBFAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 01:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYGBFA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 01:00:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:52765 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYGBFA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 01:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V0Exh+IiC771yDOI0Nd/Vj/puiCNqlZRgRAbmzExtpa3wrmwvKL/rof8ZnhJ/CzmsU
         XzyGXYH74mtHe9m2IJnjQiN1iGt779Fw5Ys2MQv1CD+G5E9EP3zpqy+4KwIoGHb2Hja5
         6KsiOcT0ipLIXvMl3v4nICUZ+1RnXYvttnto8=
Message-ID: <28c262360807012200x27711a0fq280504b00096f7e6@mail.gmail.com>
Date: Wed, 2 Jul 2008 14:00:25 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [resend][PATCH -mm] split_lru: fix pagevec_move_tail() doesn't treat unevictable page
Cc: "Rik van Riel" <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080702122850.380B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701093840.07b48ced@bree.surriel.com>
	 <28c262360807011739w5668920buf7880de6ed30f912@mail.gmail.com>
	 <20080702122850.380B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 12:30 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi Kim-san,
>
>> Hi, Rik and Kosaki-san
>>
>> I want to know exact race situation for remaining git log.
>> As you know, git log is important for me who is newbie to understand source
>>
>> There are many possibility in this race problem.
>>
>> Did you use hugepage in this test ?
>> I think that If you used hugepage, it seems to happen following race.
>
> I don't use hugepage. but use SYSV-shmem.
> so following scenario is very reasonable.

It is not reasonable if you don't use hugepage.
That's because file's address_space is still unevictable.
Am I missing your point?

I think following case is more reasonable rather than it,
Please, Let you review this scenario.
---

CPU1							CPU2

shrink_[in]active_list
cull_unevictable_page
putback_lru_page
TestClearPageUnevicetable
						rotate_reclaimable_page
						!PageUnevictable(page)
add_page_to_unevictable_list
						pagevec_move_tail



> OK.
> I resend my patch with following description.
>
>
>>
>> --------------
>>
>> CPU1                                                           CPU2
>>
>> shm_unlock
>> scan_mapping_unevictable_pages
>> check_move_unevictable_page
>> ClearPageUnevictable                                 rotate_reclaimable_page
>>
>> PageUnevictable(page) return 0
>> SetPageUnevictable
>> list_move(LRU_UNEVICTABLE)
>>
>> local_irq_save
>>
>> pagevec_move_tail
>>
>> Do you think it is possible ?
>
>
>



-- 
Kinds regards,
MinChan Kim
