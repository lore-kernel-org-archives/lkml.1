Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXEAThw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXEAThw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXEAThw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:37:52 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:55795 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbXEAThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BH7EQTQrN9I1rlchcE6KK8eUr6Bzx5S/SIj1kHYcs7b1QSE+I7lNjdsxX3jAqDBI6iKrYZmN1EuuQHjcT6+shEM5cUo9IcXGiSmzq7dGhj0pda0hzWeykMjncgNI4LjllPtIQXat3HmVLx0z/fDOq7G3/i/kFii87up3SPquLEw=
Message-ID: <a781481a0705011237n791f7cafn54509c1a41cf3de6@mail.gmail.com>
Date: Wed, 2 May 2007 01:07:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH 16/21] sysfs: implement bin_buffer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <463753DB.2060101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11777675753460-git-send-email-htejun@gmail.com>
	 <1177767582628-git-send-email-htejun@gmail.com>
	 <a781481a0705010725t310ecb31yde475412f620d6d6@mail.gmail.com>
	 <463753DB.2060101@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(We went off-list just now. Adding lkml again.)

On 5/1/07, Tejun Heo <htejun@gmail.com> wrote:
> Satyam Sharma wrote:
> > On 4/28/07, Tejun Heo <htejun@gmail.com> wrote:
> >> Implement bin_buffer which contains a mutex and pointer to PAGE_SIZE
> >> buffer to properly synchronize accesses to per-openfile buffer and
> >> prepare for immediate-kobj-disconnect.
> >>
> >> Signed-off-by: Tejun Heo <htejun@gmail.com>
> >> ---
> >> [...]
> >> @@ -135,14 +160,22 @@ static int open(struct inode * inode, struct
> >> file * file)
> >>                 goto Error;
> >>
> >>         error = -ENOMEM;
> >> -       file->private_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
> >> -       if (!file->private_data)
> >> +       bb = kzalloc(sizeof(*bb), GFP_KERNEL);
> >> +       if (!bb)
> >>                 goto Error;
> >>
> >> +       bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> >
> > You could simply do a __get_free_page() here instead of a
> > kmalloc(PAGE_SIZE).
>
> Yes, I could but 1. the original code was done using kmalloc

Yes, I saw that, but you could change it just as well. In any case,
this will only make fs/sysfs/bin.c similar to what is being done in
fs/sysfs/file.c. We allocate the buffer page backing the attribute's
data in fill_read_buffer() and fill_write_buffer() using
get_zeroed_page() and not kzalloc().

> 2. I'm not sure __get_free_page() is better than kmalloc(PAGE_SIZE, ), is it?

If you know for sure that you require *exactly* PAGE_SIZE bytes, then
yes, it is.
