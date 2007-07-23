Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbXGWUQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbXGWUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbXGWUQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:16:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769AbXGWUQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:16:47 -0400
Date: Mon, 23 Jul 2007 13:15:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070723131553.2943861f.akpm@linux-foundation.org>
In-Reply-To: <200707231419.13182.rgetz@blackfin.uclinux.org>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<200707182358.24984.rgetz@blackfin.uclinux.org>
	<8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
	<200707231419.13182.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 14:19:12 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Sun 22 Jul 2007 19:50, Mike Frysinger pondered:
> >
> > i think the attached two functions account for what Robin and Andrew
> > were thinking ...
> 
> A note about why/when grab_lock would be set to zero (pre-kernel init, or 
> OOPs) might be nice. 

Definitely.

The pre-kernel init shouldn't be an issue: logbuf_lock is initialised at
compile time.

At oops time we could possibly use oops_in_progress to work out whether to
avoid taking the lock.  That's not terribly nice, but nor is it nice for
callers to know about printk internals.

> Or - remove it - and tell people they should be using do_syslog interface in 
> a "normal" kernel environment (where log_end or log_start can be updated).

You can't (or al least, shouldn't) use do_syslog() from within kernel code?

> Either would be fine with me. Andrew?

The interface is pretty bad, IMO:

 /*
+ * Read the log buffer into the supplied buffer.  The len option
+ * tells whether to copy from the beginning (> 0), the end (< 0), or
+ * just query the number of existing chars.   The number of bytes
+ * actually copied is returned.
+ */
+int log_buf_read(int len, char *buf, int grab_lock)

The magical interpretation of len isn't very nice.  This code would be
simpler if it did not attempt to read more than one char at a time.  It
will be plenty fast enough.

If the caller knows the length of the buffer, why is there any need for the
index-from-the-end function?

I think a sufficient implementation is

	int log_buf_len(void);

and

	int log_buf_read(int index);

which will return the character at `index', or -1 if `index' is out of
bounds.

