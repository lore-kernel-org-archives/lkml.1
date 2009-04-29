Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZD2UiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZD2UiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZD2UiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:38:07 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:30746 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZD2UiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:38:05 -0400
Subject: Re: [PATCH RFC] ext3 data=guarded v5
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20090429200412.GA27924@duck.suse.cz>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
	 <20090429085632.GA18273@duck.suse.cz>
	 <1241014093.20099.28.camel@think.oraclecorp.com>
	 <20090429191533.GB22936@duck.suse.cz>
	 <1241034089.20099.60.camel@think.oraclecorp.com>
	 <20090429200412.GA27924@duck.suse.cz>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 16:37:01 -0400
Message-Id: <1241037421.20099.70.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49F8BA74.01D6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 22:04 +0200, Jan Kara wrote:

> > What we don't want to do is have a call to write() over existing blocks
> > in the file add new things to the data=ordered list.  I don't see how we
> > can avoid that without datanew.
>   Yes, what I suggest would do exactly that:
> In ordered_writepage() in the beginning we do:
>   page_bufs = page_buffers(page);
>   if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
>                          NULL, buffer_unmapped)) {
>   	return block_write_full_page(page, NULL, wbc);
>   }
> So we only get to starting a transaction and file some buffers if some buffer
> in the page is unmapped. Write() maps / allocates all buffers in write_begin()
> so they are never added to ordered lists in writepage().

Right, writepage doesn't really need datanew.

>  We rely on write_end
> to do it. So the only case where not all buffers in the page are mapped is
> when we have to allocate in writepage() (mmaped write) or the two cases I
> describe above.

But I still think write_end does need datanew.  That's where 99% of the
ordered buffers are going to come from when we overwrite the contents of
an existing file.

-chris


