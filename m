Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYHSM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYHSM4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYHSM4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 08:56:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55584 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753343AbYHSM4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:56:36 -0400
Date: Tue, 19 Aug 2008 13:37:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage (v2)
Message-ID: <20080819133738.76181d57@lxorguk.ukuu.org.uk>
In-Reply-To: <20080818210414.GB7154@redhat.com>
References: <20080808213625.GK20355@redhat.com>
	<20080808222635.4fe52b51@lxorguk.ukuu.org.uk>
	<20080812145812.GH7154@redhat.com>
	<20080818181902.59ac763b@lxorguk.ukuu.org.uk>
	<20080818210414.GB7154@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 17:04:14 -0400
Aristeu Rozanski <aris@redhat.com> wrote:

> Hi Alan,
> > > The commit e0426e6a09954d205da2d674a3d368d2715e3afd fixes a real race but
> > > still isn't enough to prevent these:
> > > 
> > > kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
> > > things with the same name in the same direc.
> > 
> > Patch dropped due to testing failures.
> > 
> > Boot to run level 3, log in and type "reboot\n". Wait
> > 
> > Spews vt->driver_data == NULL warnings and oopses
> do you mind posting the logs somewhere? I wasn't able to reproduce it here so
> far.

I had a quick look and there are some obvious races from the change

You don't seem to have any locking between a hangup occuring at the same
time as say an ioctl. The f_ops change means no further calls will be
made to the console code but *not* that current ones won't continue.

Most of the time tty->driver_data is internally protected and checked by
the console_sem but not always. In particular your changes are showing up
corner cases in do_con_write and in the tty ioctl code.



