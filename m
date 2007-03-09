Return-Path: <linux-kernel-owner+w=401wt.eu-S1161349AbXCIAPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161349AbXCIAPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161353AbXCIAPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:15:25 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:43651 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161349AbXCIAPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:15:24 -0500
Message-ID: <45F0A71C.2000800@cosmosbay.com>
Date: Fri, 09 Mar 2007 01:15:24 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>	 <45F09F9C.4030801@cosmosbay.com> <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
In-Reply-To: <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 09 Mar 2007 01:15:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards a écrit :
> On 3/8/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> Nothing in the manuals says that write() on same fd should be non racy 
>> : In
>> particular file pos might be undefined. There is a reason pwrite() 
>> exists.
>>
>> Kernel doesnt have to enforce thread safety as standard is quite clear.
> 
> I know the standard _allows_ us to crash and burn (well, corrupt
> f_pos) when two threads race on an fd, but why would we want to?
> Wouldn't it be better to do something at least slightly sane, like add
> atomically to f_pos the expected number of number of bytes written,
> then do the write, then fix it up (again atomically) if vfs_write
> returns an unexpected pos?

Absolutely not. We dont want to slow down kernel 'just in case a fool might 
want to do crazy things'


> 
>> Only O_APPEND case is specially handled (and NFS might fail to handle 
>> this
>> case correctly)
> 
> Is it?  How?
mm/filemap.c

generic_write_checks()

if (file->f_flags & O_APPEND)
	*pos = i_size_read(inode);

done while inode is locked.

O_APPEND basically says : Just ignore fpos and always use the 'end of file'

