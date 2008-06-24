Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYFXHkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYFXHkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYFXHkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:40:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:20883 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYFXHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xVxChArT66QBoMmSsKoW1Vw3HxmzL3gNUOZjs0hIp9WFpGN4TjKgeNttUHnOChF21x
         +eSDtVM3by6j4rjXZd9ek1HIrxMN0MJZ9ch70BtDqtGJr20LvWEYeqeIJkRA3XbOLorw
         pyyY7AhO9NzGSc87IKXqmehH5zcX3UtnSzOJg=
Message-ID: <19f34abd0806240040xebb1c0fy52133a729cf1a1aa@mail.gmail.com>
Date: Tue, 24 Jun 2008 09:40:37 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, "Adrian Bunk" <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Cc: "Mike Travis" <travis@sgi.com>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org, "Gautham R Shenoy" <ego@in.ibm.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>
In-Reply-To: <200806241136.52430.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622125633.GA8166@damson.getinternet.no>
	 <200806231326.11328.rusty@rustcorp.com.au> <485FD644.80208@sgi.com>
	 <200806241136.52430.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 3:36 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Vegard's analysis is flawed: just because cpu is offline, it still must be <
> nr_cpu_ids, which is based on possible cpus.  Unless something crazy is
> happening, but a quick grep doesn't reveal anyone manipulating nr_cpu_ids.

Hm, you are right and I was wrong. I'm sorry, it just seemed too
obvious to be any other way, and I made some assumptions about
nr_cpu_ids. (IIRC, nr_node_ids changes dynamically as nodes are
added/removed, so I assumed it was the same for CPUs.)

This doesn't change the fact that get_cpu_sysdev(cpu) returns NULL,
however. This variable, the per-cpu cpu_sys_device, is only ever
changed in two places, register_cpu() and unregister_cpu(); in
register_cpu(), it is set to

                per_cpu(cpu_sys_devices, num) = &cpu->sysdev;,

and in unregister_cpu(), it is set to

        per_cpu(cpu_sys_devices, logical_cpu) = NULL;.

So it seems *likely* that register_cpu() was never called (after the
previous unregister_cpu(), which we know happened successfully).

register_cpu() is called from arch_register_cpu(), which is called
from toplogy_init() and acpi_processor_hotadd_init(). Now, the
topology_init() call-chain is uninteresting, since it only happens at
boot. The question is whether acpi_processor_hotadd_init() will be
called if the arch-specific __cpu_up() fails...

But I am not able to follow that code.

Thanks for looking at this.


Vegard

PS: I'll withdraw the statement that this is probably a regression. It
seems more likely that nobody ever hit the "cpu failed to init" case
before.

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
