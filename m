Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZD0Q6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZD0Q6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZD0Q6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:58:22 -0400
Received: from galaxy-old.riz.pl ([195.94.202.2]:40525 "HELO vhost.riz.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751688AbZD0Q6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:58:21 -0400
Date: Mon, 27 Apr 2009 18:58:16 +0200 (CEST)
From: Bart <mmx@riz.pl>
X-X-Sender: evil@galaxy.riz.pl
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13112] Oops in drain_array
In-Reply-To: <alpine.DEB.1.10.0904271000200.16119@qirst.com>
Message-ID: <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>  <egHshlwQQFE.A.KjC.JpE9JB@chimera>
  <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com>
 <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com>
 <alpine.DEB.1.10.0904271000200.16119@qirst.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Mon, 27 Apr 2009, Christoph Lameter wrote:

> On Mon, 27 Apr 2009, Pekka Enberg wrote:
>
>>   18:   4a 8b 8c eb 68 01 00    mov    0x168(%rbx,%r13,8),%rcx # l3 =
>> cachep->nodelists[node];
>>   1f:   00
>>   20:   48 8b 16                mov    (%rsi),%rdx
>>   23:   48 8b 46 08             mov    0x8(%rsi),%rax
>>   27:   48 89 42 08             mov    %rax,0x8(%rdx)
>>   2b:*  48 89 10                mov    %rdx,(%rax)     <-- trapping instruction
>>   2e:   89 e8                   mov    %ebp,%eax
>>   30:   48 c7 06 00 01 10 00    movq   $0x100100,(%rsi)
>>   37:   48 c7 46 08 00 02 20    movq   $0x200200,0x8(%rsi)
>>
>> it seems like list_del() in free_block() explodes because because
>> ->prev ("rax") of slab->list is bogus ("0000000000000cd0").
>
> Where do I find the rest of the information regarding this report?
> bugzilla does only contain a pointer to the initial report on lkml no
> discussion.
>
> Typically these oopses occur because the slab header at the beginning of a
> slab is overwritten. Enable debugging. Switching to SLUB would give better
> diagnostics.

After turning the suggested debuging options I've got tons of these when 
trying to stress the tape device like before:

Apr 27 16:57:30 fs kernel: [   96.446708] slab error in verify_redzone_free(): cache `size-128': memory outside object was overwritten
Apr 27 16:57:30 fs kernel: [   96.446713] Pid: 0, comm: swapper Not tainted 2.6.29.1-64 #2
Apr 27 16:57:30 fs kernel: [   96.446715] Call Trace:
Apr 27 16:57:30 fs kernel: [   96.446717]  <IRQ>  [<ffffffff8029adc5>] __slab_error+0x1f/0x25
Apr 27 16:57:30 fs kernel: [   96.446728]  [<ffffffff8029b24b>] cache_free_debugcheck+0x108/0x1d6
Apr 27 16:57:30 fs kernel: [   96.446731]  [<ffffffff8029b473>] kfree+0x81/0xc2
Apr 27 16:57:30 fs kernel: [   96.446735]  [<ffffffff802bd311>] bio_free_map_data+0xc/0x1e
Apr 27 16:57:30 fs kernel: [   96.446738]  [<ffffffff802bdc6d>] bio_uncopy_user+0x38/0x48
Apr 27 16:57:30 fs kernel: [   96.446742]  [<ffffffff803670e6>] blk_rq_unmap_user+0x1e/0x45
Apr 27 16:57:30 fs kernel: [   96.446747]  [<ffffffff8046ed7f>] st_scsi_execute_end+0x4e/0x5e
Apr 27 16:57:30 fs kernel: [   96.446751]  [<ffffffff8036425f>] blk_end_io+0x55/0x76
Apr 27 16:57:30 fs kernel: [   96.446754]  [<ffffffff804a17ad>] mpt_interrupt+0x422/0x53f
Apr 27 16:57:30 fs kernel: [   96.446758]  [<ffffffff8044be0b>] scsi_io_completion+0x18f/0x415
Apr 27 16:57:30 fs kernel: [   96.446762]  [<ffffffff80368160>] blk_done_softirq+0x62/0x72
Apr 27 16:57:30 fs kernel: [   96.446766]  [<ffffffff802523d0>] __do_softirq+0x7f/0x138
Apr 27 16:57:30 fs kernel: [   96.446770]  [<ffffffff80238d70>] ack_apic_level+0x46/0xce
Apr 27 16:57:30 fs kernel: [   96.446774]  [<ffffffff80225b3c>] call_softirq+0x1c/0x28
Apr 27 16:57:30 fs kernel: [   96.446777]  [<ffffffff8022706c>] do_softirq+0x2c/0x6c
Apr 27 16:57:30 fs kernel: [   96.446780]  [<ffffffff802272b1>] do_IRQ+0xb6/0xd5
Apr 27 16:57:30 fs kernel: [   96.446784]  [<ffffffff80225413>] ret_from_intr+0x0/0xa
Apr 27 16:57:30 fs kernel: [   96.446785]  <EOI>  [<ffffffff80564e7a>] udp_poll+0x0/0x10e
Apr 27 16:57:30 fs kernel: [   96.446793]  [<ffffffff8022b26c>] mwait_idle+0x63/0x66
Apr 27 16:57:30 fs kernel: [   96.446795]  [<ffffffff802238d6>] cpu_idle+0x40/0x5e
Apr 27 16:57:30 fs kernel: [   96.446798] ffff88013c197b48: redzone 1:0xd84156c5635688c0, redzone 2:0xffffe20004209348.

Can I help by testing an rc version if this happens too ?

-- 
  Regards,
  Bart mmx@riz.pl
