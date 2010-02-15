Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0BORua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 12:50:30 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45588 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0BORu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:50:28 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 15 Feb 2010 09:50:22 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stephane.thiell@cea.fr
Subject: Re: [patch/rfc] Make poll/select report error (POLLNVAL and EBADF)
 for unsupported files
In-Reply-To: <1266255759.8262.26.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1002150945460.7390@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.1002141403240.18795@makko.or.mcafeemobile.com> <1266255759.8262.26.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-22440617-1266256226=:7390"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-22440617-1266256226=:7390
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 15 Feb 2010, Eric Dumazet wrote:

> Le dimanche 14 février 2010 à 14:27 -0800, Davide Libenzi a écrit :
> > Currently poll and select consider a non poll-supported file as one with 
> > full event mask set, instead of reporting proper error to the caller.
> > This behavior can fool the caller of proper functionality being returned, 
> > while instead no valid event was processed/read from the device.
> > This came out linked to this bug report:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=15272
> > 
> > IMHO, it'd be more adequate to report proper error code, for files that do 
> > not support f_op->poll(), but then I am also not sure how much breakage 
> > can this bring to existing (already broken "in just the right way") 
> > applications.
> > Untested, discussion-only, patch.
> > 
> > 
> > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> > 
> > 
> > - Davide
> 
> Hmm, according to POSIX :
> 
> 	The poll() function shall support regular files, terminal and
> pseudo-terminal devices, FIFOs, pipes, sockets ...
> 
> 	Regular files shall always poll TRUE for reading and writing.
> 
> 
> So unless I missed something, this patch could break some conformant
> applications.

If that's POSIX, than the patch is no good.  I missed the part on the 
regular files being always ready, which explaqins why the code is as it is 
right now.


> In particular, if an application is polling() on stdin (usually a tty),
> and other 'files', what's happening if we do :
> 
> cat replay_file | application
> 
> Either it wont read stdin, or application exits without reading its
> input.

That case would be fine, since that's a pipe.
This will behave differently:

$ application < replay_file

Anyway, since POSIX states the above, the patch cannot apply.


- Davide


--8323329-22440617-1266256226=:7390--
