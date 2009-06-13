Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZFMUmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZFMUmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZFMUma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:42:30 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46349 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126AbZFMUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:42:29 -0400
Subject: Re: -git tree build failure #2: drivers/net/cnic.c:2520: error:
 implicit declaration of function
 =?UTF-8?Q?=E2=80=98=5F=5Fsymbol=5Fget=E2=80=99?=
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com>
	 <20090613062933.GA14034@elte.hu>
	 <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Jun 2009 15:42:26 -0500
Message-Id: <1244925747.5323.57.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-13 at 13:11 -0700, Linus Torvalds wrote:
> 
> On Sat, 13 Jun 2009, Ingo Molnar wrote:
> >
> > > I just posted a patch for this to netdev and it was acked by its maintainer.
> > > Patch is below.
> > 
> > This solves the first build failure but there's still a second build 
> > failure:
> > 
> >  drivers/net/cnic.c: In function ‘init_bnx2_cnic’:
> >  drivers/net/cnic.c:2520: error: implicit declaration of function ‘__symbol_get’
> >  drivers/net/cnic.c:2520: warning: assignment makes pointer from integer without a cast
> >  make[1]: *** [drivers/net/cnic.o] Error 1
> >  make: *** [drivers/net/cnic.o] Error 2
> > 
> > This too triggers with the config i sent. The patch below solves it 
> > - but i havent done more testing.
> > 
> > 	Ingo
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
> > index 8d74037..49135cc 100644
> > --- a/drivers/net/cnic.c
> > +++ b/drivers/net/cnic.c
> > @@ -25,6 +25,8 @@
> >  #include <linux/delay.h>
> >  #include <linux/ethtool.h>
> >  #include <linux/if_vlan.h>
> > +#include <linux/module.h>
> > +
> 
> That makes no sense. 
> 
> Look at the first #include in the file - it already includes 
> <linux/module.h>.
> 
> Why do we need to do it twice?

We don't ... it's the wrong fix.  The actual problem is that
__symbol_get() is only defined for the modular case.  What it looks to
be doing is a reflection call on bnx2_cnic_probe().  I'm not sure why
it's doing this ... other than perhaps cnic wants to avoid an explicit
bnx2 dependency?  I actually think it's incorrect, since the netdev code
before it just checked bnx2 is present, so I see no harm in an explicit
call, so this should fix it.

If it had a good reason for the reflective call, then symbol_get()
without the __ should be used.

Michael Chan, could you confirm?

James

---

diff --git a/drivers/net/bnx2.h b/drivers/net/bnx2.h
index a1ff739..d49b6da 100644
--- a/drivers/net/bnx2.h
+++ b/drivers/net/bnx2.h
@@ -7345,4 +7345,6 @@ struct bnx2_rv2p_fw_file {
 
 #define HOST_VIEW_SHMEM_BASE			0x167c00
 
+struct cnic_eth_dev *bnx2_cnic_probe(struct net_device *dev);
+
 #endif
diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index 44f77eb..3db64ad 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -2520,14 +2520,9 @@ static struct cnic_dev *init_bnx2_cnic(struct net_device *dev)
 	struct pci_dev *pdev;
 	struct cnic_dev *cdev;
 	struct cnic_local *cp;
-	struct cnic_eth_dev *ethdev = NULL;
-	struct cnic_eth_dev *(*probe)(void *) = NULL;
+	struct cnic_eth_dev *ethdev;
 
-	probe = __symbol_get("bnx2_cnic_probe");
-	if (probe) {
-		ethdev = (*probe)(dev);
-		symbol_put_addr(probe);
-	}
+	ethdev = bnx2_cnic_probe(dev);
 	if (!ethdev)
 		return NULL;
 


