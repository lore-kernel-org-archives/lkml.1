Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYKYLAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYKYLAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYKYK77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:59:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57216 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYKYK76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:59:58 -0500
Message-ID: <492BDAA9.4090405@vlnb.net>
Date: Tue, 25 Nov 2008 13:59:53 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Wu Fengguang <wfg@linux.intel.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <x491vxgkd61.fsf@segfault.boston.devel.redhat.com> <20081112190227.GS26778@kernel.dk> <1226566313.199910.29888@de>
In-Reply-To: <1226566313.199910.29888@de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+6zfq31i6ghSzuZRsJMgQQQ0B64eCQRraCvHW
 zerLRuuYy+NfPySF0aaFwBuFKZdBBTae43PcX+Gw1tMNp0eqRY
 Z83ERm7mQsvY8DyvRzANg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Hi all,
> 
> //Sorry for being late. 
> 
> On Wed, Nov 12, 2008 at 08:02:28PM +0100, Jens Axboe wrote:
> [...]
>> I already talked about this with Jeff on irc, but I guess should post it
>> here as well.
>>
>> nfsd aside (which does seem to have some different behaviour skewing the
>> results), the original patch came about because dump(8) has a really
>> stupid design that offloads IO to a number of processes. This basically
>> makes fairly sequential IO more random with CFQ, since each process gets
>> its own io context. My feeling is that we should fix dump instead of
>> introducing a fair bit of complexity (and slowdown) in CFQ. I'm not
>> aware of any other good programs out there that would do something
>> similar, so I don't think there's a lot of merrit to spending cycles on
>> detecting cooperating processes.
>>
>> Jeff will take a look at fixing dump instead, and I may have promised
>> him that santa will bring him something nice this year if he does (since
>> I'm sure it'll be painful on the eyes).
> 
> This could also be fixed at the VFS readahead level.
> 
> In fact I've seen many kinds of interleaved accesses:
> - concurrently reading 40 files that are in fact hard links of one single file
> - a backup tool that splits a big file into 8k chunks, and serve the
>   {1, 3, 5, 7, ...} chunks in one process and the {0, 2, 4, 6, ...}
>   chunks in another one
> - a pool of NFSDs randomly serving some originally sequential read requests 
> - now dump(8) seems to have some similar problem.
> 
> In summary there have been all kinds of efforts on trying to
> parallelize I/O tasks, but unfortunately they can easily screw up the
> sequential pattern. It may not be easily fixable for many of them.
> 
> It is however possible to detect most of these patterns at the
> readahead layer and restore sequential I/Os, before they propagate
> into the block layer and hurt performance.

I believe this would be the most effective way to go, especially in case 
if data delivery path to the original client has its own latency 
depended from the amount of transferred data as it is in the case of 
remote NFS mount, which does synchronous sequential reads. In this case 
it is essential for performance to make both links (local to the storage 
and network to the client) be always busy and transfer data 
simultaneously. Since the reads are synchronous, the only way to achieve 
that is perform read ahead on the server sufficient to cover the network 
link latency. Otherwise you would end up with only half of possible 
throughput.

However, from one side, server has to have a pool of threads/processes 
to perform well, but, from other side, current read ahead code doesn't 
detect too well that those threads/processes are doing joint sequential 
read, so the read ahead window gets smaller, hence the overall read 
performance gets considerably smaller too.

> Vitaly, if that's what you need, I can try to prepare a patch for testing out.

I can test it with SCST SCSI target sybsystem (http://scst.sf.net). SCST 
needs such feature very much, otherwise it can't get full backstorage 
read speed. The maximum I can see is about ~80MB/s from ~130MB/s 15K RPM 
disk over 1Gbps iSCSI link (maximum possible is ~110MB/s).

> Thank you,
> Fengguang
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
