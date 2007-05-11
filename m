Return-Path: <linux-kernel-owner+w=401wt.eu-S1763019AbXEKUCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763019AbXEKUCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761713AbXEKUBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:01:48 -0400
Received: from gw.goop.org ([64.81.55.164]:47079 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761425AbXEKUBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:01:47 -0400
Message-ID: <4644CBA2.7000302@goop.org>
Date: Fri, 11 May 2007 13:01:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Joel Becker <joel.becker@oracle.com>, Tony Luck <tony.luck@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>
Subject: Re: [patch 7/7] tidy up usermode helper waiting a bit
References: <20070510235708.155502000@goop.org>	 <20070511000028.927787000@goop.org> <1178912735.28304.4.camel@johannes.berg>
In-Reply-To: <1178912735.28304.4.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> [/me wonders why he was CC'ed]
>   

Because I knew you'd ask a good question ;)  No, I looked through the
recent changes on the files I changes and guessed at likely-looking
names.  But come to think of it, cc:ing completely random people is not
a bad way of getting some extra review cycles you mightn't otherwise get...


>>  	/* CLONE_VFORK: wait until the usermode helper has execve'd
>>  	 * successfully We need the data structures to stay around
>>  	 * until that is done.  */
>> -	if (wait)
>> +	if (wait == UMH_WAIT_PROC)
>>  		pid = kernel_thread(wait_for_helper, sub_info,
>>  				    CLONE_FS | CLONE_FILES | SIGCHLD);
>>  	else
>>  		pid = kernel_thread(____call_usermodehelper, sub_info,
>>  				    CLONE_VFORK | SIGCHLD);
>>     
>
> Isn't that a change in behaviour? Previously it said
> 	if (wait)
>  <=>	if (wait != 0)
>  <=>	if (wait != UMH_WAIT_EXEC)
> or am I missing something?
>   

Hm, you're right, it is a change in behaviour.  Yep, and a bug, since
its expecting wait_for_helper() to free the info in the UMH_NO_WAIT case.

---
 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -243,7 +243,7 @@ static void __call_usermodehelper(struct
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
-	if (wait == UMH_WAIT_PROC)
+	if (wait == UMH_WAIT_PROC || wait == UMH_NO_WAIT)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else

Thanks,
    J
