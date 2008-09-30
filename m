Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYI3JFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYI3JFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYI3JEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:04:52 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33062 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYI3JEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:04:52 -0400
Date: Tue, 30 Sep 2008 11:04:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Tom Zanussi <zanussi@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Subject: Re: [RFC PATCH 7/11] relay - Remove padding-related code from relay_read()/relay_splice_read() et al.
Message-ID: <20080930090433.GD2677@kernel.dk>
References: <1222666828.7637.180.camel@charm-linux> <20080929162743.GA15472@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929162743.GA15472@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29 2008, Mathieu Desnoyers wrote:
> * Tom Zanussi (zanussi@comcast.net) wrote:
> > Remove padding-related code from relay_read()/relay_splice_read() et al.
> > 
> > Because we no longer write padding, we no longer have to read it or
> > account for it anywhere else, greatly simplifying the related code.
> > 
> > Signed-off-by: Tom Zanussi <zanussi@comcast.net>
> > 
> 
> Hi Tom,
> 
> This question might sound a bit dumb, but I'll ask anyway : why do you
> implement a splice_read rather than a splice_write in relay ?
> 
> splice_read allows reading information from a file or from a socket to a
> pipe, while splice_write does the opposite.
> 
> So if you implement a relay splice_read, you probably consider the
> relay buffers to be a "file", so you really have to send the information
> to a pipe, and then you have to use this pipe to send the data
> elsewhere.
> 
> My first reaction when looking at the splice implementation is that what
> we would really want is a splice_write which would take the data from a
> pipe (actually, we would have to write an actor which would make the
> relay buffer behave like a pipe) and write it either to disk or to a
> socket.

I don't understand where you are going with this... With the
->splice_read(), we can move relay data into a pipe and pass that to a
user application (or send it off using sendfile() or splice to a
socket). So it's a way to get the data to user space, instead of using
read().

With a ->splice_write(), you could support adding data to relayfs from
userspace. Why? You want the ->splice_write() on the output end, for
your socket or file or wherever you want to send to relay data TO.

So as long as your model is that the kernel produces data and the user
app consumes them, you need the ->splice_read() and not a
->splice_write().

> Is there something I am misunderstanding here ?

I think so :-)

-- 
Jens Axboe

