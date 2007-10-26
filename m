Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbXJZSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbXJZSiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbXJZSiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:38:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbXJZSiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:38:02 -0400
Message-ID: <47223402.1050402@zytor.com>
Date: Fri, 26 Oct 2007 11:37:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Joseph Parmelee <jparmele@wildbear.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Old version of lilo fails to boot 2.6.23
References: <Pine.LNX.4.64.0710151600090.15578@bruno> <20071025014746.96e5e776.akpm@linux-foundation.org> <47211070.4090502@zytor.com> <4721194F.1040202@zytor.com> <Pine.LNX.4.64.0710260131280.17830@bruno>
In-Reply-To: <Pine.LNX.4.64.0710260131280.17830@bruno>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Parmelee wrote:
> 
> This patch will work in my particular case, though it appears to violate 
> the rules about getting too close to the EBDA (SP=0xB000 on entry).
> 
> The boot loader is responsible for loading the kernel loader at a suitable
> location in low memory, but I don't understand why the boot loader 
> should be
> involved in setting the stack at all.  If we explicitly allocate the stack
> as part of the .data segment, why not just play it safe and in all cases
> fully set up the stack in header.S?  This insures that the stack pointer is
> not zero, is as low as possible to stay out of the EBDA, and that ss=ds;
> quite irrespective of what the boot loader does.
> 
> What am I missing?
> 

What you're missing is that "just loading into a suitable location in 
low memory" isn't a sufficient condition.  This is something that one 
finds out very quickly trying to do boot loader work.

Heap and stack control the amount of functionality that is available, 
and therefore the protocol allows them to be dynamic.

Anyway, the final version of the patch that I sent you privately uses 
this logic:

- If heap size is properly reported, use it.
- Otherwise, if %ss == %ds, then use the stack pointer as entered.
- Otherwise, use the minimum stack.

This seems like a fairly reasonable compromise, especially since 
anything even remotely modern will be handled by the first clause.

	-hpa



