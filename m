Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbXFCX4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbXFCX4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 19:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXFCX4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 19:56:10 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:65473 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXFCX4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 19:56:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18019.21781.470399.393340@stoffel.org>
Date: Sun, 3 Jun 2007 19:56:05 -0400
From: "John Stoffel" <john@stoffel.org>
To: "Aaron Wiebe" <epiphani@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
In-Reply-To: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Aaron" == Aaron Wiebe <epiphani@gmail.com> writes:

More details on which kernel you're using and which distro would be
helpful.  Also, more details on your App and reasons why you're
writing bunches of small files would help as well. 

Aaron> Greetings all.  I'm not on this list, so I apologize if this subject
Aaron> has been covered before.  (Also, please cc me in the response.)

Aaron> I've spent the last several months trying to work around the lack of a
Aaron> decent disk AIO interface.  I'm starting to wonder if one exists
Aaron> anywhere.  The short version:

Aaron> I have written a daemon that needs to open several thousand
Aaron> files a minute and write a small amount of data to each file.

How large are these files?  Are they all in a single directory?  How
many files are in the directory? 

Ugh. Why don't you just write to a DB instead?  It sounds like you're
writing small records, with one record to a file.  It can work, but
when you're doing thousands per-minute, the open/close overhead is
starting to dominate.  Can you just amortize that overhead across a
bunch of writes instead by writing to a single file which is more
structured for your needs?  

Aaron> After extensive research, I ended up going with the POSIX AIO
Aaron> kludgy pthreads wrapper in glibc to handle my writes due to the
Aaron> time constraints of writing my own pthreads handler into the
Aaron> application.

Aaron> The problem with this equation is that opens, closes and
Aaron> non-readwrite operations (fchmod, fcntl, etc) have no interface
Aaron> in posix aio.  Now I was under the assumption that given open
Aaron> and close operations are comparatively less common than the
Aaron> write operations, this wouldn't be a huge problem.  My tests
Aaron> seemed to reflect that.

Aaron> I went to production with this yesterday to discover that under
Aaron> production load, our filesystems (nfs on netapps) were
Aaron> substantially slower than I was expecting.  open() calls are
Aaron> taking upwards of 2 seconds on occation, and usually ~20ms.

Netapps usually scream for NFS writes and such, so it sounds to me
that you've blown out the NVRAM cache on the box.  Can you elaborate
more on your hardware & Network & Netapp setup?  

Of course, you could also be using sucky NFS configuration, so we need
to see your mount options as well.  You are using TCP and NFSv3,
right?  And a large wsize/rsize values too?  

Have you also checked your NetApp to make sure you have the following
options turned OFF:

	nfs.per_client_stats.enable
	nfs.mountd_trace
	
Seeing your exports file and output of 'options nfs' would help.

Aaron> Now, Netapp speed aside, O_NONBLOCK and O_DIRECT seem to make
Aaron> zero difference to my open times.  Example:

Aaron> open("/somefile", O_WRONLY|O_NONBLOCK|O_CREAT, 0644) = 1621 <0.415147>

Aaron> Now, I'm a userspace guy so I can be pretty dense, but
Aaron> shouldn't a call with a nonblocking flag return EAGAIN if its
Aaron> going to take anywhere near 415ms?  Is there a way I can force
Aaron> opens to EAGAIN if they take more than 10ms?

The problem is that O_NONBLOCK on files open doesn't make sense.  You
either open it, or you don't.  How long it takes to comlete isn't part
of the spec.

But in this case, I think you're doing something hokey with your data
design.  You should be opening just a handful of files and then
streaming your writes to those files.   You'll get much more
performance.

Also, have you tried writing to a local disk instead of via NFS to see
how local disk speed is?  

Aaron> (ps.  having come from the socket side of the fence, its
Aaron> incredibly frustrating to be unable to poll() or epoll regular
Aaron> file FDs -- Especially knowing that the kernel is translating
Aaron> them into a TCP socket to do NFS anyway.  Please add regular
Aaron> files to epoll and give me a way to do the opens in the same
Aaron> fasion as connects!)

epoll isn't going to help you much here, it's the open which is
causing the delay, not the writing to the file itself.

Maybe you need to be caching more of your writes into memory on the
client side, and then streaming them to the NetApp later on when you
know you can write a bunch of data at once.

But honestly, I think you've done a bad job architecting your
application's backend data store and you really need to re-think it
through.  

Heck, I'm not even much of a programmer, I'm a SysAdmin who runs
Netapps and talks the users into more sane ways of getting better
performance out of their applications.  *grin*.

John
