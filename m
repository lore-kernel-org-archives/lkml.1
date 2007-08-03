Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXHCSFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXHCSFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758599AbXHCSFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:05:11 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:39097 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753560AbXHCSFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:05:08 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: Jeff Garzik <jeff@garzik.org>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: dev->priv to netdev_priv(dev)
References: <87r6mzmf6q.fsf@wanadoo.fr> <46AE43F5.8070802@garzik.org>
Date: Fri, 03 Aug 2007 20:03:05 +0200
In-Reply-To: <46AE43F5.8070802@garzik.org> (Jeff Garzik's message of "Mon, 30
	Jul 2007 16:03:01 -0400")
Message-ID: <87myx8338m.fsf_-_@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

>> PS: I have performed the same transformation on the whole kernel
>> and it affects around 70 files, most of them in drivers/net/.
>> Should I split my patch for each subnet directories ? (wireless/, wan/, etc)
>
> applied.  splitting up by sub-directory would be helpful.

Done. I was not always able to find the maintainer for all the subdirectories
so for those cases I have considered you as the maintainer :)

I have run another semantic patch (more like a semantic grep in fact)
to find the places where our tool didn't transform the dev->priv to
netdev_priv. The reason is that our tool was not able to find the call
to alloc_dev_xxx(sizeof(T),...) in the driver or there was an
assignation to dev->priv which means that transforming to netdev_priv
would do something wrong. I have printed the list of "bad driver"
below.

In very few cases the driver was in fact "good" but because of the
way the code was written, our tool was not able to find the alloc_xxx
function.



drivers/net/82596.c                     
drivers/net/chelsio/cxgb2.c             
drivers/net/chelsio/sge.c               
drivers/net/cxgb3/cxgb3_main.c          
drivers/net/cxgb3/sge.c                 
drivers/net/e1000/e1000_main.c          
drivers/net/ehea/ehea_main.c            
drivers/net/hamradio/dmascc.c           
drivers/net/hamradio/scc.c              
drivers/net/lance.c                     
drivers/net/mace.c                      

 for mace.c the code is written this way:

    #define PRIV_BYTES	(sizeof(struct mace_data) \
       + (N_RX_RING + NCMDS_TX * N_TX_RING + 3) * sizeof(struct dbdma_cmd))

     dev = alloc_etherdev(PRIV_BYTES);
 
 So our semantic patch can't find a   alloc_etherdev(sizeof(T)).
 If I inline the definition of PRIV_BYTES, then our tool will be
 able to transform it.

 


drivers/net/ni65.c      
drivers/net/pcmcia/com20020_cs.c

   dev = alloc_arcdev("");
 

drivers/net/ppp_generic.c       
drivers/net/spider_net_ethtool.c 

 again, the code is written this way:

       alloc_size = sizeof(struct spider_net_card) +
          (tx_descriptors + rx_descriptors) * sizeof(struct spider_net_descr);
       netdev = alloc_etherdev(alloc_size);

 If I inline the definition of alloc_size, then we can transform
 the file.

drivers/net/tulip/xircom_cb.c           
drivers/net/wan/cosa.c                  
drivers/net/wan/cycx_x25.c              
drivers/net/wan/hdlc_fr.c               
drivers/net/wan/hdlc_ppp.c              
drivers/net/wan/hostess_sv11.c          
drivers/net/wan/pc300_drv.c             
drivers/net/wan/sbni.c                  
drivers/net/wireless/airo.c             
drivers/net/wireless/libertas/ethtool.c 
drivers/net/wireless/libertas/main.c    
drivers/net/wireless/libertas/scan.c    
drivers/net/wireless/libertas/wext.c    
drivers/net/wireless/wavelan.c          
drivers/net/wireless/zd1201.c           

drivers/net/tokenring/tms380tr.c
   This file is both used as a single module and used by other module.
   The other modules have a call to a alloc_xxx but not tms380tr.c when
   used as a single module. 
  

