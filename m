Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbZCAXaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbZCAXaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZCAX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:29:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZCAX3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:29:55 -0500
Message-ID: <49AB1A5C.6040300@zytor.com>
Date: Sun, 01 Mar 2009 15:29:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86: put initial_pg_tables into bss -v2
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org> <49A8F319.3030802@goop.org> <49A9E392.6090004@kernel.org> <49AA47D2.4020804@kernel.org> <49AA5356.3050602@zytor.com> <49AACEB3.5050206@kernel.org>
In-Reply-To: <49AACEB3.5050206@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
>> No, this is garbage.  If you're insisting on getting rid of the brk-like
>> allocation patterns,> YH
  then you have to get an alternative dynamic
>> allocator available to the pre-paging code.  Now, there is no reason we
>> couldn't execute C code before enabling paging, although the code would
>> either have to be PIC or linked at the physical address.
> 
> you can use find_e820_area()/reserve_early() pair to find right position for that.
> 

This stuff is currently done before paging is enabled, and existing C 
code can't be run as-is.  There are three ways to deal with that:

a) compile some of the code with -fPIC/-fPIE.
b) link some code twice with different offsets.
c) play really ugly games with segments (thus making the virtualization
    guys unhappy.)

Pretty much, these options all suck.  Another option, of course, is to 
generate a fixed amount of page tables just to get us into the C 
environment, generate a new set, *and reclaim the old ones*.  That way 
we're not wasting memory if we're on a small-RAM machine.

It's still really ugly, though.  A much easier and cleaner way would 
seem to be to calculate a far limit on the brk and then marking it as a 
formal (non-alloc) section in the linker script and vmlinux file.  That 
way anything that examines the vmlinux file will see it as an exclusion 
section.  We can (and should) even verify that we don't overflow the brk 
and panic if we do.

	-hpa
