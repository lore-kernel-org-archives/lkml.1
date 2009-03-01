Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZCAJX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZCAJX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZCAJVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:21:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34045 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbZCAJVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:21:21 -0500
Message-ID: <49AA5356.3050602@zytor.com>
Date: Sun, 01 Mar 2009 01:20:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86: put initial_pg_tables into bss -v2
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org> <49A8F319.3030802@goop.org> <49A9E392.6090004@kernel.org> <49AA47D2.4020804@kernel.org>
In-Reply-To: <49AA47D2.4020804@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: cleanup
> 
> Don't use ram after _end blindly for pagetables.
> put those pg table into bss
> 
> also remove init_pg_tables_start/end tricks all around
> 
> v2: keep initial page table up to 512M only.
> 

I really, REALLY, don't like this.  This is going right back to the 
situation which we had before the dynamically generated page tables.  We 
now have yet another hardcoded limit, and big chunk of wasted memory in 
case we don't need to allocate it all.

   * Modulo rounding, each megabyte assigned here requires a kilobyte of
   * memory, which is currently unreclaimed.

You're potentially throwing away half a megabyte, which is a major deal 
on a small embedded system!

No, this is garbage.  If you're insisting on getting rid of the brk-like 
allocation patterns, then you have to get an alternative dynamic 
allocator available to the pre-paging code.  Now, there is no reason we 
couldn't execute C code before enabling paging, although the code would 
either have to be PIC or linked at the physical address.

	-hpa
