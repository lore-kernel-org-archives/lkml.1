Return-Path: <linux-kernel-owner+w=401wt.eu-S934520AbYAaR1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbYAaR1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762369AbYAaR1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:27:35 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:41714 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763411AbYAaR1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:27:34 -0500
Message-ID: <47A204FD.70607@grupopie.com>
Date: Thu, 31 Jan 2008 17:27:25 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: managing kallsyms_addresses
References: <200801311148.18859.rgetz@blackfin.uclinux.org>
In-Reply-To: <200801311148.18859.rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> When the kernel needs to find out what symbol is at a specific address, it 
> uses kallsyms_lookup() This seems to work pretty well - almost.
> 
> The problem is today, we don't to remove the symbols from the init section 
> when the init section is freed. There is invalid data in kallsyms_addresses.
> [...]
> There would be two solutions:
>  - when freeing the init section, remove all the init labels from the 
> kallsyms_addresses, and resort/pack it.

This should be doable, but to be worth it, we would need to use 
different structures for the init symbols, that would be stored in 
__initdata.

Then, ideally we would have separate functions in the __init section to 
look up symbols in those structures that would only be called until we 
released the init sections.

On the plus side, this would avoid the "repacking" the kallsyms 
structures to remove the init labels.

>  - if the init section is unloaded, have is_kernel_inittext always return 0.

This is by far the simplest solution. I even STR a patch floating around 
to do this, by I can't seem to locate it now... :(

> I assume that similar things need to be handled for module init too, but I 
> have not run into that yet.

It seems that at least the last solution should be easy enough to 
implement there.

> Thoughts?

I think that the simplest solution (the second one) is probably the best 
for now.

One thing that did cross my mind though, is stuff like lockdep.

If we run a locking sequence that is called from init code, and later a 
different locking sequence is used when we already freed init data, how 
can the debug information show the names of the functions that generated 
the previous locking sequence?

It seems that the only "correct" approach would be to store a "before 
freeing init sections" flag together with the function pointer, and then 
have a kallsyms interface that could receive this flag to know where to 
look.

In that case, the first solution can not be used at all (because we need 
to keep the init symbols anyway) and the second solution could be simply 
implemented by having a default value for the flag that is the "current 
state" for that flag...

-- 
Paulo Marques - www.grupopie.com

"There cannot be a crisis today; my schedule is already full."
