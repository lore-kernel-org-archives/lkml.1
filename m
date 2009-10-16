Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZJPDdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZJPDdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 23:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZJPDdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 23:33:38 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:39093 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbZJPDdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 23:33:37 -0400
Message-ID: <4AD7E928.9000701@agilent.com>
Date: Thu, 15 Oct 2009 20:31:52 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: fs/pipe.c null pointer dereference
References: <4AD5D476.6010103@agilent.com> <200910141653.03611.elendil@planet.nl> <4AD655C0.2030202@agilent.com>
In-Reply-To: <4AD655C0.2030202@agilent.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 03:31:54.0523 (UTC) FILETIME=[35117EB0:01CA4E11]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earl Chew wrote:
 > I have given the matter more thought, and I believe it is unlikely
 > that the problem is in fs/fifo.c. As outlined in my previous
 > email, the code looks ok.

I notice that the other place the rdwr_pipe_fops is set up is:

 > static struct inode * get_pipe_inode(void)
 > {
 >        ...
 >         inode->i_fop = &rdwr_pipe_fops;
 >

and that get_pipe_inode() is called from:

 > struct file *create_write_pipe(void)
 > {
 >        ...
 >         inode = get_pipe_inode();
 >         if (!inode)
 >                 goto err_file;

and that is called from do_pipe():

 > int do_pipe(int *fd)
 > {
 >        ...
 >         fw = create_write_pipe();
 >         if (IS_ERR(fw))
 >                 return PTR_ERR(fw);
 >         fr = create_read_pipe(fw);
 >         error = PTR_ERR(fr);
 >         if (IS_ERR(fr))
 >                 goto err_write_pipe;


... and do_pipe() is called from many places.


The stack trace I have shows:

 > Call Trace:
 > [<ffffffff802899a5>] pipe_rdwr_open+0x35/0x70
 > [<ffffffff8028125c>] __dentry_open+0x13c/0x230
 > [<ffffffff8028143d>] do_filp_open+0x2d/0x40
 > [<ffffffff802814aa>] do_sys_open+0x5a/0x100
 > [<ffffffff8021faf3>] sysenter_do_call+0x1b/0x67


How can it be possible that sys_open (ie open(2)) can get hold
of an inode whose i_fop->open() points at pipe_rdwr_open() ?

Is this possible via /proc/pid/fd/* ?

Yes, it looks likely:

> { echo y ; sleep 1 ; } | { while read ; do echo z$REPLY; done ; } &
> PID=$!
> OUT=$(ps -efl | grep 'sleep 1' | grep -v grep)
> OUT=${OUT%% *}
> echo n > /proc/$OUT/fd/1

This test prints zy and zn indicating that the 2nd echo was able
to open the writing end of the pipe and inject another character.

Earl


