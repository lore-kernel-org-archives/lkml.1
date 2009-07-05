Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZGENTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZGENTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZGENTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:19:34 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:25021 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZGENTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ofenVYMMeEYSwTYOE317+L/Y1eQvGR0RxWwGI0i5/3qsO+YRVsbFfNTgQUz9JTg9S+
         +TpMz7hWA1FLzmTuX+pXEQKTLa4CKZ17VKzgqa34wpuPG0L6IFK2eihMi+alXZ0Jgj4b
         wzHrWIL6bEt9GH5yWNx4Vf36hNYWVnzP2yVBc=
Date: Sun, 5 Jul 2009 15:19:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5/5] perf report: Support callchains with relative
	overhead rate
Message-ID: <20090705131931.GA4912@nowhere>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com> <1246772361-9960-5-git-send-email-fweisbec@gmail.com> <20090705083400.GB12783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705083400.GB12783@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 10:34:00AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > The current callchain displays the overhead rates as absolute:
> > relative to the total overhead.
> > 
> > This patch provides relative overhead percentage, in which each
> > branch of the callchain tree is a independant instrumentated object.
> > 
> > You can produce such output by using the "relative" mode
> > that you can lower in r, re, rel, etc...
> > 
> > ./perf report -s sym -c relative
> > 
> > Example:
> > 
> >      8.46%  [k] copy_user_generic_string
> >                 |
> >                 |--52.01%-- generic_file_aio_read
> >                 |          do_sync_read
> >                 |          vfs_read
> >                 |          |
> >                 |          |--97.20%-- sys_pread64
> >                 |          |          system_call_fastpath
> >                 |          |          pread64
> >                 |          |
> >                 |           --2.81%-- sys_read
> >                 |                     system_call_fastpath
> >                 |                     __read
> >                 |
> >                 |--39.85%-- generic_file_buffered_write
> >                 |          __generic_file_aio_write_nolock
> >                 |          generic_file_aio_write
> >                 |          do_sync_write
> >                 |          reiserfs_file_write
> >                 |          vfs_write
> >                 |          |
> >                 |          |--97.05%-- sys_pwrite64
> >                 |          |          system_call_fastpath
> >                 |          |          __pwrite64
> >                 |          |
> >                 |           --2.95%-- sys_write
> >                 |                     system_call_fastpath
> >                 |                     __write_nocancel
> > [...]
> 
> Wow, this is extremely intuitive and powerful looking!
> 
> It's basically a fractal structure: each sub-graph looks like a 
> full-blown profile in itself. Thus the overhead of individual 
> components of the graph profile can be analyzed without having to 
> think in small numbers.
> 
> The above example shows it particularly well - it shows that in 
> regard to generic_file_buffered_write() overhead, the system is 
> doing 97% sys_pwrite64() calls and 3% sys_write() calls.
> 
> Thus i took the liberty to change your last patch in two ways: i 
> renamed 'relative' to 'fractal' (it was not a proper counterpart to 
> 'graph' anyway - we have no 'absolute' output mode name either), and 
> i changed it to be the default output mode. This stuff rocks!



Ok.

I first planned to add a submode, or more likely a parameter structured
like the following:

perf report -c layout,min,mode

where layout=flat|graph
and   mode=abs|rel

But relative flat doesn't make sense.
fractal is nice, it's just a pity that "graph" mode doesn't tell much
about it's absolute measure context.
 
> absolute-graph and flat mode can be displayed too, via the option, 
> as usual.
> 
> 	Ingo

