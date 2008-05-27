Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbYE0Vfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbYE0Vfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758641AbYE0Vf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:35:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:45542 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbYE0VfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s5pvIPlmSpkWmeGNsrJW+W392EtWIwqyjwmfFkXdSQQ8Tl9sljkPF8YKKgVbiahjDpircqgHwTeBMRsm10JkCAOoUrUIYdpg3swYc35cJ7EaItZWNaC7k8KlmgC1LYDLTWqdtoVK4DxeSmNhl5ltmMRoRqXFadNdL7SgdQEeyS0=
Message-ID: <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
Date: Tue, 27 May 2008 14:35:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483C7BB0.6080901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805180118.57863.yhlu.kernel@gmail.com>
	 <200805211840.18619.yhlu.kernel@gmail.com>
	 <200805251000.10205.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>
	 <483C70F9.2030901@goop.org>
	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
	 <483C7BB0.6080901@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 2:22 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> Can you send out your boot log?
>>
>
> I've included it below.
>
>> I still can not figure out INIT_PG_TABLE and RAMDISK could overlap? or
>> only one byte? or the same page?
>>
>
> Perhaps my explanation in the patch description wasn't clear enough.
>
> When Xen builds the domain, it's responsible for layout of the kernel, the
> initrd and the initial pagetable (the kernel does not create its own
> pagetable like it does when booting directly on x86).
>
> The layout is (from low to high addresses):
>
>    kernel start ->+-------+
>                   |.text  |
>                   + - - - +
>                   |.data  |
>                   + - - - +
>                   |.bss   |
>             _end->+-------+
>                   :padding:
>                   +-------+<-ramdisk_image
>                   :       :
>                   |initrd |
>                   :       :
>                   +-------+<-ramdisk_end
>                   :padding:
>                   +-------+
>                   |pgtable|
> init_pg_tables_end->+-------+
>
>
> Therefore, when you call early_reserve(&end, init_pg_tables_end) to reserve
> the inital pagetable, you also implicitly reserve the whole ramdisk area.
>  Since your code currently reserves the ramdisk first, the reservation of
> the pagetable fails because it overlaps the ramdisk.
>
> My patch does two things:
>
>  1. reserve the initial pagetable first
>  2. skip reserving the ramdisk if it is within the pagetable range
>
> This makes sure that all the important memory is reserved from early in
> boot.
>
> There are two alternate fixes:
>
>  1. try to precisely reserve *just* the pagetable, rather than
>     assuming it starts at &_end.  I'm not sure there's currently a way
>     to do this, but it would be easy enough to add.  Or,
>  2. Make early reservation cope with overlapping ranges, and deal with
>     them appropriately.

thanks for the explanation...

method 1 need to be done.

BTW, XEN PV only support 32 bit?

YH
