Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZGOVZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZGOVZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZGOVYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:24:54 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:47855 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZGOVYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wFfWamfQaMfcMdmvGL3B913LIJ2YMXzcPz/uPbmIZndgVAXqdn1b+yb39TXZhf6Otj
         +IOxpNYuLaD7KjGOxq1DII8WpaxbQNkJ2egB/nBUmibaU+L3Ab/ZuT9DfET47ZDwMIe0
         ekR6s0pFzTW8p0zp2I3yLyCskmTE0igiNPnu0=
Message-ID: <4A5E4918.3010903@tuffmail.co.uk>
Date: Wed, 15 Jul 2009 22:24:40 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: PM/hibernate swapfile regression
References: <20090714135453.GA26976@osiris.boeblingen.de.ibm.com> <200907141821.06101.rjw@sisk.pl>
In-Reply-To: <200907141821.06101.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 14 July 2009, Heiko Carstens wrote:
>   
>> We've seen this bug:
>>
>> Jul  8 13:16:02 h05lp03 kernel: BUG: sleeping function called from invalid context at /home/autobuild/BUILD/linux-2.6.30-20090707/include/linux/writeback.h:87
>> Jul  8 13:16:02 h05lp03 kernel: in_atomic(): 1, irqs_disabled(): 0, pid: 24377, name: bash
>> Jul  8 13:16:02 h05lp03 kernel: 3 locks held by bash/24377:
>> Jul  8 13:16:02 h05lp03 kernel: #0:  (&buffer->mutex){+.+.+.}, at: [<0000000000276e74>] sysfs_write_file+0x4c/0x1ac
>> Jul  8 13:16:02 h05lp03 kernel: #1:  (pm_mutex#2){+.+.+.}, at: [<000000000018f128>] hibernate+0x34/0x200
>> Jul  8 13:16:02 h05lp03 kernel: #2:  (swap_lock){+.+.-.}, at: [<00000000001f371c>] swap_type_of+0x44/0x158
>> Jul  8 13:16:02 h05lp03 kernel: CPU: 8 Not tainted 2.6.30-39.x.20090707-s390xdefault #1
>> Jul  8 13:16:02 h05lp03 kernel: Process bash (pid: 24377, task: 000000012ce84240, ksp: 00000000c262bb00)
>> Jul  8 13:16:02 h05lp03 kernel: 0000000000000000 00000000c262ba88 0000000000000002 0000000000000000
>> Jul  8 13:16:02 h05lp03 kernel:       00000000c262bb28 00000000c262baa0 00000000c262baa0 00000000005448c4
>> Jul  8 13:16:02 h05lp03 kernel:       0000000000000000 000000012ce84718 000000013d5bf1a8 0000000000000000
>> Jul  8 13:16:02 h05lp03 kernel:       000000000000000d 0000000000000000 00000000c262baf8 000000000000000e
>> Jul  8 13:16:02 h05lp03 kernel:       0000000000553da8 0000000000105600 00000000c262ba88 00000000c262bad0
>> Jul  8 13:16:02 h05lp03 kernel: Call Trace:
>> Jul  8 13:16:02 h05lp03 kernel: ([<00000000001054fc>] show_trace+0xf0/0x148)
>> Jul  8 13:16:02 h05lp03 kernel: [<00000000001391ba>] __might_sleep+0x172/0x188
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000021f738>] ifind+0x88/0xe4
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000220b0e>] iget5_locked+0x66/0x1d8
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000023b676>] bdget+0x5e/0x150
>> Jul  8 13:16:02 h05lp03 kernel: [<00000000001f37b2>] swap_type_of+0xda/0x158
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000192342>] swsusp_write+0x4e/0x458
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000018f254>] hibernate+0x160/0x200
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000018d8da>] state_store+0x82/0xa8
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000276f20>] sysfs_write_file+0xf8/0x1ac
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000020663a>] vfs_write+0xae/0x15c
>> Jul  8 13:16:02 h05lp03 kernel: [<00000000002067e0>] SyS_write+0x54/0xac
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000117a96>] sysc_noemu+0x10/0x16
>> Jul  8 13:16:02 h05lp03 kernel: [<00000047083e36b4>] 0x47083e36b4
>>
>> Looks like this was introduced with git commit a1bb7d61 "PM/hibernate: fix "swap
>> breaks after hibernation failures"".
>> Calling bdget while holding a spinlock doesn't seem to be a good idea...
>>     
>
> Agreed, sorry for missing that.
>
> Alan, can you please prepare a fix?
>
> Rafael
>   

I'll be back from graduation on the 17th.  I'll see what I can do then.

Thanks
Alan
