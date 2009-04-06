Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZDFIsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZDFIsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 04:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZDFIsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 04:48:43 -0400
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:59001 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZDFIsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 04:48:42 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 04:48:42 EDT
Message-ID: <49D9C0B0.1060905@ladisch.de>
Date: Mon, 06 Apr 2009 10:43:28 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: Ira Snyder <iws@ovro.caltech.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: speed up request_firmware()
References: <20090128180446.GB31107@ovro.caltech.edu> <20090128203421.GC31107@ovro.caltech.edu> <49D5B0B3.2040405@ladisch.de> <200904032125.28803.arvidjaar@mail.ru>
In-Reply-To: <200904032125.28803.arvidjaar@mail.ru>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Friday 03 of April 2009 10:46:11 Clemens Ladisch wrote:
> > Well, userspace does know the actual size of the image, so I see no
> > reason why it shouldn't be able to tell the kernel about it
> > beforehand.
> 
> Right; but it will need some time for user space to catch up.

It's only an optimization.

> > @@ -46,6 +46,7 @@ struct firmware_priv {
> >  	struct firmware *fw;
> >  	unsigned long status;
> >  	int alloc_size;
> > +	int size_hint;
> 
> Unsigned?

It is as signed as alloc_size.  ;-)

Yes, all these variables probably should be size_t.  

> > +static ssize_t firmware_data_size_show(struct device *dev,
> > +				       struct device_attribute *attr, char *buf)
> > +{
> > +	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%d\n", fw_priv->size_hint);
> > +}
> 
> Why would you need it?

Good question.  Apparently, for the same reason why we'd need
firmware_data_read ...

> > +static ssize_t firmware_data_size_store(struct device *dev,
> > +					struct device_attribute *attr,
> > +					const char *buf, size_t count)
> > +{
> > +	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
> > +	long value;
> > +	int err;
> > +
> > +	err = strict_strtol(buf, 10, &value);
> > +	if (err)
> > +		return err;
> > +	fw_priv->size_hint = value;
> 
> Should not there be some protection against using silly large values? 

It is already possible to do "cat /dev/zero > .../data".  What we'd need
is a limit not only on this variable but on the size of the firmware
image itself.


Okay, I'll do a bunch of patches to fix these warts in the firmware
loader.


Best regards,
Clemens
