Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbXE0SOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbXE0SOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 14:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXE0SOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 14:14:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXE0SN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 14:13:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Sun, 27 May 2007 20:19:07 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200705261128.57332.maxi@daemonizer.de> <1180215220.5493.36.camel@nigel.suspend2.net> <200705271801.30119.maxi@daemonizer.de>
In-Reply-To: <200705271801.30119.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705272019.08860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 May 2007 18:01, Maximilian Engelhardt wrote:
> On Saturday 26 May 2007, Nigel Cunningham wrote:
> > Hi.
> >
> > On Sat, 2007-05-26 at 14:49 +0200, Maximilian Engelhardt wrote:
> > > On Saturday 26 May 2007, Nigel Cunningham wrote:
> > > > Hi.
> > > >
> > > > On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhardt wrote:
> > > > > Hello,
> > > > >
> > > > > When I try software suspend on my laptop it always returns to my
> > > > > running system after some time.
> > > > > This is what's logged by the kernel:
> > > > >
> > > > > swsusp: Basic memory bitmaps created
> > > > > Stopping tasks ...
> > > > > Stopping kernel threads timed out after 20 seconds (1 tasks refusing
> > > > > to freeze):
> > > > >  cryptd
> > > > > Restarting tasks ... done.
> > > > > swsusp: Basic memory bitmaps freed
> > > > >
> > > > > I have no idea what's the problem, but if you tell me what I should
> > > > > do I can create debugging information and/or test patches.
> > > >
> > > > Could you try this patch, please? It should help.
> > > >
> > > > Herbert, is this right? If cryptd is going to be used for block devs,
> > > > the task should probably be PF_NOFREEZE (or whatever it is today)
> > > > instead.
> > > >
> > > > Regards,
> > > >
> > > > Nigel
> > > >
> > > >  crypto/cryptd.c         |    1 +
> > > >  include/linux/freezer.h |    3 +++
> > > >  kernel/power/process.c  |    2 +-
> > > >  3 files changed, 5 insertions(+), 1 deletion(-)
> > > > diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c
> > > > 991-fix-cryptd.patch-new/crypto/cryptd.c ---
> > > > 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19 18:16:47.000000000
> > > > +1000 +++ 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26
> > > > 19:45:42.000000000 +1000 @@ -341,6 +341,7 @@ static int
> > > > cryptd_thread(void *data)
> > > >
> > > >  		mutex_unlock(&state->mutex);
> > > >
> > > > +		try_to_freeze();
> > > >  		schedule();
> > > >  	} while (!stop);
> > >
> > > I tried your patch, but when I apply it my kernel doesn't compile any
> > > more. I get these warnings/errors:
> > >
> > > [...]
> > >   CC      crypto/cryptd.o
> > > crypto/cryptd.c: In function ‘cryptd_thread’:
> > > crypto/cryptd.c:344: warning: implicit declaration of function
> > > ‘try_to_freeze’ [...]
> > >   LD      init/built-in.o
> > >   LD      .tmp_vmlinux1
> > > crypto/built-in.o: In function `cryptd_thread':
> > > cryptd.c:(.text+0xd7f5): undefined reference to `try_to_freeze'
> > > make: *** [.tmp_vmlinux1] Error 1
> >
> > Ah. You'll need to add #include <linux/freezer.h> near that start of
> > crypto/cryptd.c. Sorry for forgetting that.
> >
> > Nigel
> 
> I added the include line and now I could compile the kernel, but suspending 
> still doesn't work.
> 
> swsusp: Basic memory bitmaps created
> Stopping tasks ... 
> Stopping kernel threads timed out after 20 seconds (1 tasks refusing to 
> freeze):
> cryptd
> Restarting tasks ... done.
> swsusp: Basic memory bitmaps freed

OK, this means that cryptd doesn't execute the try_to_freeze() for some
reason.

Please apply the appended patch on top of 2.6.22-rc3 and see if that helps.

Greetings,
Rafael

---
 crypto/cryptd.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22-rc3/crypto/cryptd.c
===================================================================
--- linux-2.6.22-rc3.orig/crypto/cryptd.c
+++ linux-2.6.22-rc3/crypto/cryptd.c
@@ -316,6 +316,7 @@ static int cryptd_thread(void *data)
 	struct cryptd_state *state = data;
 	int stop;
 
+	current->flags |= PF_NOFREEZE;
 	do {
 		struct crypto_async_request *req, *backlog;
 
