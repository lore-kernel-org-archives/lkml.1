Return-Path: <linux-kernel-owner+w=401wt.eu-S965685AbXCPRQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965685AbXCPRQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965766AbXCPRQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:16:43 -0400
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:51443 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965757AbXCPRQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:16:42 -0400
Message-ID: <45FAD0F7.5090506@grupopie.com>
Date: Fri, 16 Mar 2007 17:16:39 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, rusty@rustcorp.com.au
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
References: <20070316114458.GB6817@localhost.sw.ru> <20070316115154.GC30195@elte.hu> <45FAC2CA.80009@grupopie.com> <20070316161853.GD9413@elte.hu>
In-Reply-To: <20070316161853.GD9413@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Paulo Marques <pmarques@grupopie.com> wrote:
> 
>>> looking at the problem from another angle: wouldnt this be something 
>>> that would benefit from freeze_processes()/unfreeze_processes(), and 
>>> hence no locking would be required?
>> I also considered this, but it seemed a little too "blunt" to stop 
>> everything (including completely unrelated processes and kernel 
>> threads) just to remove a module.
> 
> 'just to remove a module' is very, very rare, on the timescale of most 
> kernel ops. Almost no distro does it. Furthermore, because we want to do 
> CPU-hotplug that way, we really want to make 
> freeze_processes()/unfreeze_processes() 'instantaneous' to the human - 
> and it is that already. (if it isnt in some case we can make it so)

Ok. I started to look at this approach and realized that module.c 
already does this:

> ....
> static int __unlink_module(void *_mod)
> {
> 	struct module *mod = _mod;
> 	list_del(&mod->list);
> 	return 0;
> }
> 
> /* Free a module, remove from lists, etc (must hold module mutex). */
> static void free_module(struct module *mod)
> {
> 	/* Delete from various lists */
> 	stop_machine_run(__unlink_module, mod, NR_CPUS);
> ....

However stop_machine_run doesn't seem like the right thing to do, 
because users of the "modules" list don't seem to do anything to prevent 
preemption. Am I missing something?

Does freeze_processes() / unfreeze_processes() solve this by only 
freezing processes that have voluntarily scheduled (opposed to just 
being preempted)?

-- 
Paulo Marques - www.grupopie.com

"The Computer made me do it."
