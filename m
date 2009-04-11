Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbZDKQLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbZDKQLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZDKQLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:11:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41208 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZDKQLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:11:01 -0400
Message-ID: <49E0C102.4020705@pobox.com>
Date: Sat, 11 Apr 2009 12:10:42 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: v2.6.25: WARNING: at kernel/lockdep.c:2437	__lock_acquire+0xc69/0xfa0()
References: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com> <1208782090.7115.179.camel@twins> <480FF821.9050208@gmail.com>
In-Reply-To: <480FF821.9050208@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Peter Zijlstra wrote:
>> Indeed, quite easy to reproduce:
>>
>> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
>> index 81a4e4a..33901ef 100644
>> --- a/kernel/lockdep.c
>> +++ b/kernel/lockdep.c
>> @@ -2434,6 +2434,13 @@ static int __lock_acquire(struct lockdep_map 
>> *lock, unsigned int subclass,
>>       * the hash, not class->key.
>>       */
>>      id = class - lock_classes;
>> +    if (id >= MAX_LOCKDEP_KEYS) {
>> +        spinlock_t *slock = container_of(lock, spinlock_t, dep_map);
>> +
>> +        printk(KERN_EMERG "magic: %x\n", slock->magic);
>> +        printk(KERN_EMERG "class: %p\n", class);
>> +        printk(KERN_EMERG "id: %u\n", id);
>> +    }
>>      if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
>>          return 0;
>>  
>>
>>
>> gives me:
>>
>> ata3: PATA max PIO4 cmd 0x1e8 ctl 0x3ee irq 11
>> magic: c050cf60
>> class: c7c20e54
>> id: 2265185251
>> ------------[ cut here ]------------
>> WARNING: at /mnt/md0/src/linux-2.6-2/kernel/lockdep.c:2444
>> __lock_acquire+0x57b/0xfd0()
>>
>>
>> Looks like someone is stomping on the spinlock or just passing us
>> garbage.
> 
> Does the attached patch help?
> 
> diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
> index 7af4b29..f7ba234 100644
> --- a/drivers/ata/pata_legacy.c
> +++ b/drivers/ata/pata_legacy.c
> @@ -1037,6 +1037,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
>  			return 0;
>  		}
>  	}
> +	ata_host_detach(host);
>  fail:
>  	platform_device_unregister(pdev);
>  	return ret;


(going through old, unresolved email)

It looks like this might still be needed?  I never saw an "it works" 
response to this email.

	Jeff



