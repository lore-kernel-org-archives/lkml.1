Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYJPJBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYJPJBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYJPJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:01:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:9626 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYJPJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YeGj/55myhuuYCkuqx7E1QFVROmPgBVO/+yspwnQxWWU1U0d7WEbcKuPDsIfQiEK4p
         Q6CedEHdum76cf2giGQoWRDoZ+1eulwghfE9lRiU0elBrxKc550Gl2xVN46GybYzkUIg
         KJrOhFSYUDZHRbhQtvdIIYLPDKMMJOMQaaeTU=
Message-ID: <48F702C4.5080503@gmail.com>
Date: Thu, 16 Oct 2008 11:00:52 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dong-Jae Kang <baramsori72@gmail.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Marco Innocenti <m.innocenti@cineca.it>,
       matt@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/6] cgroup: block device i/o controller (v11)
References: <1223373818-13687-1-git-send-email-righi.andrea@gmail.com>	 <2891419e0810140217l70f233bbr3b08760188458c35@mail.gmail.com>	 <48F46CB6.3010904@gmail.com> <2891419e0810142313p1aa16295ne2aa8ac3a87be491@mail.gmail.com>
In-Reply-To: <2891419e0810142313p1aa16295ne2aa8ac3a87be491@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong-Jae Kang wrote:
>>> I have several question about io-throttle
>>> below is my test reusult of io-throttle(v11) with xdd 6.5
>>> But, I think I have something wrong, as showed in result
>>> In direct IO mode, Only read operation was controlled by io-throttle
>>> Can you check my  test procedure and result and comments to me about that
>> Your procedure is correct. Anyway, you found a known bug in io-throttle
>> v11. If you want to properly use it you need to mount the memory
>> controller together with blockio, since currently blockio depends on it
>> to retrieve the owner of a page during writes in submit_bio().
>>
>> As reported in:
>>
>> [PATCH -mm 4/6] memcg: interface to charge the right cgroup of asynchronous i/o activity
>>
>> this is no more than a hack and in perspective a more generic framework
>> able to provide this functionality should be used (i.e. bio-cgroup).
> 
> But, In my opinion,
> it is some strange that the bandwidth of write operation in direct IO
> mode was not controlled by io-throttle
> I think [PATCH -mm 4/6] is for control of buffered IO.
> Do I misunderstand it?

The approach is the same both for buffered and direct IO. With buffered
IO, writes are accounted in submit_bio() and throttling is performed in
balance_dirty_pages_ratelimited_nr(). With direct IO, accounting is always
performed in submit_bio() and throttling in submit_page_section(). That's
the same also for AIO, accounting in submit_bio() and throttling in
io_submit_one(), returning -EAGAIN in this case when the IO limits are
exceeded (instead of sleeping).

We never sleep in submit_bio() during writes and to account the IO activity
we always look at the owner (cgroup) of the first page in the struct bio,
also when the IO context is the cgroup of the current task (as in the direct
IO case). To correctly retrieve the owner of each page I've used the memory
controller functionality. This part should be improved to use a more generic
framework and remove the dependency of the memory controller. Or better, doesn't
impose to mount blockio and memory controller both to the same mountpoint.

-Andrea
