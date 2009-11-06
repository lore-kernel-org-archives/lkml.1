Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbZKFWyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbZKFWyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbZKFWyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:54:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070AbZKFWy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:54:29 -0500
Message-ID: <4AF4A924.5080609@zytor.com>
Date: Fri, 06 Nov 2009 14:54:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: castet.matthieu@free.fr
CC: linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
References: <1257512389.4af41dc504e1b@imp.free.fr>
In-Reply-To: <1257512389.4af41dc504e1b@imp.free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2009 04:59 AM, castet.matthieu@free.fr wrote:
> Hi,
> 
> I am wondering why we can't set the KERNEL_DS data segment to not contain the
> first page, ie changing it from R/W flat model to R/W expand down from
> 0xffffffff to 4096.
> 
> The modification seems simple : change GDT_ENTRY_KERNEL_DS [1], and some
> modification for syscall entry point that doesn't support segment (sysenter).
> 
> The drawback of this it that the kernel can't access anymore data in the first
> segment. Is it needed for application like wine or dosemu ?
> 

Yes, it is.  On 32 bits it is possible to switch around segments and do
this (in which case you want it to only cover the actual kernel area,
and use USER_DS for all user-space references.)  This also lets you drop
nearly all pointer-range checks, since they are now redundant.  However,
there is a cost -- it pretty much requires a segment register for
USER_DS (this used to be fs once upon a time, hence set_fs) and probably
would break Xen and possibly other virtualization solutions.

> PS : why x86_64 segment got access bit set and x86_32 doesn't ?

It is trivially faster to start out with the access bit set -- the
hardware will set the accessed bit anyway.

	-hpa
