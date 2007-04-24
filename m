Return-Path: <linux-kernel-owner+w=401wt.eu-S1161159AbXDXATv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161159AbXDXATv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030937AbXDXATv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:19:51 -0400
Received: from thunk.org ([69.25.196.29]:60123 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030839AbXDXATv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:19:51 -0400
Date: Mon, 23 Apr 2007 20:19:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Hopper <hopper@omnifarious.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
Message-ID: <20070424001934.GC1663@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Hopper <hopper@omnifarious.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <462C4858.3050006@redhat.com> <Pine.LNX.4.64.0704230555020.25153@server.thyself> <462C4D32.4000909@redhat.com> <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com> <Pine.LNX.4.64.0704230640540.25153@server.thyself> <20070423010445.454eda63.akpm@linux-foundation.org> <20070423135216.GA2744@omnifarious.org> <20070423225640.GA1663@thunk.org> <462D46DF.4090802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462D46DF.4090802@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 04:53:03PM -0700, H. Peter Anvin wrote:
> Theodore Tso wrote:
> >
> >One of the big problems of using a filesystem as a DB is the system
> >call overheads.  If you use huge numbers of tiny files, then each
> >attempt read an atom of information from the DB takes three system
> >calls --- an open(), read(), and close(), with all of the overheads in
> >terms of dentry and inode cache.
> >
> 
> Now, to be fair, there are probably a number of cases where 
> open/lseek/readv/close and open/lseek/writev/close would be worth doing 
> as a single system call.  The big problem as far as I can see involves 
> EINTR handling; such a system call has serious restartability implications.

Sure, but Hans wants to change /etc/inetd.conf into /etc/inetd.conf.d,
where you have: /etc/inetd.conf.d/telnet/port,
/etc/inetd.conf.d/telnet/protocol, /etc/inetd.conf.d/telnet/wait,
/etc/inetd.conf.d/telnet/userid, /etc/inetd.conf.d/telnet/daemon,
etc. for each individual line in /etc/inetd.conf.  (And where each
file might only contains 2-4 characters each: i.e., "23", "tcp",
"root", etc.)

So it's not enough just to collapse open/pread/close into a single
system call; in order to gain back the performance squandered by all
of these itsy-bitsy tiny little files.  You want to collapse the
open/pread/close for many of these little files into a single system
call, hence Hans's insistence on sys_reiser4(); otherwise his scheme
doesn't work all that well at all.

						- Ted

