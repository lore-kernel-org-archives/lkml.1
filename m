Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYKTJpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYKTJpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYKTJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:44:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:31581 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYKTJot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:44:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i9PYd3m699VL1slqLJXtNXq+HRWZq34ORsLGSUJ08dc1aBAJFR/bGiALHN+ZV9OR7U
         CJ3YTKLCJEsYyMSA06sAnWfpfNE/bjZkZMer4mGjUDNKUpI/f6P/5yWpd05F0M138PcI
         CZyCgg/wQG5A2rlV30r3CGQXtIIAj1eIgP7Kc=
Message-ID: <5e93dcec0811200144m1c6837bn28392e2d5f4277bd@mail.gmail.com>
Date: Thu, 20 Nov 2008 18:44:45 +0900
From: "Ryota OZAKI" <ozaki.ryota@gmail.com>
To: "Izik Eidus" <ieidus@redhat.com>
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v2
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, dlaor@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, corbet@lwn.net
In-Reply-To: <49252A54.6010602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1226888432-3662-1-git-send-email-ieidus@redhat.com>
	 <5e93dcec0811192344l3813867egcc6b5a3c666142b9@mail.gmail.com>
	 <492527DF.1080602@redhat.com> <49252A54.6010602@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mAK9jDdq017019

2008/11/20 Izik Eidus <ieidus@redhat.com>:> ×¦×™×˜×•×˜ Izik Eidus:>>>> ×¦×™×˜×•×˜ Ryota OZAKI:>>>>>> Hi Izik,>>>>>> I've tried your patch set, but ksm doesn't work in my machine.>>>>>> I compiled linux patched with the four patches and configured with KSM>>> and KVM enabled. After boot with the linux, I run two VMs running linux>>> using QEMU with a patch in your mail and started KSM scanner with your>>> script, then the host linux caused panic with the following oops.>>>>>>> Yes you are right, we are missing pte_unmap(pte); in get_pte()!>> that will effect just 32bits with highmem so this why you see it>> thanks for the reporting, i will fix it for v3>>>> below patch should fix it (i cant test it now, will test it for v3)>>>> can you report if it fix your problem? thanks>>> Thinking about what i just did, it is wrong,> this patch is the right one (still wasnt tested), but if you are going to> apply something then use this one.
Great! Applied the 2nd patch, ksm works with both HIGHMEM enabled and disabled.
Thanks for your quick response,  ozaki-r
>> thanks>> diff --git a/mm/ksm.c b/mm/ksm.c> index 707be52..c842c29 100644> --- a/mm/ksm.c> +++ b/mm/ksm.c> @@ -569,14 +569,16 @@ out:>  static int is_present_pte(struct mm_struct *mm, unsigned long addr)>  {>        pte_t *ptep;> +       int r;>>        ptep = get_pte(mm, addr);>        if (!ptep)>                return 0;>> -       if (pte_present(*ptep))> -               return 1;> -       return 0;> +       r = pte_present(*ptep);> +       pte_unmap(ptep);> +> +       return r;>  }>>  #define PAGEHASH_LEN 128> @@ -669,6 +671,7 @@ static int try_to_merge_one_page(struct mm_struct *mm,>        if (!orig_ptep)>                goto out_unlock;>        orig_pte = *orig_ptep;> +       pte_unmap(orig_ptep);>        if (!pte_present(orig_pte))>                goto out_unlock;>        if (page_to_pfn(oldpage) != pte_pfn(orig_pte))>>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
