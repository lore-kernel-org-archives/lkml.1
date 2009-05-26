Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZEZVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZEZVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZEZVJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:09:21 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:11642 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZEZVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:09:21 -0400
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <878wkjobbm.fsf@basil.nowhere.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	 <878wkjobbm.fsf@basil.nowhere.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Tue, 26 May 2009 17:09:16 -0400
Message-Id: <1243372156.7369.119.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 22:31 +0200, Andi Kleen wrote:
> Paul Smith <paul@mad-scientist.net> writes:
> > Well, -512 is ERESTARTSYS.  That, to me, seems like a reasonable error
> > code to get when we're trying to dump core to a pipe.  Yes?  No?
> 
> Which signal is it? SIGPIPE?

I'm not sure; I'll have to dig in a little further.  I'm not sure
offhand how to determine which signal it was from inside the kernel but
it shouldn't be hard to find.

> >
> > Shouldn't we be doing some kind of error handling here, at least for
> > basic things like signals?  Should a process that's dumping core be set
> > to ignore signals?  Should dump_write() try again on ERESTARTSYS?
> 
> I think it should block signals. Here's a untested patch.
> 
> It has the disadvantage that it reports the incorrect blocked mask
> in the ELF corefile, but that's probably better than truncated 
> coredumps.

As a quick test I changed dump_write() to retry on ERESTARTSYS after
disabling the pending signal, like:

        static int dump_write(struct file *file, const void *addr, int nr)
        {
                while (1) {
                        int r = file->f_op->write(file, addr, nr, &file->f_pos);
                        if (r != -ERESTARTSYS)
                                return r == nr;
        
                        /* We don't handle signals while dumping core. */
                        clear_thread_flag(TIF_SIGPENDING);
                }
        }

I don't know if this is right, but in some quick tests I ran it did
work: my cores were full size.  I haven't finished testing (and I have
to go to soccer practice right now).

This obviously doesn't reset the signal mask in the dumping process, but
it makes the dump_write() more complex and it may cause other issues so
I can't say whether this is the way to go.

> -
> Block signals during core dump

Cool, I'll test this one as well.

