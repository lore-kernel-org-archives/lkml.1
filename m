Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbYGQUUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbYGQUUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760579AbYGQUTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:19:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:15988 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbYGQUTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Iop3k31poI2nRIFUJ8qhV4P9zgawUGmjE9kQSALeUUo/a73a7RafBMFzzACKp2u5f6
         qRJXa0GgW+ZOHIgPHda+5b0Xgcb5AbDpbwI8FekK65/Dx4ZvKx2cUKHaoNU/M8X9uYYN
         UhWkPW1VzZYGbf2ItInS3SocoHawkI/yUdQu8=
Date: Fri, 18 Jul 2008 00:17:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, pagexec@freemail.hu
Subject: Re: *sigh* /proc/*/pagemap
Message-ID: <20080717201703.GA23775@martell.zuzino.mipt.ru>
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com> <20080704185312.052e7145.akpm@linux-foundation.org> <b6fcc0a0807050044g7a34a688s903e74848ab14b92@mail.gmail.com> <28fa9c5e0807161906q68411e9bn5975dc277f67b086@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28fa9c5e0807161906q68411e9bn5975dc277f67b086@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> 5) check with microscope allocation there -- page-aligned address and
> > size
> > >> == 0
> > >>     should allocate 0 bytes, and
> > >
> > > Where?
> >
> > kmalloc() in pagemap_read(). kmalloc(0)  and integer wraparound look
> > possible.

Now that I unsuccessfully tried to reproduce multiplication wraparound (on 32-bit),
integer wraparound in kmalloc() simply can't happen here.

Relevant code from pagemap_read():

	uaddr = (unsigned long)buf & PAGE_MASK;
	uend = (unsigned long)(buf + count);
	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);


pagecount is effectively "count / PAGE_SIZE", where "count" is size_t.
kmalloc() takes size_t as first argument, so one has to overflow

	count / PAGE_SIZE * sizeof(pointer).

For sure, page is bigger than pointer.

Anyone still see holes?

