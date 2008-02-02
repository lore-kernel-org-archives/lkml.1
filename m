Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbYBBOks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbYBBOks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYBBOki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:40:38 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:46181 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbYBBOki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:40:38 -0500
Date: Sat, 02 Feb 2008 15:40:36 +0100
Message-Id: <141208903@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Laurent.Vivier@bull.net, jengelh@computergmbh.de, pavel@ucw.cz
Subject: Re: [PATCH] Allow NBD to be used locally
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19CqnibOcjoCuYkCaHobfEoE3cOofjNHYjfhR/Q9v+6yErE+
 qYdDDYngrIsmt8BJWbqxlWFrvW/h79p7J45zAmUYZ1MQ+ehxU0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>In fact, VMware uses local nbd today for its vmware-loop helper
>utility, most likely because of the above-mentioned reasons. (Though
>it quite often hung last time I tried.)

seems this will go away.
recent vmware versions (e.g. server 2.0 beta) have a fuse based replacement for that.

ldd /usr/bin/vmware-mount
        linux-gate.so.1 =>  (0xffffe000)
        libz.so.1 => /lib/libz.so.1 (0xb7f95000)
! ->  libfuse.so.2 => /lib/libfuse.so.2 (0xb7f79000)   
        libpthread.so.0 => /lib/libpthread.so.0 (0xb7f61000)
        libdl.so.2 => /lib/libdl.so.2 (0xb7f5d000)
        libc.so.6 => /lib/libc.so.6 (0xb7e1c000)
        /lib/ld-linux.so.2 (0xb7fbd000)
        librt.so.1 => /lib/librt.so.1 (0xb7e13000)

i`m not sure if this is the perfect approach (slower....) , but at least that shouldn`t have those stability issues as the nbd one.

i always felt uncomfortable with the nbd approach...that`s why i started the following discussion-thread: 
http://communities.vmware.com/message/854746

anyway, i can see a point to use nbd locally, but i think it shouldn`t be abused for mapping local disk-images of any kind, even if this has better capabilities than loop or other. why should local disk data be sent trough the network layer? isn`t device-mapper the better infrastructure here?

>So what we have is non-linearity -- LBA 22 comes after LBA 40 -- loop
>does not deal with that.
maybe dm-loop does? http://sources.redhat.com/lvm2/wiki/DMLoop

regards
roland



>On Feb 2 2008 12:23, Pavel Machek wrote:
>>On Fri 2008-02-01 14:25:32, Laurent Vivier wrote:
>>> This patch allows Network Block Device to be mounted locally.
>>
>>What is local nbd good for? Use loop instead...
>
>Local NBD is good for when the content you want to make available
>through the block device is dynamic (generated on-the-fly),
>non-linear or supersparse.
>
>Take for example VMware virtual disks. Just a guess, but
>they roughly can look like this:
>
>  kilobytes  0.. 1: header
>  kilobytes  1..10: correspond to LBA 0..20
>  kilobytes 11..20: correspond to LBA 40..60
>  kilobytes 21..22: correspond to LBA 22..23
>
>So what we have is non-linearity -- LBA 22 comes after LBA 40 -- loop
>does not deal with that.
>
>And there is supersparsity -- the VMDK file itself is complete, but
>unallocated regions like LBA 24..40 are sparse/zero when projected
>onto a file/block device, respectively; loop cannot deal with that
>either.
>
>In fact, VMware uses local nbd today for its vmware-loop helper
>utility, most likely because of the above-mentioned reasons. (Though
>it quite often hung last time I tried.)
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

