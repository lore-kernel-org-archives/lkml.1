Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYLJMIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYLJMIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYLJMIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:08:39 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52302 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLJMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:08:38 -0500
Date: Wed, 10 Dec 2008 13:08:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, Frank Blaschka <frank.blaschka@de.ibm.com>,
       Ursula Braun <braunu@de.ibm.com>
Subject: Re: [BUILD-FAILURE] linux-next: next-20081210 - s390x - lcs
	drivers breaks with !CONFIG_IP_MULTICAST
Message-ID: <20081210120833.GA4586@osiris.boeblingen.de.ibm.com>
References: <20081210164659.9ebb8158.sfr@canb.auug.org.au> <20081210111740.GA6107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210111740.GA6107@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 04:47:40PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> 	next-20081210 randconfig kernel builds fails with !CONFIG_IP_MULTICAST
> 
> drivers/s390/net/lcs.c: In function 'lcs_new_device':
> drivers/s390/net/lcs.c:2179: error: implicit declaration of function 'lcs_set_multicast_list'
> make[2]: *** [drivers/s390/net/lcs.o] Error 1
> make[1]: *** [drivers/s390/net] Error 2
> make: *** [drivers/s390] Error 2

Thanks for reporting!

This should do the trick:

---
 drivers/s390/net/lcs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/s390/net/lcs.c
===================================================================
--- linux-2.6.orig/drivers/s390/net/lcs.c
+++ linux-2.6/drivers/s390/net/lcs.c
@@ -69,7 +69,9 @@ static char debug_buffer[255];
 static void lcs_tasklet(unsigned long);
 static void lcs_start_kernel_thread(struct work_struct *);
 static void lcs_get_frames_cb(struct lcs_channel *, struct lcs_buffer *);
+#ifdef CONFIG_IP_MULTICAST
 static int lcs_send_delipm(struct lcs_card *, struct lcs_ipm_list *);
+#endif /* CONFIG_IP_MULTICAST */
 static int lcs_recovery(void *ptr);
 
 /**
@@ -1280,6 +1282,8 @@ out:
 	lcs_clear_thread_running_bit(card, LCS_SET_MC_THREAD);
 	return 0;
 }
+#endif /* CONFIG_IP_MULTICAST */
+
 /**
  * function called by net device to
  * handle multicast address relevant things
@@ -1287,6 +1291,7 @@ out:
 static void
 lcs_set_multicast_list(struct net_device *dev)
 {
+#ifdef CONFIG_IP_MULTICAST
         struct lcs_card *card;
 
         LCS_DBF_TEXT(4, trace, "setmulti");
@@ -1294,9 +1299,9 @@ lcs_set_multicast_list(struct net_device
 
         if (!lcs_set_thread_start_bit(card, LCS_SET_MC_THREAD))
 		schedule_work(&card->kernel_thread_starter);
+#endif /* CONFIG_IP_MULTICAST */
 }
 
-#endif /* CONFIG_IP_MULTICAST */
 
 static long
 lcs_check_irb_error(struct ccw_device *cdev, struct irb *irb)
