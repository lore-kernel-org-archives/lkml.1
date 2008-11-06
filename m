Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYKFEPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYKFEPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYKFEPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:15:24 -0500
Received: from smtp02.mtu.ru ([62.5.255.49]:50048 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYKFEPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:15:22 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.28-rc3] regression when switching TTY->X, input related?
To: Bernhard Schmidt <berni@birkenwald.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2008 07:15:11 +0300
References: <20081105220419.GA15685@pest>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20081106041517.1C7FE143D4EA@smtp02.mtu.ru>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Schmidt wrote:

> Hi,
> 
> I have a pretty weird issue with 2.6.28-rc3 that I originally thought to
> be related with suspend2ram, then with intel's xorg driver and now it
> looks like something related to the input subsystem.
> 
> I have a Dell Latitude D630 (Intel GM965 graphics) running Ubuntu 8.10
> amd64. Since the included (heavily patched by Ubuntu) 2.6.27 is
> extremely unstable in iwlagn I've been trying my luck with 2.6.28-rc3.
> 
> One thing that did not work anymore was suspend2ram and resume. It would
> suspend just fine and resume as well, but then I would sit in front of a
> black screen with an unmovable mouse cursor and not be able to do
> anything, not even switch vtys or kill X with ctrl-alt-backspace. Magic
> Sysrq to reboot did usually work though.
> 
> I've been following a few threads about similar issues in here, among
> others this one: http://lkml.org/lkml/2008/11/5/217 . However, the
> workaround mentioned in there (switch to a textmode console prior to
> suspend) didn't work, in fact when switching back to X without
> suspending I had the same problem. After sitting there and scratching my
> head for a couple of minutes the screensaver unlock dialog suddenly
> appeared and I could enter my password and "work", but the touchpad
> didn't work. 

Cannot comment on input stuff, but I noticed that you are using driver
that requests firmware:

[   39.735183] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[   39.735272] iwlagn 0000:0c:00.0: restoring config space at offset 0x1
(was 0x100102, writing 0x100106)
[   39.735379] iwlagn 0000:0c:00.0: irq 42 for MSI/MSI-X
[   39.735448] iwlagn 0000:0c:00.0: firmware: requesting
iwlwifi-4965-2.ucode

If it tries to do it during resume in ->resume method, this won't work and
will timeout; symptoms are exactly as you describe (sitting there for 180
seconds and suddenly start to work). Do you have WiFi connection on resume?

>              I verified that a couple of times and it is always the 
> same, after switching to a textmode vty and back to X I have a black
> screen with my mousecursor, I can neither move the cursor with the
> touchpad nor any keypress has any effect, but the box isn't locked up.
> There is a bit of disk activity, I can login using the serial console
> just fine and immediately kill and restart X and it comes back fine, in
> seldom cases without a working touchpad, but that might be a different
> issue.  After about 30-120s the situation resolves itself and I get my
> normal X, but again sometimes without touchpad.
> 
> I think this is an input issue because I get the following messages in
> /var/log/Xorg.0.log when switching away:
> 
> (II) AIGLX: Suspending AIGLX clients for VT switch
> (II) intel(0): xf86UnbindGARTMemory: unbind key 0
> (II) intel(0): xf86UnbindGARTMemory: unbind key 1
> 
> when switching back
> 
> (II) Open ACPI successful (/var/run/acpid.socket)
> (II) AIGLX: Resuming AIGLX clients after VT switch
> (II) intel(0): xf86BindGARTMemory: bind key 0 at 0x0c6b0000 (pgoffset
> 50864) (II) intel(0): xf86BindGARTMemory: bind key 1 at 0x0e000000
> (pgoffset 57344) (II) intel(0): Fixed memory allocation layout:
> (II) intel(0): 0x00000000-0x00000fff: power context (4 kB)
> (II) intel(0): 0x0077f000:            end of stolen memory
> (II) intel(0): 0x0077f000-0x0c6affff: DRI memory manager (195780 kB)
> (II) intel(0): 0x0c6b0000-0x0dffffff: exa offscreen (25920 kB)
> (II) intel(0): 0x0e000000-0x0fffffff: classic textures (32768 kB)
> (II) intel(0): 0x10000000:            end of aperture
> (II) intel(0): BO memory allocation layout:
> (II) intel(0): 0x0077f000:            start of memory manager
> (II) intel(0): 0x0079f000-0x0100efff: depth buffer (8640 kB) Y tiled
> (II) intel(0): 0x0179f000-0x0200efff: back buffer (8640 kB) X tiled
> (II) intel(0): 0x02800000-0x0306ffff: front buffer (8640 kB) X tiled
> (II) intel(0): 0x0279f000-0x0279ffff: overlay registers (4 kB)
> (II) intel(0): 0x027a0000-0x027b5fff: exa G965 state buffer (88 kB)
> (II) intel(0): 0x027c0000-0x027c7fff: logical 3D context (32 kB)
> (II) intel(0): 0x027c8000-0x027d1fff: HW cursors (40 kB)
> (II) intel(0): 0x0c6b0000:            end of memory manager
> (WW) intel(0): ESR is 0x00000001
> (WW) intel(0): PRB0_CTL (0x0001f001) indicates ring buffer enabled
> (WW) intel(0): Existing errors found in hardware state.
> (II) intel(0): using SSC reference clock of 100 MHz
> (II) intel(0): Selecting standard 18 bit TMDS pixel format.
> (II) intel(0): Output configuration:
> (II) intel(0):   Pipe A is off
> (II) intel(0):   Display plane A is now disabled and connected to pipe A.
> (II) intel(0):   Pipe B is on
> (II) intel(0):   Display plane B is now enabled and connected to pipe B.
> (II) intel(0):   Output VGA is connected to pipe none
> (II) intel(0):   Output LVDS is connected to pipe B
> (II) intel(0):   Output TMDS-1 is connected to pipe none
> (II) intel(0):   Output TV is connected to pipe none
> (II) intel(0): [drm] mapped front buffer at 0xe2800000, handle =
> 0x2fff8000 (II) Configured Mouse: x-axis range 0 - 1023
> (II) Configured Mouse: y-axis range 0 - 767
> (--) Configured Mouse touchpad found
> (II) AlpsPS/2 ALPS GlidePoint: x-axis range 0 - 1023
> (II) AlpsPS/2 ALPS GlidePoint: y-axis range 0 - 767
> (WW) AlpsPS/2 ALPS GlidePoint can't grab event device, errno=16
> (--) AlpsPS/2 ALPS GlidePoint touchpad found
> 
> then it hangs some seconds/minutes with the usual symptoms.  When I move
> my finger on the touchpad in this stage I get my xorg log flooded with
> 
> [mi] EQ overflowing. The server is probably stuck in an infinite loop.
> [mi] mieqEnequeue: out-of-order valuator event; dropping.
> 
> And then it suddenly shows me the login screen, and at the same time the
> Xorg logfile gets the following lines added (at once, so there is a long
> delay right before the following line)
> 
> (II) PS/2 Mouse: Device reopened after 10 attempts.
> (**) PS/2 Mouse: YAxisMapping: buttons 4 and 5
> (**) PS/2 Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10,
> EmulateWheelTimeout: 200 (II) AT Translated Set 2 keyboard: Device
> reopened after 10 attempts. (II) Video Bus: Device reopened after 10
> attempts. (II) Video Bus: Device reopened after 10 attempts.
> (II) Video Bus: Device reopened after 10 attempts.
> (II) intel(0): EDID vendor "SEC", prod id 17495
> (II) intel(0): Printing DDC gathered Modelines:
> (II) intel(0): Modeline "1440x900"x0.0  105.06  1440 1488 1616 1920  900
> 906 909 912 -hsync -vsync (54.7 kHz)
> 
> I think this is a regression because it used to work with the 2.6.27
> kernel from Ubuntu. I'll try with a vanilla 2.6.27 but I had been
> running ext4dev which I need to work a bit to mount on 2.6.27 (it got
> flagged as ext4 without test_fs flag the first time 2.6.28-rc was
> booting). It's not really related to suspend, because it happens on VTY
> switching as well. It happens with both Intel xorg driver 2.4.1 and
> 2.5.0. I think it's related to input because the first message after it
> starts working again is always related to the mouse.
> 
> Anyone having an idea where to look? dmesg and config attached.
> 
> Bernhard


