Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYDBPH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYDBPH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbYDBPHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:07:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:57774 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbYDBPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=COyXm7Xee2ruGSTSc4xcYONajnOY2mvQH4HzPfpFvsYEM8KHGVSDWRY/CqZ7Ioa3Je1GlktgmEV1DSVTrzO1tClCP5FtgCLZJqfOa9GMUrRwid4e4GJ4UxOKpq8cZGQ9an7tksX3gemJhRvUQ5NuvpfqEKo0VFPFvOoLvW0sX9U=
Message-ID: <8bd0f97a0804020807o21f69b7due910563b9dad03e8@mail.gmail.com>
Date: Wed, 2 Apr 2008 11:07:11 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: nommu: handling anonymous mmap clearing in userspace rather than kernel
Cc: "David Howells" <dhowells@redhat.com>, "Greg Ungerer" <gerg@snapgear.com>,
       "David McCullough" <David_Mccullough@securecomputing.com>,
       LKML <linux-kernel@vger.kernel.org>, "Bryan Wu" <Bryan.Wu@analog.com>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
In-Reply-To: <47F3A02B.5070302@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>
	 <5516.1207146014@redhat.com>
	 <8bd0f97a0804020747r2d7c2802pa18cf08eced3821b@mail.gmail.com>
	 <47F3A02B.5070302@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 11:03 AM, Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> Mike Frysinger wrote:
> > On Wed, Apr 2, 2008 at 10:20 AM, David Howells <dhowells@redhat.com>
> > > Mike Frysinger <vapier.adi@gmail.com> wrote:
> > >  > a workaround: introduce a new no-mmu-only mmap flag MAP_UNINITIALIZE
> > >  > to signal to the kernel that it should skip the memset().  this way,
> > >  > userspace malloc() can do mmap(MAP_ANONYMOUS|MAP_UNINITIALIZE) to get
> > >  > large chunks of memory without affecting any other anonymous mmap()
> > >  > call.
> > >
> > >  I think that's reasonable for NOMMU.  It's not like the process
> accessing the
> > >  uninitialised memory is prevented from accessing anything it wants to
> anyway.
> > >
> > >  I would vote that the memset() should only be skipped if requested as
> there
> > >  may be programs that call mmap(MAP_ANONYMOUS) expecting the memory
> they're
> > >  given to be zeroed out.
> >
> > in the second proposal, the C library would be expected to do this, so
> > no programs would be broken.  but you're right that any program that
> > invokes the mmap() syscall directly would not get zeroed memory ...
> > but is anyone doing such a crazy thing, let alone on embedded ?
>
>  It's not a guarantee we should break.  What's wrong with just using the
> MAP_UNINITIALIZE code we have?

i outlined the benefits of doing it in userspace in my first e-mail.
i also expected MAP_UNINITIALIZE to be unacceptable to LKML.  and
afaik, there doesnt seem to be a way to distinguish in the kernel
whether the call is coming from userspace or kernel space, so the
memset() call will still be called for the kernel.  ideally the code
would read:
if (!kernel && !(flags & MAP_UNINITIALIZE))
    memset(base, 0, len);
-mike
