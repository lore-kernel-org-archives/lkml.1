Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYEORDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYEORDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYEORC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:02:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbYEORC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:02:57 -0400
Date: Thu, 15 May 2008 14:02:56 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH][PCI]: Introduce pci_find_capability_cached and make
	MSI use it
Message-ID: <20080515170256.GE14846@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-rt-users@vger.kernel.org
References: <20080515160426.GD14846@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515160426.GD14846@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 15, 2008 at 01:04:26PM -0300, Arnaldo Carvalho de Melo escreveu:
> Hi,
> 
> 	While using the preemptirqsoff ftrace tracer I noticed that
> everytime handle_edge_irq is called it needs to mask and unmask MSI, and
> that leads to a series of very expensive calls to pci_find_capability,
> as can be seen here, with preemption disabled:
> 
>           <idle>-0     [03]   422.558652: unmask_msi_irq <-handle_edge_irq
>           <idle>-0     [03]   422.558653: msi_set_mask_bits <-unmask_msi_irq
>           <idle>-0     [03]   422.558653: msi_set_enable <-msi_set_mask_bits
>           <idle>-0     [03]   422.558654: pci_find_capability <-msi_set_enable
>           <idle>-0     [03]   422.558655: __pci_bus_find_cap_start <-pci_find_capability
>           <idle>-0     [03]   422.558655: pci_bus_read_config_word <-__pci_bus_find_cap_start
>           <idle>-0     [03]   422.558656: _spin_lock_irqsave <-pci_bus_read_config_word
>           <idle>-0     [03]   422.558656: add_preempt_count <-_spin_lock_irqsave
>           <idle>-0     [03]   422.558657: pci_read <-pci_bus_read_config_word
>           <idle>-0     [03]   422.558657: raw_pci_read <-pci_read
>           <idle>-0     [03]   422.558658: pci_conf1_read <-raw_pci_read
>           <idle>-0     [03]   422.558658: _spin_lock_irqsave <-pci_conf1_read
>           <idle>-0     [03]   422.558659: add_preempt_count <-_spin_lock_irqsave
> 
> 	  BZZT! 37us
> 
>           <idle>-0     [03]   422.558696: _spin_unlock_irqrestore <-pci_conf1_read
>           <idle>-0     [03]   422.558697: sub_preempt_count <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558697: preempt_schedule <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558698: _spin_unlock_irqrestore <-pci_bus_read_config_word
>           <idle>-0     [03]   422.558698: sub_preempt_count <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558699: preempt_schedule <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558699: __pci_find_next_cap <-pci_find_capability
>           <idle>-0     [03]   422.558700: __pci_find_next_cap_ttl <-__pci_find_next_cap
>           <idle>-0     [03]   422.558700: pci_bus_read_config_byte <-__pci_find_next_cap_ttl
>           <idle>-0     [03]   422.558701: _spin_lock_irqsave <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558701: add_preempt_count <-_spin_lock_irqsave
>           <idle>-0     [03]   422.558702: pci_read <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558702: raw_pci_read <-pci_read
>           <idle>-0     [03]   422.558703: pci_conf1_read <-raw_pci_read
>           <idle>-0     [03]   422.558703: _spin_lock_irqsave <-pci_conf1_read
>           <idle>-0     [03]   422.558704: add_preempt_count <-_spin_lock_irqsave
> 
> 	  BZZT! 38us
> 
>           <idle>-0     [03]   422.558742: _spin_unlock_irqrestore <-pci_conf1_read
>           <idle>-0     [03]   422.558743: sub_preempt_count <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558743: preempt_schedule <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558744: _spin_unlock_irqrestore <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558744: sub_preempt_count <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558745: preempt_schedule <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558745: pci_bus_read_config_byte <-__pci_find_next_cap_ttl
>           <idle>-0     [03]   422.558746: _spin_lock_irqsave <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558746: add_preempt_count <-_spin_lock_irqsave
>           <idle>-0     [03]   422.558747: pci_read <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558747: raw_pci_read <-pci_read
>           <idle>-0     [03]   422.558748: pci_conf1_read <-raw_pci_read
>           <idle>-0     [03]   422.558748: _spin_lock_irqsave <-pci_conf1_read
>           <idle>-0     [03]   422.558749: add_preempt_count <-_spin_lock_irqsave
> 
> 	  BZZT! 39us
> 
>           <idle>-0     [03]   422.558788: _spin_unlock_irqrestore <-pci_conf1_read
>           <idle>-0     [03]   422.558789: sub_preempt_count <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558789: preempt_schedule <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558790: _spin_unlock_irqrestore <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558790: sub_preempt_count <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558791: preempt_schedule <-_spin_unlock_irqrestore
>           <idle>-0     [03]   422.558791: pci_bus_read_config_byte <-__pci_find_next_cap_ttl
>           <idle>-0     [03]   422.558792: _spin_lock_irqsave <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558792: add_preempt_count <-_spin_lock_irqsave
>           <idle>-0     [03]   422.558793: pci_read <-pci_bus_read_config_byte
>           <idle>-0     [03]   422.558793: raw_pci_read <-pci_read
>           <idle>-0     [03]   422.558794: pci_conf1_read <-raw_pci_read
>           <idle>-0     [03]   422.558794: _spin_lock_irqsave <-pci_conf1_read
>           <idle>-0     [03]   422.558795: add_preempt_count <-_spin_lock_irqsave
> 
> 	  BZZT! 39us
> 
>           <idle>-0     [03]   422.558834: _spin_unlock_irqrestore <-pci_conf1_read
>           <idle>-0     [03]   422.558834: sub_preempt_count <-_spin_unlock_irqrestore
> 
> 	  <SNIP many more such BZZT!s>
> 
> 	So I implemented pci_find_capability_cached and made MSI use it
> for good measure, please consider applying.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> diff --git a/Makefile b/Makefile
> index 14f34b4..d79fdac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 25
> -EXTRAVERSION =
> +EXTRAVERSION = .pci_cached
>  NAME = Funky Weasel is Jiggy wit it
>  
>  # *DOCUMENTATION*

Ouch, left this in, do you want another patch or can you just remove
this bit?

Thanks,

- Arnaldo
