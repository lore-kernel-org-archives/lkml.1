Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXIQAYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXIQAYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 20:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbXIQAYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 20:24:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:3848 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbXIQAYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 20:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SJVpIATcJoK1XuEjtwxcm56d4qbIAvPnz/AhStIgkEp+fpkSc/FsR4QWKAIUQO/GOmexqcBRqdevIhU9GtAgU5tgH/COYPKwyRUwZO9B0rQEGcOwHrYSF71mWXqFgtXdKe+cA9eFsFHI4llcTRyhc+iEsytpHLxK1Mh0hy2XUzU=
Message-ID: <a781481a0709161724r6cf664e6q453331911cd0b493@mail.gmail.com>
Date: Mon, 17 Sep 2007 05:54:45 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] modpost: detect unterminated device id lists
Cc: "Kees Cook" <kees@ubuntu.com>, "Greg KH" <greg@kroah.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       "Ben Collins" <bcollins@ubuntu.com>,
       "Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <20070916151447.dc925a9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org>
	 <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	 <20070912215356.GC23294@kroah.com> <20070913004937.GM8183@outflux.net>
	 <20070916151447.dc925a9e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 12 Sep 2007 17:49:37 -0700 Kees Cook <kees@ubuntu.com> wrote:
>
> > This patch against 2.6.23-rc6 will cause modpost to fail if any device
> > id lists are incorrectly terminated, after reporting the offender.
>
> I'm getting this:
>
> rusb2/pvrusb2: struct usb_device_id is 20 bytes.  The last of 3 is:
> 0x03 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
> 0x00 0x00 0x00 0x00 0x00
> FATAL: drivers/media/video/pvrusb2/pvrusb2: struct usb_device_id is not terminated
> with a NULL entry!
>
> ("rusb2/pvrusb2" ??)

Hmm? Are you sure you didn't see any "drivers/media/video/pv" before the
"rusb2/pvrusb2" bit? Looking at Kees' patch (and the existing code), I've no
clue how/why this should happen ... will try to reproduce here ...


> but:
>
> struct usb_device_id pvr2_device_table[] = {
>         [PVR2_HDW_TYPE_29XXX] = { USB_DEVICE(0x2040, 0x2900) },
>         [PVR2_HDW_TYPE_24XXX] = { USB_DEVICE(0x2040, 0x2400) },
>         { USB_DEVICE(0, 0) },
> };
>
> looks OK?
>
> Using plain old "{ }" shut the warning up.

USB_DEVICE(0, 0) is not empty termination, actually, and this looks like
a genuine bug caught by the patch. As that dump shows, USB_DEVICE(0, 0)
assigns "0x03 0x00" (in little endian) to usb_device_id.match_flags. And
I don't think the USB code treats such an entry as an empty entry (?)

Interestingly, the "USB_DEVICE(0, 0)" thing is absent from latest -git
tree and also in my copy of 23-rc4-mm1 -- so this looks like something
you must've merged recently.
