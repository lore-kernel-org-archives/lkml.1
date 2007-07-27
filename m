Return-Path: <linux-kernel-owner+w=401wt.eu-S938162AbXG0XPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938162AbXG0XPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765640AbXG0XOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:14:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:48317 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764912AbXG0XOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=E1zhvahrk46vFd7FIWzXTcrYirhKx3v2/SEPbrbFhmsyg3EknL/xFcpes8NAGkod6H1L3+4ri8+4bI7mp0MAt5CWv+3dKqp/0fOlJwF2Xtuii0f/USTDMIs6PG9vyXWbIy6cEY1QeW0lDuWKge8lIsy4nr95iOMGvaHhvw5+rHE=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH][sas] Fix potential NULL pointer dereference bug in sas_smp_get_phy_events()
Date: Sat, 28 Jul 2007 01:13:33 +0200
User-Agent: KMail/1.9.7
Cc: linux-scsi@vger.kernel.org, Luben Tuikov <luben_tuikov@adaptec.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200707272327.57356.jesper.juhl@gmail.com> <1185577372.3434.29.camel@localhost.localdomain>
In-Reply-To: <1185577372.3434.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707280113.33766.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/07/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Fri, 2007-07-27 at 23:27 +0200, Jesper Juhl wrote:
> > In sas_smp_get_phy_events() we never test if the call to
> > alloc_smp_req(RPEL_REQ_SIZE) succeeds or fails. That means we run
> > the risk of dereferencing a NULL pointer if it does fail. Far
> > better to test if we got NULL back and in that case return -ENOMEM
> > just as we already do for the other memory allocation in that
> > function.
> > This patch reworks the memory allocation a bit to deal with it
> > (compile tested only).
> >
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> > ---
> >
> >  drivers/scsi/libsas/sas_expander.c |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> > index b500f0c..85f5145 100644
> > --- a/drivers/scsi/libsas/sas_expander.c
> > +++ b/drivers/scsi/libsas/sas_expander.c
> > @@ -507,14 +507,21 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
> >  int sas_smp_get_phy_events(struct sas_phy *phy)
> >  {
> >       int res;
> > +     u8 *req;
> > +     u8 *resp;
> >       struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
> >       struct domain_device *dev = sas_find_dev_by_rphy(rphy);
> > -     u8 *req = alloc_smp_req(RPEL_REQ_SIZE);
> > -     u8 *resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
> >
> > +     resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
> 
> Actually, this should be alloc_smp_resp(RPEL_RESP_SIZE);
> 
> >       if (!resp)
> >               return -ENOMEM;
> >
> > +     req = alloc_smp_req(RPEL_REQ_SIZE);
> > +     if (!req) {
> > +             res = -ENOMEM;
> > +             goto out;
> > +     }
> 
> Just for the sake of being the same as all the rest of the code, the
> sequence should be
> 
>         req = alloc_smp_req(xxx_REQ_SIZE);
>         if (!req)
>                 return -ENOMEM;
> 
>         resp = alloc_smp_resp(xxx_RESP_SIZE);
>         if (!resp) {
>                 kfree(req);
>                 return -ENOMEM;
>         }
> 
> (allocate request then response).
> 
Fair enough. It makes the code a bit larger though : 

 My way, as per the original patch:
    text    data     bss     dec     hex filename
   13820       0       8   13828    3604 drivers/scsi/libsas/sas_expander.o
 Your way, as per this patch:
    text    data     bss     dec     hex filename
   13832       0       8   13840    3610 drivers/scsi/libsas/sas_expander.o

I hope this patch is acceptable : 


In sas_smp_get_phy_events() we never test if the call to
alloc_smp_req(RPEL_REQ_SIZE) succeeds or fails. That means we run
the risk of dereferencing a NULL pointer if it does fail. Far
better to test if we got NULL back and in that case return -ENOMEM
just as we already do for the other memory allocation in that
function.
This patch should take care of it (compile tested only).


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/libsas/sas_expander.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b500f0c..e98d2b9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -507,14 +507,21 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
 int sas_smp_get_phy_events(struct sas_phy *phy)
 {
 	int res;
+	u8 *req;
+	u8 *resp;
 	struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 	struct domain_device *dev = sas_find_dev_by_rphy(rphy);
-	u8 *req = alloc_smp_req(RPEL_REQ_SIZE);
-	u8 *resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
 
-	if (!resp)
+	req = alloc_smp_req(RPEL_REQ_SIZE);
+	if (!req)
 		return -ENOMEM;
 
+	resp = alloc_smp_resp(RPEL_RESP_SIZE);
+	if (!resp) {
+		kfree(req);
+		return -ENOMEM;
+	}
+
 	req[1] = SMP_REPORT_PHY_ERR_LOG;
 	req[9] = phy->number;
 




> It looks like disc_resp could use a little love too (it's using the req
> alloc routines).
> 
I'll take a look at that later.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

