Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZEGAB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZEGAB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZEGABt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:01:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:55337 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZEGABs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:from:date:message-id:user-agent:mime-version
         :content-type;
        b=YzrbZEzYkCPhIeTrYjPJbkEv5KL/u9iIu5XtG+OtoGrojHIS7RxZpk9upf1Vxct6CO
         Lk/z7TEGHSl52YL3OWXCVktcvMD/a/bPhJ9VAA3Qdurlhy7thgq6HzXTduzSBYpiDeNt
         RI/ie05+w6F8SiYZviXy8/stluQH2pEyaWoJM=
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Ian Abbott <abbotti@mev.co.uk>
Subject: comedi: some questions 
From: Alexis Berlemont <alexis.berlemont@gmail.com>
Date: Thu, 07 May 2009 02:01:42 +0200
Message-ID: <87zldpeq6x.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi,

Please find attached a patch related with the Comedi layer. This patch
is just a proposal (among two) to change the way the ranges tables are
managed. 

I first tried to send it to the Comedi community three weeks ago:
http://groups.google.com/group/comedi_list/browse_thread/thread/85be8195ddf52896

One week after my first mail, Ian Abott told me the Comedi CVS tree
would not integrate any code change other than bug fix; he redirected
me to the linux-next mailing list. According to him, the clean up
effort should be hosted on the staging area of the linux-next tree. 

Then, I sent the patches (adapted for the linux-next git tree) to the
linux-next mailing list:
http://marc.info/?l=linux-next&m=124078248400745&w=2

Greg KH asked me to send them to the Comedi community before asking
for integration into the staging area (which I already did). After a
few mails, it became clear that the suitable procedure was to send
patches to the Comedi mailing-list and CC Greg KH. Thus, with the
Comedi maintainers' agreements, GKH will integrate them. 

I am kind of puzzled. That is why I thought mailing the LKML might be
interesting. 

It seems like the original Comedi developers (the ones who maintain
the original CVS tree) do not seem involved in the developments for
the integration of Comedi into mainstream. However, any contribution
must go through them. That might slow down the evolutions. No ? 

By the way, I have been waiting for one more week and I still have no
feedback on my little proposals which are, I think, meaningless
compared to other issues (kcomedilib, buffer management, user
interfaces, etc.). I should ask once more.

That leads to the last point which I do not understand: Comedi is
supposed to undergo a host of changes before considering integration
into mainline (here is a mail which lists some of them:
http://lkml.org/lkml/2009/2/9/335). That should imply many
incompatibilities with the original Comedi tree; so why keeping
coherency with upstream?

Alexis.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Introduce-a-container-structure-for-ranges-so-as-to.patch
Content-Description: proposal 1

>From 12b57a9ece86c658fc84db4c635d69d2f7e9638f Mon Sep 17 00:00:00 2001
From: Alexis Berlemont <alexis.berlemont@gmail.com>
Date: Sun, 26 Apr 2009 00:51:43 +0200
Subject: [PATCH] Introduce a container structure for ranges so as to handle global
 range tables and per channel range tables

---
 drivers/staging/comedi/comedi_fops.c |   11 +++--
 drivers/staging/comedi/comedidev.h   |   75 +++++++++++++++++++++++++++++++++-
 drivers/staging/comedi/drivers.c     |    5 +-
 drivers/staging/comedi/range.c       |   64 +++++++++++------------------
 4 files changed, 107 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index bb4a289..c71ddf6 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -419,7 +419,7 @@ static int do_subdinfo_ioctl(struct comedi_device *dev, struct comedi_subdinfo *
 		us->maxdata = s->maxdata;
 		if (s->range_table) {
 			us->range_type =
-			    (i << 24) | (0 << 16) | (s->range_table->length);
+			    (i << 24) | (0 << 16) | get_range_table(s, 0)->length;
 		} else {
 			us->range_type = 0;	/* XXX */
 		}
@@ -437,7 +437,8 @@ static int do_subdinfo_ioctl(struct comedi_device *dev, struct comedi_subdinfo *
 			us->subd_flags |= SDF_MAXDATA;
 		if (s->flaglist)
 			us->subd_flags |= SDF_FLAGS;
-		if (s->range_table_list)
+		if (s->range_table && 
+		    (s->range_table->mode & COMEDI_PERCHAN_LRANGE) != 0)
 			us->subd_flags |= SDF_RANGETYPE;
 		if (s->do_cmd)
 			us->subd_flags |= SDF_CMD;
@@ -503,13 +504,15 @@ static int do_chaninfo_ioctl(struct comedi_device *dev, struct comedi_chaninfo *
 	if (it.rangelist) {
 		int i;
 
-		if (!s->range_table_list)
+ 		if(s->range_table == NULL ||
+ 		   (s->range_table->mode & COMEDI_PERCHAN_LRANGE) == 0)
 			return -EINVAL;
+
 		for (i = 0; i < s->n_chan; i++) {
 			int x;
 
 			x = (dev->minor << 28) | (it.subdev << 24) | (i << 16) |
-			    (s->range_table_list[i]->length);
+				get_range_table(s, i)->length;
 			put_user(x, it.rangelist + i);
 		}
 #if 0
diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 753d3ab..4c67058 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -149,8 +149,7 @@ struct comedi_subdevice {
 
 	unsigned int settling_time_0;
 
-	const struct comedi_lrange *range_table;
-	const struct comedi_lrange *const *range_table_list;
+	struct comedi_crange *range_table;
 
 	unsigned int *chanlist;	/* driver-owned chanlist (not used) */
 
@@ -411,6 +410,78 @@ struct comedi_lrange {
 	struct comedi_krange range[GCC_ZERO_LENGTH_ARRAY];
 };
 
+#define COMEDI_PERCHAN_LRANGE	0x80000000
+
+struct comedi_crange {
+	unsigned int mode;
+	struct comedi_lrange *list[0];
+};
+
+/* For static configuration (global declaration) */
+#define COMEDI_GLOBAL_RNG(x) {			\
+	.mode = 0,				\
+	.list = {&(x)}, }
+
+/* For dynamic confiugration */
+static inline int setup_global_range_table(struct comedi_subdevice * subd,
+					   struct comedi_lrange *lrng)
+{
+	subd->range_table = kmalloc(sizeof(struct comedi_crange) +
+				    sizeof(struct comedi_lrange *), 
+				    GFP_KERNEL);
+
+	if(subd->range_table == NULL)
+		return -ENOMEM;
+
+	subd->range_table->mode = 0;
+	subd->range_table->list[0] = lrng;
+	
+	return 0;
+}
+
+static inline int alloc_perchan_range_table(struct comedi_subdevice * subd)
+{
+	subd->range_table = kmalloc(sizeof(struct comedi_crange) +
+				    sizeof(struct comedi_lrange *) * 
+				    subd->n_chan, 
+				    GFP_KERNEL);
+
+	if(subd->range_table == NULL)
+		return -ENOMEM;
+
+	memset(subd->range_table, 0,
+	       sizeof(struct comedi_crange) +
+	       sizeof(struct comedi_lrange *) * subd->n_chan);
+	
+	subd->range_table->mode = COMEDI_PERCHAN_LRANGE;
+	
+	return 0;
+}
+
+static inline int set_range_table(struct comedi_subdevice *subd,
+				  unsigned int chan_idx,
+				  struct comedi_lrange *lrng)
+{
+	if(subd->range_table == NULL)
+		return -EINVAL;
+
+	chan_idx = (subd->range_table->mode & COMEDI_PERCHAN_LRANGE) ?
+		chan_idx : 0;
+	subd->range_table->list[chan_idx] = lrng;
+
+	return 0;
+}
+
+static inline 
+struct comedi_lrange *get_range_table(struct comedi_subdevice *subd,
+				      unsigned int chan_idx)
+{
+	chan_idx = (subd->range_table->mode & COMEDI_PERCHAN_LRANGE) ?
+		chan_idx : 0;
+	return subd->range_table->list[chan_idx];
+}
+				  
+
 /* some silly little inline functions */
 
 static inline int alloc_subdevices(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index cabbf09..c0bcff3 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -273,8 +273,9 @@ static int postconfig(struct comedi_device *dev)
 			comedi_alloc_subdevice_minor(dev, s);
 		}
 
-		if (!s->range_table && !s->range_table_list)
-			s->range_table = &range_unknown;
+		if (!s->range_table)
+			setup_global_range_table
+				(s, (struct comedi_lrange *)&range_unknown);
 
 		if (!s->insn_read && s->insn_bits)
 			s->insn_read = insn_rw_emulate_bits;
diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index d09f0bb..04f7b89 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -61,15 +61,11 @@ int do_rangeinfo_ioctl(struct comedi_device *dev, struct comedi_rangeinfo *arg)
 	if (subd >= dev->n_subdevices)
 		return -EINVAL;
 	s = dev->subdevices + subd;
-	if (s->range_table) {
-		lr = s->range_table;
-	} else if (s->range_table_list) {
-		if (chan >= s->n_chan)
-			return -EINVAL;
-		lr = s->range_table_list[chan];
-	} else {
-		return -EINVAL;
-	}
+
+ 	if (s->range_table == NULL || chan >= s->n_chan)
+ 		return -EINVAL;
+ 	else
+ 		lr = get_range_table(s, chan);
 
 	if (RANGE_LENGTH(it.range_type) != lr->length) {
 		DPRINTK("wrong length %d should be %d (0x%08x)\n",
@@ -125,36 +121,24 @@ int check_chanlist(struct comedi_subdevice *s, int n, unsigned int *chanlist)
 	int i;
 	int chan;
 
-	if (s->range_table) {
-		for (i = 0; i < n; i++)
-			if (CR_CHAN(chanlist[i]) >= s->n_chan ||
-				CR_RANGE(chanlist[i]) >= s->range_table->length
-				|| aref_invalid(s, chanlist[i])) {
-				rt_printk
-					("bad chanlist[%d]=0x%08x n_chan=%d range length=%d\n",
-					i, chanlist[i], s->n_chan,
-					s->range_table->length);
-#if 0
-				for (i = 0; i < n; i++)
-					printk("[%d]=0x%08x\n", i, chanlist[i]);
-#endif
-				return -EINVAL;
-			}
-	} else if (s->range_table_list) {
-		for (i = 0; i < n; i++) {
-			chan = CR_CHAN(chanlist[i]);
-			if (chan >= s->n_chan ||
-				CR_RANGE(chanlist[i]) >=
-				s->range_table_list[chan]->length
-				|| aref_invalid(s, chanlist[i])) {
-				rt_printk("bad chanlist[%d]=0x%08x\n", i,
-					chanlist[i]);
-				return -EINVAL;
-			}
-		}
-	} else {
-		rt_printk("comedi: (bug) no range type list!\n");
-		return -EINVAL;
-	}
+ 	if (s->range_table == NULL) {
+  		rt_printk("comedi: (bug) no range type list!\n");
+  		return -EINVAL;
+  	}
+ 	
+ 	for (i = 0; i < n; i++) {
+ 
+ 		chan = CR_CHAN(chanlist[i]);
+ 
+ 		if (chan >= s->n_chan ||
+ 		    CR_RANGE(chanlist[i]) >= get_range_table(s, chan)->length || 
+ 		    aref_invalid(s, chanlist[i])) {
+ 			
+ 			rt_printk("bad chanlist[%d]=0x%08x\n", 
+ 				  i, chanlist[i]);
+ 			return -EINVAL;
+ 		}
+ 	}
+
 	return 0;
 }
-- 
1.6.2.4


--=-=-=--
