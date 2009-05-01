Return-Path: <linux-kernel-owner+w=401wt.eu-S932400AbZEAPoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbZEAPoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbZEAPnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:43:51 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:34422 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZEAPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CTl6x0jZ8lCZAqbU9AZcdyJ3lbmmbC5uluSEFDFVOdQJUxCUQF08phkHeTurz6jjDT
         B85BQNQFJZT6E3y5623D1VwkqHnWALXzzSRPgFmUseNEEBYhcStXLfjTnNdq2PsQWozU
         2+m3Ex5aUrSadsROq3mURYDhdks4DR9ozujyA=
MIME-Version: 1.0
In-Reply-To: <20090501140108.GA20846@kroah.com>
References: <1241097822.2516.3.camel@poy>
	 <20090501065754.GA30626@puku.stupidest.org>
	 <20090501140108.GA20846@kroah.com>
Date: Fri, 1 May 2009 16:43:49 +0100
Message-ID: <9b2b86520905010843p63daf856pd537adcb439cbaed@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Greg KH <greg@kroah.com>
Cc: Chris Wedgwood <cw@f00f.org>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/09, Greg KH <greg@kroah.com> wrote:
> On Thu, Apr 30, 2009 at 11:57:54PM -0700, Chris Wedgwood wrote:
>> On Thu, Apr 30, 2009 at 03:23:42PM +0200, Kay Sievers wrote:
>>
>> > Devtmpfs lets the kernel create a tmpfs very early at kernel
>> > initialization, before any driver core device is registered. Every
>> > device with a major/minor will have a device node created in this
>> > tmpfs instance. After the rootfs is mounted by the kernel, the
>> > populated tmpfs is mounted at /dev. In initramfs, it can be moved to
>> > the manually mounted root filesystem before /sbin/init is executed.
>>
>> Why can't the initramfs create /dev and populate it?
>
> Right now it does, and it takes about 1-2 seconds to do so depending on
> the hardware.
>
> Which is over double the time it takes to boot the kernel entirely these
> days, so it is quite noticable.

Please, this argument is pants.  The initramfs _could_  create /dev
and populate it.  Neither crawling /sys or creating device nodes is
horribly expensive.  It's udev that adds overhead which is not needed
at this point.  If the initramfs was optimised to do the same as
devtmpfs, it needn't take more than 50ms on my eeepc.

Here's my 630Mhz Celeron in action:

# Crawl sysfs to discover valid devices
time ls -l /sys/dev/ > /dev/null

real    0m0.008s
user    0m0.000s
sys     0m0.007s

# Create X number of device nodes
time cp -a /dev/block /dev/char .dev2

real    0m0.016s
user    0m0.003s
sys     0m0.013s

If this deserves to live in the kernel, let's not pretend that it is
because it works dramatically faster.

Thanks
Alan
