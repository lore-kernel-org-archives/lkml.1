Return-Path: <linux-kernel-owner+w=401wt.eu-S964996AbXAYA6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964996AbXAYA6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964983AbXAYA6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:58:47 -0500
Received: from lucidpixels.com ([75.144.35.66]:35203 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964925AbXAYA6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:58:46 -0500
Date: Wed, 24 Jan 2007 19:58:44 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pavel Machek <pavel@ucw.cz>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <20070125003242.GA23343@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0701241945090.3841@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
 <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan> <20070125003242.GA23343@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jan 2007, Pavel Machek wrote:

> Hi!
> 
> > > Is it highmem-related? Can you try it with mem=256M?
> > 
> > Bad idea, the kernel crashes & burns when I use mem=256, I had to boot 
> > 2.6.20-rc5-6 single to get back into my machine, very nasty.  Remember I 
> > use an onboard graphics controller that has 128MB of RAM allocated to it 
> > and I believe the ICH8 chipset also uses some memory, in any event mem=256 
> > causes the machine to lockup before it can even get to the boot/init 
> > processes, the two leds on the keyboard were blinking, caps lock and 
> > scroll lock and I saw no console at all!
> 
> Okay, so try mem=700M or disable CONFIG_HIGHMEM or something.
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks like you may be onto something Pavel, has not invoked the OOM killer 
yet using mem=700M, I see the swap increasing and the speed of the copy is 
only 14-15MB/s, when mem= is off (giving me all memory w/preempt) I get 
45-65MB/s.

With append="mem=700M", seen below:

top - 19:38:46 up 1 min,  3 users,  load average: 1.24, 0.38, 0.13
Tasks: 172 total,   1 running, 171 sleeping,   0 stopped,   0 zombie
Cpu(s): 10.6%us,  4.6%sy,  1.3%ni, 69.6%id, 13.9%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:    705512k total,   699268k used,     6244k free,       12k buffers
Swap:  2200760k total,    18520k used,  2182240k free,    34968k cached


(with mem=700M):
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0  40276   7456     12  23184    0    0 13196 14904 1204 4756  1  2 50 47
 0  2  40276   6156     12  24264    0    0 20096 18352 1293 6400  1  4 49 46
 0  2  40276   6264     12  24264    0    0 15504 17836 1219 5202  0  2 50 48
 0  2  40276   6144     12  24376    0    0 14348 14453 1190 4815  0  3 49 48
 0  2  40276   6156     12  24504    0    0 11396 12724 1169 3724  1  2 50 48
 0  1  40276   7532     12  23272    0    0 11412 13121 1183 4017  0  2 50 48
 0  1  40276   7944     12  22644    0    0 19084 19144 1234 6548  0  4 50 46


Almost there, looks like its going to make it.
-rw-r--r-- 1 user group 18630127104 2007-01-21 12:41 18gb
-rw-r--r-- 1 user group 15399329792 2007-01-24 19:55 18gb.copy

Hrmm, with preempt off it works and with preempt ON and mem=700M it works.
I guess I will run with preempt off as I'd prefer to have the memory 
available-- and tolerate the large lag bursts w/ no preemption.


Yup it worked.

-rw-r--r-- 1 user group 18630127104 2007-01-21 12:41 18gb
-rw-r--r-- 1 user group 18630127104 2007-01-21 12:41 18gb.copy

Justin.
