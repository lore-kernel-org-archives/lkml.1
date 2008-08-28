Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYH1Xil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYH1Xil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbYH1Xic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:38:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54593 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbYH1Xic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:38:32 -0400
Message-ID: <48B736E7.5000407@kernel.org>
Date: Thu, 28 Aug 2008 16:38:15 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Adrian Bunk <bunk@kernel.org>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Takashi Iwai <tiwai@suse.de>,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <20080828221828.GB2855@kroah.com> <48B72F53.9080109@kernel.org> <20080828231426.GA15284@kroah.com>
In-Reply-To: <20080828231426.GA15284@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Hm, why?  It's a "fake" serial port as it is just a pass-through to the
> USB device.  No flow control or line settings work on the device, so the
> kernel driver just silently eats them.  But there is old, closed source
> software that wants to talk to a serial port, so the kernel driver
> remains.  With this code, we could then use the more modern libusb code
> instead.
> 
> I guess you could hook it up through a pty, and somehow create
> /dev/pilot/ for it as well, that is an idea to consider.
> 

Why?  Because there is a lot of complexity in the tty layer, and there 
is no point in replicating the entire tty layer with all its ioctls 
through a fragile user-space emulator.  For cases like this, a pty is 
easier (your daemon opens /dev/ptmx, and then symlinks the appropriate 
pty to /dev/pilot) and works better.

>> The big problem with using ptys for serial port emulation is that they 
>> currently don't handle BREAK at all.
> 
> For this type of USB device, that's not an issue :)

Indeed.  It would be nice to fix, because it would make implementing 
serial ports as ptys+userspace a much more capable replacement.  It's 
not trivial, though, because the interpretation of the BREAK has to be 
done when received, not when sent, which means supporting a 257th value 
in the underlying buffer setup.

	-hpa
