Return-Path: <linux-kernel-owner+w=401wt.eu-S1423014AbXCIApq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423014AbXCIApq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423013AbXCIApp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:45:45 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:10773 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422716AbXCIApn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k32EtNVLHHNPyI/QAO/Hu33532sIdrdU3RGVeY3i+86CVKNbFJKEDMDM4DIFIHnC5OhfNlO/JxPOF0dbHYaWkHFR4qCaBp0LKGNtLhf0bs9msPfhk4xKfoKDwVoLugT0qVjk/+Afuw50qM2u/0dSK101KR0+uMsdN5YGdMOxFLo=
Message-ID: <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
Date: Thu, 8 Mar 2007 16:45:41 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45F0A71C.2000800@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
	 <45F09F9C.4030801@cosmosbay.com>
	 <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
	 <45F0A71C.2000800@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Absolutely not. We dont want to slow down kernel 'just in case a fool might
> want to do crazy things'

Actually, I think it would make the kernel (negligibly) faster to bump
f_pos before the vfs_write() call.  Unless fget_light sets fput_needed
or the write doesn't complete cleanly, you won't have to touch the
file table entry again after vfs_write() returns.  You can adjust
vfs_write to grab f_dentry out of the file before going into
do_sync_write.  do_sync_write is done with the struct file before it
goes into the aio_write() loop.  Result: you probably save at least an
L1 cache miss, unless the aio_write loop is so frugal with L1 cache
that it doesn't manage to evict the struct file.

Patch to follow.

Cheers,
- Michael
