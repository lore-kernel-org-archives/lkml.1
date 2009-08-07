Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbZHGHE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbZHGHE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZHGHEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:04:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZHGHEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:04:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Date: Fri, 7 Aug 2009 09:04:11 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <1249564170-18627-4-git-send-email-arnd@arndb.de> <20090807062356.GA4955@nowhere>
In-Reply-To: <20090807062356.GA4955@nowhere>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908070904.11260.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+pLgAd9GdY3BHGbnWz4PWE82UiW+kcOY0dUfW
 ZH127FGFgUz5/vrNYWNxdkQDZzd2KVzCNwBpGzYL0Uo2VGM6AO
 1ViFXJZ1+Ibu/vFb1DroQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Frederic Weisbecker wrote:

> On Thu, Aug 06, 2009 at 03:09:28PM +0200, Arnd Bergmann wrote:
> > The VT specific compat_ioctl handlers are the only ones
> > in common code that require the BKL. Moving them into
> > the vt driver lets us remove the BKL from the other handlers
> > and cleans up the code.
> 
> 
> Why does it require the bkl?
> 

All the VT ioctls are currently called under the BKL. I did not try
to find out why that is but simply kept that state. All other
compat ioctl do not interact with device driver state at all,
so they obviously do not need the BKL.

> > +
> > +long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
> > +	     unsigned int cmd, unsigned long arg)
> > +{
> > +	struct vc_data *vc = tty->driver_data;
> > +	struct console_font_op op;	/* used in multiple places here */
> > +	struct kbd_struct *kbd;
> > +	unsigned int console;
> > +	void __user *up = (void __user *)arg;
> > +	int perm;
> > +	int ret = 0;
> > +
> > +	console = vc->vc_num;
> > +
> > +	lock_kernel();
> 
> 
> 
> It would be really nice to add a comment here that explain what it
> is protecting.
> I would like to work on removing the bkl from tty, and such nude lock_kernel()
> don't help much to work in this area.
> This is more than ever a FUD lock, nothing about its role in tty in the Lockronomicon,
> and even not in the comments :-)

This function is a straight copy from vt_ioctl, with the data structures replaced,
and calling it vt_ioctl where they are identical.

You are right that this needs more code comments to make that obvious.

	Arnd <><
