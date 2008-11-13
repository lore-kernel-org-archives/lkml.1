Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYKMSqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYKMSqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYKMSqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:46:23 -0500
Received: from voyager.telenet.dn.ua ([195.39.211.35]:49509 "EHLO
	voyager.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYKMSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:46:23 -0500
Message-ID: <491C75FC.1000409@telenet.dn.ua>
Date: Thu, 13 Nov 2008 20:46:20 +0200
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20081011)
MIME-Version: 1.0
To: Wu Fengguang <wfg@linux.intel.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <x491vxgkd61.fsf@segfault.boston.devel.redhat.com> <20081112190227.GS26778@kernel.dk> <1226566313.199910.29888@de>
In-Reply-To: <1226566313.199910.29888@de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
> 
> Vitaly, if that's what you need, I can try to prepare a patch for testing out.

Deadline scheduler should fit my needs, I believe. I can test a patch which
tries to resolve the issue or run some more tests, though.

-- 
Thanks,
Vitaly
