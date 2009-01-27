Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZA0FIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZA0FIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZA0FIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:08:04 -0500
Received: from omr3.networksolutionsemail.com ([205.178.146.53]:48228 "EHLO
	omr3.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbZA0FID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:08:03 -0500
Message-ID: <497E968F.3020708@nerdgrounds.com>
Date: Mon, 26 Jan 2009 21:07:27 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com> <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
In-Reply-To: <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Can the GPU use the data placed in your file system? 
Assuming the GPU can access any part of VRAM, yes. Files created in 
vramfs will always have content that exists somewhere in video ram. A 
file you create never moves, and is always contiguous in memory. All 
your program needs to direct the GPU to it is the block offset from the 
start of VRAM, which can be obtained by an ioctl() or bmap().

I thought the best possible design would be for any process to create a 
file in vramfs, and then direct the attention of whoever's managing the 
GPU to that file (perhaps a user-space daemon), who could open the file 
and use bmap or an ioctl to locate it and direct the GPU to operate on it.

I'd also like to point out the filesystem structures themselves are 
never placed in VRAM on purpose. I'd hate for files to suddenly 
disappear from the filesystem because of an errant GPU bug or pixel 
shader gone amok; the worst that can happen by doing it that way is that 
a bunch of files go blank or get filled with garbage and no harm done.
> Do you have strong control as to exactly how the data is mapped into VRAM? 
Not exactly. When you create a file you get whatever free space is 
available. However, vramfs does guarantee that your file is never 
fragmented, never sparse, and will always exist for the life of the file 
from it's offset in video ram to the offset plus the file size. I 
believe I've written the code to be flexible enough however to allow 
stronger control if needed.
> I'm thinking about parallel processing  - Linux puts data there and then
> the GPU works on it to produce a result which Linux can eventually
> fetch.
>   
Or multimedia uses too. I'd like to see this used by MPlayer or Xine 
someday for example to make use of the MPEG-2 or H.264 hardware GPU 
decoding that today's graphics cards support: Just feed in the H.264 in 
one file and direct the GPU to spit out decoded video to another file, 
which MPlayer would have memory-mapped and could directly do something 
with it, -vf filters and all.
> - Mark
>
>
>   

