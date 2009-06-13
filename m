Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbZFMTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbZFMTz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZFMTzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 15:55:17 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:2413 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZFMTzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 15:55:15 -0400
From: James Cloos <cloos@jhcloos.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, "Linux-MIPS" <linux-mips@linux-mips.org>,
       Florian Fainelli <florian@openwrt.org>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/8] add lib/gcd.c
In-Reply-To: <m3ocssw2sw.fsf@lugabout.jhcloos.org> (James Cloos's message of
	"Sat, 13 Jun 2009 11:50:15 -0400")
References: <200906041615.10467.florian@openwrt.org>
	<m38wjwz5ur.fsf@lugabout.jhcloos.org>
	<20090613162802.6c212505@lxorguk.ukuu.org.uk>
	<m3ocssw2sw.fsf@lugabout.jhcloos.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.92 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sat, 13 Jun 2009 15:54:38 -0400
Message-ID: <m3my8bvrhl.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "|" == James Cloos <cloos@jhcloos.com> writes:
>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

|> Would the binary gcd algorithm not be a better fit for the kernel?

Alan> Could well be the shift based one is better for some processors only.

|> Very likely, I suspect.

|> In any case, I do not have the hardware to do any statistically
|> significant testing;

I take that back.  Just in case speed is a relevant issue, I ran a test
on my MX, which is a small xen domU running on a:
,----
| EFamily: 0 EModel: 0 Family: 6 Model: 15 Stepping: 11
| CPU Model: Core 2 Quad 
| Processor name string: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
`----
I got, compiling with gcc-4.4 -march=native -O3:

binary
408.39user 0.05system 6:52.75elapsed 98%CPU

quick (the code in the kernel)
600.96user 0.16system 10:19.06elapsed 97%CPU

contfrac (the typical euclid algo)
569.19user 0.12system 9:35.50elapsed 98%CPU

extended euclid (calculates g=ia+jb=gcd(a,b))
684.53user 0.13system 11:32.77elapsed 98%CPU

I also tried on an old Alpha at freeshell; it had gcc-3.3; gcc's -S
output looks like it uses hardware div there, just like it does on
x86 and amd64.  The bgcd, though, was 10-16 times faster than either
version of euclid's algo.

On my laptop's P3M, binary gcd was about twice as fast as euclid.

So, although modern processors are *much* better at int div, the
binary gcd algo is still faster.

The timings on the alpha and the laptop were of:

    for (a=0xFFF; a > 0; a--)
        for (b=a; b > 0; b--)
            g=gcd(a,b);

For the core2 times quoted above, I started with a=0xFFFF.

And I forgot to mention:  the bgcd code I posted was based on
some old notes of mine which most likely trace to TAoCP.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
