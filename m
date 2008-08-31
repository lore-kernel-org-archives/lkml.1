Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbYHaNEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbYHaNEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbYHaNEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:04:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:49608 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124AbYHaNEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=eLOJksxEGdf/Mpn5IU25kJ5o8zFAmAmhaa3J3HP1q3cHUo6/0uDgr6SxCwnvmcgxFp
         l2vIMmBzUcaqQdK7ScmlnHnz7zVjR/3KFBe2ye8NcFTWT+FJOkrDpLrhZpsTb5GN29ch
         6ziwAxOHe01H8FxKBZtz0hB6jeqveI3ecEcL0=
Message-ID: <48BA969C.4060207@gmail.com>
Date: Sun, 31 Aug 2008 15:03:24 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>
In-Reply-To: <87ej45mlp3.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Elias Oltmanns wrote:
>> Ah.. you need to part ATAPI too?  If so, just test for
>> ata_dev_enabled().
> 
> Well, I'm not quite sure really. Perhaps you are right and I'd better
> leave ATAPI alone, especially given the problem that the unload command
> might mess up a CD/DVD write operation. As long as no laptop HDs are
> identified as ATAPI devices, there should be no problem with that.

Hmm... I think it would be safer to stick with ATA for the time being.

>> Can you please elaborate a bit?  The reloading is done by the kernel
>> after a timeout, right?  What kind of precarious situation can the
>> kernel get into regarding suspend?
> 
> Sorry, I haven't expressed myself very clearly there, it seems. The user
> space process detects some acceleration and starts writing timeouts to
> the sysfs file. This causes the unload command to be issued to the
> device and stops all I/O until the user space daemon decides that the
> danger has passed, writes 0 to the sysfs file and leaves it alone
> afterwards. Now, if the daemon happens to request head parking right at
> the beginning of a suspend sequence, this means that we are in danger of
> falling, i.e. we have to make sure that I/O is stopped until that user
> space daemon gives the all-clear. However, suspending implies freezing
> all processes which means that the daemon can't keep checking and
> signalling to the kernel. The last timeout received before the daemon
> has been frozen will expire and the suspend procedure goes ahead. By
> means of the notifiers we can make sure that suspend is blocked until
> the daemon says that everything is alright.

Is it really worth protecting against that?  What if the machine
started to fall after the userland tasks have been frozen?  And how
long the usual timeout would be?  If the machine has been falling for
10 secs, there really isn't much point in trying to protect anything
unless there also is ATA DEPLOY PARACHUTE command somewhere in the new
revision.

In libata, as with any other exceptions, suspend/resume are handled by
EH so while emergency head unload is in progress, suspend won't
commence which is about the same effect as the posted code sans the
timeout extension part.  I don't really think there's any significant
danger in not being able to extend timeout while suspend is in
progress.  It's not a very big window after all.  If you're really
worried about it, you can also let libata reject suspend if head
unload is in progress.

Also, the suspend operation is unloading the head and spin down the
drive which sound like a good thing to do before crashing.  Maybe we
can modify the suspend sequence such that it always unload the head
first and then issue spindown.  That will ensure the head is in safe
position as soon as possible.  If it's done this way, it'll be
probably a good idea to split unloading and loading operations and do
loading only when EH is being finished and the disk is not spun down.

To me, much more serious problem seems to be during hibernation.  The
kernel is actively writing memory image to userland and it takes quite
a while and there's no protection whatsoever during that time.

>>     spin_lock_irq(ap->lock);
>>     ap->deadline = jiffies + timeout;
>>     ap->link.eh_info.action |= ATA_EH_PARK;
>>     ata_port_schedule_eh(ap);
>>     spin_unlock_irq(ap->lock);
> 
> Please note that I want to schedule EH (and thus the head unload -
> check power command sequence) only once in the event of overlapping
> timeouts. For instance, when the daemon sets a timeout of 2 seconds and
> does so again after one second has elapsed, I want the following to
> happen:
> 
> [ Daemon writes 2 to the unload_heads file ]
> 1. Set timer / deadline;
> 2. eh_info.action |= ATA_EH_PARK;
> 3. schedule EH;
> 4. execute EH and sleep, waiting for the timeout to expire;
> 
> [ Daemon writes 2 to the unload_heads file before the previous timeout
> has expired. ]
> 
> 5. update timer / deadline;
> 6. the EH thread keeps blocking until the new timeout has expired.
> 
> In particular, I don't want to reschedule EH in response to the second
> write to the unload_heads file. Also, we have to consider the case where
> the daemon signals to resume I/O prematurely by writing a timeout of 0.
> In this case, the EH thread should be woken up immediately.

Whether EH is scheduled multiple times or not doesn't matter at all.
EH can be happily scheduled without any actual action to do and that
does happen from time to time due to asynchronous nature of events.
libata EH doesn't have any problem with that.  The only thing that's
required is there's at least one ata_schedule_eh() after the latest
EH-worthy event.  So, the simpler code might enter EH one more time
once in the blue moon, but it won't do any harm.  EH will just look
around and realize that there's nothing much to do and just exit.

Thanks.

-- 
tejun
