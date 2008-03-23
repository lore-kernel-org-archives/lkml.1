Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbYCWKka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbYCWKka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 06:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbYCWKkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 06:40:21 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:48523 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbYCWKkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 06:40:19 -0400
Message-ID: <47E6338E.8030001@orcon.net.nz>
Date: Sun, 23 Mar 2008 23:40:14 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080318032427.298BCDBA2@gherkin.frus.com> <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz>
In-Reply-To: <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx3.orcon.net.nz on Sun, 23 Mar 2008 23:40:16 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Mar 23 23:40:17 2008
X-DSPAM-Confidence: 0.6513
X-DSPAM-Improbability: 1 in 188 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Cree wrote:
> On 18/03/2008, at 4:24 PM, Bob Tracy wrote:
> 
>> I'll try the below when I get back from my business trip (in approx.
>> two weeks).  Apologies for the inconvenience, but the Alpha hardly
>> qualifies as a laptop :-).  If someone else with a Miata (or other
>> Alpha with the ES1888 sound device) cares to give this a try, I *will*
>> be keeping up with my e-mail.
> 
> I should be able to give this a go over Easter on a PWS500au, which, 
> IIRC, is a miata system.

I have been able to run some tests.  BTW, it is a PWS600au I have.  It 
has an ES1887 sound chip.  The most important result is that it is not 
only the snd-es18xx driver that fails (often leading to complete system 
lockups) but I also installed a CM8738 based sound card and use of the 
snd-cmipci driver exhibits exactly the same symptoms as the snd-es18xx 
driver.  Both of these drivers work find on the Compaq XP1000.

I am testing with the 2.6.24.3 kernel.  On the PWS600au I have compiled 
the kernel for the miata system and selected the EV56 cpu option.  On 
the XP1000 I have compiled the kernel for a DP264 system and with the 
EV67 cpu option.  In response to an earlier question by Rene I note that 
arch/alpha/kernel/es1888.o is added in as a built in object by both systems.

The es18xx and cmipci drivers work fine on the XP1000.  I base that 
observation on using a variety of software, such as mplayer and mocp, 
through both sound cards, mainly through oss, but also have tried alsa, 
over the last year for es18xx and for the last three or four months for 
cmipci.  (I have noted that the M-Audio Revolution 7.1 sound card with 
the ice1724 driver fails to work and causes system crashes on the 
XP1000, but that's a different discussion).

On the PWS600au I have been running aplay on a two minute or so long wav 
file (because that is what I have on that system and couldn't be 
bothered searching for short files like what Bob was having troubles 
with).  I can play the file once (using aplay) without any problem. 
When I attempt to the play the file the second time all hell breaks 
lose, sometimes with a variety of pops and whistles out the sound card, 
and the system crashes or just completely freezes.  Occasionally a 
kernel oops makes it into the logs.  This happens for both sound drivers 
(es18xx driver into the ES1887 and the cmipci driver into the CM8738 
sound card).

I applied the patches of Rene (es18xx-trial-and-error.diff) and the 
patch provided by Takashi (with the #ifdef CONFIG_ALPHA detection). 
Similar behaviour as before.  First time playing the sound file works 
and on attempting to play the sound file for the second time the system 
crashes and locks up.  (The es18xx-trial... patch produces no sound and 
interrupts do not clock up in /proc/interrupts.  The crash on second 
time of playing a sound file still occurs).

The same behaviour as above also occurs with running the speaker-test 
program.

I therefore think we are looking in the wrong place if we are looking at 
the es18xx driver!

An example of the kernel oops that occurs on running aplay for the 
second time (actually it was third time in this particular trial - the 
second time just lead to a segmentation violation) follows:

Unable to handle kernel paging request at virtual address 0000000000100100
aplay(2125): Oops 0
pc = [<fffffc000035bd80>]  ra = [<fffffc000035bcac>]  ps = 0007    Not 
tainted
pc is at get_page_from_freelist+0x1b0/0x4d0
ra is at get_page_from_freelist+0xdc/0x4d0
v0 = 0000000000000000  t0 = 0000000000000000  t1 = 0000000000100100
t2 = 0000000000000000  t3 = fffffc0000b2ab38  t4 = 0000000000100000
t5 = 0000000000000001  t6 = 0000000000000002  t7 = fffffc0021ba4000
s0 = fffffc00006ea028  s1 = 00000000001000d8  s2 = fffffc00006ea018
s3 = 0000000000000002  s4 = fffffc00006e9fe8  s5 = 0000000000000000
s6 = 0000000000000001
a0 = 0000000000000007  a1 = 0000000000000000  a2 = 00000000000001dd
a3 = 0000000000000000  a4 = 0000000000000044  a5 = 0000000000000002
t8 = 000000000000001f  t9 = 000002000009cd54  t10= 000000000001fee0
t11= 0000000000000010  pv = fffffc000035c5d0  at = 0000000000000000
gp = fffffc000071c598  sp = fffffc0021ba7c50
Trace:
[<fffffc000035c64c>] __alloc_pages+0x7c/0x450
[<fffffc0000369ff0>] handle_mm_fault+0x470/0x6e0
[<fffffc0000380610>] vfs_read+0xc0/0x190
[<fffffc0000369fcc>] handle_mm_fault+0x44c/0x6e0
[<fffffc000031f604>] do_page_fault+0x2d4/0x490
[<fffffc0000310bdc>] entMM+0x9c/0xc0
[<fffffc00003806a0>] vfs_read+0x150/0x190
[<fffffc000

(and dmesg failed at this point as the system crashed.)


The following example was playing through the cmipci sound driver and 
copied from the system log (since the system locked up before I ran dmesg):

Mar 23 22:24:38 aleph kernel: Kernel bug at mm/mmap.c:2054
Mar 23 22:24:38 aleph kernel: aplay(2604): Kernel Bug 1
Mar 23 22:24:38 aleph kernel: pc = [<fffffc000036cba4>]  ra = 
[<fffffc000036cb68>]  ps = 0000    Not tainted
Mar 23 22:24:38 aleph kernel: pc is at exit_mmap+0x134/0x150
Mar 23 22:24:38 aleph kernel: ra is at exit_mmap+0xf8/0x150
Mar 23 22:24:38 aleph kernel: v0 = 0000000000000000  t0 = 
0000000000000002  t1 = 0000000000000041
Mar 23 22:24:38 aleph kernel: t2 = 0000000000000040  t3 = 
fffffc002300c600  t4 = 0000000000000008
Mar 23 22:24:38 aleph kernel: t5 = fffffc00001da000  t6 = 
0000000000000000  t7 = fffffc001a34c000
Mar 23 22:24:38 aleph kernel: a0 = 0000000000000000  a1 = 
fffffc002300c400  a2 = 0000000000000000
Mar 23 22:24:38 aleph kernel: a3 = 0000000000000000  a4 = 
0000000000000000  a5 = 0000000000000000
Mar 23 22:24:38 aleph kernel: t8 = 0000000000000000  t9 = 
000000684d5720ff  t10= d000000000000000
Mar 23 22:24:38 aleph kernel: t11= 0000000000002000  pv = 
fffffc000037c0b0  at = 0000000000000002
Mar 23 22:24:38 aleph kernel: gp = fffffc000071c598  sp = fffffc001a34fbe8
Mar 23 22:24:38 aleph kernel: Trace:
Mar 23 22:24:38 aleph kernel: [<fffffc0000325e4c>] mmput+0x5c/0x100
Mar 23 22:24:38 aleph kernel: [<fffffc000032a500>] exit_mm+0xc0/0x180
Mar 23 22:24:38 aleph kernel: [<fffffc000032b63c>] do_exit+0x16c/0x950
Mar 23 22:24:38 aleph kernel: [<fffffc000032be64>] do_group_exit+0x44/0xc0
Mar 23 22:24:38 aleph kernel: [<fffffc000033677c>] 
get_signal_to_deliver+0x2fc/0x450
Mar 23 22:24:38 aleph kernel: [<fffffc0000316874>] 
do_notify_resume+0xb4/0x570
Mar 23 22:24:38 aleph kernel: [<fffffc00003110cc>] work_pending+0x5c/0x70
Mar 23 22:24:38 aleph kernel: [<fffffc0000334c40>] 
__sigqueue_alloc+0x40/0xc0
Mar 23 22:24:38 aleph kernel: [<fffffc0000390480>] do_ioctl+0x30/0x90
Mar 23 22:24:38 aleph kernel: [<fffffc0000335634>] 
specific_send_sig_info+0xd4/0x110
Mar 23 22:24:38 aleph kernel: [<fffffc000033577c>] force_sig_info+0x8c/0xe0
Mar 23 22:24:38 aleph kernel: [<fffffc0000310bdc>] entMM+0x9c/0xc0
Mar 23 22:24:38 aleph kernel:
Mar 23 22:24:38 aleph kernel: Code: a77df570  6b5b497f  27ba003b 
23bdfa04  c3ffffec  00000081 <00000806> 00609c4a
Mar 23 22:24:38 aleph kernel: Fixing recursive fault but reboot is needed!


Hope the above gives food for thought.

Michael.

