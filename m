Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXDJM4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXDJM4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXDJM4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:56:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbXDJM4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:56:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200704091146.32346.rgetz@blackfin.uclinux.org> 
References: <200704091146.32346.rgetz@blackfin.uclinux.org>  <6d6a94c50704082001y5c13c865ic3d70217aba7d181@mail.gmail.com> <1176112223.17975.8.camel@roc-desktop> 
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: bryan.wu@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       waltje@uwalt.nl.mugnet.org, "Aubrey Li" <aubreylee@gmail.com>,
       netdev@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 10 Apr 2007 13:55:28 +0100
Message-ID: <9561.1176209728@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> David - I know you have been reworking the noMMU vma handling - is there a 
> solution to vm_insert_page?

The reason vm_insert_page() is being called, I imagine, is because
packet_mmap() has to insert mappings to an already existing buffer.  All it
does is munge the PTEs in that virtual region to point to the buffer.

As long as the buffer is completely contiguous (which I don't know for
certain), then this function can be trivially reduced in NOMMU-mode to
something that just returns the address of the requested part of the buffer.
No remapping would be required.

However...  If the buffer is *not* completely contiguous, then you can still
perform mmaps of it - but only where the desired part _is_ contiguous.
Alternatively, you can arrange for the buffer to be completely contiguous
upfront.

Looking at alloc_pg_vec() in af_packet.c, I will place my bets on the latter
case.  I don't know that this is a problem; it depends on how things work, and
that I don't know offhand.  If someone can give me a simple test program, I
would be able to evaluate it better.

David
