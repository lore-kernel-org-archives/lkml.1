Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbZEMQ7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbZEMQ7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZEMQ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:59:29 -0400
Received: from mail.pentek.com ([12.35.250.145]:1743 "HELO mailhost.pentek.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754301AbZEMQ72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:59:28 -0400
Message-ID: <4A0AFC62.3090002@pentek.com>
Date: Wed, 13 May 2009 12:59:14 -0400
From: Steve Rottinger <steve@pentek.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk>
In-Reply-To: <20090511192253.GH4694@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!  This really helped me to progress using this interface.  My
current problem
is passing in the pages into splice_to_pipe.  The pages are associated
with a PCI BAR,
not main memory.  I'm wondering if this could be a problem?  Within my
driver, I use
ioremap() to map in the desired PCI BAR space; then, use virt_to_page()
to generate the
page table, based on the address returned from ioremap().   I can see
the correct pages
being received on the other end (by instrumenting the splice_to_file()
routine).  However,
the data in the resulting outfile does not match the data contained
within in my PCI BAR. I
see that splice_to_file() uses kmap_atomic() to mapping in the page,
before performing a
memcpy.  Is this going to be valid on an page that doesn't reside in
main memory?


Jens Axboe wrote:
> On Mon, May 11 2009, Steve Rottinger wrote:
>   
>> Hi,
>>
>> Has anyone successfully implemented the splice() method's in a character
>> device driver?
>> I'm having a tough time finding any existing drivers that implement
>> these method's, which
>> I can use as an example. Specifically, it is unclear to me, as to how I
>> need to set up .ops
>> in the splice_pipe_desc, when using splice_to_pipe(). 
>> My ultimate goal is to use splice to move data from a high speed data
>> acquisition device,
>> which has a buffer in PCI space to disk without the need for going
>> through block memory.
>>     
>
> I implemented ->splice_write() for /dev/null for testing purposes, but I
> doubt that you'll find much inspiration there.
>
> To use splice_to_pipe(), basically all you need to do is provide some
> way of stuffing the data pages in question into a struct page *pages[].
> See fs/splice.c:vmsplice_to_pipe(), for instance. Then you need to
> provide a way to ensure that these pages can be settled if they need to
> be accessed. Splice doesn't require that the IO is completed on the
> pages before they are put in the pipe, that's part of the power of the
> design. So if your design is allocating the pages in the ->splice_read()
> handler and initiating IO to these pages, then you need to provide a
> suitable ->confirm() hook that can wait on this IO to complete if
> needed. ->map() and ->unmap() can typically use the generic functions,
> ditto ->release(). You can implement ->steal() easily if you use the
> method of dynamically allocating pages for each IO instead of reusing
> them.
>
> So it should not be very hard, your best inspiration is likely to be
> found in fs/splice.c itself.
>
>   

