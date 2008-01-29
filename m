Return-Path: <linux-kernel-owner+w=401wt.eu-S934427AbYA2Tn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbYA2Tn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934365AbYA2TnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:43:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34130 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204AbYA2TnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:43:04 -0500
Date: Tue, 29 Jan 2008 20:43:01 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mike Frysinger <vapier@gentoo.org>, LKML <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] linux/types.h: always export 64bit aligned defines
In-Reply-To: <20080127213319.01026b19.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801292030190.14907@fbirervta.pbzchgretzou.qr>
References: <200801260423.21860.vapier@gentoo.org>
 <20080127213319.01026b19.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27 2008 21:33, Andrew Morton wrote:
>On Sat, 26 Jan 2008 04:23:21 -0500 Mike Frysinger <vapier@gentoo.org> wrote:
>
>> Some kernel headers exported to userspace rely on these 64bit
>> aligned defines. However, they are hidden behind
>> __KERNEL_STRICT_NAMES at the moment which means most of the time,
>> they're never actually available.

Wrong way. They are inside #ifndef __KERNEL_STRICT_NAMES, so
they _are_ available to userspace.

>> These these defines dont
>> actually conflict with normal userspace / C library types, there's
>> no reason to hide them behind the __KERNEL_STRICT_NAMES define.
>
>Maybe we shouldn't be using these helper macros in
>exported-to-userspace headers.  Do you know which headers are
>affected?  Did you consider jsut expanding the macros in situ for
>thse cases?

grep aligned_u64 include/linux/netfilter{,ipv4,ipv6}/*.h

iptables uses that, but we can get rid of it if need be.
It just throws up 3 lines anyway, ...

>But I'd have thought that if we're going to do this, we should create a
>standard naming convention for types which the kernel exports to userspace.
>Say, kern_*.
>
>In which case the change becomes:
>
>#define kern_aligned_u64 unsigned long long __attribute__((aligned(8)))
>#define kern_aligned_be64 __be64 __attribute__((aligned(8)))
>#define kern_aligned_le64 __le64 __attribute__((aligned(8)))
>
>
>What thinkest thou?

... so could use __attribute__((aligned(8))) directly for exported
headers, like we currently do for pointers (since there is no
alignedptr_64 or so).

>If _that_ is all sane then we should do it all in a singe header file, say
>kern_types_for_userspace.h.  include/linux/types.h would then do:

<linux/utypes.h> maybe? (not_so_long_filenames_please.h.)

>#include <linux/kern_types_for_userspace.h>
>
>#ifdef __KERNEL__
>#define aligned_u64 kern_aligned_u64
>etc...
>
>(all approximate, you-get-what-I-mean)
>
>Duno if it'd be worth the effort, but it is The Right Thing To Do.
