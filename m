Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYAVUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYAVUou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYAVUom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:44:42 -0500
Received: from 1wt.eu ([62.212.114.60]:1505 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYAVUol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:44:41 -0500
Date: Tue, 22 Jan 2008 21:15:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080122201524.GA16428@1wt.eu>
References: <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080117225744.GL8244@cosmic.amd.com> <478FE733.2030806@i4.informatik.rwth-aachen.de> <20080121232709.GJ10837@cosmic.amd.com> <20080121233226.GA1052@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121233226.GA1052@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Tue, Jan 22, 2008 at 12:32:26AM +0100, Willy Tarreau wrote:
> [   44.013100] NET: Registered protocol family 16                               
> [   44.066308] geode-mfgpt:  IRQ MSR=0:0                                        
> [   44.110161] geode-mfgpt:  NMI MSR=0:0                                        
> [   44.154037] geode-mfgpt:  Unrestricted sources=0                             
> 
> Then it hangs here.
> In another mail I sent privately to Andres, I noticed that it was the
> following line which hangs at first iteration (i == 0) :
> 
>                 val = geode_mfgpt_read(i, MFGPT_REG_SETUP);
> 
> I have a tinybios 0.98 with no workaround option configurable. I also
> have CONFIG_GEODE_MFGPT_TIMER=n.

Good news! I read the mfgpt patch for 2.6.22 and saw what the workaround
consisted in (writing 0xff at MSR 0x5140002B). So I tried adding the
following on top of 2.6.24-rc8 :

static int __init mfgpt_fix(char *s)
{
	u32 val, dummy;

        /* The following udocumented bit resets the MFGPT timers */
        val = 0xFF;
        wrmsr(0x5140002B, val, dummy);

	return 1;
}
__setup("mfgptfix", mfgpt_fix);

and booted with the newly added option (mfgptfix). It worked like a charm :

[   29.173796] NET: Registered protocol family 16
[   29.226986] geode: lbars[0].base = 0x9d00
[   29.275003] geode: lbars[1].base = 0x9c00
[   29.323042] geode: lbars[2].base = 0x6100
[   29.371082] geode: lbars[3].base = 0x6200
[   29.419121] geode-mfgpt:  IRQ MSR=0:0                                        
[   29.463000] geode-mfgpt:  NMI MSR=0:0                                        
[   29.506881] geode-mfgpt:  Unrestricted sources=0                             
[   29.562202] geode_mfgpt: reading 0x6200 + 0x6 + (0x0 * 8) = 0x6206           
[   29.636237] geode_mfgpt: reading 0x6200 + 0x6 + (0x1 * 8) = 0x620e           
[   29.710270] geode_mfgpt: reading 0x6200 + 0x6 + (0x2 * 8) = 0x6216           
[   29.784305] geode_mfgpt: reading 0x6200 + 0x6 + (0x3 * 8) = 0x621e           
[   29.858338] geode_mfgpt: reading 0x6200 + 0x6 + (0x4 * 8) = 0x6226           
[   29.932376] geode_mfgpt: reading 0x6200 + 0x6 + (0x5 * 8) = 0x622e           
[   30.006409] geode_mfgpt: reading 0x6200 + 0x6 + (0x6 * 8) = 0x6236           
[   30.080444] geode_mfgpt: reading 0x6200 + 0x6 + (0x7 * 8) = 0x623e           
[   30.154475] geode:  8 MFGPT timers available.                                

So it seems like applying the workaround on top of TinyBIOS 0.98 undoes
this BIOS's workaround. I'm now wondering how we could detect whether
the workaround was applied or not :-/

Next, I retried with MFGPT_TIMER=y + latest fix you posted moving the
initialization race, and here's what I get now :

root@ALOHA-500:~# cat /proc/interrupts                                          
           CPU0                                                                 
  0:         77    XT-PIC-XT        timer                                       
  2:          0    XT-PIC-XT        cascade                                     
  4:        348    XT-PIC-XT        serial                                      
  7:      12273    XT-PIC-XT        mfgpt-timer                                 
  8:          0    XT-PIC-XT        rtc                                         
 10:         80    XT-PIC-XT        eth0                                        
 11:          0    XT-PIC-XT        eth1                                        
 12:          1    XT-PIC-XT        eth2                                        
 14:      13614    XT-PIC-XT        ide0                                        
NMI:          0   Non-maskable interrupts                                       
TRM:          0   Thermal event interrupts                                      
SPU:          0   Spurious interrupts                                           
ERR:          0                                                                 

Interestingly, during the boot, I got thousands of the following line :
geode_mfgpt: reading 0x6200 + 0x6 + (0x0 * 8) = 0x6206                          

It's a debug line I added in geode_mfgpt_read() which writes the timer and
reg being read. It slowed the boot down due to being written to a serial
console, but fortunately stopped when syslogd had changed the console log
level. Just checking...

# grep mfgpt /proc/interrupts;sleep 10;grep mfgpt /proc/interrupts
  7:      82320    XT-PIC-XT        mfgpt-timer
  7:      84882    XT-PIC-XT        mfgpt-timer

It delivers 256 IRQs/s. That makes me think about this comment in mfgpt_32.c :

 * We are using the 32Khz input clock - its the only one that has the
 * ranges we find desirable.  The following table lists the suitable
 * divisors and the associated hz, minimum interval
 * and the maximum interval:
 *
 *  Divisor   Hz      Min Delta (S) Max Delta (S)
 *   1        32000     .0005          2.048
 *   2        16000      .001          4.096
 *   4         8000      .002          8.192
...

When you say a 32kHz clock, you mean 32000 Hz. Are you really sure ? Most
32 kHz clocks everywhere are really 32768 Hz (the watch quartz). BTW, I'm
seeing a 32.768 kHz xtal close to the CS5536, and the numbers above seem
to support this suggestion too.

So right now that I've found what caused old kernel to unexpectedly work,
I'm planning a BIOS upgrade. I'm still just wondering what we can do to
detect that the workaround should be needed. I suspect nothing, of course,
but just in case... Maybe we can detect the effects of the workaround ?

Best regards,
Willy

