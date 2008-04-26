Return-Path: <linux-kernel-owner+w=401wt.eu-S1761832AbYDZTxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761832AbYDZTxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbYDZTw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:52:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846AbYDZTw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:52:56 -0400
Date: Sat, 26 Apr 2008 12:52:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, bootmem/sparsemem
In-Reply-To: <20080426194143.GA8366@elte.hu>
Message-ID: <alpine.LFD.1.10.0804261247020.2813@woody.linux-foundation.org>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426194143.GA8366@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Ingo Molnar wrote:
>  #ifdef CONFIG_NUMA
> +	nid = phys_to_nid(phys);
> +	next_nid = phys_to_nid(phys + len - 1);
> +	if (nid == next_nid)
>  	reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
> -#else
> -	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
> +	else
>  #endif
> +	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
> +

Noticed this when just trying to read the code to see if it looks sensible 
(without looking at any real details).

Code like this is *not* acceptable.

We do proper indentations. Improperly indented code is buggy. It doesn't 
matter if the compiler might generate the same code with or without 
indentation, it's still totally unacceptable.

Having preprocessor conditionals that mix things up is not an excuse, and 
it might be an argument for not doing the conditional that way (ie maybe 
just make sure that when NUMA is not on, nid/next_nid will always be 
different, and in a way that the compiler can perhaps see statically that 
they are different - so that you can have the conditional there even with 
NUMA off, but the compiler will just fold it away?).

		Linus
