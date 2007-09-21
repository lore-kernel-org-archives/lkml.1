Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbXIUTPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbXIUTPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXIUTPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:15:01 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:56919 "EHLO
	outbound4-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbXIUTPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:15:00 -0400
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 209.50.91.134;Service: EHS
Message-ID: <46F4182C.9050202@amd.com>
Date: Fri, 21 Sep 2007 15:14:52 -0400
From: Slava Abramov <slava.abramov@amd.com>
Reply-To: slava.abramov@amd.com
Organization: Advanced Micro Devices
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ptep_test_and_clear_young() i386 vs. x86_64 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2007 19:14:53.0265 (UTC) FILETIME=[B0556410:01C7FC83]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All!

Is there any special reason why ptep_test_and_clear_young()
implementation for x86_64 does not call pte_update()?

Compare the following:

include/asm-x86_64/pgtable.h:

static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, 
unsigned long addr, pte_t *ptep)
{
        if (!pte_young(*ptep))
               return 0;
        return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte);

}

include/asm-i386/pgtable.h:

#define ptep_test_and_clear_young(vma, addr, ptep) ({                   \
        int __ret = 0;                                                  \
        if (pte_young(*(ptep)))                                         \
                __ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,          \
                                                &(ptep)->pte_low);       \
        if (__ret)                                                      \
                pte_update((vma)->vm_mm, addr, ptep);                   
     \
        __ret;                                                          \

})


Slava

