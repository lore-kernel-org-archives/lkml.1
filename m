Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYANB5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYANB5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYANB5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:57:36 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:32926 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755281AbYANB5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:57:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M15X5r7hKO14XUu33r8PVFcXUiBODgWks8a/JafJJ4EMCRNWJ7r4EStEU+G48t+g/u2EnAfpTUl2/oP3ojKqcRCvASYj7IHQ2dDdweCk5J6ifv7VY2dyHb+Yx7ygdkwutW5fWcHVPsubTflJDVXN17Kbd+z2QwUQvvP0pd+V4yw=
Message-ID: <a8e1da0801131757s7b4c46e3vc72b03e6a809917d@mail.gmail.com>
Date: Mon, 14 Jan 2008 09:57:33 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/7] ieee1394 : use class iteration api
Cc: gregkh@suse.de, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <4788A039.4090802@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112095008.GB2893@darkstar.te-china.tietoenator.com>
	 <4788A039.4090802@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 12, 2008 7:10 PM, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Dave Young wrote:
> > +++ linux.new/drivers/ieee1394/nodemgr.c      2008-01-12 15:20:27.000000000 +0800
> ...
>
> >  static void nodemgr_remove_uds(struct node_entry *ne)
> >  {
> >       struct device *dev;
> > -     struct unit_directory *tmp, *ud;
> > +     struct unit_directory *ud;
> >
> > -     /* Iteration over nodemgr_ud_class.devices has to be protected by
> > -      * nodemgr_ud_class.sem, but device_unregister() will eventually
> > -      * take nodemgr_ud_class.sem too. Therefore pick out one ud at a time,
> > -      * release the semaphore, and then unregister the ud. Since this code
> > -      * may be called from other contexts besides the knodemgrds, protect the
> > -      * gap after release of the semaphore by nodemgr_serialize_remove_uds.
> > +     /* Use class_find device to iterate the devices. Since this code
> > +      * may be called from other contexts besides the knodemgrds,
> > +      * protect it by nodemgr_serialize_remove_uds.
> >        */
> >       mutex_lock(&nodemgr_serialize_remove_uds);
> > -     for (;;) {
> > -             ud = NULL;
> > -             down(&nodemgr_ud_class.sem);
> > -             list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
> > -                     tmp = container_of(dev, struct unit_directory,
> > -                                        unit_dev);
> > -                     if (tmp->ne == ne) {
> > -                             ud = tmp;
> > -                             break;
> > -                     }
> > -             }
> > -             up(&nodemgr_ud_class.sem);
> > -             if (ud == NULL)
> > -                     break;
> > -             device_unregister(&ud->unit_dev);
> > -             device_unregister(&ud->device);
> > +     dev = class_find_device(&nodemgr_ud_class, ne, __match_ne);
> > +     if (!dev) {
> > +             mutex_unlock(&nodemgr_serialize_remove_uds);
> > +             return;
> >       }
> > +     ud = container_of(dev, struct unit_directory, unit_dev);
> > +     device_unregister(&ud->unit_dev);
> > +     device_unregister(&ud->device);
> >       mutex_unlock(&nodemgr_serialize_remove_uds);
> >  }
>
> A quick response on this change, without having checked the rest yet:
>
> This doesn't work.  Each "ne" may have zero or more "ud".  The purpose
> of nodemgr_remove_uds is to kill all of the uds of one ne.  After your
> change, only the first ud of a ne would be gone.
>
> You need to keep the loop which takes care that all of the uds of the ne
> are removed

My wrong, will fix.

>
> Furthermore, I usually try to use "goto" or "break" constructs with
> single unlock + return path instead of multiple unlock + return paths.
> However, if these unlock + return paths are as visually close together
> as they are here, it doesn't really matter (to me) which of the styles
> is used.

I will update as your style in this patch, thanks for review.

>
> BTW, you don't need to CC <krh@redhat.com> on drivers/ieee1394/ patches
> (CONFIG_IEEE1394).  He only looks after drivers/firewire/
> (CONFIG_FIREWIRE).  I know, these are details, and everybody confuses
> them.  :-)  I should try to clarify this in MAINTAINERS.

Ok.

> --
> Stefan Richter
> -=====-==--- ---= -==--
> http://arcgraph.de/sr/
>
