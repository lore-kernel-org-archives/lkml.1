Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbZDOLjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbZDOLjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbZDOLjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:39:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:59523 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862AbZDOLjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=stC+FrZ0iHwmZa1wZhTKqDOS9IP+FYTkBwnUFia9aGBoH5Wl/pSqvO3yzyqHkW4H+D
         SrR/goAFSBKcsgvWM11rvU/y8y5evxCVdAlySMn9j5mMW6msFtWLftWQI+Wtgo1gY9/p
         93wZwjRQzz0WOAwGeLEkN/e07lTFGvvm2TOHU=
MIME-Version: 1.0
In-Reply-To: <20090415104615.GG9809@random.random>
References: <20090414143252.GE28265@random.random>
	 <200904150042.15653.nickpiggin@yahoo.com.au>
	 <20090415165431.AC4C.A69D9226@jp.fujitsu.com>
	 <20090415104615.GG9809@random.random>
Date: Wed, 15 Apr 2009 20:39:04 +0900
X-Google-Sender-Auth: fa5531849fcc2cbd
Message-ID: <2f11576a0904150439k6e828307ja97b6729650bcb94@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     if (!migration) {
>> +             /* re-check */
>> +             if (PageSwapCache(page) &&
>> +                 page_count(page) != page_mapcount(page) + 2) {
>> +                     /* We lose race against get_user_pages_fast() */
>> +                     set_pte_at(mm, address, pte, pteval);
>> +                     ret = SWAP_FAIL;
>> +                     goto out_unmap;
>> +             }
>> +     }
>> +     mmu_notifier_invalidate_page(vma->vm_mm, address);
>
> With regard to mmu notifier, this is the opposite of the right
> ordering. One mmu_notifier_invalidate_page must run _before_ the first
> check. The ptep_clear_flush_notify will then stay and there's no need
> of a further mmu_notifier_invalidate_page after the second check.

OK. but I have one question.

Can we assume mmu_notifier is only used by kvm now?
if not, we need to make new notifier.
