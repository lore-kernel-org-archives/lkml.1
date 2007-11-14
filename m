Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbXKNC4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbXKNC4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXKNC4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:56:02 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbXKNC4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:56:00 -0500
Date: Tue, 13 Nov 2007 18:55:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] - [12/15] - remove defconfig ptr comparisons to 0 -
 include/asm-x86
In-Reply-To: <1195005932.5163.98.camel@localhost>
Message-ID: <alpine.LFD.0.9999.0711131844240.2786@woody.linux-foundation.org>
References: <1195005932.5163.98.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Nov 2007, Joe Perches wrote:
>
> Remove defconfig ptr comparison to 0
> 
> The memcpy from memory location 0 sure looks odd.

Btw, this is also very compiler-bug-prone.

And sadly, the cast to "(void *)" doesn't help. This could easily be a 
case where a compiler decides to play lawyer games, knowing that "NULL 
pointers cannot be dereferenced", deciding that it's all totally undefined 
behavior, and then just "optimizing" it all away.

> -	memcpy(&header, 0, sizeof(struct acpi_table_header));
> +	memcpy(&header, (void *)0, sizeof(struct acpi_table_header));

So to be safe from bogus compilers who care more about standards than the 
obvious intention of the programmer, it might actually be better in the 
long run to do something like

	static inline void *create_pointer(unsigned long val)
	{
		void *result;
		asm("":"=r" (result):"0" (val));
		return result;
	}

and then use "create_pointer(0)" here.

On that note: I'm not going to apply this series, because it's simply not 
really appropriate any more. But when re-sending for 2.6.25-rc1, can you 
make the subject lines have a slightly higher signal-to-noise ratio, ie 
dropt he unnecessary stuff that doesn't add any value as a commit message 
(eg "defconfig"? Is it really relevant?), and make it properly formatted?

My scripts by default remove the stuff in between []'s, so the end result 
for the commit message header from this subject line would be

	"- remove defconfig ptr comparisons to 0 - include/asm-x86"

which is strange and not very useful. It would read better as

 Subject: [PATCH 1/15] include/asm-x86: remove ptr comparisons to 0

which would create a commit message header that is more readable.

		Linus
