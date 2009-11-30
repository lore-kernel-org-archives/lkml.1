Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZK3VlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZK3VlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZK3VlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:41:00 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:52431 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZK3Vk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:40:59 -0500
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix> <4B125051.6010506@redhat.com>
	<87k4x9saqn.fsf@spindle.srvr.nix> <4B1283F5.5060204@redhat.com>
	<87y6lorjq6.fsf@spindle.srvr.nix> <20091130130509.52762237@varda>
From: Nix <nix@esperi.org.uk>
Emacs: an inspiring example of form following function... to Hell.
Date: Mon, 30 Nov 2009 21:40:46 +0000
In-Reply-To: <20091130130509.52762237@varda> (Alejandro Riveira
 =?iso-8859-1?Q?Fern=E1ndez's?= message of "Mon, 30 Nov 2009 13:05:09
 +0100")
Message-ID: <87d42zr8rl.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-URT-Metrics: spindle 1060; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Nov 2009, Alejandro Riveira Fernández spake thusly:
>  When I install the infamous nvidia driver I use. « sudo stop gdm » 
> there are a start and restart aliases too see « man initctl ».

Aha! That's done it. New upstartish aliases I hadn't noticed...

FWIW, my qemu startup line (later adjusted, see below):

DISPLAY=mutilate:0 /usr/bin/qemu-system-x86_64 -M pc-0.11 -enable-kvm -m 1024 \
    -smp 2 -name ubuntwo -vnc :0 -boot c \
    -drive file=/vm/linux/ubuntwo.img,if=virtio,index=0,boot=on,format=raw \
    -drive file=/usr/local/tmp/ubuntu-9.10-beta-alternate-amd64.iso,if=ide,media=cdrom,index=2 \
    -net nic,macaddr=52:54:00:4b:f7:7f,vlan=0,model=virtio,name=virtio.0 \
    -net tap,vlan=0,ifname=ubuntwo,script=/sbin/qemu-linux.ifup,downscript=/sbin/qemu-linux.ifdown \
    -parallel none -usb -k en-gb -vga vmware -soundhw ac97 -runas linux-vm \
    -serial mon:telnet::10404,server,nowait

> Sometimes is not enough though and I have to stop gdm and then pkill
> the X server

Unfortunately stopping X renders the vnc console useless. I got the SDL
console working (note for frustrated others: a quick 'xhost +blah' no
longer works in recent X versions, xhost support is gone from the
server: you must propagate your xauth cookie across instead), whereupon
it coredumps on me with a pretty-much-useless stacktrace:

vmsvga_fifo_run (s=0x117e5e8) at /usr/src/qemu/x86_64-spindle/hw/vmware_vga.c:572
572     /usr/src/qemu/x86_64-spindle/hw/vmware_vga.c: No such file or directory.
        in /usr/src/qemu/x86_64-spindle/hw/vmware_vga.c
(gdb) bt
#0  vmsvga_fifo_run (s=0x117e5e8) at /usr/src/qemu/x86_64-spindle/hw/vmware_vga.c:572
#1  0x0000000000000000 in ?? ()

I seem to be getting a lot of coredumps from qemu right now :(

So I started with -vga std. The emulation failed flood is unaffected
(strangely it's not consistent: it happens about half the time). As soon
as I issue a 'stop gdm', X exits and the emulation flood halts: but
although there are other getties running I can't find a way to switch to
them, as qemu has stolen Ctrl-Alt for its own purposes: so the system is
pretty much useless (maybe I should get an sshd up and try to restart
things from there). (I've never needed to do this before: either my
qemus have been text mode all the time, or X with one console.)

Surely switching VTs is possible: any clues?


Unfortunately Ubuntu bug 417859 has broken the recovery console so I
can't use that to get me in in text mode and *then* start X. Not fixed,
but then it's only a bug in something critical to system recovery which
has been open for months and has had variations on the same bug open for
*two flipping years*. Sheesh.

:/
