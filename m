Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbZHJSIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbZHJSIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZHJSH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:07:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbZHJSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:07:59 -0400
Date: Mon, 10 Aug 2009 11:07:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ray Lee <ray-lk@madrabbit.org>
cc: Artur Skawina <art.08.09@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: xterm loses data (pty regression)
In-Reply-To: <alpine.LFD.2.01.0908101016100.3288@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908101105040.3602@localhost.localdomain>
References: <4A803CE7.20201@gmail.com> <2c0942db0908101007t54c39b64k2800b2c320969318@mail.gmail.com> <alpine.LFD.2.01.0908101016100.3288@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Aug 2009, Linus Torvalds wrote:
> 
> On Mon, 10 Aug 2009, Ray Lee wrote:
> > On Mon, Aug 10, 2009 at 8:29 AM, Artur Skawina <art.08.09@gmail.com> wrote:
> > >
> > > First noticed it after upgrading to v2.6.31-rc5-246-g90bc1a6, still happens
> > > in rc5-381-g7b2aa03.
> > > If i press ^S in an xterm the output stops as expected, but after a ^Q i see
> > > only the newly written data, everything in between is lost. 
> 
> Yup, I can confirm that. 
> 
> > > > for i in `seq 1 111`; do echo $i; sleep 1; done
> 
> (Do ^S/^Q, see data loss)
> 
> Will take a look asap, thanks. Although I bet it's the same old commit 
> (d945cb9cc: "pty: Rework the pty layer to use the normal buffering logic") 
> again.

I think it's really this trivial.

That pty commit removed the checking for tty->stopped in 
pty_write_buffer() for no clear reason. And when it did that, it broke all 
the pausing logic in drivers/char/n_tty.c.

Can you confirm?

		Linus

---
 drivers/char/pty.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6e6942c..d083c73 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -144,6 +144,8 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf,
 
 static int pty_write_room(struct tty_struct *tty)
 {
+	if (tty->stopped)
+		return 0;
 	return pty_space(tty->link);
 }
 
