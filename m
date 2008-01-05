Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYAEPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYAEPDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYAEPDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:03:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:33594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbYAEPDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:03:12 -0500
To: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
From: Andi Kleen <andi@firstfloor.org>
References: <1199480498017@dmwebmail.japan.chezphil.org>
Date: Sat, 05 Jan 2008 16:03:11 +0100
In-Reply-To: <1199480498017@dmwebmail.japan.chezphil.org> (Phil Endecott's message of "Fri\, 04 Jan 2008 21\:01\:38 +0000")
Message-ID: <p731w8w8gcw.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:
>
> Many thanks for any suggestions.

It's a long standing bug reported regularly but so far nobody has tracked 
it down. That's mostly because most people cannot really reproduce it.

If you can reproduce it reliably: you could do the brute force debugging 
method. Simply grep all  places in the kernel code that set or pass ERESTART
and add a 

    printk("%s:%d ERESTART\n", __FILE__, __LINE__);

or perhaps

   printk("%s:%d %s:%d ERESTART\n", current->comm, current->pid, __FILE__,
               __LINE__);

or perhaps

   if (!strcmp(current->comm, "yourprogramwithoutpath"))
            printk("%s:%d ERESTART\n", __FILE__, __LINE__);

[the later two might need adding linux/string.h and/or linux/sched.h includes
to the files if they don't compile]

to all of them. Then recompile and boot that kernel.

Now if you can match such a output line to your program 
malfunction we would know where the problem is and then it would be likely
reasonable easy to fix.

Note that the above first two might produce a lot of output if you're
unlucky -- definitely don't do it on a production machine and kill
syslog first so that it doesn't all end up on disk.

-Andi
