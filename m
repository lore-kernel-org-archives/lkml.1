Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbXJATFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbXJATFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbXJATFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:05:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:60422 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXJATFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:05:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 1 Oct 2007 12:04:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Al Viro <viro@ftp.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
In-Reply-To: <200710011949.03482.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710011158390.25942@alien.or.mcafeemobile.com>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
 <200710011107.15846.vda.linux@googlemail.com> <20071001181648.GB8181@ftp.linux.org.uk>
 <200710011949.03482.vda.linux@googlemail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Denys Vlasenko wrote:

> On Monday 01 October 2007 19:16, Al Viro wrote:
> > 	* it's on a bunch of cyclic lists.  Have its neighbor
> > go away while you are doing all that crap => boom
> > 	* there's that thing call current position...  It gets buggered.
> > 	* overwriting it while another task might be in the middle of
> > syscall involving it => boom
> 
> Hm, I suspected that it's herecy. Any idea how to do it cleanly?
> 
> > 	* non-cooperative tasks reading *in* *parallel* from the same
> > opened file are going to have a lot more serious problems than agreeing
> > on O_NONBLOCK anyway, so I really don't understand what the hell is that for.
> 
> They don't even need to read in parallel, just having shared fd is enough.
> Think about pipes, sockets and terminals. A real-world scenario:
> 
> * a process started from shell (interactive or shell script)
> * it sets O_NONBLOCK and does a read from fd 0...
> * it gets killed (kill -9, whatever)
> * shell suddenly has it's fd 0 in O_NONBLOCK mode
> * shell and all subsequent commands started from it unexpectedly have
>   O_NONBLOCKed stdin.

I told you how in the previous email. You cannot use the:

1) set O_NONBLOCK
2) read/write
3) unset O_NONBLOCK

in a racy-free fashion, w/out wrapping it with a lock (thing that we 
don't want to do).



PS: send/recv are socket functions, and you really don't want to overload 
    them for other fds.



- Davide


