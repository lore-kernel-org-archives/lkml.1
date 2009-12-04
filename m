Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZLDHeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZLDHeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZLDHeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:34:21 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57981 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZLDHeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cb9d2rVsXLXaF8apovGRHqAPmrh48ehe89DsTDRGmNJPxD03nfAFuI72dcjoAu03wv
         unhtgjGsDwVuHZgWwWXbMCLr5f+o4aucVDSpqnrgDml4JhGDRIqEtgNuVF2bz0hQhJIF
         64NKNFhguNksdNiLw/+YV7cpCyMWplS3kjLhc=
Date: Thu, 3 Dec 2009 23:34:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] DMI: allow omitting ident strings in DMI tables
Message-ID: <20091204073421.GA17012@core.coreip.homeip.net>
References: <20091203031240.GB9121@core.coreip.homeip.net> <20091203093009.059197a6@hyperion.delvare> <20091203085629.GN9121@core.coreip.homeip.net> <20091203102542.6df59efc@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203102542.6df59efc@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 10:25:42AM +0100, Jean Delvare wrote:
> On Thu, 3 Dec 2009 00:56:30 -0800, Dmitry Torokhov wrote:
> > On Thu, Dec 03, 2009 at 09:30:09AM +0100, Jean Delvare wrote:
> > > On Wed, 2 Dec 2009 19:12:40 -0800, Dmitry Torokhov wrote:
> > > > diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> > > > index 938100f..9116aa7 100644
> > > > --- a/drivers/firmware/dmi_scan.c
> > > > +++ b/drivers/firmware/dmi_scan.c
> > > > @@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
> > > >  }
> > > >  
> > > >  /**
> > > > + *	dmi_is_end_of_table - check for end-of-table marker
> > > > + *	@dmi: pointer to the dmi_system_id structure to check
> > > > + */
> > > > +static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
> > > > +{
> > > > +	return dmi->ident == NULL && dmi->matches[0].slot == DMI_NONE;
> > > 
> > > If you really want to allow for dmi->ident == NULL, then I guess you can
> > > _only_ check for dmi->matches[0].slot == DMI_NONE. I can't think of any
> > > legitimate use of DMI_NONE for a used slot.
> > 
> > Current behavior is that entry with ident and empty match table matches
> > everything. If we only check on the first slot then it will not match. I
> > wanted to preserve the current behavior.
> 
> Is there a use case for this behavior? If not then I don't see the
> point of preserving it.
> 

I looked through current uses of dmi_check_system and could not find
any cases where anyone would rely on this behavior. Thus the updated
patch below.

Thanks.

-- 
Dmitry


DMI: allow omitting ident strings in DMI tables

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The purpose of dmi->ident is twofold - it may be used by DMI callback
functions when composing log messages; it is also used to determine
end of DMI table in dmi_check_system() and dmi_first_match(). However,
in case when callbacks are not interested in using ident at all it just
wastes memory. Let's make enties with empty first match slot serve as
end-of-table markers instead.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/firmware/dmi_scan.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 938100f..3a2ccb0 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -429,7 +429,7 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
 	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
 		int s = dmi->matches[i].slot;
 		if (s == DMI_NONE)
-			continue;
+			break;
 		if (dmi_ident[s]
 		    && strstr(dmi_ident[s], dmi->matches[i].substr))
 			continue;
@@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
 }
 
 /**
+ *	dmi_is_end_of_table - check for end-of-table marker
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
+{
+	return dmi->matches[0].slot == DMI_NONE;
+}
+
+/**
  *	dmi_check_system - check system DMI data
  *	@list: array of dmi_system_id structures to match against
  *		All non-null elements of the list must match
@@ -457,7 +466,7 @@ int dmi_check_system(const struct dmi_system_id *list)
 	int count = 0;
 	const struct dmi_system_id *d;
 
-	for (d = list; d->ident; d++)
+	for (d = list; !dmi_is_end_of_table(d); d++)
 		if (dmi_matches(d)) {
 			count++;
 			if (d->callback && d->callback(d))
@@ -484,7 +493,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
 {
 	const struct dmi_system_id *d;
 
-	for (d = list; d->ident; d++)
+	for (d = list; !dmi_is_end_of_table(d); d++)
 		if (dmi_matches(d))
 			return d;
 
