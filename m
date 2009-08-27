Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZH0KL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZH0KL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZH0KL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:11:29 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:54694 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZH0KL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:11:28 -0400
Message-ID: <4A965BD1.205@oss.ntt.co.jp>
Date: Thu, 27 Aug 2009 19:11:29 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC, PATCH] filesystem freeze: fix sys_umount induced perpetual
 freeze
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de>
In-Reply-To: <20090826173839.GA20175@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Aug 26, 2009 at 02:00:01PM +0900, Fernando Luis V??zquez Cao wrote:
>> The current locking scheme for filesystem freeze avoids races between
>> freeze_bdev() and do_umount() by taking the s_umount semaphore.
>>
>> If freeze_bdev() wins the race the process that invoked sys_umount
>> will sleep until thaw_bdev releases the semaphore. Unfortunately, this
>> will never happen because thaw_bdev bails out early the
>> bd_fsfreeze_count check having failed (the count is 0).
>>
>> The problem is that the block_device that ioctl_fsthaw() passes to
>> thaw_bdev() is not the one that we freezed because before sleeping in
>> deactivate_super() do_umount() released the dentry (dput()) and freed
>> the vfs mount (free_vfsmnt()).
>>
>> This patch works around this issue by checking the freeze level in
>> do_umount()
> 
> 
> This should be solved my my freeze locking rewrite:
> 
> 	http://marc.info/?l=linux-fsdevel&m=124933489118480&w=2
> 	http://marc.info/?l=linux-fsdevel&m=124933491918517&w=2

Hi Christoph,

Thank you for the pointers. I gave those patches a spin, but it seems
the umount case is not being tackled. I suggest rejecting the umount
for frozen filesystems. What do you think?

I will be replying to this email with a forward port of your patches
along with my own patches that fix the locking for umount and add a
new ioctl to check the freeze state of the filesystem (this is helpful
to create clean resource agents for HA solutions).

- Fernando
