Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZCaHYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZCaHYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZCaHX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:23:58 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:6948 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752457AbZCaHX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:23:57 -0400
Message-ID: <49D1C44D.8060806@panasas.com>
Date: Tue, 31 Mar 2009 10:20:45 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, zbr@ioremap.net,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, linux-next@vger.kernel.org
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
References: <49C1331D.1080805@panasas.com> <20090330142200.af4b497c.akpm@linux-foundation.org>
In-Reply-To: <20090330142200.af4b497c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 07:22:40.0038 (UTC) FILETIME=[796F2C60:01C9B1D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 12:22 AM, Andrew Morton wrote:
> On Wed, 18 Mar 2009 19:45:01 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> What's new since last iteration:
>>
>> * I completely re-wrote the [PATCH 4/8] exofs: address_space_operations
>>   in which we actually write/read to/from osd-storage. The difference is
>>   that now we try to accumulate as many contiguous pages as possible and
>>   send them as one large request. As opposed to writing each page at a
>>   time, in the previous patchset.
>>
>> * [PATCH 5/8] exofs: dir_inode and directory operations received lots
>>   of love thanks to Evgeniy Polyakov's grate comments.
>>
>> exofs is a file system that uses an OSD device as it's back store.
>>
>> OSD is a new T10 command set that views storage devices not as a large/flat
>> array of sectors but as a container of objects, each having a length, quota,
>> time attributes and more. Each object is addressed by a 64bit ID, and is
>> contained in a 64bit ID partition. Each object has associated attributes
>> attached to it, which are integral part of the object and provide metadata about
>> the object. The standard defines some common obligatory attributes, but user
>> attributes can be added as needed.
>>
>> Here is the list of patches
>> [PATCH 1/8] exofs: Kbuild, Headers and osd utils
>> [PATCH 2/8] exofs: file and file_inode operations
>> [PATCH 3/8] exofs: symlink_inode and fast_symlink_inode operations
>> [PATCH 4/8] exofs: address_space_operations
>> [PATCH 5/8] exofs: dir_inode and directory operations
>> [PATCH 6/8] exofs: super_operations and file_system_type
>> [PATCH 7/8] exofs: Documentation
>> [PATCH 8/8] fs: Add exofs to Kernel build
> 
> Are all the prerequisites for exofs now in mainline?
> 

Yes they are all in

>> This patchset is also available on:
>>   git-clone git://git.open-osd.org/linux-open-osd.git linux-next
>> or on the web at:
>>   http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next
> 
> Well I could merge them, but given that you have a git tree, a more
> convenient path would be for us to include your tree in linux-next 

As Stephan said they are there since 2.6.29-rc1

> and
> then you ask Linus to pull it directly when the time comes.
> 

I was hoping the time is now

> I'm unsure when that time will come.  Who has reviewed this work and
> what was the result?
> 
> 

The patches have been reveiwed on linux-kernel and linux-fsdevel for
5-6 rounds. Each round drew it's comments which I fixed and so on.

The code is pretty well as far as styling and layout. And I'm not sure
what else can be done for them.

As far as quality robustness and performance, that's hard to say since
it has not been used outside of the labs yet. Perhaps being in mainline
will give the exposure it needs to stabilize.

Exofs is the only current candidate user for the osd in mainline, and in a
shape that does things relatively well as far as we could test it.

It has lots of work still to do on it in order to make it the pNFS-Objects
filesystem it needs to be. One reason it is very important for me that it
will go in mainline is because of the pNFS patches that need to come. pNFS
is an out-of-tree staging area that holds the up coming pNFS stuff that will
be added to Linux. It currently holds patches that will eventually go through
4 different git trees / maintainers. if exofs is left outside it is another
headache added. And of course is the hassle of keeping out-of-tree code for
another round, that's depressing. I don't see what is the danger of inclusion
and what is to be gained with keeping this out-of-tree? Please advise you have
much longer experience with these thing then me.

For long term plans By next kernel exofs should be pNFS capable, and a
pNFS-object-layout driver should be added for the pNFS client side. The
layout driver is based on the same infrastructure as exofs. Then farther
down exofs will need to be multi-device raids and all.

Lots of more work to do, but first thing first, can this be included in
2.6.30?

Thanks
Boaz
