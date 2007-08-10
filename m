Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbXHJM2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbXHJM2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbXHJM17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:27:59 -0400
Received: from mail.xandmail.com ([212.155.184.97]:39511 "EHLO
	mail.xandmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbXHJM15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:27:57 -0400
Date: Fri, 10 Aug 2007 14:27:15 +0200
Message-Id: <JMK59F$A939B2F621EBD81DEDA4E2E798F90696@xandmail.com>
Subject: Re: 2.6.23-rc2: WARNING: at kernel/irq/resend.c:70  check_irq_resend()
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>
To: "mingo" <mingo@elte.hu>
Cc: "jarkao2" <jarkao2@o2.pl>, "tglx" <tglx@linutronix.de>,
       "john" <john@stoffel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "shemminger" <shemminger@linux-foundation.org>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>,
       "torvalds" <torvalds@linux-foundation.org>,
       "akpm" <akpm@linux-foundation.org>, "alan" <alan@lxorguk.ukuu.org.uk>,
       "linux-net" <linux-net@vger.kernel.org>,
       "netdev" <netdev@vger.kernel.org>
X-XaM3-API-Version: 4.2(R3) (B21)
X-type: 0
X-SenderIP: 212.155.184.109
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

see below

>  arch/i386/kernel/io_apic.c   |    3 ++-
>  arch/x86_64/kernel/genapic.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/i386/kernel/io_apic.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/io_apic.c
> +++ linux/arch/i386/kernel/io_apic.c
> @@ -735,7 +735,8 @@ void fastcall send_IPI_self(int vector)
>  	 * Wait for idle.
>  	 */
>  	apic_wait_icr_idle();
> -	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL;
> +	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL |
> +		APIC_INT_LEVELTRIG;
>  	/*
>  	 * Send the IPI. The write to APIC_ICR fires this off.
>  	 */
> Index: linux/arch/x86_64/kernel/genapic.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/genapic.c
> +++ linux/arch/x86_64/kernel/genapic.c
> @@ -62,5 +62,6 @@ void __init setup_apic_routing(void)
>  
>  void send_IPI_self(int vector)
>  {
> -	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
> +	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL |
> +			    APIC_INT_LEVELTRIG);
>  }
>

clean 2.6.23-rc1 with this patch : 

Aug 10 14:12:09 loki kernel: NETDEV WATCHDOG: eth2: transmit timed out
Aug 10 14:12:09 loki kernel: eth2: transmit timed out, tx_status 00 status e601.
Aug 10 14:12:09 loki kernel:   diagnostics: net 0ccc media 8880 dma 0000003a fifo 8000
Aug 10 14:12:09 loki kernel: eth2: Interrupt posted but not delivered -- IRQ blocked by another device?
Aug 10 14:12:09 loki kernel:   Flags; bus-master 1, dirty 231829(5) current 231829(5)
Aug 10 14:12:09 loki kernel:   Transmit list 00000000 vs. ffff81007eaad520.
Aug 10 14:12:09 loki kernel:   0: @ffff81007eaad200  length 80000115 status 0c010115
Aug 10 14:12:09 loki kernel:   1: @ffff81007eaad2a0  length 8000005c status 0c01005c
Aug 10 14:12:09 loki kernel:   2: @ffff81007eaad340  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   3: @ffff81007eaad3e0  length 8000002a status 8001002a 
Aug 10 14:12:09 loki kernel:   4: @ffff81007eaad480  length 8000005c status 8c01005c
Aug 10 14:12:09 loki kernel:   5: @ffff81007eaad520  length 80000042 status 00010042
Aug 10 14:12:09 loki kernel:   6: @ffff81007eaad5c0  length 8000007b status 0001007b
Aug 10 14:12:09 loki kernel:   7: @ffff81007eaad660  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   8: @ffff81007eaad700  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   9: @ffff81007eaad7a0  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   10: @ffff81007eaad840  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   11: @ffff81007eaad8e0  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   12: @ffff81007eaad980  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   13: @ffff81007eaada20  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   14: @ffff81007eaadac0  length 8000002a status 0001002a
Aug 10 14:12:09 loki kernel:   15: @ffff81007eaadb60  length 8000002a status 0001002a

I did not had to wait too long for this to occurs (1-2 minutes).

Jb


