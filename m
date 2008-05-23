Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbYEWLKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbYEWLKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYEWLKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:10:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60155 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbYEWLKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:10:36 -0400
Date: Fri, 23 May 2008 11:57:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] raw1394: Push the BKL down into the driver ioctls
Message-ID: <20080523115741.5d695706@core>
In-Reply-To: <48369B0D.7050309@s5r6.in-berlin.de>
References: <20080522223351.22e09d20@core>
	<48369B0D.7050309@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 12:23:09 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Alan Cox wrote:
> > Actually in this case wrap the function for now.
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Can an .unlocked_ioctl() preempt another .unlocked_ioctl() to the very
> same instance of struct file?

Yes. And this btw is true even with the old locked ioctl call if you ever
sleep (eg a copy_to/from_user).

> If yes, we need to serialize do_raw1394_ioctl against itself or come up
> with another protection against concurrent fi->iso_state switches before
> we can remove lock_kernel().  And if a .write() can preempt another
> .write() to the same instance of struct file, raw1394_write() already
> has a problem with concurrent fi->state switches.

Quite a few drivers end up with a private mutex and do mutex_lock/unlock
around the ioctl and write paths (and if the write path can be slow using
_trylock and O_NDELAY check when appropriate).

The goal of pushing it down is to enable driver authors to see and to do
the locking at a driver level instead - plus fix lots of bugs where the
BKL "sleep and drop" behaviour isn't anticipated.

> The same s/raw1394_ioctl/do_raw1394_ioctl/ should be done in
> raw1394_compat_ioctl().  But I suppose it doesn't really matter because
> lock_kernel() is allowed to nest.

Agreed.

Alan
