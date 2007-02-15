Return-Path: <linux-kernel-owner+w=401wt.eu-S1751231AbXBOB3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbXBOB3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXBOB3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:29:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3910 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbXBOB27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:28:59 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 17:28:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Alan <alan@lxorguk.ukuu.org.uk>,
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
In-Reply-To: <Pine.LNX.4.64.0702141656240.7796@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702141721560.7796@alien.or.mcafeemobile.com>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070214210251.GA15025@elte.hu> <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org>
 <20070214215613.56d76257@localhost.localdomain> <20070214223216.GA7616@elte.hu>
 <Pine.LNX.4.64.0702141656240.7796@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Davide Libenzi wrote:

> On Wed, 14 Feb 2007, Ingo Molnar wrote:
> 
> > yeah, that's another key thing. I do plan to provide a sys_upcall() 
> > syscall as well which calls a 5-parameter user-space function with a 
> > special stack. (it's like a lightweight signal/event handler, without 
> > any of the signal handler legacies and overhead - it's like a reverse 
> > system call - a "user call". Obviously pure userspace would never use 
> > sys_upcall(), unless as an act of sheer masochism.)
> 
> That is exactly what I described as clets. Instead of having complex jump 
> and condition interpreters on the kernel (on top of new syscalls to 
> modify/increment userspace variables), you just code it in C and you pass 
> the clet pointer to the kernel.
> The upcall will setup a frame, execute the clet (where jump/conditions and 
> userspace variable changes happen in machine code - gcc is pretty good in 
> taking care of that for us) on its return, come back through a 
> sys_async_return, and go back to userspace.

So, for example, this is the setup code for the current API (and that's a 
really simple one - immagine going wacko with loops and userspace varaible 
changes):


static struct req *alloc_req(void)
{
        /*
         * Constants can be picked up by syslets via static variables:
         */
        static long O_RDONLY_var = O_RDONLY;
        static long FILE_BUF_SIZE_var = FILE_BUF_SIZE;
                
        struct req *req;
                 
        if (freelist) {
                req = freelist;
                freelist = freelist->next_free;
                req->next_free = NULL;
                return req;
        }
                        
        req = calloc(1, sizeof(struct req));
 
        /*
         * This is the first atom in the syslet, it opens the file:
         *
         *  req->fd = open(req->filename, O_RDONLY);
         *
         * It is linked to the next read() atom.
         */
        req->filename_p = req->filename;
        init_atom(req, &req->open_file, __NR_sys_open,
                  &req->filename_p, &O_RDONLY_var, NULL, NULL, NULL, NULL,
                  &req->fd, SYSLET_STOP_ON_NEGATIVE, &req->read_file);
        
        /*
         * This second read() atom is linked back to itself, it skips to
         * the next one on stop:
         */
        req->file_buf_ptr = req->file_buf;
        init_atom(req, &req->read_file, __NR_sys_read,
                  &req->fd, &req->file_buf_ptr, &FILE_BUF_SIZE_var,
                  NULL, NULL, NULL, NULL,
                  SYSLET_STOP_ON_NON_POSITIVE | SYSLET_SKIP_TO_NEXT_ON_STOP,
                  &req->read_file);
                
        /*
         * This close() atom has NULL as next, this finishes the syslet:
         */
        init_atom(req, &req->close_file, __NR_sys_close,
                  &req->fd, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL);
                
        return req;
}


Here's how your clet would look like:

static long main_sync_loop(ctx *c)
{
        int fd;
        char file_buf[FILE_BUF_SIZE+1];
        
        if ((fd = open(c->filename, O_RDONLY)) == -1)
                return -1;
        while (read(fd, file_buf, FILE_BUF_SIZE) > 0)
                ;
        close(fd);
        return 0;
}


Kinda easier to code isn't it? And the cost of the upcall to schedule the 
clet is widely amortized by the multple syscalls you're going to do inside 
your clet.




- Davide


