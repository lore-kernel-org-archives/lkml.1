Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYLFHmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYLFHmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYLFHmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:42:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbYLFHmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:42:23 -0500
Date: Fri, 5 Dec 2008 23:41:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Andrew <nick@nick-andrew.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] Recursive printk
Message-Id: <20081205234105.430a7b5e.akpm@linux-foundation.org>
In-Reply-To: <20081206073304.GE24654@1wt.eu>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
	<20081205232016.366765e2.akpm@linux-foundation.org>
	<20081206073304.GE24654@1wt.eu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008 08:33:05 +0100 Willy Tarreau <w@1wt.eu> wrote:

> On Fri, Dec 05, 2008 at 11:20:16PM -0800, Andrew Morton wrote:
> > > void snd_verbose_printk(const char *file, int line, const char *format, ...)
> > > {
> > >         va_list args;
> > > 
> > >         if (format[0] == '<' && format[1] >= '0' && format[1] <= '7' && format[2] == '>') {
> > >                 char tmp[] = "<0>";
> > >                 tmp[1] = format[1];
> > >                 printk("%sALSA %s:%d: ", tmp, file, line);
> > >                 format += 3;
> > 
> > That's racy.  Two threads can fight over tmp[1].  It should do:
> > 
> > 		printk("<%c>ALSA %s:%d: ", format[1], tmp, file, line);
> > 
> > (I didn't know that you can even modify literal strings - shouldn't
> > they be in read-only storage?)
> 
> no Andrew, this tmp[] is declared on the stack, and gcc emits code to
> copy the constant "<0>" onto the stack every time this code is called

Good heavens, so it does.  It is unusual for C to cater to such stupid
code by generating such inefficient code.  A bit of a trap, really.

