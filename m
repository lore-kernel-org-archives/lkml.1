Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbYAFBBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbYAFBBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbYAFBBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:01:10 -0500
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:35244 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbYAFBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:01:09 -0500
X-Greylist: delayed 2786 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2008 20:01:08 EST
Message-ID: <47801D70.8020504@uni-koeln.de>
Date: Sun, 06 Jan 2008 01:14:40 +0100
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk>
In-Reply-To: <20080105065233.GE27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro schrieb:
> On Tue, Jan 01, 2008 at 08:26:05PM +0100, Berthold Cogel wrote:
> 
>> Jan  1 17:34:39 wonderland kernel: BUG: unable to handle kernel paging 
>> request at virtual address 00100100
> 
> LIST_POISON1
> 
>> Jan  1 17:34:39 wonderland kernel: EIP is at evdev_disconnect+0x65/0x9e 
> 
> and by the look of code, it's a bit before the call of something that gets
> 0x20006 as one of its arguments.  Which, by the look of evdev.s, gets
> passed only to kill_fasync().  So it's POLL_HUP, so this code could be
> these days:
> 	spin_lock(&evdev->client_lock);
> 	list_for_each_entry(client, &evdev->client_list, node)
> 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
> 	spin_unlock(&evdev->client_lock);
> in evdev_hangup()
> prior to commit 6addb1d6de1968b84852f54561cc9a999909b5a9:
> 		list_for_each_entry(client, &evdev->client_list, node)
> 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
> in evdev_disconnect()
> 
> 
>> I'm using Debian stable/testing/unstable with homemade kernel 2.6.23.12 
>> (patched with tuxonice-3.0-rc3-for-2.6.23.9).
> 
> ... and seeing that this changeset postdates 2.6.23 *and* adds locking to
> the lists we are traversing in either variant, I'd bet that the kernel you
> have does *NOT* have the changeset in question, that you have list corruption
> from race and that your oops is list_for_each_entry() trying to walk
> forward from entry that just had list_del() poisoning its ->next.
> 
> There are only 4 changesets between 2.6.23 and this one affecting drivers/input
> and only
> 8006479c9b75fb6594a7b746af3d7f1fbb68f18f and
> 6addb1d6de1968b84852f54561cc9a999909b5a9
> appear to be relevant.  Apply to your kernel and see if it helps...

Looks as if I have to start using git ... I always feared that this day 
will come. ;-)

If I'm able to reproduce the oops with my patched kernel, I will gladly 
follow your advice.

Regards,

Berthold


