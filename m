Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbZARKEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbZARKEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 05:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbZARKEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 05:04:09 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:60622 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZARKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 05:04:05 -0500
X-Greylist: delayed 1432 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 05:04:04 EST
Subject: Re: [git pull] scheduler fixes
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4972EF6B.90207@redhat.com>
References: <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232194752.6273.5.camel@marge.simson.net>
	 <20090117044316.bda7d0bd.akpm@linux-foundation.org>
	 <1232198574.16303.8.camel@marge.simson.net>
	 <20090117160115.GA31601@elte.hu> <4972E860.5080206@redhat.com>
	 <20090118083744.GB21940@elte.hu>  <4972EF6B.90207@redhat.com>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Sun, 18 Jan 2009 20:09:56 +1030
Message-Id: <1232271596.4824.29.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 10:59 +0200, Avi Kivity wrote:
> A simple test running 10 idle guests over 4 cores doesn't reproduce 
> (2.6.29-rc).  However we likely need a more complicated setup.
> 
> Kevin, any details about your setup?  What are the guests doing?  Are 
> you overcommitting memory (is the host swapping)?

Hi Avi,

No, I don't think there is any swapping. The host has 32GB RAM and only
~9GB of guest RAM has been requested in total. The host doesn't do
anything but run KVM.

I fear my test setup is quite complicated as it is a production system
and I haven't been able to reproduce a simpler case as yet. Anyway, here
are the guests I have running during the test:

Windows XP, 32-bit (UP) - There are twelve of these launched with
identical scripts, apart from differing amounts of RAM. Six with "-m
512", one with "-m 768" and five with "-m 256":

KVM=/usr/local/kvm/bin/qemu-system-x86_64
$KVM \
    -no-acpi -localtime -m 512 \
    -hda kvm-00-xp.img \
    -net nic,vlan=0,macaddr=52:54:00:12:34:56,model=rtl8139 \
    -net tap,vlan=0,ifname=tap0,script=no \
    -vnc 127.0.0.1:0 -usbdevice tablet \
    -daemonize

Windows 2003, 32-bit (UP):

KVM=/usr/local/kvm/bin/qemu-system-x86_64
$KVM \
    -no-acpi \
    -localtime -m 1024 \
    -hda kvm-09-2003-C.img \
    -hdb kvm-09-2003-E.img \
    -net nic,vlan=0,macaddr=52:54:00:12:34:5F,model=rtl8139 \
    -net tap,vlan=0,ifname=tap9,script=no \
    -vnc 127.0.0.1:9 -usbdevice tablet \
    -daemonize

Debian Lenny, 64-bit (MP):

KVM=/usr/local/kvm/bin/qemu-system-x86_64
$KVM \
    -smp 2 \
    -m 512 \
    -hda kvm-10-lenny64.img \
    -net nic,vlan=0,macaddr=52:54:00:12:34:60,model=rtl8139 \
    -net tap,vlan=0,ifname=tap10,script=no \
    -vnc 127.0.0.1:10 -usbdevice tablet \
    -daemonize

Debian Lenny, 32-bit (MP):

KVM=/usr/local/kvm/bin/qemu-system-x86_64
$KVM \
    -smp 2 \
    -m 512 \
    -hda kvm-15-etch-i386.img \
    -net nic,vlan=0,macaddr=52:54:00:12:34:65,model=rtl8139 \
    -net tap,vlan=0,ifname=tap15,script=no \
    -vnc 127.0.0.1:15 -usbdevice tablet \
    -daemonize

Debian Etch (using a kernel.org 2.6.27.10) 32-bit (MP):

KVM=/usr/local/kvm/bin/qemu-system-x86_64
$KVM \
    -smp 2 \
    -m 2048 \
    -hda kvm-17-1.img \
    -hdb kvm-17-tmp.img \
    -net nic,vlan=0,macaddr=52:54:00:12:34:67,model=rtl8139 \
    -net tap,vlan=0,ifname=tap17,script=no \
    -vnc 127.0.0.1:17 -usbdevice tablet \
    -daemonize

This last VM is the one I was pinging from the host.

I begin by launching the guests at 90 second intervals and then let them
settle for about 5 minutes. The final guest runs Apache with RT and a
postgresql database. I set my browser to refresh the main RT page every
2 minutes, to roughly simulate the common usage. With all the guests
basically idling and just the last guest servicing the RT requests, the
load average is about 0.25 or less. Then I just ping the last guest for
about 15 minutes.

One thing that may be of interest - a couple of times while running the
test I also had a terminal logged into the guest being pinged and
running "top". There was some crazy stuff showing up in there, with some
processes having e.g. 1200 in the "%CPU" column. I remember postmaster
(postgresql) being one of them. A quick scan over the top few tasks
might show the total "%CPU" adding up to 2000 or more. This tended to
happen at the same time I saw the latency spikes in ping as well. That
might just be an artifact of timing getting screwed up in "top", I
guess.

Regards,
Kevin.


