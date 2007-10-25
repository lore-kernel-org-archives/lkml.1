Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXJYSqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXJYSqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXJYSq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:46:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbXJYSqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:46:24 -0400
Message-ID: <4720E479.4020906@ce.jp.nec.com>
Date: Thu, 25 Oct 2007 14:46:17 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm: noflush resizing (0/3)
References: <471FB83D.4060307@ce.jp.nec.com>	<20071025012456.GK10006@agk.fab.redhat.com>	<4720A59A.8060001@ce.jp.nec.com> <20071025144833.GN10006@agk.fab.redhat.com>
In-Reply-To: <20071025144833.GN10006@agk.fab.redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair,

Thanks for the immediate reply.

So as far as I understand, the point is:
  1. it's preferable to resize inode after the resume, if possible
  2. it's necessary to have nowait version of bdget() to avoid stall

For the 1st item, I guess the reason is that we want to make the
table swapping code deterministic. Is it correct?
Even if we don't have to wait for bdget(), you like to have the resizing
code after the resume?

For the 2nd item, the patch included bdlookup() for that purpose.
What do you think about it?

I added below some additional comments and questions.

Alasdair G Kergon wrote:
> On Thu, Oct 25, 2007 at 10:18:02AM -0400, Jun'ichi Nomura wrote:
>> There is no guarantee that the I/O flowing through the device again.
>> The table might need be replaced again, but to do that, the resume
>> should have been completed to let the userspace know it.
> 
> Then the first attempt to set the size could be made to fail
> (because it could not get the lock immediately) and the
> size could be set after the second resume instead.
> 
> - Setting the size would lag behind the actual size the dm table was
> supporting, but (given the usage cases discussed) this would not matter.
> 
>> bdget() in noflush suspend has a possibility of stall.
> 
> So we cannot avoid fixing that: we require immediate return
> with failure instead of waiting.

bdlookup() is the almost nowait version of bdget()
("almost" means it may wait for I_NEW turned off in case there is
  bdget() doing its latter half. But it never stalls.)

Do you think we need something else?

>> OTOH, calling bdget() and i_size_write() outside of the lock
>> can cause race with other table swapping and may result in setting
>> wrong device size.
> 
> If the size setting is removed from the lock, then it becomes
> "set the inode size to match the current size of the table" and
> races would not matter - each "set size" attempt would set it
> to the instantaneous live table size, not a cached value that
> could be out-of-date.

Even though, I think we still want set_capacity() during the table
swapping. So we need to call dm_table_get_size() twice. Is it ok?

Also, do you want to move the resizing code for normal suspend, too?
Otherwise, the code will be duplicated and I don't think you like it.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
