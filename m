Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbXE1Jew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbXE1Jew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXE1Jeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:34:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:16100 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXE1Jep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RvbSz4Bt1C8gJNDv3nAgFLZi+r862VxKrdUq2YC1b2to3tM7ti8YkdNERo8J9T/ZWHnYMSKRZtBVFKrgcEoYBwAo9p/v3WSRL7N9kW+SYyGGg0DxW2NKC7w8jh1+ZNQJrs05xoZeBbdWMxCST+7AlogyEp0VUfZrbrCVrsAVA38=
Message-ID: <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
Date: Mon, 28 May 2007 12:34:44 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tero Roponen" <teanropo@jyu.fi>
Subject: Re: tty-related oops in latest kernel(s)?
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
	 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
X-Google-Sender-Auth: a10cefe3ba9e3ef1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >   BUG: unable to handle kernel NULL pointer dereference at virtual address 00000731
> >   EIP is at vt_ioctl+0xda8/0x1482

[snip]

On 5/28/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >   Call Trace:
> >    [<c0149fd9>] link_path_walk+0xa5/0xaf
> >    [<c021d766>] vt_ioctl+0x0/0x1482
> >    [<c021a395>] tty_ioctl+0xa01/0xa87

I am getting this with your config:

(gdb) p vt_ioctl
$1 = {int (struct tty_struct *, struct file *, unsigned int, long
unsigned int)} 0xc01e404a <vt_ioctl>
(gdb) l *(0xc01e404a + 0xda8)
0xc01e4df2 is in vt_ioctl (drivers/char/vt_ioctl.c:720).
715             /*
716              * Returns the first available (non-opened) console.
717              */
718             case VT_OPENQRY:
719                     for (i = 0; i < MAX_NR_CONSOLES; ++i)
720                             if (! VT_IS_IN_USE(i))
721                                     break;
722                     ucval = i < MAX_NR_CONSOLES ? (i+1) : -1;
723                     goto setint;
724

Which seems to match the code dump in the OOPS as well. I am not sure
what %edx (which is zero and causes problems) should contain but I am
guessing tty_driver->ttys is corrupted which seems consistent with the
reference count sanity check failure. Unfortunately I am not familiar
enough with tty internals to immediately see why this is happening.
