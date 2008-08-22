Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYHVDqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYHVDqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYHVDql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:46:41 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:39005 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbYHVDqk (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:46:40 -0400
Message-ID: <48AE36A7.4060000@lougher.demon.co.uk>
Date: Fri, 22 Aug 2008 04:46:47 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
References: <48AD00F0.5030403@gmail.com> <48AE0697.5040706@lougher.demon.co.uk> <6934efce0808212027q412c4cbbp6ea8673a7d3bc1b9@mail.gmail.com>
In-Reply-To: <6934efce0808212027q412c4cbbp6ea8673a7d3bc1b9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
>> I assume compressed blocks can be larger than PAGE_CACHE_SIZE?  This suffers
>> from the rather obvious inefficiency that you decompress a big block >
>> PAGE_CACHE_SIZE, but only copy one PAGE_CACHE_SIZE page out of it.  If
>> multiple files are being read simultaneously (a common occurrence), then
>> each is going to replace your one cached uncompressed block
>> (sbi->current_cnode_index), leading to decompressing the same blocks over
>> and over again on sequential file access.
>>
>> readpage file A, index 1 -> decompress block X
>> readpage file B, index 1 -> decompress block Y (replaces X)
>> readpage file A, index 2 -> repeated decompress of block X (replaces Y)
>> readpage file B, index 2 -> repeated decompress of block Y (replaces X)
>>
>> and so on.
> 
> Yep.  Been thinking about optimizing it.  So far it hasn't been an
> issue for my customers.  Most fs traffic being on the XIP pages.  Once
> I get a good automated performance test up we'll probably look into
> something to improve this.

It's relatively easy to solve.  Squashfs explicitly pushes the extra 
pages into the pagecache (so subsequent readpages find them there and 
don't call readpage on squashfs again).

Phillip


