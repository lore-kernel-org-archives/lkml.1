Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbXE1IHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbXE1IHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbXE1IGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:06:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXE1IGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:06:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Mon, 28 May 2007 09:59:36 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200705261128.57332.maxi@daemonizer.de> <200705272327.23291.rjw@sisk.pl> <200705280222.02198.maxi@daemonizer.de>
In-Reply-To: <200705280222.02198.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705280959.37516.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 02:21, Maximilian Engelhardt wrote:
> On Sunday 27 May 2007, Rafael J. Wysocki wrote:
> > On Sunday, 27 May 2007 22:41, Maximilian Engelhardt wrote:
> > > On Sunday 27 May 2007, Rafael J. Wysocki wrote:
> > > > On Sunday, 27 May 2007 18:01, Maximilian Engelhardt wrote:
> > > > > On Saturday 26 May 2007, Nigel Cunningham wrote:
> > > > > > Hi.
> > > > > >
> > > > > > On Sat, 2007-05-26 at 14:49 +0200, Maximilian Engelhardt wrote:
> > > > > > > On Saturday 26 May 2007, Nigel Cunningham wrote:
> > > > > > > > Hi.
> > > > > > > >
> > > > > > > > On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhardt wrote:
> > > > > > > > > Hello,
> > > > > > > > >
> > > > > > > > > When I try software suspend on my laptop it always returns to
> > > > > > > > > my running system after some time.
> > > > > > > > > This is what's logged by the kernel:
> > > > > > > > >
> > > > > > > > > swsusp: Basic memory bitmaps created
> > > > > > > > > Stopping tasks ...
> > > > > > > > > Stopping kernel threads timed out after 20 seconds (1 tasks
> > > > > > > > > refusing to freeze):
> > > > > > > > >  cryptd
> > > > > > > > > Restarting tasks ... done.
> > > > > > > > > swsusp: Basic memory bitmaps freed
> > > > > > > > >
> > > > > > > > > I have no idea what's the problem, but if you tell me what I
> > > > > > > > > should do I can create debugging information and/or test
> > > > > > > > > patches.
> > > > > > > >
> > > > > > > > Could you try this patch, please? It should help.
> > > > > > > >
> > > > > > > > Herbert, is this right? If cryptd is going to be used for block
> > > > > > > > devs, the task should probably be PF_NOFREEZE (or whatever it
> > > > > > > > is today) instead.
> > > > > > > >
> > > > > > > > Regards,
> > > > > > > >
> > > > > > > > Nigel
> > > > > > > >
> > > > > > > >  crypto/cryptd.c         |    1 +
> > > > > > > >  include/linux/freezer.h |    3 +++
> > > > > > > >  kernel/power/process.c  |    2 +-
> > > > > > > >  3 files changed, 5 insertions(+), 1 deletion(-)
> > > > > > > > diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c
> > > > > > > > 991-fix-cryptd.patch-new/crypto/cryptd.c ---
> > > > > > > > 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19
> > > > > > > > 18:16:47.000000000 +1000 +++
> > > > > > > > 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26
> > > > > > > > 19:45:42.000000000 +1000 @@ -341,6 +341,7 @@ static int
> > > > > > > > cryptd_thread(void *data)
> > > > > > > >
> > > > > > > >  		mutex_unlock(&state->mutex);
> > > > > > > >
> > > > > > > > +		try_to_freeze();
> > > > > > > >  		schedule();
> > > > > > > >  	} while (!stop);
> > > > > > >
> > > > > > > I tried your patch, but when I apply it my kernel doesn't compile
> > > > > > > any more. I get these warnings/errors:
> > > > > > >
> > > > > > > [...]
> > > > > > >   CC      crypto/cryptd.o
> > > > > > > crypto/cryptd.c: In function ‘cryptd_thread’:
> > > > > > > crypto/cryptd.c:344: warning: implicit declaration of function
> > > > > > > ‘try_to_freeze’ [...]
> > > > > > >   LD      init/built-in.o
> > > > > > >   LD      .tmp_vmlinux1
> > > > > > > crypto/built-in.o: In function `cryptd_thread':
> > > > > > > cryptd.c:(.text+0xd7f5): undefined reference to `try_to_freeze'
> > > > > > > make: *** [.tmp_vmlinux1] Error 1
> > > > > >
> > > > > > Ah. You'll need to add #include <linux/freezer.h> near that start
> > > > > > of crypto/cryptd.c. Sorry for forgetting that.
> > > > > >
> > > > > > Nigel
> > > > >
> > > > > I added the include line and now I could compile the kernel, but
> > > > > suspending still doesn't work.
> > > > >
> > > > > swsusp: Basic memory bitmaps created
> > > > > Stopping tasks ...
> > > > > Stopping kernel threads timed out after 20 seconds (1 tasks refusing
> > > > > to freeze):
> > > > > cryptd
> > > > > Restarting tasks ... done.
> > > > > swsusp: Basic memory bitmaps freed
> > > >
> > > > OK, this means that cryptd doesn't execute the try_to_freeze() for some
> > > > reason.
> > > >
> > > > Please apply the appended patch on top of 2.6.22-rc3 and see if that
> > > > helps.
> > > >
> > > > Greetings,
> > > > Rafael
> > > >
> > > > ---
> > > >  crypto/cryptd.c |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > Index: linux-2.6.22-rc3/crypto/cryptd.c
> > > > ===================================================================
> > > > --- linux-2.6.22-rc3.orig/crypto/cryptd.c
> > > > +++ linux-2.6.22-rc3/crypto/cryptd.c
> > > > @@ -316,6 +316,7 @@ static int cryptd_thread(void *data)
> > > >  	struct cryptd_state *state = data;
> > > >  	int stop;
> > > >
> > > > +	current->flags |= PF_NOFREEZE;
> > > >  	do {
> > > >  		struct crypto_async_request *req, *backlog;
> > >
> > > Even with this patch suspending doesn't work, dmesg shows the same error
> > > message.
> > > I also did build a kernel without cryptd and suspending does work there.
> >
> > Well, that's strange, because in that case the freezer shouldn't even wait
> > for cryptd.
> >
> > Can you please try the patch at http://lkml.org/lkml/2007/5/26/169 ?
> 
> With this patch applied suspend does work fine.

Hmm.  IMO the patch is too intrusive for 2.6.22, but OTOH it's going into the
direction preferred by some prominent people. ;-)

Let's try to combine the two threads and see what results from that.

Greetings,
Rafael
