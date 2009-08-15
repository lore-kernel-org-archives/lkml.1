Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZHOKeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZHOKeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZHOKeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:34:36 -0400
Received: from bar.sig21.net ([80.81.252.164]:44187 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZHOKef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:34:35 -0400
Date: Sat, 15 Aug 2009 12:35:32 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090815103532.GA5596@sig21.net>
References: <20090814170228.GM13320@pengutronix.de>
 <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
 <20090814204305.GA31727@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090814204305.GA31727@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.820,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 10:43:05PM +0200, Robert Schwebel wrote:
> On Fri, Aug 14, 2009 at 10:04:57PM +0200, Denys Vlasenko wrote:
> > > rsc@thebe:~$ microcom | ptx_ts "U-Boot 2.0.0-rc9"

Now that microcom is in Debian sid (thanks!), where can I find ptx_ts?
It seems to be quite useful.


> > > [  0.874559] <  0.003967> Hit any key to stop autoboot:  0
> >
> > boot loader is not fast. considering its simple task, it can be made
> > faster.
> 
> Yup, will check. Almost 1 s seems really long.


I'm working on a SoC with a 200MHz ARM926EJ-S.  We managed to get
to 1.5sec from power-on to "starting init". The main difference to
your platform seems to be that we use NOR flash.  The kernel is
not optimized, it still has some debug options turned on and
is used during development. (however, the 1.5sec is with "quiet")
The root fs is cramfs. The kernel version is 2.6.20.

For u-boot we enabled the D-cache which gave a decent speed up
(on ARM926EJ-S this requires one to set up page tables and enable
MMU, but it's not that difficult). I don't have the numbers here
but I think it still takes ~300ms in u-boot, and ~1.2s for the kernel boot.


> > > [  1.326621] <  0.452062> loaded zImage from /dev/nand0.kernel.bb with size 1679656
> > > [  2.009996] <  0.683375> Uncompressing Linux............................................................................................................... done, booting the kernel.
> > > [  2.416999] <  0.407003> Linux version 2.6.31-rc4-g056f82f-dirty (sha@octopus) (gcc version 4.3.2 (OSELAS.Toolchain-1.99.3) ) #1 PREEMPT Thu Aug 6 08:37:19 CEST 2009
> > 
> > Other people already commented on this (kernel is too big)
> 
> Not sure (the kernel is already customized for the board), but I'll take
> a look again.

We are booting an uncomressed kernel (~2.8MB).  Uncompressing (running the uncompressor
XIP in NOR flash) took ~0.5s longer than copying 2.8MB from flash to RAM.
BTW, we are using uImage and set verify=no in u-boot. We use u-boot-1.3.0.


> > > [  5.082616] <  0.007992> RPC: Registered tcp transport module.
> > > [  5.605159] <  0.522543> eth0: config: auto-negotiation on, 100FDX, 100HDX, 10FDX, 10HDX.

What is happening here? Waiting for eth link negotiation?

> > > [  6.602621] <  0.997462> IP-Config: Complete:
> > > [  6.606638] <  0.004017>      device=eth0, addr=192.168.23.197, mask=255.255.0.0, gw=192.168.23.2,
> > > [  6.614588] <  0.007950>      host=192.168.23.197, domain=, nis-domain=(none),
> > > [  6.618652] <  0.004064>      bootserver=192.168.23.2, rootserver=192.168.23.2, rootpath=
> > 
> > Well, this ~1 second is not really kernel's fault, it's DHCP delay.
> > But, do you need to do it at this moment?
> > You do not seem to be using networking filesystems.
> > You can run DHCP client in userspace.
> 
> The board has ip autoconfig configured in, because we also use tftp/nfs
> boot for development. But it had been disabled on the commandline:
> 
> ip=192.168.23.197:192.168.23.2:192.168.23.2:255.255.0.0:::
> 
> That shouldn't do dhcp, right?

Try to boot with eth cable unplugged, see if it hangs in IP-config.
If it were doing static configuration it would be faster.

However, unless you need ethernet to boot (NFS root) I'd suggest
doing eth config in userspace.


> > > [  7.137924] <  0.059316> starting udev
> > > [  7.147925] <  0.010001> mounting tmpfs at /dev
> > > [  7.182299] <  0.034374> creating static nodes
> > > [  7.410613] <  0.228314> starting udevd...done
> > > [  8.811097] <  1.400484> waiting for devices...done

And suddenly devtmpfs sounds like a good idea ;-)

We use static device nodes during boot, and later
setup busybox mdev for hotplug.


Johannes
