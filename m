Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbXEAUEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbXEAUEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXEAUEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:04:12 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:7908 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbXEAUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=luAvQgKSSsfdw8pERZLic0przhT4aH8ykG/gHzhU8igNReyVzQ7s+6QzH2L+pI2AGrnj7jja8Z4EYwkiE6skIqOMMQbwJADxe0aFbXzNwCAwcxwm9pJRgGkGGo02xNi6rw6JYo72R/Z/7Tx9uEOjVz0toLbC1aWfm4cw2GU98tQ=
Message-ID: <a781481a0705011304mb8b33faq4afc67363ac79c8d@mail.gmail.com>
Date: Wed, 2 May 2007 01:34:09 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH 16/21] sysfs: implement bin_buffer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0705011237n791f7cafn54509c1a41cf3de6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11777675753460-git-send-email-htejun@gmail.com>
	 <1177767582628-git-send-email-htejun@gmail.com>
	 <a781481a0705010725t310ecb31yde475412f620d6d6@mail.gmail.com>
	 <463753DB.2060101@gmail.com>
	 <a781481a0705011237n791f7cafn54509c1a41cf3de6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> (We went off-list just now. Adding lkml again.)
>
> On 5/1/07, Tejun Heo <htejun@gmail.com> wrote:
> > Satyam Sharma wrote:
> > > On 4/28/07, Tejun Heo <htejun@gmail.com> wrote:
> > >> Implement bin_buffer which contains a mutex and pointer to PAGE_SIZE
> > >> buffer to properly synchronize accesses to per-openfile buffer and
> > >> prepare for immediate-kobj-disconnect.
> > >>
> > >> Signed-off-by: Tejun Heo <htejun@gmail.com>
> > >> ---
> > >> [...]
> > >> @@ -135,14 +160,22 @@ static int open(struct inode * inode, struct
> > >> file * file)
> > >>                 goto Error;
> > >>
> > >>         error = -ENOMEM;
> > >> -       file->private_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
> > >> -       if (!file->private_data)
> > >> +       bb = kzalloc(sizeof(*bb), GFP_KERNEL);
> > >> +       if (!bb)
> > >>                 goto Error;
> > >>
> > >> +       bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> > >
> > > You could simply do a __get_free_page() here instead of a
> > > kmalloc(PAGE_SIZE).
> >
> > Yes, I could but 1. the original code was done using kmalloc
>
> Yes, I saw that, but you could change it just as well. In any case,
> this will only make fs/sysfs/bin.c similar to what is being done in
> fs/sysfs/file.c. We allocate the buffer page backing the attribute's
> data in fill_read_buffer() and fill_write_buffer() using
> get_zeroed_page() and not kzalloc().

Which begs another question -- why do we allocate the buffer page
lazily (only at the time of read(2) and write(2) and not at open(2))
in the case of normal attributes but prefer to do it during open(2)
itself for binary attributes? Note that the page (if allocated) is
freed during release() for both cases.
