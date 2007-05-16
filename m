Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbXEPLg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbXEPLg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXEPLgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:36:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:1734 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbXEPLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rR4Z3cbucrV7NjL/gY5S+lMfX7cU9Lq76T54A9fGIYV52yqdCiCzZRri/r4rBIGFBcCDVlWDvH7zLLoTJgqFJRi+E2x4Iaw8I1Xdf3XabvezjnoGOvKJ8qiWxP3FV7XF2cyyG7VGkwI6Z58pV++5CU1fnjhQZe49eAm2cIskYoM=
Message-ID: <a781481a0705160436s3564022aybd9b318ec0947d94@mail.gmail.com>
Date: Wed, 16 May 2007 17:06:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: 2.6.21-rc7: BUG: sleeping function called from invalid context at net/core/sock.c:1523
Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Greg KH" <gregkh@suse.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, "Cedric Le Goater" <clg@fr.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705161124030.25986@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <462D1B09.9050005@goop.org>
	 <Pine.LNX.4.64.0704232257090.20657@twin.jikos.cz>
	 <Pine.LNX.4.64.0704261625410.20657@twin.jikos.cz>
	 <a781481a0705110629n7c7130c1x3a89fa958b271f20@mail.gmail.com>
	 <Pine.LNX.4.64.0705161124030.25986@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 5/16/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Fri, 11 May 2007, Satyam Sharma wrote:
> > (later)
> > I Googled a bit to see if this problem was faced elsewhere in the kernel
> > too. Saw the following commit by Ingo Molnar
> > (9883a13c72dbf8c518814b6091019643cdb34429):
> > -     lock_sock(sock->sk);
> > +     local_bh_disable();
> > +     bh_lock_sock_nested(sock->sk);
> >       rc = selinux_netlbl_socket_setsid(sock, sksec->sid);
> > -     release_sock(sock->sk);
> > +     bh_unlock_sock(sock->sk);
> > +     local_bh_enable();
> > Is it _really_ *this* simple?
> [...]
> actually this *seems* to be proper solution also for our case, thanks for
> pointing this out. I will think about it once again, do some more tests
> with this locking scheme, and will let you know.

Yes, I can almost confirm that this (open-coding of spin_lock_bh,
effectively) is the proper solution (Rusty's unreliable guide to
kernel-locking needs to be next to every developer's keyboard :-)
I also came across this idiom in other places in the networking code
so it seems to be pretty much the standard way. I wish I owned
bluetooth hardware, could've tested this for you myself.

Thanks,
Satyam
