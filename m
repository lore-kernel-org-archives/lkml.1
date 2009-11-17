Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZKQQlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZKQQlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZKQQlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:41:49 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:64667 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZKQQls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kTkzW2qWm+/Q6/fITF1ISY8gq7FPS8LY0tc6NFCZC+6SfSFNEAsmPs57q275kE7zNT
         H+fXYv4M2bKfJtfKg0CMM+1oZGsg3PszszVtGdhbmzyBZLsmj+K6BmWla/5DbUdvLzzJ
         IvWEihVOcQIbYczING2qdM9oPSpm75+z41xlc=
MIME-Version: 1.0
In-Reply-To: <20091117074739.4abaef85@tlielax.poochiereds.net>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
	 <20091117162111.3DE8.A69D9226@jp.fujitsu.com>
	 <20091117074739.4abaef85@tlielax.poochiereds.net>
Date: Tue, 17 Nov 2009 10:41:54 -0600
Message-ID: <524f69650911170841p262ca2a6s8f2802f20d15a4f4@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: Don't use PF_MEMALLOC
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is hard to follow exactly what this flag does in /mm (other than
try harder on memory allocations) - I haven't found much about this
flag (e.g. http://lwn.net/Articles/246928/) but it does look like most
of the fs no longer set this (except xfs) e.g. ext3_ordered_writepage.
 When running out of memory in the cifs_demultiplex_thread it will
retry 3 seconds later, but if memory allocations ever fail in this
path we could potentially be holding up (an already issued write in)
writepages for that period by not having memory to get the response to
see if the write succeeded.

We pass in few flags for these memory allocation requests: GFP_NOFS
(on the mempool_alloc) and SLAB_HWCACHE_ALIGN (on the
kmem_cache_create of the pool) should we be passing in other flags on
the allocations?

On Tue, Nov 17, 2009 at 6:47 AM, Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 17 Nov 2009 16:22:32 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
> >
> > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> > memory, anyone must not prevent it. Otherwise the system cause
> > mysterious hang-up and/or OOM Killer invokation.
> >
> > Cc: Steve French <sfrench@samba.org>
> > Cc: linux-cifs-client@lists.samba.org
> > Cc: samba-technical@lists.samba.org
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  fs/cifs/connect.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 63ea83f..f9b1553 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -337,7 +337,6 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
> >       bool isMultiRsp;
> >       int reconnect;
> >
> > -     current->flags |= PF_MEMALLOC;
> >       cFYI(1, ("Demultiplex PID: %d", task_pid_nr(current)));
> >
> >       length = atomic_inc_return(&tcpSesAllocCount);
>
> This patch appears to be safe for CIFS. I believe that the demultiplex
> thread only does mempool allocations currently. The only other case
> where it did an allocation was recently changed with the conversion of
> the oplock break code to use slow_work.
>
> Barring anything I've missed...
>
> Acked-by: Jeff Layton <jlayton@redhat.com>



--
Thanks,

Steve
