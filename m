Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360Ab0ASAok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0ASAok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625Ab0ASAok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:44:40 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51021 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0ASAoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:44:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B54FFF9.9000906@s5r6.in-berlin.de>
Date: Tue, 19 Jan 2010 01:42:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?0JjQu9GM0Y8g0JHQsNGB0LjQvQ==?= <basinilya@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: net: fix panic in fwnet_write_complete
References: <574312453.20100114002526@gmail.com> <4B4E4D73.5060100@s5r6.in-berlin.de> <4B4E4FD7.9060403@s5r6.in-berlin.de> <4B53291A.5050901@s5r6.in-berlin.de> <1833218156.20100118151651@gmail.com> <4B547154.40700@s5r6.in-berlin.de> <tkrat.a8b022df2a5d588d@s5r6.in-berlin.de>
In-Reply-To: <tkrat.a8b022df2a5d588d@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> The fix is to add checks in the tx soft RQ and in the tasklet to
> determine who of these two is the last referrer to the transaction
> object.  Then handle the cleanup of the object by the last referrer
> rather than assuming that the tasklet is always the last one.
...
> Илья, could you give this a try?

My own testing on a dual core box --- peered with another Linux box
which ran the older eth1394 --- worked OK so far for transfers of
massive files (> 4 GiB) back and forth via FTP and ssh running on a text
console.

But in my first attempt to use FTP on X11 --- i.e. with more concurrent
interrupt sources --- the firewire-net box crashed very soon.  In that
test I used Dolphin of KDE as FTP client, and the crash already happened
after Dolphin had loaded and displayed the remote home directory and was
peeking into files for preview data.  I got the following trace:

------------: cut here ]------------			
kernel: BUG at mm/slab.c:2885!  			
invalid: opcode: 0000 [#1]				
PREEMPT:						
SMP:							
DEBUG_PAGEALLOC:					
							
last: sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:03:03.0/fw0/units								
Modules: linked in:					
firewire_net:						
firewire_ohci:  					
firewire_core:  					
netconsole:						
nfs:							
lockd:  						
sunrpc: 						
i915:							
drm_kms_helper: 					
drm:							
i2c_algo_bit:						
snd_hda_codec_idt:					
snd_hda_intel:  					
snd_hda_codec:  					
applesmc:						
led_class:						
input_polldev:  					
snd_pcm:						
rtc:							
i2c_i801:						
snd_timer:						
sg:							
sky2:							
snd:							
video:  						
backlight:						
snd_page_alloc: 					
thermal:						
output: 						
button: 						
							
							
Pid: 4267, comm: kio_thumbnail Not tainted 2.6.33-rc4 #2
Mac-F4208EC8/Macmini1,1							
EIP: 0060:[<c1080e4f>] EFLAGS: 00010006 CPU: 0  	
EIP: is at cache_free_debugcheck+0x1e8/0x2e8		
EAX: f8efddca EBX: f2008000 ECX: 65727661 EDX: 00c38e0a
ESI: d84156c5 EDI: f707fe40 EBP: f07fddc0 ESP: f07fdd80
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068		
Process: kio_thumbnail (pid: 4267, ti=f07fc000 task=f079b6e8
task.ti=f07fc000)  							
Stack:  						
f2008e20:						
00000000:						
0000000c:						
c11c6f96:						
00640100:						
f2008000:						
635688c0:						
d84156c5:						
							
kernel: 						
f2008ec0:						
00000082:						
f2008e18:						
00000000:						
00000000:						
f715ff30:						
f707fe40:						
f2008e20:						
							
kernel: 						
f07fddd8:						
c108137c:						
00000282:
f2008e20:
f2008e3c:
00000060:
f07fdde4:
c11c6f96:

Call: Trace:
? __kfree_skb+0x6e/0x71
? kmem_cache_free+0x56/0xb0
? __kfree_skb+0x6e/0x71
? kfree_skb+0x2b/0x2d
? unix_stream_recvmsg+0x3c3/0x48d
? file_read_actor+0x74/0xcc
? sock_aio_read+0xf2/0x107
? do_sync_read+0x89/0xc7


This was all that made it out via netconsole.  This was on 2.6.33-rc4
and I think I am going back to 2.6.32.y to eliminate unrelated .33-rc
flakiness from my testing.
-- 
Stefan Richter
-=====-==-=- ---= =--==
http://arcgraph.de/sr/
