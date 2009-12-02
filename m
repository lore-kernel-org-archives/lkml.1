Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZLBO1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZLBO1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZLBO1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:27:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbZLBO1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:27:04 -0500
Date: Wed, 2 Dec 2009 09:25:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
Message-ID: <20091202142508.GA31715@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4B15C828.4080407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B15C828.4080407@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:51:36AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > Hi Jens,
> > 
> > This is V4 of the Block IO controller patches on top of "for-2.6.33" branch
> > of block tree.
> > 
> > A consolidated patch can be found here:
> > 
> > http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v4.patch
> > 
> 
> Hi Vivek,
> 
> It seems this version doesn't work very well for "direct(O_DIRECT) sequence read" mode.
> For example, you can create group A and group B, then assign weight 100 to group A and
> weight 400 to group B, and you run "direct sequence read" workload in group A and B 
> simultaneously. Ideally, we should see 1:4 disk time differentiation for group A and B. 
> But actually, I see almost 1:2 disk time differentiation for group A and B. I'm looking
> into this issue.
> BTW, V3 works well for this case.

Hi Gui,

In my testing of 8 fio jobs in 8 cgroups, direct sequential reads seems to
be working fine.

http://lkml.org/lkml/2009/12/1/367

I suspect that in some case we choose not to idle on the group and it gets
deleted from service tree hence we loose share. Can you have a look at
blkio.dequeue files. If there are excessive deletions, that will signify
that we are loosing share because we chose not to idle.

If yes, please also run blktrace to see in what cases we chose not to
idle.

In V3, I had a stronger check to idle on the group if it is empty using
wait_busy() function. In V4 I have removed that and trying to wait busy
on a queue by extending its slice if it has consumed its allocated slice.

Thanks
Vivek
