Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYEZVnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYEZVnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbYEZVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:42:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330AbYEZVm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:42:56 -0400
Date: Mon, 26 May 2008 14:42:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesper Krogh <jesper@krogh.cc>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.26-rc4
In-Reply-To: <483B2A9B.4050007@krogh.cc>
Message-ID: <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <483B2A9B.4050007@krogh.cc>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 May 2008, Jesper Krogh wrote:
> 
> I did get this one (which I didn't on 2.6.25.2)
> 
> [42949399.810959] ck804xrom ck804xrom_init_one(): Unable to register resource
> 0x0000000000000000-0x00000000ffffffff - kernel bug?

Something is trying to register a 4GB resource. That sounds unlikely 
(possible on a 64-bit PCI setup, but I think it's more likely to be some 
overflow of 0 in "unsigned int").

In fact, this seems to be due to some driver bug. It looks like we have

	window->size = 0xffffffffUL - window->phys + 1UL;

and in order for window->size to be 0x100000000, that means that 
window->phys has to be 0. Which looks impossible, or at least like 
ent->driver_data is neither DEV_CK804 nor DEV_MCP55. Very odd.

The warning:

> [42949399.979924] WARNING: at arch/x86/mm/ioremap.c:159 __ioremap_caller+0x299/0x330()

is then just a result of the driver blindly continuing and trying to 
"ioremap()" the resource even though it's bogus and the resource 
allocation failed.

In other words, that driver init routine is really bad about error 
handling. Carl-Daniel? David?

		Linus
