Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbXKGQKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbXKGQKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXKGQKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:10:00 -0500
Received: from goliath.siemens.de ([192.35.17.28]:16290 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbXKGQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:09:59 -0500
X-Greylist: delayed 2155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 11:09:59 EST
Message-ID: <4731DAFE.3080509@siemens.com>
Date: Wed, 07 Nov 2007 16:34:22 +0100
From: "Hillier, Gernot" <gernot.hillier@siemens.com>
Organization: Siemens AG, CT SE 2
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: current status of Async I/O (io_submit & friends) on pipes
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is the content of http://lse.sourceforge.net/io/aio.html still correct
regarding support of pipes? Is there any up-to-date & authoritative
interface description of io_submit & friends available?

This page tells me I'd receive EINVAL or the like when using async I/O
on a pipe; however what I actually see on e.g. 2.6.23.1 is no error
return, but an indefinite blocking in the io_submit syscall when the
pipe is empty.

Is this expected behaviour?

Please put me on CC for any answer.

Here's a short snippet showing the behaviour. (link it against libaio -
yes, I checked that libaio does nothing else than wrapping the syscalls).

------ SNIP -----

#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <libaio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main() {
        int filedes[2];
        char buf;
        io_context_t *ctx;
        struct iocb * cb;

        ctx=(io_context_t *)malloc(sizeof(io_context_t));
        memset(ctx,0,sizeof(io_context_t));
        cb=(struct iocb *)malloc(1*sizeof(struct iocb));
        memset(cb,0,1*sizeof(struct iocb));

        pipe(filedes);

        cb[0].aio_lio_opcode=IO_CMD_PREAD;
        cb[0].aio_fildes=filedes[0];
        cb[0].u.c.buf=&buf;
        cb[0].u.c.nbytes=1;

        printf("before read\n");
	/* program will block here */
        printf("io_submit %i\n",io_submit(*ctx,1,&cb));
        printf("read completed\n");
}

-- 
Gernot Hillier

Siemens AG, CT SE 2
Corporate Competence Center Embedded Linux

