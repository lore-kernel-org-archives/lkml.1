Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbZKSN2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbZKSN2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZKSN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:28:24 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:36046
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbZKSN2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:28:24 -0500
X-IronPort-AV: E=Sophos;i="4.44,771,1249250400"; 
   d="scan'208";a="50620925"
Date: Thu, 19 Nov 2009 14:28:28 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for non-ASCII
Message-ID: <20091119132828.GA31025@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com,
	alan@lxorguk.ukuu.org.uk, mgarski@post.pl
References: <20091116135114.GA2719@x200> <20091116190739.GJ4764@const.famille.thibault.fr> <20091116195313.GB4462@x200> <20091116222738.GQ4764@const.famille.thibault.fr> <20091116225429.GB4764@const.famille.thibault.fr> <20091116230523.GC24961@x200> <20091116231520.GD4764@const.famille.thibault.fr> <20091117115503.GB1657@x200> <20091117132358.GJ12736@const.bordeaux.inria.fr> <20091119131854.GA1628@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091119131854.GA1628@x200.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan, le Thu 19 Nov 2009 16:18:54 +0300, a écrit :
> > More precisely, in the kbd source code, in the add_capslock function, in
> > the unicode case, instead of ignoring the '+', add 0xD800 to the unicode
> > value if it is below 0x0800.
> 
> You suggest to change kernel and keymap and kbd and introduce 0xD800 hack.
> This is not going to fly.

Sure, that's precisely what I said here:

> > But again, that's a very limited fix and just fixing the LED interface
> > would allow to just use modifiers and permit much more powerful keymaps.

Just to make sure you understand my point: your bug is _not_ in the
kernel, but in kbd, see what the add_capslock() function does when in
unicode mode:

	fprintf(stderr, _("plus before %s ignored\n"), p);

No wonder capslocked keys don't work, kbd doesn't even tell the kernel
which keys should get capslock behavior. Breaking the capslock behavior
to make it a shiftlock to compensate kbd's bug is not going to fly
either.

Now, as I said, kbd's issue is that it doesn't have any way to express
that a unicode keysym should get capslock behavior, due to kernel
interface limitation.  But as I said, it can do like console-setup: use
a modifier instead of the limited capslock interface. A side issue is
that modifier locks don't get advertised through keyboard leds. That can
be solved by adding an interface to make that happen.

Instead of breaking an interface (capslock by making it a shiftlock
instead), add one that makes sense (being able to configure how modifier
locks are advertised through LEDs). _That_ will fly.

Samuel
