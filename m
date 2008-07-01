Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYGAIwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYGAIwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYGAIwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:52:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbYGAIwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:52:34 -0400
Date: Tue, 1 Jul 2008 10:52:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080701085204.GA23289@elte.hu>
References: <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48696690.90907@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48696690.90907@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> -tip auto-testing found pagetable corruption (CPA self-test failure):
>>
>> [   32.956015] CPA self-test:
>> [   32.958822]  4k 2048 large 508 gb 0 x 2556[ffff880000000000-ffff88003fe00000] miss 0
>> [   32.964000] CPA ffff88001d54e000: bad pte 1d4000e3
>> [   32.968000] CPA ffff88001d54e000: unexpected level 2
>> [   32.972000] CPA ffff880022c5d000: bad pte 22c000e3
>> [   32.976000] CPA ffff880022c5d000: unexpected level 2
>> [   32.980000] CPA ffff8800200ce000: bad pte 200000e3
>> [   32.984000] CPA ffff8800200ce000: unexpected level 2
>> [   32.988000] CPA ffff8800210f0000: bad pte 210000e3
>>
>> config and full log can be found at:
>>
>>  http://redhat.com/~mingo/misc/config-Mon_Jun_30_11_11_51_CEST_2008.bad
>>  http://redhat.com/~mingo/misc/log-Mon_Jun_30_11_11_51_CEST_2008.bad
>>
>> i've pushed that tree out into tip/tmp.xen-64bit.Mon_Jun_30_11_11. The  
>> only new item in that tree over a well-tested base is x86/xen-64bit, so 
>> i've taken it out again.
>>   
>
> Phew.  OK, I've worked this out.  Short version is that's it's a false  
> alarm, and there was no real failure here.  Long version:
>
>    * I changed the code to create the physical mapping pagetables to
>      reuse any existing mapping rather than replace it.   Specifically,
>      reusing an pud pointed to by the pgd caused this symptom to appear.
>    * The specific PUD being reused is the one created statically in
>      head_64.S, which creates an initial 1GB mapping.
>    * That mapping doesn't have _PAGE_GLOBAL set on it, due to the
>      inconsistency between __PAGE_* and PAGE_*.
>    * The CPA test attempts to clear _PAGE_GLOBAL, and then checks to
>      see that the resulting range is 1) shattered into 4k pages, and 2)
>      has no _PAGE_GLOBAL.
>    * However, since it didn't have _PAGE_GLOBAL on that range to start
>      with, change_page_attr_clear() had nothing to do, and didn't
>      bother shattering the range,
>    * resulting in the reported messages
>
> The simple fix is to set _PAGE_GLOBAL in level2_ident_pgt.
>
> An additional fix to make CPA testing more robust by using some other  
> pagetable bit (one of the unused available-to-software ones).  This  
> would solve spurious CPA test warnings under Xen which uses _PAGE_GLOBAL  
> for its own purposes (ie, not under guest control).
>
> Also, we should revisit the use of _PAGE_GLOBAL in asm-x86/pgtable.h, 
> and use it consistently, and drop MAKE_GLOBAL.  The first time I 
> proposed it it caused breakages in the very early CPA code; with luck 
> that's all fixed now.
>
> Anyway, the simple fix below.  [...]

great - i've applied your fix and re-integrated x86/xen-64bit, it's 
under testing now. (no problems so far)

> [...] I'll put together RFC patches for the other suggestions.  I also 
> split the originating patch into tiny, tiny bisectable pieces.

cool! :)

	Ingo
