Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbYCFSZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbYCFSZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYCFSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:25:10 -0500
Received: from gw.goop.org ([64.81.55.164]:38964 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbYCFSZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:25:08 -0500
Message-ID: <47D035AF.8080306@goop.org>
Date: Thu, 06 Mar 2008 10:19:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hugh Dickins <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu> <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu> <Pine.LNX.4.64.0803051407310.22243@blonde.site> <47CECEE9.3000801@goop.org> <Pine.LNX.4.64.0803051721200.13410@blonde.site> <47CEF20D.5070608@goop.org> <20080306125215.GD20173@elte.hu>
In-Reply-To: <20080306125215.GD20173@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> actually, i think the correct approach is to remove the TLB flushing and 
> perhaps to check that the old pte is not present. Do we ever _change_ 
> mappings via __set_fixmap()? I think we only ever install them.
>   

Yes, I think that's the case.  clear_fixmap() exists for clearing out an 
existing mapping, but its only used to clear out the WP test mapping and 
in early_iounmap (if called late).  I couldn't see any instances of 
replacing a mapping.

> but if we ever change them somewhere then the correct approach is to do 
> a flush_tlb_all(). It's not just about preemption but about the fact 
> that we modified the kernel address space and we must propagate that to 
> all CPUs.
>   

Yes, I was wondering about that.  If __set_fixmap is only used at boot 
time, then a global flush isn't necessary, but if its deemed a 
general-purpose API in a normal running kernel, it needs to deal with 
cross-cpu flushes.

64-bit set_fixmap is __init only, and I'd be OK with that.  The only 
non-__init use in the 32-bit kernel is the compat vdso mapping, and that 
could easily be done by other means (though it would effectively become 
an opencoded set_fixmap, so perhaps that's not a good idea...).

> the vmalloc() backtrace you sent - how did set_pte_pfn() get into that 
> codepath - vmalloc shouldnt be using __set_fixmap().
>   

No, that's set_pte_at(), which is the real issue in both cases.  
__set_fixmap calls both set_pte_at and flush_tlb_one, which is why it 
gets two backtrackes.

    J
