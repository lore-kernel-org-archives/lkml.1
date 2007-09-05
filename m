Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbXIEPUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbXIEPUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXIEPU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:20:27 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:49062 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXIEPU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:20:26 -0400
Message-ID: <46DEC92F.7050905@linux.vnet.ibm.com>
Date: Wed, 05 Sep 2007 16:20:15 +0100
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <26495.1189003060@turing-police.cc.vt.edu> <20070905081207.1d8a0e05.akpm@linux-foundation.org>
In-Reply-To: <20070905081207.1d8a0e05.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Wed, 05 Sep 2007 10:37:40 -0400 Valdis.Kletnieks@vt.edu wrote:
>> On Fri, 31 Aug 2007 21:58:22 PDT, Andrew Morton said:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
>> (Warning - if discussion of binary modules bothers you, hit delete now..)
> 
> It's legitimate.  That change was supposed to be a no-op.
> 
> Thanks for reporting.
> 
>> Dell Latitude D840, x86_64 kernel
>>
>> memory-controller-memory-accounting-v7.patch causes the NVidia graphics driver
>> to go into a soft-lockup:
> 
> (is it not a bit weird from a namin POV that we have
> mem_container_charge(page, mm) and mem_container_uncharge_page(page)?)
> 
> 
>> BUG: soft lockup - CPU#0 stuck for 11s! [X:2733]
>> CPU 0:
>> Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack nfnetlink ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables vmnet(P)(U) vmmon(U) sha256 aes fan container bay acpi_cpufreq nvram arc4 ecb pcmcia iwl3945 firmware_class yenta_socket nvidia(P)(U) mac80211 iTCO_wdt rsrc_nonstatic iTCO_vendor_support ohci1394 watchdog_core ieee1394 watchdog_dev pcmcia_core cfg80211 video thermal output button battery processor ac intel_agp rtc
> 
> Seems to me that there's a missing pte_unmap_lock() in insert_page().
> 
> Also, a hunk in do_anonymous_page() is indented one tabstop too far, which
> makes me suspect that patch(1) might have put it in the wrong place. 
> Balbir, can you please check that?
> 
> diff -puN mm/memory.c~memory-controller-memory-accounting-v7-fix mm/memory.c
> --- a/mm/memory.c~memory-controller-memory-accounting-v7-fix
> +++ a/mm/memory.c
> @@ -1135,7 +1135,7 @@ static int insert_page(struct mm_struct 
>  {
>  	int retval;
>  	pte_t *pte;
> -	spinlock_t *ptl;  
> +	spinlock_t *ptl;
> 
>  	retval = mem_container_charge(page, mm);
>  	if (retval)
> @@ -1160,6 +1160,7 @@ static int insert_page(struct mm_struct 
>  	set_pte_at(mm, addr, pte, mk_pte(page, prot));
> 
>  	retval = 0;
> +	pte_unmap_unlock(pte, ptl);
>  	return retval;

Wonderful! Thanks Andrew!

>  out_unlock:
>  	pte_unmap_unlock(pte, ptl);
> @@ -2184,8 +2185,8 @@ static int do_anonymous_page(struct mm_s
>  	if (!page)
>  		goto oom;
> 
> -		if (mem_container_charge(page, mm))
> -			goto oom_free_page;
> +	if (mem_container_charge(page, mm))
> +		goto oom_free_page;
> 
>  	entry = mk_pte(page, vma->vm_page_prot);
>  	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> _
> 

Yes, this fix looks right as well.

Thanks for catching them so quickly.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
