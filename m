Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXGETy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXGETy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbXGETyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:54:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbXGETyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:54:17 -0400
Date: Thu, 5 Jul 2007 12:51:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, marcel@holtmann.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>, Greg KH <greg@kroah.com>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
In-Reply-To: <1183663888.2756.19.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.0.98.0707051236410.9434@woody.linux-foundation.org>
References: <468A7D14.1050505@googlemail.com>  <1183599771.2740.19.camel@shinybook.infradead.org>
  <alpine.LFD.0.98.0707050921000.9434@woody.linux-foundation.org> 
 <1183661171.2756.13.camel@shinybook.infradead.org>
 <1183663888.2756.19.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Looks input-related..

On Thu, 5 Jul 2007, David Woodhouse wrote:
> 
> Hm, it's not something new. It's an oops I saw occasionally in 2.6.21-rc
> too, whenever we had CONFIG_SYSFS_DEPRECATED set.
> 
>  Unable to handle kernel paging request for data at address 0x6b6b6b6b

Ok, that 0x6b is obviously the kfree() poisoning, ie it looks like a 
use-after-free problem with a pointer being loaded from a structure that 
had been free'd-

And the trace seems to be (ignore the unreliable one):

>  NIP [c001870c] strlen+0x4/0x18
>  LR [c0134fec] kobject_get_path+0x34/0xc4
>  Call Trace:
>  [eed5be90] [c01d5124] class_uevent+0xac/0x1bc
>  [eed5bed0] [c01357e4] kobject_uevent_env+0x23c/0x460
>  [eed5bf20] [c01d485c] class_device_del+0x178/0x1a0
>  [eed5bf40] [c01d489c] class_device_unregister+0x18/0x30
>  [eed5bf60] [c021f820] input_unregister_device+0xf4/0x130
>  [eed5bf70] [c0242f4c] hidinput_disconnect+0x2c/0x60
>  [eed5bf90] [f27f2bac] hidp_session+0x550/0x584 [hidp]
>  [eed5bff0] [c0013e28] kernel_thread+0x44/0x60

Where we have a few missing functions due to inlining, ie the real 
sequence seems to be:

class_device_del ->
  kobject_uevent_env ->
    class_uevent ->
      kobject_get_path ->
	get_kobj_path_length ->
	  parent = kobj;
	  do {
	    strlen(parent->k_name /* kobject_name(parent) */);
	    parent = parent->parent;
	  } while (parent);

so either the kobj or one of it's parents had already been freed when it 
was unregistered due to the disconnect.

I'm not seeing any reference counting or other protection for the device 
("input") on "hid->inputs" list. But I don't know the code. Dmitry? Jiri?

		Linus
