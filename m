Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYJKE7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYJKE7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 00:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYJKE7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 00:59:00 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:36176
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbYJKE7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 00:59:00 -0400
X-Authority-Analysis: v=1.0 c=1 a=AE1oZuSjHPYA:10 a=4XX46gVHXKYA:10
 a=VwQbUJbxAAAA:8 a=tC0oqZoBfkweKGONl7gA:9 a=a2rwYzTo0j1OiSShSIgA:7
 a=Z84D4FfFpf8D30FLlGHSMCAEBaUA:4 a=WuK_CZDBSqoA:10
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Tom Zanussi <zanussi@comcast.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <1223631723.8959.46.camel@penberg-laptop>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 23:58:51 -0500
Message-Id: <1223701131.7489.25.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-10-10 at 12:42 +0300, Pekka Enberg wrote:
> (I'm cc'ing Tom, Jens, and LKML.)
> 
> On Fri, 2008-10-10 at 12:10 +0300, Pekka Enberg wrote:
> > > I'm seeing a hard lock on my machine when I run kmemtraced with the
> > > following patch applied:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=17ca1d5506b1db433f0b7167a627bfd55d319dd3
> > > 
> > > I can enable/disable kmemtrace via the debugfs files fine and can also
> > > read the relay files with cat.
> > > 
> > > Any idea where this is coming from?
> > 
> > OK, it's the first splice() call in reader_thread() that causes the
> > hang. Hmm.
> 
> To recap, with a CONFIG_KMEMTRACE enabled kernel from the
> "topic/kmemtrace" branch of:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git topic/kmemtrace
> 
> running the "kmemtraced" program from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/kmemtrace-user.git
> 
> results to a hard lock on my machine. I am unable to find anything
> obviously wrong with it and as I can read/write the relay files just
> fine, I'm beginning to think it's problem in relayfs splice
> implementation.
> 
> Tom, thoughts?
> 

It looks like you hit the same problem as described here:

commit 8191ecd1d14c6914c660dfa007154860a7908857

    splice: fix infinite loop in generic_file_splice_read()

relay uses the same loop but it never got noticed or fixed.  Can you try
the following patch:

diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..6a4d439 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1318,12 +1318,9 @@ static ssize_t relay_file_splice_read(struct file *in,
 		if (ret < 0)
 			break;
 		else if (!ret) {
-			if (spliced)
-				break;
-			if (flags & SPLICE_F_NONBLOCK) {
+			if (flags & SPLICE_F_NONBLOCK)
 				ret = -EAGAIN;
-				break;
-			}
+			break;
 		}
 
 		*ppos += ret;


It worked for me, but I also had to apply the following patch to
kmemtraced:

diff --git a/kmemtraced.c b/kmemtraced.c
index 217478d..324ced9 100644
--- a/kmemtraced.c
+++ b/kmemtraced.c
@@ -109,6 +109,8 @@ static void *reader_thread(void *data)
 		if (retval < 0)
 			panic("splice() (from) failed: %s\n",
 			      strerror(errno));
+		if (!retval)
+			continue;
 		retval = splice(pipe_fd[0], NULL, log_fd, NULL,
 				128, SPLICE_F_MOVE);
 		if (retval < 0)


Otherwise it would end up hanging kmemtraced in the second splice (pipe
to log_fd) if the return from the first splice was 0 (i.e. there's no
data available (and we can never know if there will ever be any
more)).

I'm not sure why kmemtraced is only splicing 128 bytes at a time - it
seems to defeat the purpose - or why it wouldn't be using poll to know
when there's at least a whole sub-buffer to splice, but to each his own.
Hopefully the kernel patch at least fixes the loop. 

Tom



