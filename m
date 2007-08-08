Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbXHHV5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbXHHV5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXHHV5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:57:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50662 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbXHHV5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:57:44 -0400
Date: Wed, 8 Aug 2007 23:57:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
In-Reply-To: <1186608977.3073.30.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708082345320.10387@fbirervta.pbzchgretzou.qr>
References: <tI4NY5SL.1186153543.0764100.khali@localhost> 
 <1186179369.13852.36.camel@localhost>  <20070807131949.fa060048.akpm@linux-foundation.org>
  <20070808220226.1dc03a67@hyperion.delvare>  <1186605086.11897.67.camel@localhost>
  <Pine.LNX.4.64.0708082237210.10387@fbirervta.pbzchgretzou.qr>
 <1186608977.3073.30.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 8 2007 14:36, Joe Perches wrote:
>On Wed, 2007-08-08 at 22:39 +0200, Jan Engelhardt wrote:
>> I fail to see what problem these are trying to fix. 
>
>Any code that does the equivalent of printk(KERN_foo "\n message");
>
>egrep -r "printk[[:space:]]*\([[:space:]]*KERN.*\\\n[A-JL-Za-jl-z[:space:]" --include=*.[ch] *
>
>At least 61 instances right now.

Eww. Well, let's look at some.
arch/i386/kernel/io_apic.c:line 1529

        printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
                smp_processor_id(), hard_smp_processor_id());

The \n seems unneeded, since print_local_APIC() is run on each cpu.
(see caller).


Then, there are also messages that are just a standalone \n
without even a debugging level. Not sure that is useful.

	# io_apic.c again, line 1601
	#
        printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);  
        printk("\n");

So, well, let's pick one with KERN_DEBUG "\n....

fs/freevxfs/vxfs_bmap.c:line 169 (near "case VXFS_TYPED_DATA_DEV4")

                        printk(KERN_INFO "\n\nTYPED_DEV4 detected!\n");
                        printk(KERN_INFO "block: %Lu\tsize: %Ld\tdev: %d\n",
                               (unsigned long long) typ4->vd4_block,
                               (unsigned long long) typ4->vd4_size,
                               typ4->vd4_dev);

Seems normal. So it looks like your regex has some false positives.
(which nothing can be done about - the 61 must be hand-sorted)

Perhaps we're looking for this idiom:

	printk(KERN_WHATEVER "Doing foo...");
	for (as_long_as_there_is_work) {
		do_it();
		printk(KERN_WHATEVER ".");
	}
	printk(KERN_WHATEVER "\n");

Yes, that imo is horrible :) since code running on another cpu can printk in
the middle. Perhaps

	int i;
	for (as_long with ++i) {
		do_it();
		printk("something informative %d\n", i++);
	}

should be done _instead_. This would also address number 8:

>> >8 Minimization/elimination of interleaved log messages
>> 
>> This is a separate, and worthwhile, thing to do, yes.
>> And it can be done without deviating from the regular printk().
>
>I'm not sure how.  Maybe you have an idea you could share?

[My idea is above]

>Maybe an external tool to reassemble complete messages from
>prefixed {{cookie}} message logs would be fine for awhile.
>
>Perhaps something like:
>
>cookie = printk_block_start()
>printk_block[s](cookie)
>printk_block_end(cookie)?
>
>where printk_block emits cookie when multiple cookies
>are active.

How is this supposed to work? Are you suggesting that the printk buffer is
locked? I hope not. Cache output until a block is ended? No, I do not think
that helps either, because the   for(){printk(".");}  loops are meant to
give an indication _THAT_ something is happening (or not - e.g. lockup).
Now, if you hold the output of a printk block until it's _end()
counterpart is executed, the user does not get any output when the
machine locks up during the for loop.

Hence, better do a full printk (e.g. with newline) in each iteration.
And if possible sparingly. Booting in 9600 bps serial mode is going to
take longer the more output the kernel produces ;-)
Or just to not clutter dmesg too much.



And at the end of the day when this would be done -
what would we need pr_foo for?


	Jan
-- 
