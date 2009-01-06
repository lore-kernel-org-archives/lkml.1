Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZAFMGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZAFMGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZAFMGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:06:21 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:39852 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZAFMGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:06:20 -0500
X-IronPort-AV: E=Sophos;i="4.36,338,1228107600"; 
   d="scan'208";a="64827913"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <gregkh@suse.de>
Subject: Re: debugfs & vfs file permission issue?
Date: Tue, 6 Jan 2009 07:05:33 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <200901052157.07306.rgetz@blackfin.uclinux.org> <20090106061946.GA10026@suse.de> <8bd0f97a0901052232l22b60386pbcd9438cc752638f@mail.gmail.com>
In-Reply-To: <8bd0f97a0901052232l22b60386pbcd9438cc752638f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901060705.33294.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Jan 2009 12:05:22.0045 (UTC) FILETIME=[0CE10AD0:01C96FF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 6 Jan 2009 01:32, Mike Frysinger pondered:
> On Tue, Jan 6, 2009 at 01:19, Greg KH wrote:
> > On Tue, Jan 06, 2009 at 12:54:58AM -0500, Mike Frysinger wrote:
> >> On Tue, Jan 6, 2009 at 00:48, Greg KH wrote:
> >> > On Mon, Jan 05, 2009 at 09:57:07PM -0500, Robin Getz wrote:
> >> >> On 2.6.28-rc2, If I create a debugfs file with
> >> >>
> >> >>     debugfs_create_x16("SPORT1_TX", 0200 , parent, 0xFFC00910);
> >> >
> >> > Um, are you are passing in a pointer to a known memory location
> >> > properly?  Why would it be ok for the kernel to directly read that
> >> > location?
> >>
> >> it's a nommu system and the 0xffc00000+ addresses are always available
> >
> > Writable but not readable?  Isn't hardware fun :)
> 
> yeah and we have some readable but not writable addresses too :/
> 
> >> >> Although the file shows up as write only (no read):
> >> >>
> >> >> root:/> ls -l /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> >> >> --w-------    1 root     root            0 Jan  1
> >> >> 2007 /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> >> >>
> >> >> root:/> cat /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> >> >>
> >> >> Still works - and causes the read to occur, which crashes :(
> >> >
> >> > You're root, you can do anything :)
> >>
> >> any thoughts on how to declare debugfs files that are read or write
> >> only ?  we'll have to add new helper functions or have it be a
> >> parameter or declare our own debugfs file ?
> >
> > Just use debugfs_create_file() and use your own read/write functions to
> > prevent a read or write from happening no matter what.  No new debugfs
> > infrastructure should be needed.
> 
> would it be useful for this to be a common function ?  probably not so
> much considering (i'm assuming) no one else has asked so far for such
> a beast ...

Today there is:

file.c:DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs_u8_get, debugfs_u8_set, "%llu\n");
file.c:DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugfs_u16_get, debugfs_u16_set, "%llu\n");
file.c:DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugfs_u32_get, debugfs_u32_set, "%llu\n");
file.c:DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugfs_u64_get, debugfs_u64_set, "%llu\n");
file.c:DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");
file.c:DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
file.c:DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");

adding a readonly, and writeonly, and ensuring that when you call 
debugfs_create_*, the mode is checked, and the "correct" fops are set 
doesn't seem like it would be a bad idea? This would enforce the
kernel programmer's view on the world, and not allow pesky root users
to override things....

Greg - would you take something like that?

Or do you just want us to it as you suggested previously? and don't use the 
existing debugfs_create_* functions directly on wonky hardware registers?

Thanks
-Robin
