Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYKYL00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYKYL00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYKYL0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:26:11 -0500
Received: from mga12.intel.com ([143.182.124.36]:6744 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbYKYL0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:26:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="82379192"
Date: Tue, 25 Nov 2008 19:25:58 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081125112558.GA16422@localhost>
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <x491vxgkd61.fsf@segfault.boston.devel.redhat.com> <20081112190227.GS26778@kernel.dk> <1226566313.199910.29888@de> <20081113085439.GZ26778@kernel.dk> <1226626590.681364.9398@de> <492BDB55.3050407@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492BDB55.3050407@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 02:02:45PM +0300, Vladislav Bolkhovitin wrote:
>
>
> Wu Fengguang wrote:
>> On Thu, Nov 13, 2008 at 09:54:39AM +0100, Jens Axboe wrote:
>>> On Thu, Nov 13 2008, Wu Fengguang wrote:
>>>> Hi all,
>>>>
>>>> //Sorry for being late. 
>>>>
>>>> On Wed, Nov 12, 2008 at 08:02:28PM +0100, Jens Axboe wrote:
>>>> [...]
>>>>> I already talked about this with Jeff on irc, but I guess should post it
>>>>> here as well.
>>>>>
>>>>> nfsd aside (which does seem to have some different behaviour skewing the
>>>>> results), the original patch came about because dump(8) has a really
>>>>> stupid design that offloads IO to a number of processes. This basically
>>>>> makes fairly sequential IO more random with CFQ, since each process gets
>>>>> its own io context. My feeling is that we should fix dump instead of
>>>>> introducing a fair bit of complexity (and slowdown) in CFQ. I'm not
>>>>> aware of any other good programs out there that would do something
>>>>> similar, so I don't think there's a lot of merrit to spending cycles on
>>>>> detecting cooperating processes.
>>>>>
>>>>> Jeff will take a look at fixing dump instead, and I may have promised
>>>>> him that santa will bring him something nice this year if he does (since
>>>>> I'm sure it'll be painful on the eyes).
>>>> This could also be fixed at the VFS readahead level.
>>>>
>>>> In fact I've seen many kinds of interleaved accesses:
>>>> - concurrently reading 40 files that are in fact hard links of one single file
>>>> - a backup tool that splits a big file into 8k chunks, and serve the
>>>>   {1, 3, 5, 7, ...} chunks in one process and the {0, 2, 4, 6, ...}
>>>>   chunks in another one
>>>> - a pool of NFSDs randomly serving some originally sequential read 
>>>> requests - now dump(8) seems to have some similar problem.
>>>>
>>>> In summary there have been all kinds of efforts on trying to
>>>> parallelize I/O tasks, but unfortunately they can easily screw up the
>>>> sequential pattern. It may not be easily fixable for many of them.
>>>>
>>>> It is however possible to detect most of these patterns at the
>>>> readahead layer and restore sequential I/Os, before they propagate
>>>> into the block layer and hurt performance.
>>>>
>>>> Vitaly, if that's what you need, I can try to prepare a patch for
>>>> testing out.
>>> It's not easy. To really fix it, you have to get that sequential RA
>>> pattern from just the single process. As soon as you spread the IO
>>> between processes (eg N-1 aren't just getting cache hits), then you may
>>> run into trouble on the IO scheduler side.
>>
>> Yes, it's not easy(or possible) to tell from file->f_ra all those
>> cooperative processes working on the same sequential stream, since
>> they will have different file->f_ra instances. In the case of NFSD,
>> the file->f_ra may well be all zeros.
>>
>> Another scheme is to detect the sequential pattern via looking up
>> the page cache, which provides one single and consistent view of the
>> pages recently accessed. That makes sequential detection possible.
>>
>> The cost will be one extra page cache lookup per random read.
>> If it's not acceptable, the corresponding code could be disabled
>> by default. 
>
> I think, this should be the best and the simplest way to go. Since in  
> most case data from the cache should be later copied to user, one more  
> page cache lookup should be negligible.

After the initial proposal, two merits come to my mind to implement
cooperative sequential I/O detection in the readahead code:

1) readahead can make larger(hence more efficient) I/O requests
2) the page cache lookup trick eliminates the overheads of extra rbtrees.

So I would definitely like to try it out :-)

Thank you,
Fengguang
