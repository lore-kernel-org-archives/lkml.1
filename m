Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbYDOUlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbYDOUlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYDOUlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:41:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:20458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYDOUlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:41:07 -0400
X-ExtLoop1: 1
Message-ID: <480512BD.3060407@intel.com>
Date: Tue, 15 Apr 2008 13:40:29 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Anton Titov <a.titov@host.bg>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Bad network performance over 2Gbps
References: <1208282804.23631.27.camel@localhost> <20080415201441.GE8474@1wt.eu>
In-Reply-To: <20080415201441.GE8474@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2008 20:41:05.0703 (UTC) FILETIME=[06DB0B70:01C89F39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Apr 15, 2008 at 09:06:44PM +0300, Anton Titov wrote:
>> I use Linux for serving a huge amount of static web on few servers. When
>> network traffic goes above 2Gbit/sec ksoftirqd/5 (not every time 5, but
>> every time just one) starts using exactly 100% CPU time and packet
>> packet loss starts preventing traffic from going up. When the network
>> traffic is lower than 1.9Gbit ksoftirqds use 0% CPU according to top.
>>
>> Uplink is 6 gigabit Intel cards bonded together using 802.3ad algorithm
>> with xmit_hash_policy set to layer3+4. On the other side is Cisco 2960
>> switch. Machine is with two quad core Intel Xeons @2.33GHz.
>>
>> Here goes a screen snapshot of "top" command. The described behavior
>> have nothing to do with 13% io-wait. It happens even if it is 0%
>> io-wait.
>> http://www.titov.net/misc/top-snap.png
>>
>> kernel configuration:
>> http://www.titov.net/misc/config.gz
>>
>> /proc/interrupts, lspci, dmesg (nothing intresting there), ifconfig,
>> uname -a:
>> http://www.titov.net/misc/misc.txt.gz
>>
>> Is it a Linux bug or some hardware limitation?
> 
> possibly some missing parameters when loading your e1000 drivers.
> e1000 NICs support interrupt rate limitation, which proves very
> efficient in cases such as yours. I'm used to limit them to about
> 5k ints/s. Do a "modinfo e1000" to get the parameter name, I don't
> have it quite right in mind.
> 
> Also, I've CCed linux-net.

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6
      CPU7
  0:        342        261        258        278        271        253        264
       283   IO-APIC-edge      timer
  1:          0          0          1          0          1          0          0
         0   IO-APIC-edge      i8042
  6:          0          1          0          1          0          0          1
         0   IO-APIC-edge      floppy
  9:          0          0          0          0          0          0          0
         0   IO-APIC-fasteoi   acpi
 12:          1          1          0          0          0          1          1
         0   IO-APIC-edge      i8042
 17:        180        190        178        183        182        186        186
       188   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb4
 18:     843504     842514     843653     842033     842416     842742     841903
    842960   IO-APIC-fasteoi   3w-9xxx, uhci_hcd:usb3
 19:          0          0          0          0          0          0          0
         0   IO-APIC-fasteoi   uhci_hcd:usb2
498:  534642903  534635899  534726883  534732377  534701710  534708588  534730550
 534742730   PCI-MSI-edge      eth5
499:  531832274  531846609  531917849  531942676  531855140  531850692  531885565
 531863468   PCI-MSI-edge      eth4
500:  487251627  487279206  487248030  487220044  487239637  487231454  487281672
 487227202   PCI-MSI-edge      eth3
501:  486083953  486062203  486109925  486075793  486036977  486035152  486097551
 486117164   PCI-MSI-edge      eth2
502:  528889380  528863624  528760188  528798619  528891886  528890760  528807939
 528822746   PCI-MSI-edge      eth1
503:  529043135  529056706  528980250  528975209  529018995  529027386  528941583
 528970472   PCI-MSI-edge      eth0
NMI:          0          0          0          0          0          0          0
         0   Non-maskable interrupts
LOC:   62893699   62809502   62744208   62746035   62708815   62709055   62739182
  62620363   Local timer interrupts
RES:   15454866   15827970   16235695   15386970   15761053   16097167   16190851
  16159843   Rescheduling interrupts
CAL:         85         98         85         84         98         93         94
        91   function call interrupts
TLB:    3565361    3561798    3570271    3566272    3556996    3555866    3578257
   3564557   TLB shootdowns
TRM:          0          0          0          0          0          0          0
         0   Thermal event interrupts
THR:          0          0          0          0          0          0          0
         0   Threshold APIC interrupts
SPU:          0          0          0          0          0          0          0
         0   Spurious interrupts


Yikes! all wrong!

the network irq's are being ping-ponged around all the cores! bad!

1) turn the in-kernel IRQBALANCE option off !
2) use either the userspace `irqbalance` daemon or
3) set smp_affinity manually

Auke

> 
> Regards,
> Willy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

