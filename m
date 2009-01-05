Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZAELsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZAELsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZAELsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:48:15 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:45242 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752537AbZAELsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:48:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sKXDIHrvm4yurQPM4oTuIMd2gReMwadpO/wQzjYS97+O0D5a6mo+zF+V0agFidHCH5p8DoKNc3ZirhHEerLyf8cdRmI13Ji4BGk72xXuFppLF0l4IotCVeISe6PpSKN8eH2W4b+YieU6Ro+9dFO0Ywr5QoIYLbNiS8O35ppXgn8=  ;
X-YMail-OSG: nkXquEIVM1mCnjFbP6MKSlcTsmdvqfSNL8HZii52oqf4XNt0tAfJSRzscZP42yEM7AzqX8RBVEV.1oc7V0FZQ.UVr0wYd9fd1zTYwoVlhVFND_npmMvb0YsTNooOn_4u0FOItqo6MZCc279RXsnY9_4ofgh0VoE3F43tshe9bmbFx9VPpHK2b4EzoDxrxU_PZauZphPuDl_HBYpYl_6wih46iEw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>, stable@kernel.org
Subject: Re: [PATCH] [5/5] Avoid theoretical vmalloc fault loop
Date: Mon, 5 Jan 2009 22:47:56 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org
References: <200901051236.281008835@firstfloor.org> <20090104233642.745CF3E6653@basil.firstfloor.org>
In-Reply-To: <20090104233642.745CF3E6653@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901052247.56509.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be a -stable patch too I think.

On Monday 05 January 2009 10:36:42 Andi Kleen wrote:
> Ajith Kumar noticed:
>
> I was going through the vmalloc fault handling for x86_64 and am unclear
> about the following lines in the vmalloc_fault() function.
>
> pgd = pgd_offset(current->mm ?: &init_mm, address);
> pgd_ref = pgd_offset_k(address);
>
> Here the intention is to get the pgd corresponding to the current
> process and sync it up with the pgd in init_mm(obtained from
> pgd_offset_k). However, for kernel threads current->mm is NULL and hence
> pgd = pgd_offset(init_mm, address) = pgd_ref which means the fault
> handler returns without setting the pgd entry in the MM structure in
> the context of which the kernel thread has faulted. This could lead to
> never-ending faults and busy looping of kernel threads like pdflush.
> So, shouldn't the pgd = pgd_offset(current->mm ?: &init_mm, address);
> be
> pgd = pgd_offset(current->active_mm ?: &init_mm, address);
>
> AK: We can use active_mm unconditionally because it should
> be always set. Do that.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  arch/x86/mm/fault.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.28-test/arch/x86/mm/fault.c
> ===================================================================
> --- linux-2.6.28-test.orig/arch/x86/mm/fault.c	2008-10-24
> 13:34:41.000000000 +0200 +++
> linux-2.6.28-test/arch/x86/mm/fault.c	2009-01-02 16:01:11.000000000 +0100
> @@ -533,7 +533,7 @@
>  	   happen within a race in page table update. In the later
>  	   case just flush. */
>
> -	pgd = pgd_offset(current->mm ?: &init_mm, address);
> +	pgd = pgd_offset(current->active_mm, address);
>  	pgd_ref = pgd_offset_k(address);
>  	if (pgd_none(*pgd_ref))
>  		return -1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


