Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbXBRUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbXBRUVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXBRUUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:20:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3851 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023AbXBRUUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:20:47 -0500
Date: Sun, 18 Feb 2007 20:01:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070218200145.GD3945@ucw.cz>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070214210251.GA15025@elte.hu> <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org> <20070214215613.56d76257@localhost.localdomain> <20070214223216.GA7616@elte.hu> <Pine.LNX.4.64.0702141656240.7796@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702141721560.7796@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141721560.7796@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The upcall will setup a frame, execute the clet (where jump/conditions and 
> > userspace variable changes happen in machine code - gcc is pretty good in 
> > taking care of that for us) on its return, come back through a 
> > sys_async_return, and go back to userspace.
> 
> So, for example, this is the setup code for the current API (and that's a 
> really simple one - immagine going wacko with loops and userspace varaible 
> changes):
> 
> 
> static struct req *alloc_req(void)
> {
>         /*
>          * Constants can be picked up by syslets via static variables:
>          */
>         static long O_RDONLY_var = O_RDONLY;
>         static long FILE_BUF_SIZE_var = FILE_BUF_SIZE;
>                 
>         struct req *req;
>                  
>         if (freelist) {
>                 req = freelist;
>                 freelist = freelist->next_free;
>                 req->next_free = NULL;
>                 return req;
>         }
>                         
>         req = calloc(1, sizeof(struct req));
>  
>         /*
>          * This is the first atom in the syslet, it opens the file:
>          *
>          *  req->fd = open(req->filename, O_RDONLY);
>          *
>          * It is linked to the next read() atom.
>          */
>         req->filename_p = req->filename;
>         init_atom(req, &req->open_file, __NR_sys_open,
>                   &req->filename_p, &O_RDONLY_var, NULL, NULL, NULL, NULL,
>                   &req->fd, SYSLET_STOP_ON_NEGATIVE, &req->read_file);
>         
>         /*
>          * This second read() atom is linked back to itself, it skips to
>          * the next one on stop:
>          */
>         req->file_buf_ptr = req->file_buf;
>         init_atom(req, &req->read_file, __NR_sys_read,
>                   &req->fd, &req->file_buf_ptr, &FILE_BUF_SIZE_var,
>                   NULL, NULL, NULL, NULL,
>                   SYSLET_STOP_ON_NON_POSITIVE | SYSLET_SKIP_TO_NEXT_ON_STOP,
>                   &req->read_file);
>                 
>         /*
>          * This close() atom has NULL as next, this finishes the syslet:
>          */
>         init_atom(req, &req->close_file, __NR_sys_close,
>                   &req->fd, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL);
>                 
>         return req;
> }
> 
> 
> Here's how your clet would look like:
> 
> static long main_sync_loop(ctx *c)
> {
>         int fd;
>         char file_buf[FILE_BUF_SIZE+1];
>         
>         if ((fd = open(c->filename, O_RDONLY)) == -1)
>                 return -1;
>         while (read(fd, file_buf, FILE_BUF_SIZE) > 0)
>                 ;
>         close(fd);
>         return 0;
> }
> 
> 
> Kinda easier to code isn't it? And the cost of the upcall to schedule the 
> clet is widely amortized by the multple syscalls you're going to do inside 
> your clet.

I do not get it. What if clet includes

int *a = 0; *a = 1; /* enjoy your oops, stupid kernel? */

I.e. how do you make sure kernel is protected from malicious clets?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
