Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbXKLOI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbXKLOI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbXKLOIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:08:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:44297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580AbXKLOIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:08:17 -0500
Message-ID: <47385E4A.5030306@suse.de>
Date: Mon, 12 Nov 2007 23:08:10 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: fix  off-by-one error in fill_read_buffer
References: <4732EDD2.2050406@cn.fujitsu.com>
In-Reply-To: <4732EDD2.2050406@cn.fujitsu.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miao Xie wrote:
> Hi,everyone.
>   I found that there is a off-by-one problem in the following code.
> 
> Version:    2.6.24-rc2
> File:        fs/sysfs/file.c:118-122
> Function:    fill_read_buffer
> --------------------------------------------------------------------
>     count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
> 
>     sysfs_put_active_two(attr_sd);
> 
>     BUG_ON(count > (ssize_t)PAGE_SIZE);
> --------------------------------------------------------------------
> Because according to the specification of the sysfs and the implement of
> the
> show methods, the show methods return the number of bytes which would be
> generated for the given input, excluding the trailing null.So if the return
> value of the show methods equals PAGE_SIZE - 1, the buffer is full in fact.
> And if the return value equals PAGE_SIZE, the resulting string was already
> truncated,or buffer overflow occurred.
> 
> This patch fixes an off-by-one error in fill_read_buffer.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

It isn't strictly a bug.  If the ->show() op fills full PAGE_SIZE and
returns PAGE_SIZE, the user will get full PAGE_SIZE bytes correctly, so
it will work.  However, considering normal use cases, return value of
PAGE_SIZE very likely indicates an error condition, so considering it a
BUG condition is a good idea.

Miao, can you please note that the code works fine with PAGE_SIZE return
but it's likely to indicate truncated result or overflow in normal use
cases as a comment on top of the BUG_ON()?

Thanks.

-- 
tejun
