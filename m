Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYLSNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYLSNzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYLSNza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:55:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbYLSNz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:55:29 -0500
Message-ID: <494BA7CE.2020007@suse.de>
Date: Fri, 19 Dec 2008 14:55:26 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Seewer Philippe <philippe.seewer@bfh.ch>
Cc: Bernhard Walle <bwalle@suse.de>, Christoph Hellwig <hch@infradead.org>,
       initramfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
       cjwatson@ubuntu.com, Bernhard Walle <bwalle@novell.com>
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
References: <1229540094.28858.150.camel@aglarond.local>	<20081217190700.GA15377@infradead.org>	<4949FD67.6040906@suse.de>	<494B5031.5080306@bfh.ch> <20081219091841.207bc951@kopernikus.site>
In-Reply-To: <20081219091841.207bc951@kopernikus.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Bernhard Walle wrote:
> * Seewer Philippe [2008-12-19 08:41]:
>> Hannes Reinecke wrote:
>> [snip]
>>> If anyone is interested I can give a short overview of it.
>> Please do so, would be appreciated.
> 
> A good start is the manual page in section 5:
> http://git.opensuse.org/?p=projects/mkinitrd.git;a=blob_plain;f=man/mkinitrd.5.txt;hb=7583c3cc047edc3e8f1a06e8b7925bd27ac0228c
> 
> (The git.kernel.org and the opensuse.org repos are basically the same,
> we just switched to opensuse.org after the internal maintainership has
> been transferred from Hannes to myself because it was easier to add
> new users there. The opensuse.org git repo site didn't exist when the
> kernel.org mkinitrd repo was created.)
> 
> Anyway:
> 
> The basic idea is to have most stuff not in the main 'mkinitrd' script
> but in modules. Each module has (normally) a setup script part that is
> executed when the initrd is created, and a boot part that is executed
> when the initrd is running. For example, NFS root is in the 'nfs-util'
> package, not in 'mkinitrd'. Same for iSCSI. Or the kdump part is
> not in the main mkinitrd but in our 'kdump' package [1]. So the main
> initrd  package is quite small but still very flexible.
> 
> It's also flexible enough to use Busybox as module that resides in the
> 'busybox' package and can then be enabled with -F busybox (feature)
> when building the initrd.
> 
> Only documentation is at the current time a bit weak, one has to fiddle
> some stuff from the sources when writing new modules. But that's easy
> to fix. :-)
> 
> Hannes may explain more ...
> 
Yes, quite so. The design principles are as follows:

The goal of the initrd is to activate and mount the root fs.
And the root fs _only_. Every other system should be configured
once the main system is running.

So mkinitrd has two parts:
a) Detect the configuration of the rootfs and create the
   initramfs
b) Configure the rootfs on boot.

Therefore there are two distinct script types:

setup-XXX.sh - run during initrd creation time to detect
  and record the configuration

boot-XXX.sh - run during boot to configure the subsystem

The setup scripts have these tasks:
- Detect the rootfs
- Unwind the storage stack and record the configuration
  on each level
- Copy the required contents into the initramfs
- Pack initramfs for use

The boot scripts have these tasks:
- Initial configuration (create required device nodes, start udev)
- Configure the storage stack
- fsck and mount the root fs

So basically the boot scripts have to be called in reverse
order to the setup scripts.
To ensure the order is preserved during each run I've
introduced some 'stages', which are run consecutively.
These stages are documented in mkinitrd.5

The neat thing here is that we've split off each
configuration into small scripts, which will be called
if present. This allows for a pretty modular setup
and avoid the massive requirement setting of an
monolithic script.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
