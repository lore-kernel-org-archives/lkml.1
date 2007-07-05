Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbXGEVEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbXGEVEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760116AbXGEVDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:03:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:58675 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703AbXGEVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s0wD/vOcK7ytRYrpF2u2GF1XoorVrmvry4R4vjOqn9tZkhqdmeAY5Z8bJXfQkXnddySHxlpORZ08tbHQkdgj5RHlb0pAoUFu+jdXcusKQP4m20oo8cfPZIAhZlq1nBDa3tv7iH7ONUWUpgRbbCRFt4wKYbPBKghvyQ59bzjhYJ0=
Message-ID: <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com>
Date: Thu, 5 Jul 2007 17:03:48 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
Cc: "David Woodhouse" <dwmw2@infradead.org>, "Jiri Kosina" <jkosina@suse.cz>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       marcel@holtmann.org, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       "David Chinner" <dgc@sgi.com>, sparclinux@vger.kernel.org,
       "David Miller" <davem@davemloft.net>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Mark Fortescue" <mark@mtfhpc.demon.co.uk>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <alpine.LFD.0.98.0707051236410.9434@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <468A7D14.1050505@googlemail.com>
	 <1183599771.2740.19.camel@shinybook.infradead.org>
	 <alpine.LFD.0.98.0707050921000.9434@woody.linux-foundation.org>
	 <1183661171.2756.13.camel@shinybook.infradead.org>
	 <1183663888.2756.19.camel@shinybook.infradead.org>
	 <alpine.LFD.0.98.0707051236410.9434@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Looks input-related..
>
> On Thu, 5 Jul 2007, David Woodhouse wrote:
> >
> > Hm, it's not something new. It's an oops I saw occasionally in 2.6.21-rc
> > too, whenever we had CONFIG_SYSFS_DEPRECATED set.
> >
> >  Unable to handle kernel paging request for data at address 0x6b6b6b6b
>
> Ok, that 0x6b is obviously the kfree() poisoning, ie it looks like a
> use-after-free problem with a pointer being loaded from a structure that
> had been free'd-
>
> And the trace seems to be (ignore the unreliable one):
>
> >  NIP [c001870c] strlen+0x4/0x18
> >  LR [c0134fec] kobject_get_path+0x34/0xc4
> >  Call Trace:
> >  [eed5be90] [c01d5124] class_uevent+0xac/0x1bc
> >  [eed5bed0] [c01357e4] kobject_uevent_env+0x23c/0x460
> >  [eed5bf20] [c01d485c] class_device_del+0x178/0x1a0
> >  [eed5bf40] [c01d489c] class_device_unregister+0x18/0x30
> >  [eed5bf60] [c021f820] input_unregister_device+0xf4/0x130
> >  [eed5bf70] [c0242f4c] hidinput_disconnect+0x2c/0x60
> >  [eed5bf90] [f27f2bac] hidp_session+0x550/0x584 [hidp]
> >  [eed5bff0] [c0013e28] kernel_thread+0x44/0x60
>
> Where we have a few missing functions due to inlining, ie the real
> sequence seems to be:
>
> class_device_del ->
>  kobject_uevent_env ->
>    class_uevent ->
>      kobject_get_path ->
>        get_kobj_path_length ->
>          parent = kobj;
>          do {
>            strlen(parent->k_name /* kobject_name(parent) */);
>            parent = parent->parent;
>          } while (parent);
>
> so either the kobj or one of it's parents had already been freed when it
> was unregistered due to the disconnect.
>
> I'm not seeing any reference counting or other protection for the device
> ("input") on "hid->inputs" list. But I don't know the code. Dmitry? Jiri?
>

In hidinput_connect we do:

          input_dev->dev.parent = hid->dev;

This should pin hid object untill all inputs are released. However
bluetooth does not use driver model and does not have hid->dev set up
and so it looks like we are simply trying to unregister an input
device that is already gone... I still don't quite get how we
unregister the same device twice - it is done from a per-hid-device
thread in hidp...

-- 
Dmitry
