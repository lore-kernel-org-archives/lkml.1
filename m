Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZLCIp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZLCIp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZLCIpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:45:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZLCIpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:45:54 -0500
Message-ID: <4B1779CE.1050801@cn.fujitsu.com>
Date: Thu, 03 Dec 2009 16:41:50 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4B15C828.4080407@cn.fujitsu.com> <20091202142508.GA31715@redhat.com>
In-Reply-To: <20091202142508.GA31715@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Wed, Dec 02, 2009 at 09:51:36AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> Hi Jens,
>>>
>>> This is V4 of the Block IO controller patches on top of "for-2.6.33" branch
>>> of block tree.
>>>
>>> A consolidated patch can be found here:
>>>
>>> http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v4.patch
>>>
>> Hi Vivek,
>>
>> It seems this version doesn't work very well for "direct(O_DIRECT) sequence read" mode.
>> For example, you can create group A and group B, then assign weight 100 to group A and
>> weight 400 to group B, and you run "direct sequence read" workload in group A and B 
>> simultaneously. Ideally, we should see 1:4 disk time differentiation for group A and B. 
>> But actually, I see almost 1:2 disk time differentiation for group A and B. I'm looking
>> into this issue.
>> BTW, V3 works well for this case.
> 
> Hi Gui,
> 
> In my testing of 8 fio jobs in 8 cgroups, direct sequential reads seems to
> be working fine.
> 
> http://lkml.org/lkml/2009/12/1/367
> 
> I suspect that in some case we choose not to idle on the group and it gets
> deleted from service tree hence we loose share. Can you have a look at
> blkio.dequeue files. If there are excessive deletions, that will signify
> that we are loosing share because we chose not to idle.
> 
> If yes, please also run blktrace to see in what cases we chose not to
> idle.
> 
> In V3, I had a stronger check to idle on the group if it is empty using
> wait_busy() function. In V4 I have removed that and trying to wait busy
> on a queue by extending its slice if it has consumed its allocated slice.

Hi Vivek,

I ckecked the blktrace output, it seems that io group was deleted all the time,
because we don't have group idle any more. I pulled the wait_busy code back to
V4, and retest it, problem seems disappeared.

So i suggest that we need to retain the wait_busy code.

Thanks,
Gui

