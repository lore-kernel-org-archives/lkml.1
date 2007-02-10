Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXBJSFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXBJSFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 13:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXBJSFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 13:05:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXBJSFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 13:05:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JOmmToWDndzXKT03pK+3LWE8izxoLpK8FtGGUfgQmRUWcErYO1cP9eOFIYhz2k4nQ
	ruQIn+WGyuHxdGFiPpiEQ==
Message-ID: <b040c32a0702101005q7ff4a679xd3586531aa8a99cc@mail.gmail.com>
Date: Sat, 10 Feb 2007 10:05:24 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy
Cc: suparna@in.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC804976@mssmsx411>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070209071600.GA21276@in.ibm.com>
	 <B41635854730A14CA71C92B36EC22AAC804976@mssmsx411>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Ananiev, Leonid I <leonid.i.ananiev@intel.com> wrote:
> I have used EIOCBRETRY in the patch to minimize source code modification
> only.
> [...]
> A lot of errno's have different meaning in different functions or
> contexts. EAGAIN could be used instated of EIOCBRETRY for irredundant
> set.

I also think the original patch is wrong.  It might shut up kernel
panic by eliminate double calls to aio_complete(), but it will
silently introduce data corruption.

If invalidate_inode_pages2_range() says it can not invalidate pages,
while dio to the same file offset range is in flight, something is
really wrong there.  In generic_file_direct_IO, the function
explicitly flushes all dirty pages and wait on them before submits
DIO.

So any error value returned from invalidate_inode_pages2_range() has
to be taken seriously in the direct IO submit path instead of dropping
it to the floor.

- Ken
