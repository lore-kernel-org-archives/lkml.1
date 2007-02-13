Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbXBMLO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbXBMLO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXBMLO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:14:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:42398 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXBMLO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jby2sKUL0iy970NX8+Hv6Hc7PUH8fDM2UiYeNlf+F1KXmZwyR4gjtu1aP+NGlWp/SMbCc5Fbgw5Ho0KWRVigTMt99cc0G2PEIKEg6V6QINXl+YHfpQK3scc2LyachkJkwRKMnQBsnOK5I1ZSk1EEk110h9TuSxz/GwCZoyL6n3w=
Message-ID: <1a297b360702130314i3b67a828v804ddb85dc975101@mail.gmail.com>
Date: Tue, 13 Feb 2007 15:14:23 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Marcel Siegert" <mws@linuxtv.org>
Subject: Re: dvb shared datastructure bug?
Cc: "Arjan van de Ven" <arjan@infradead.org>, mchehab@infradead.org,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
In-Reply-To: <200702131204.47314.mws@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1171352878.12771.30.camel@laptopd505.fenrus.org>
	 <200702131204.47314.mws@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Marcel Siegert <mws@linuxtv.org> wrote:
> On Tuesday 13 February 2007, Arjan van de Ven wrote:
> > Hi,
> >
> > while working on the last pieces of the file_ops constantification, DVB
> > is the small village in France that is holding the Romans at bay... but
> > I think I found the final flaw in it now:
> >
> >        *pdvbdev = dvbdev = kmalloc(sizeof(struct dvb_device), GFP_KERNEL);
> >
> >         if (!dvbdev) {
> >                 mutex_unlock(&dvbdev_register_lock);
> >                 return -ENOMEM;
> >         }
> >
> >         memcpy(dvbdev, template, sizeof(struct dvb_device));
> >         dvbdev->type = type;
> >         dvbdev->id = id;
> >         dvbdev->adapter = adap;
> >         dvbdev->priv = priv;
> >
> >         dvbdev->fops->owner = adap->module;
> >
> >
> > this is the place in DVB that is writing to a struct file_operations.
> > But as with almost all such cases in the kernel, this one is buggy:
> > While the code nicely copies a template dvbdev, that template only has a
> > pointer to a *shared* fops struct, the copy doesn't help that. So this
> > code is overwriting the fops owner field for ALL active devices, not
> > just the ones the copy of the template is for....
> >
> > I'm lost in the maze of this part of DVB (it seems to have some magic
> > potion to resist me) but I was hoping some of the local citizens could
> > take a look at this buglet...
> >
> > Greetings,
> >     Arjan van de Ven
>
> hi arjan,
> thanks for pointing out this issue.
>
> attached find a patch that fixes the problem.
>
> @mauro - please pull changeset a7ac92d208fe
>    dvbdev: fix illegal re-usage of fileoperations struct
>
> from  http://www.linuxtv.org/hg/~mws/v4l-dvb-fixtree
>

Ack'd-by: Manu Abraham <manu@linuxtv.org>
