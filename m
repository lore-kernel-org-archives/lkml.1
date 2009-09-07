Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZIGVzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZIGVzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZIGVzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:55:47 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:64480 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZIGVzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=XM5nfhlqS0UV24Y/lyHOsPS/GrPRp4lteQBwrHeuhuiQzWVVcZEBu9M7BzSB5FECVT
         GthYrzHtFmwto9uhP8mbdjyhn3KusgR4ReD97qz4L2vQO5exM47j5ENbcZeXLryoYe/W
         GyBXzdHo6idn+IPt5k5opk8iFMOyyy6qIypZc=
Message-ID: <4AA58160.7080908@skyrush.com>
Date: Mon, 07 Sep 2009 15:55:44 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090722)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tty tree with the  tree
References: <20090907191347.fe010955.sfr@canb.auug.org.au> <alpine.LFD.2.01.0909071104340.25628@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909071104340.25628@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050103040205070304010104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050103040205070304010104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> Hmm. I think that the "honor opost flag for echoes" patch is actually 
> wrong.
> 
> We check O_OPOST() in the _caller_ for the regular write case, and that
> test actually looks like this:
> 
> 	if (O_OPOST(tty) && !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
> 
> so at a minimum, if we add it to process_output() we should likely add it 
> in the same format. But if we need that test, I'd rather do it in the 
> caller anyway, like we already do for regular writes.

Yes, very true.  The old opost() function also contained the O_OPOST
check (i.e. causing a double check for normal writes), and you are right
that we should not reintroduce it (and it makes sense for the caller to
check it).

There is only the one case in which the O_OPOST check is needed before
calling do_output_char() (in process_echoes()), so we could just inline
the test there.  Take a look at my new attached patch (untested also).
I'll test and resubmit, assuming there are no objections.

					-Thanks, Joe

--------------050103040205070304010104
Content-Type: text/plain;
 name="n_tty-honor-opost-flag-for-echoes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n_tty-honor-opost-flag-for-echoes.patch"

--- n_tty.c.orig	2009-09-07 13:54:32.460678337 -0600
+++ n_tty.c	2009-09-07 15:48:51.191033405 -0600
@@ -272,7 +272,8 @@ static inline int is_continuation(unsign
  *
  *	This is a helper function that handles one output character
  *	(including special characters like TAB, CR, LF, etc.),
- *	putting the results in the tty driver's write buffer.
+ *	doing OPOST processing and putting the results in the
+ *	tty driver's write buffer.
  *
  *	Note that Linux currently ignores TABDLY, CRDLY, VTDLY, FFDLY
  *	and NLDLY.  They simply aren't relevant in the world today.
@@ -351,8 +352,9 @@ static int do_output_char(unsigned char 
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
  *
- *	Perform OPOST processing.  Returns -1 when the output device is
- *	full and the character must be retried.
+ *	Output one character with OPOST processing.
+ *	Returns -1 when the output device is full and the character
+ *	must be retried.
  *
  *	Locking: output_lock to protect column state and space left
  *		 (also, this is called from n_tty_write under the
@@ -378,8 +380,11 @@ static int process_output(unsigned char 
 /**
  *	process_output_block		-	block post processor
  *	@tty: terminal device
- *	@inbuf: user buffer
- *	@nr: number of bytes
+ *	@buf: character buffer
+ *	@nr: number of bytes to output
+ *
+ *	Output a block of characters with OPOST processing.
+ *	Returns the number of characters output.
  *
  *	This path is used to speed up block console writes, among other
  *	things when processing blocks of output data. It handles only
@@ -606,12 +611,18 @@ static void process_echoes(struct tty_st
 			if (no_space_left)
 				break;
 		} else {
-			int retval;
-
-			retval = do_output_char(c, tty, space);
-			if (retval < 0)
-				break;
-			space -= retval;
+			if (O_OPOST(tty) &&
+			    !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
+				int retval = do_output_char(c, tty, space);
+				if (retval < 0)
+					break;
+				space -= retval;
+			} else {
+				if (!space)
+					break;
+				tty_put_char(tty, c);
+				space -= 1;
+			}
 			cp += 1;
 			nr -= 1;
 		}

--------------050103040205070304010104--
