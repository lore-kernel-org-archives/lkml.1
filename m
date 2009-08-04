Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbZHDKHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbZHDKHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932742AbZHDKHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:07:22 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48185 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbZHDKHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZjqBzegeHWP3LMKnGrse7KjF9jseaNTgQVET4bMvsG12/1vq0bhZZdhskeY1cA4b2o
         pIRTz8lAIX808qJkA/lM9kjvNgQoqhYeAfEMnYL1wfh8OXfQXJUO90VBpNe3Rulgg6bO
         17eH0RowYoyKfMRUb1LIhXsLNmVW+d4u1yUnE=
MIME-Version: 1.0
In-Reply-To: <20090804185058.09f79b37.kamezawa.hiroyu@jp.fujitsu.com>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
	 <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
	 <c384c5ea0908040157g222f5408o52dd10f02da5a07d@mail.gmail.com>
	 <20090804185058.09f79b37.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 4 Aug 2009 12:07:20 +0200
Message-ID: <c384c5ea0908040307g7389f33alad0cdf14ec58e10b@mail.gmail.com>
Subject: Re: get_user_pages() on an mmap()ed file allowed? What to do if 0 < 
	get_user_pages(..., nr_pages, ...) < nr_pages?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 4, 2009 at 11:50 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 4 Aug 2009 10:57:33 +0200
> Leon Woestenberg <leon.woestenberg@gmail.com> wrote:
>
>
>> >> - what should a driver do when get_user_pages() returns less pages
>> >> than requested?
>> >
>> > Probably put_page the pages gotten then report the surprise;
>> > perhaps, before putting the pages gotten, try get_user_pages
>> > on the next alone, to see what error code is returned for that.
>> >
>> > Unless it's happy to work with fewer pages than requested,
>> > in which case work with them and ignore the surprise.
>> >
>> I expect a certain amount of data to be DMA'd from the PCI device to
>> the file mmap, so I'ld rather map the complete file before I start
>> DMA.
>>
> I wonder.... If your device does DMA from-PCI-to-user, then,
>
>  rc = get_user_pages(current, current->mm, start & PAGE_MASK,
> nr_pages, 0 /* do not write*/, 1 /* do force */, pages, NULL);
>
> This is *write* access. isn't it ? (contents of pages got by this call
> will be overwritten by DMA ?)
>
>From the header:

int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
unsigned long start,
int len, int write, int force, struct page **pages, struct
vm_area_struct **vmas);

So with write being 0, I think it is read access to user space pages.


The actual code looks like this:

        /* is the PCI device (DMA) writing to user space? */
        to_user = !dir_to_dev;

        ...

	/* to_user != 0 means read from device, write into user space buffer memory */
	rc = get_user_pages(current, current->mm, (unsigned long)start &
PAGE_MASK, nr_pages, to_user,



> About (rc != nr_pages) case, I doubt there are difference between
> mmap region (or size of file) and [start, start+count) passed to you device.
>
I will tripple check this.

My current test is rather static (fixed size files I read from, fixed
mmap length etc) and rc varies wildly. As I said, I will check what
get_user_pages() fails on internally.

I will probably cook up a patch with Brice's idea (storing the error
code in the page[i], where i = rc).

Regards,
-- 
Leon
