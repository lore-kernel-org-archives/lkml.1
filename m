Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbXKGBVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbXKGBVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbXKGBUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:20:36 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:34917 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbXKGBUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:20:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T/tRnfMG7OCuDjo3k13Xn3NB+5DE5Z9OnZP96MCRAYuMA9zoIu6XUP0zkdZzIMZ8s7LE/ZIPrIug6iqpsRXOtBrLY5JDm3kCpAbrFUizHd44U900Q+PFsHuD3QluVYh8UOH3TBAYRtHTAVcmC1e0sye+v7qtNMLz8e8b5z35G/E=
Message-ID: <a8e1da0711061720m170e2cc9heecf58ebb2e079f@mail.gmail.com>
Date: Wed, 7 Nov 2007 09:20:33 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH]bluetooth rfcomm_dev refcount bug fix
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <1194356030.4763.18.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071106060028.GA3176@darkstar.te-china.tietoenator.com>
	 <1194356030.4763.18.camel@aeonflux>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2007 9:33 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
> > I'm afraid to be considered as spam ;)
> >
> > (Due to timezone offset, I have to mail again and cann't wait for your
> > reply, sorry for the annoying)
>
> I am in a different timezone every other week. So nevermind ;)
>
> > I think the rfcomm_dev_put could be seperated from the rfcomm_dev_put,
> > it will be more straitforward then.
> >
> > please consider below patch, tested on my side. thanks.
>
> That one looks totally wrong to me. Without even testing it, it will
> have side effects that you haven't run into yet. Unless the TTY core
> changed so much, this comments are there for a really good reason and
> the code is tested a lot.
What side effects?

Anyway, the refcnt is wrong in rfcomm_release_dev. We could either
remove the rfcomm_dev_del in rfcomm_tty_hangup or remove the
rfcomm_dev_put in the end of rfcomm_release_dev, or the rfcomm_dev
will be destructed, and  the later callback of rfcomm_tty_close could
cause oops.

>
> Also if you have to do two rfcomm_dev_put() in a row, then we are doing
> something really wrong and this tries to hide a real bug somewhere.
One is for device deletion (1->0), one is for the get/put pairs,
actually same as before.

Main reason of doing so in this patch is that if I remove the last
rfcomm_dev_put in rfcomm_release_dev, then it looks like get device
<-->  del device, so relace it with set deletion flag and then put
the device like "get device <--> put device" which is straitforward.

>
> Regards
>
> Marcel
>
>
>
