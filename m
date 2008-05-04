Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYEDRfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYEDRfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYEDRf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:35:26 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:13430 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYEDRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:35:25 -0400
Date: Sun, 04 May 2008 11:35:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: undefined reference to __udivdi3 (gcc-4.3)
In-reply-to: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <481DF3D8.3010108@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> Hi,
> 
> while trying to compile current -git or 2.6.25.1 with gcc (Debian 
> 4.3.0-4) 4.3.1 20080501 (prerelease), the following error occurs during 
> linking:
> 
> arch/x86/xen/built-in.o: In function `xen_timer_interrupt':
> time.c:(.text+0x2992): undefined reference to `__udivdi3'
> time.c:(.text+0x2a13): undefined reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> Searching the archives brought up old issues with gcc-3.4 [0] and not so 
> old posting from 01/2008 [1], but I could not find a solution (or a 
> consense about (not to) include libgcc.a).
> 
> Full make.log and .config: http://nerdbynature.de/bits/2.6.25.1/xen/
> 
> Hints welcome :)
> 
> Thanks,
> Christian.
> 
> [0] http://gcc.gnu.org/ml/gcc/2004-01/msg01975.html
> [1] http://www.nabble.com/gcc-4.3:-Kernel-build-fails-td15135607.html

I assume it's one or both of these loops in arch/x86/xen/time.c 
do_stolen_accounting() that are being optimized into a divide which 
generates a libgcc call:

	while (stolen >= NS_PER_TICK) {
		ticks++;
		stolen -= NS_PER_TICK;
	}

or

	while (blocked >= NS_PER_TICK) {
		ticks++;
		blocked -= NS_PER_TICK;
	}

I seem to recall in one previous case we added some dummy assembly code 
to stop gcc from doing this. Not sure if that is a sustainable fix, though..
