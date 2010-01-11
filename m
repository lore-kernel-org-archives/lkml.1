Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901Ab0AKOUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab0AKOUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581Ab0AKOU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:20:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0AKOU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:20:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
	<20100111014730.GA22362@sli10-desk.sh.intel.com>
	<4B4A92C7.10303@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 11 Jan 2010 09:20:18 -0500
In-Reply-To: <4B4A92C7.10303@cn.fujitsu.com> (Gui Jianfeng's message of "Mon,
	11 Jan 2010 10:53:59 +0800")
Message-ID: <x49my0ku3j1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng <guijianfeng@cn.fujitsu.com> writes:

> Shaohua Li wrote:
>> On Sat, Jan 09, 2010 at 11:59:17PM +0800, Corrado Zoccolo wrote:
>>> Current seeky detection is based on average seek lenght.
>>> This is suboptimal, since the average will not distinguish between:
>>> * a process doing medium sized seeks
>>> * a process doing some sequential requests interleaved with larger seeks
>>> and even a medium seek can take lot of time, if the requested sector
>>> happens to be behind the disk head in the rotation (50% probability).
>>>
>>> Therefore, we change the seeky queue detection to work as follows:
>>> * each request can be classified as sequential if it is very close to
>>>   the current head position, i.e. it is likely in the disk cache (disks
>>>   usually read more data than requested, and put it in cache for
>>>   subsequent reads). Otherwise, the request is classified as seeky.
>>> * an history window of the last 32 requests is kept, storing the
>>>   classification result.
>>> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>>>   were seeky.
>>>
>>> This patch fixes a regression reported by Yanmin, on mmap 64k random
>>> reads.
>> Can we not count a big request (say the request data is >= 32k) as seeky
>> regardless the seek distance? In this way we can also make a 64k random sync
>> read not as seeky.
>
>   Or maybe we can rely on *dynamic* CFQQ_SEEK_THR in terms of data lenght to 
>   determine whether a request should be a seeky one.

I'm not sure I understand the question, but it sounds like you're
assuming that the last_position tracks the beginning of the last I/O.
That's not the case.  It tracks the end of the last I/O, and so it
should not matter what the request size is.

Cheers,
Jeff
