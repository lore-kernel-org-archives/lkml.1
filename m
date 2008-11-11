Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYKKQxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYKKQxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKKQx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:53:29 -0500
Received: from voyager.telenet.dn.ua ([195.39.211.35]:50595 "EHLO
	voyager.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYKKQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:53:28 -0500
Message-ID: <4919B884.5000604@telenet.dn.ua>
Date: Tue, 11 Nov 2008 18:53:24 +0200
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20081011)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <49186C5A.5020809@telenet.dn.ua> <20081110173504.GL26778@kernel.dk> <49187D05.9050407@telenet.dn.ua> <x491vxjqmg0.fsf@segfault.boston.devel.redhat.com> <20081111093426.GS26778@kernel.dk> <20081111093540.GT26778@kernel.dk> <20081111115227.GU26778@kernel.dk>
In-Reply-To: <20081111115227.GU26778@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Nov 11 2008, Jens Axboe wrote:
>> On Tue, Nov 11 2008, Jens Axboe wrote:
>>> On Mon, Nov 10 2008, Jeff Moyer wrote:
>>>> "Vitaly V. Bursov" <vitalyb@telenet.dn.ua> writes:
>>>>
>>>>> Jens Axboe wrote:
>>>>>> On Mon, Nov 10 2008, Vitaly V. Bursov wrote:
>>>>>>> Jens Axboe wrote:
>>>>>>>> On Mon, Nov 10 2008, Jeff Moyer wrote:
>>>>>>>>> Jens Axboe <jens.axboe@oracle.com> writes:
>>>>>>>>>
>>>>>>>>>> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
>>>>>>>>> Funny, I was going to ask the same question.  ;)  The reason Jens wants
>>>>>>>>> you to try this patch is that nfsd may be farming off the I/O requests
>>>>>>>>> to different threads which are then performing interleaved I/O.  The
>>>>>>>>> above patch tries to detect this and allow cooperating processes to get
>>>>>>>>> disk time instead of waiting for the idle timeout.
>>>>>>>> Precisely :-)
>>>>>>>>
>>>>>>>> The only reason I haven't merged it yet is because of worry of extra
>>>>>>>> cost, but I'll throw some SSD love at it and see how it turns out.
>>>>>>>>
>>>>>>> Sorry, but I get "oops" same moment nfs read transfer starts.
>>>>>>> I can get directory list via nfs, read files locally (not
>>>>>>> carefully tested, though)
>>>>>>>
>>>>>>> Dumps captured via netconsole, so these may not be completely accurate
>>>>>>> but hopefully will give a hint.
>>>>>> Interesting, strange how that hasn't triggered here. Or perhaps the
>>>>>> version that Jeff posted isn't the one I tried. Anyway, search for:
>>>>>>
>>>>>>         RB_CLEAR_NODE(&cfqq->rb_node);
>>>>>>
>>>>>> and add a
>>>>>>
>>>>>>         RB_CLEAR_NODE(&cfqq->prio_node);
>>>>>>
>>>>>> just below that. It's in cfq_find_alloc_queue(). I think that should fix
>>>>>> it.
>>>>>>
>>>>> Same problem.
>>>>>
>>>>> I did make clean; make -j3; sync; on (2 times) patched kernel and it went OK
>>>>> but It won't boot anymore with cfq with same error...
>>>>>
>>>>> Switching cfq io scheduler at runtime (booting with "as") appears to work with
>>>>> two parallel local dd reads.
>>>> Strange, I can't reproduce a failure.  I'll keep trying.  For now, these
>>>> are the results I see:
>>>>
>>>> [root@maiden ~]# mount megadeth:/export/cciss /mnt/megadeth/
>>>> [root@maiden ~]# dd if=/mnt/megadeth/file1 of=/dev/null bs=1M
>>>> 1024+0 records in
>>>> 1024+0 records out
>>>> 1073741824 bytes (1.1 GB) copied, 26.8128 s, 40.0 MB/s
>>>> [root@maiden ~]# umount /mnt/megadeth/
>>>> [root@maiden ~]# mount megadeth:/export/cciss /mnt/megadeth/
>>>> [root@maiden ~]# dd if=/mnt/megadeth/file1 of=/dev/null bs=1M
>>>> 1024+0 records in
>>>> 1024+0 records out
>>>> 1073741824 bytes (1.1 GB) copied, 23.7025 s, 45.3 MB/s
>>>> [root@maiden ~]# umount /mnt/megadeth/
>>>>
>>>> Here is the patch, with the suggestion from Jens to switch the cfqq to
>>>> the right priority tree when the priority is changed.
>>> I don't see the issue here either. Vitaly, are you using any openvz
>>> kernel patches? IIRC, they patch cfq so it could just be that your cfq
>>> version is incompatible with Jeff's patch.
>> Heh, got it to trigger about 3 seconds after sending that email! I'll
>> look more into it.
> 
> OK, found the issue. A few bugs there... cfq_prio_tree_lookup() doesn't
> even return a hit, since it just breaks and returns NULL always. That
> can cause cfq_prio_tree_add() to screw up the rbtree. The code to
> correct on ioprio change wasn't correct either, I changed that as well.
> New patch below, Vitaly can you give it a spin?
> 

No crashes so far. Transfer speed is quiet good also.


NFS+deadline, file not cached:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,00    0,00   25,50   19,40    0,00   55,10

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda            6648,80     0,00 1281,70    0,00 115179,20     0,00    89,86     5,35    4,18   0,35  45,20
sdb            6672,30     0,00 1257,00    0,00 115292,80     0,00    91,72     5,09    4,06   0,35  44,60



NFS+cfq, file not cached:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,05    0,00   25,30   23,95    0,00   50,70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda            6403,00     0,00 1089,90    0,00 108655,20     0,00    99,69     4,50    4,13   0,41  44,50
sdb            6394,90     0,00 1099,60    0,00 108639,20     0,00    98,80     4,53    4,12   0,39  42,50


Just for reference: 10 sec interval average, gigabit network,
no tcp/udp hardware checksumming may lead to high system cpu load.


Also, a few more test (server has 4G RAM):

NFS+cfq, file not cached:
$ dd if=test of=/dev/null bs=1M count=2000
2000+0 records in
2000+0 records out
2097152000 bytes (2.1 GB) copied, 24.9147 s, 84.2 MB/s

NFS+deadline, file not cached:
2000+0 records in
2000+0 records out
2097152000 bytes (2.1 GB) copied, 23.2999 s, 90.0 MB/s

file cached on server:
2000+0 records in
2000+0 records out
2097152000 bytes (2.1 GB) copied, 21.9784 s, 95.4 MB/s


Local single dd read leads to 193 MB/s for deadline and
167 MB/s for cfq.

-- 
Thanks,
Vitaly
