Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYFKMtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYFKMtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYFKMtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:49:42 -0400
Received: from sacred.ru ([62.205.161.221]:51608 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYFKMtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:49:42 -0400
Message-ID: <484FC94E.1000209@openvz.org>
Date: Wed, 11 Jun 2008 16:47:10 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: autofs mailing list <autofs@linux.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH] autofs4: fix 32-bit userspace vs 64-bit kernel	communications
References: <484FA0B8.2000002@openvz.org> <1213187579.4994.25.camel@raven.themaw.net>
In-Reply-To: <1213187579.4994.25.camel@raven.themaw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 11 Jun 2008 16:49:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent wrote:
> On Wed, 2008-06-11 at 13:54 +0400, Pavel Emelyanov wrote:
>> From: Konstantin Khlebnikov <khlebnikov@openvz.org>
>>
>> The struct autofs_v5_packet has only one difference between
>> 32-bit and 64-bit versions - on 64-bit gcc aligns its size and
>> it is 4 bytes larger that it is on 32-bit kernel. This confuses
>> 32-bit user-space daemon, when talking to 64-bit kernel.
> 
> No, I don't think that's quite right.
> 
> As far as I know this issue arises when a user space program, compiled
> as a 32-bit application is executed within 64-bit user space.

What program do mean here? The problem arises right on the kernel-daemon
boundary - the latter refuses to accept the message with larger length.
No other software required.

>> This is very critical for containerized setups, when containers
>> with <different>-bit tolls are used.
> 
> Have you tested different situations with this change?
> Will this affect the existing check and adjustment the version 5
> automount daemon does now?

64-bit daemons *still* work OK and 32-bit *start* to after this fix :)

>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
>> Acked-by: Pavel Emelyanov <xemul@openvz.org>
>>
>> ---
>>
>> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
>> index 1e4a539..9855b6e 100644
>> --- a/fs/autofs4/waitq.c
>> +++ b/fs/autofs4/waitq.c
>> @@ -132,6 +132,14 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
>>  		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
>>  
>>  		pktsz = sizeof(*packet);
>> +#if defined(CONFIG_X86_64) && defined(CONFIG_IA32_EMULATION)
>> +		/*
>> +		 * On x86_64 autofs_v5_packet struct is padded with 4 bytes
>> +		 * which breaks 32-bit autofs daemon.
>> +		 */
>> +		if (test_thread_flag(TIF_IA32))
>> +			pktsz -= 4;
>> +#endif
>>  
>>  		packet->wait_queue_token = wq->wait_queue_token;
>>  		packet->len = wq->len;
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

