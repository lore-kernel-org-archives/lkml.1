Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZCHQAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZCHQAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZCHQAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:00:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:47411 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZCHQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:00:30 -0400
Date: Sun, 8 Mar 2009 09:01:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Robinson <andr345@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Rusty Russell <rusty@rustcorp.com.au>,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Message-ID: <20090308090102.2db82a5b@infradead.org>
In-Reply-To: <1236509237.5645.151.camel@andreas-laptop>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	<ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	<200902181528.29697.rusty@rustcorp.com.au>
	<ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	<1234952753.10531.48.camel@andreas-laptop>
	<cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	<ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	<1235216636.7025.1023.camel@andreas-laptop>
	<1236004353.10055.49.camel@andreas-laptop>
	<20090302082003.1bb7bdc5@infradead.org>
	<ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	<20090302102703.50aaf724@infradead.org>
	<1236192430.6785.111.camel@andreas-laptop>
	<20090305161837.6ba80cc1@infradead.org>
	<1236352543.6594.59.camel@andreas-laptop>
	<20090306074548.36ed2f9f@infradead.org>
	<1236509237.5645.151.camel@andreas-laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Mar 2009 11:47:17 +0100
Andreas Robinson <andr345@gmail.com> wrote:

> > but I guess that is for Ubuntu to resolve. I don't see the machines
> > I run (with Fedora) exhibit this same issue; while there are a
> > bunch of modules, none of the ones that are expensive-and-useless
> > in your charts are there.
> 
> I think they will. Fast boot is one of the "essential" goals for
> Jaunty and Karmic.
> 
> Anyway, attached is a bootchart for a cleaned up kernel with the
> important (AFAIK) drivers built in.

thanks; very useful overview!

> 
> >From this, I've found some tasks that I can set myself to. They would
> obviously be the topic of other threads:
> 
> * Make the nforce2 ethernet driver (init_nic) initialize itself
>   asynchronously, if possible.

I looked at doing this generically and it is really hard. BUT..
one of the options is to move work from the init to the "ifconfig up"
code...

In addition, for 2.6.30, I have a patch pending to move sata init
before the network init, which can help hide it some
> 
> * New config option: Separate initramfs decompression and
>   file-system calls. Decompress as early as possible in a
>   separate thread.

interesting idea!
> 
> * Don't unpack initramfs twice. If CONFIG_BLK_DEV_RAM is
>   set, the kernel decompresses the ramdisk just to see if
>   it's a cpio archive or not, and then throws away the result.

I actually have a patch for it stuck away somewhere; I thought it was
sent upstream but apparently it was not. I'll dig it out and dust it
off.

Note: Having a smaller initrd (like Fedora does, they make the initrd
only have the modules the specific machine needs) will save a bunch of
time... what isn't there you don't have to decompress either.

> 
> * See what can be done about pci_init(), if anything.
> 
> If there's anything else regarding fastboot you think would make more
> sense to work on first, please let me know.


One thing to mention is that fastinit for sata... I only did AHCI
(because all my machines have that). Your machine looks like it has
something different than AHCI, so maybe the sata controller can use
some work ;-)
(a sata driver needs to opt into parallel scanning via a flag)

SATA init tends to be one of the things that are fix time per drive;
and so working on that first to at least ONLY get that is worth it,
it's a huge chunk of time (more than half the total time in your
bootchart)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
