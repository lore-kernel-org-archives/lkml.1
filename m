Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYANBc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYANBc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYANBcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:32:50 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:16414 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbYANBcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:32:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SE7YbfELDGJDcLaPqQq/j0J0d5JSVk2XjllIisHX47QAQ6ZBIJJ9MBrecOzkdqMHbSevJ9wOuDUlKVY8Iy2DE446PkPTDPg2GdZkRHRql1JhegV8ebORJtGFcBIpzMl+r0Vby3jII8G03TXcA7iBqwHeAmw6K02C4ltZYzhZ4FY=
Message-ID: <a8e1da0801131732t55238bf0u8e083b1754641c68@mail.gmail.com>
Date: Mon, 14 Jan 2008 09:32:47 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Cc: "Greg KH" <gregkh@suse.de>, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       krh@redhat.com, stern@rowland.harvard.edu, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
In-Reply-To: <47889B68.8010601@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	 <47889B68.8010601@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 12, 2008 6:50 PM, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Dave Young wrote:
> > Add the following class iteration functions for driver use:
>
> Thanks Dave.  I will check the ieee1394 part in detail later.
>
> ...
> > +/**
> > + * class_find_device - device iterator for locating a particular device
> > + * @class: the class we're iterating
> > + * @data: data for the match function
> > + * @match: function to check device
> > + *
> > + * This is similar to the class_for_each_dev() function above, but it
> > + * returns a reference to a device that is 'found' for later use, as
> > + * determined by the @match callback.
>
> Maybe add "Drop the reference with put_device() after use." for the
> really slow driver programmers like me?

Sounds good, thanks.

>
> > + *
> > + * The callback should return 0 if the device doesn't match and non-zero
> > + * if it does.  If the callback returns non-zero, this function will
> > + * return to the caller and not iterate over any more devices.
> > + */
> > +struct device *class_find_device(struct class *class, void *data,
> > +                                int (*match)(struct device *, void *))
> > +{
>
> A general comment on the linux/device.h API (not a direct comment on
> your patch):
>
> The match argument in bus_find_device(), driver_find_device(),
> device_find_child(), class_find_device(), class_find_child() could be
> changed to
>
>         bool (*match)(struct device *, void *)).
>
> Then the semantics are IMO a little bit clearer.  Ditto for the
> dr_match_t type and the struct bus_type.match member.

Yes, from semantics side it's better.
But IMHO int is good as well, although it need a little bit more
understanding of the api.

>
> I don't know though whether the churn of doing such a change everywhere
> would be justified by the result.
>
>
> A comment on patch 2/7...6/7:
>
> You can bring most or all of the various __match implementations into a
> slightly terser but IMO easy to read form, like this:
>
>  static int __match_ne(struct device *dev, void *data)
>  {
>         struct unit_directory *ud;
>         struct node_entry *ne = (struct node_entry *)data;
>
>         ud = container_of(dev, struct unit_directory, unit_dev);
> -       if (ud->ne == ne)
> -               return 1;
> -       return 0;
> +       return ud->ne == ne;
>  }
>
> Here it is also easy to see that readability would improve if the return
> type was bool rather than int.

Ok, thanks.

> --
> Stefan Richter
> -=====-==--- ---= -==--
> http://arcgraph.de/sr/
>
