Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZJ0GXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZJ0GXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbZJ0GXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:23:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59581 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbZJ0GXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:23:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Bernhard Kaindl <bk@suse.de>
Subject: Re: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
In-Reply-To: Your message of "Mon, 26 Oct 2009 14:16:34 PDT."
             <4AE611B2.1030409@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <4AE24009.4090408@gmail.com> <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com> <21504.1256588976@turing-police.cc.vt.edu>
            <4AE611B2.1030409@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256624599_9496P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Oct 2009 02:23:19 -0400
Message-ID: <29209.1256624599@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4AE691D8.012B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256624599_9496P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Oct 2009 14:16:34 PDT, "Justin P. Mattock" said:
  
> as of now in init_ohci1394_dma.c
> I did:
> 
> 
> 
> void __init init_ohci1394_dma_on_all_controllers(void)
> {
>      int num, slot, func;
> 
>      if (!early_pci_allowed())
>          return;
> 
>      /* Poor man's PCI discovery, the only thing we can do at early boot */
>      for (num = 0; num < 32; num++) {
>          for (slot = 0; slot < 32; slot++) {
>              for (func = 0; func < 8; func++) {
>                  u32 class = read_pci_config(num,slot,func,
>                              PCI_CLASS_REVISION);
>                  if ((class == 0xffffffff))
> +                    printk(KERN_DEBUG "putting a printk here keeps the  machine from a panic\n");
>                      continue; /* No device at this func */

Try this instead:

                   
                   printk(KERN_DEBUG "trying class=%d num=%d slot=%d func=%d\n",
                             class, num, slot, func);
                   if ((class == 0xffffffff)) {
                       printk(KERN_DEBUG "No device here\n");
                       continue; /* No device at this func */
                   }

The curly brackets are important.  This version will still panic, and it will
probably spew a lot of msgs, but we'll hopefully find out which num/slot/func
is giving it indigestion. 


> interesting thing here, is I just was wanting to see were this thing was
> crashing. when adding this in(above) Ill see a long string during boot
> for a few seconds and then the machine boots up.
>  Now if I add a printk(example below) to here:

>                  if (class>>8 != PCI_CLASS_SERIAL_FIREWIRE_OHCI)
> +                    printk(KERN_DEBUG "putting a printk here keeps the machine from a panic\n");
>                      continue; /* Not an OHCI-1394 device */

> In dmesg I will see maybe 5 to 10 debug messages and then
> onto init_ohci1394_initialize.

That's because you forgot the curlies, and the 'continue;' is now unconditional
Now ou hit it *every* time, so you *never* do the test against
PCI_CLASS_SERIAL_FIREWIRE-OHCI and you never call init_ohci1394_controller();

And I suspect your *real* problem is something gone astray down in
init_ohci1394_conrtroller() - so if you change the code to never call it,
it never goes astray and you boot OK.

> keep in mind I'm not familiar with any of this, but just looking
> at the code I see 0xffffffff and searching(google) tells me
> that that's something with 32bit, should maybe there be something
> with 0xffffffffffffffffff 64bit?

No - it's "u32 class", so treated as a 32-bit.





--==_Exmh_1256624599_9496P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK5pHXcC3lWbTT17ARAiY5AJ0bDYClTqmCmcC2Hn7F9LJfIeis/wCg15rF
JCKo33y7tsnLVdUDFAchy6o=
=gnVx
-----END PGP SIGNATURE-----

--==_Exmh_1256624599_9496P--

