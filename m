Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbZFNAuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbZFNAuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 20:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758779AbZFNAt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 20:49:56 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3087 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZFNAt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 20:49:56 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: -git tree build failure #2: drivers/net/cnic.c:2520: error:
 implicit declaration of function
 =?UTF-8?Q?=E2=80=98=5F=5Fsymbol=5Fget=E2=80=99?=
From: "Michael Chan" <mchan@broadcom.com>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1244925747.5323.57.camel@mulgrave.site>
References: <20090612184343.GA11900@elte.hu>
 <4A32A1E4.8080708@oracle.com> <20090613062933.GA14034@elte.hu>
 <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
 <1244925747.5323.57.camel@mulgrave.site>
Date: Sat, 13 Jun 2009 17:43:02 -0700
Message-ID: <1244940182.12000.5.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 662A96A338G5353714-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-06-13 at 13:42 -0700, James Bottomley wrote:
> On Sat, 2009-06-13 at 13:11 -0700, Linus Torvalds wrote:
> > 
> > 
> > That makes no sense. 
> > 
> > Look at the first #include in the file - it already includes 
> > <linux/module.h>.
> > 
> > Why do we need to do it twice?
> 
> We don't ... it's the wrong fix.  The actual problem is that
> __symbol_get() is only defined for the modular case.  What it looks to
> be doing is a reflection call on bnx2_cnic_probe().  I'm not sure why
> it's doing this ... other than perhaps cnic wants to avoid an explicit
> bnx2 dependency?  I actually think it's incorrect, since the netdev code
> before it just checked bnx2 is present, so I see no harm in an explicit
> call, so this should fix it.
> 
> If it had a good reason for the reflective call, then symbol_get()
> without the __ should be used.
> 
> Michael Chan, could you confirm?
> 
Thanks James and Ingo.  We don't want to have a symbol dependency on
bnx2 because this driver eventually will support the 10G bnx2x driver as
well.  So we want the driver to support either or both NIC drivers
without both drivers loaded.  Please use the patch below.

cnic: Fix __symbol_get() build error.

Ingo molnar <mingo@elte.hu> reported the error when CONFIG_MODULES is
not defined.

Signed-off-by: Michael Chan <mchan@broadcom.com>

diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index a9e2fd3..4d1515f 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -2519,9 +2519,9 @@ static struct cnic_dev *init_bnx2_cnic(struct net_device *dev)
 	struct cnic_dev *cdev;
 	struct cnic_local *cp;
 	struct cnic_eth_dev *ethdev = NULL;
-	struct cnic_eth_dev *(*probe)(void *) = NULL;
+	struct cnic_eth_dev *(*probe)(struct net_device *) = NULL;
 
-	probe = __symbol_get("bnx2_cnic_probe");
+	probe = symbol_get(bnx2_cnic_probe);
 	if (probe) {
 		ethdev = (*probe)(dev);
 		symbol_put_addr(probe);
diff --git a/drivers/net/cnic_if.h b/drivers/net/cnic_if.h
index 0638096..d1bce27 100644
--- a/drivers/net/cnic_if.h
+++ b/drivers/net/cnic_if.h
@@ -296,4 +296,6 @@ extern int cnic_register_driver(int ulp_type, struct cnic_ulp_ops *ulp_ops);
 
 extern int cnic_unregister_driver(int ulp_type);
 
+extern struct cnic_eth_dev *bnx2_cnic_probe(struct net_device *dev);
+
 #endif



