Return-Path: <linux-kernel-owner+w=401wt.eu-S1422964AbXCOQyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422964AbXCOQyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422963AbXCOQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:54:09 -0400
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:53307 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1422964AbXCOQyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:54:07 -0400
Message-ID: <45F97A27.4030002@grupopie.com>
Date: Thu, 15 Mar 2007 16:53:59 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       mingo@elte.hu, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] Fix some kallsyms_lookup() vs rmmod races
References: <20070315161442.GA6812@localhost.sw.ru>
In-Reply-To: <20070315161442.GA6812@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> [cc'ing folks whose proc files are affected]
> 
> kallsyms_lookup() can call module_address_lookup() which iterates over
> modules list without module_mutex taken. Comment at the top of
> module_address_lookup() says it's for oops resolution so races are
> irrelevant, but in some cases it's reachable from regular code:

So maybe we should just add a new parameter to "kallsyms_lookup" to 
inform it if it is safe to take a mutex or not.

Spreading module_mutex everywhere doesn't seem like the right interface 
for several reasons:

  - new users of "kallsyms_lookup" might not be aware that they should 
take module_mutex if it is safe

  - many times we will be taking module_mutex even when we are fetching 
a kernel symbol that shouldn't require the mutex at all

  - it just creates new dependencies (hint: this patch shouldn't even 
compile with current git since module_mutex is not declared in module.h, 
not to mention compile when CONFIG_MODULES not set)

IMHO we should not expose module_mutex outside of module.c. That is just 
wrong from an encapsulation point of view.

-- 
Paulo Marques - www.grupopie.com

"667: The neighbor of the beast."

