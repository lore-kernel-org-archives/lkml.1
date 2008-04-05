Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbYDEDVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbYDEDVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 23:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYDEDVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 23:21:09 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:22840 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751300AbYDEDVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 23:21:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Q+aRINNZagUz8K+L2knynNnUX8qfvBMJ0OoOyFA8puOXthYzXpVGT9T/Hy2jv+UTLC2E9bRNZ/5vGBgx6wjsJ4GkQpu5Ldpyh1vf5S0OyeJn4Vup7u4McZVOgXAd11X/5WmnqnHFIhAhi1qUBd9qqa2+25ZbmnI2VBaxPB41qNM=  ;
X-YMail-OSG: V4JK318VM1nJ8ki7AVWc9PanOgKVjt4pe9DU_H3U1OXjhcvDO5jX6URKsMtlh0yFdcOjFeu06g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Date: Fri, 4 Apr 2008 19:53:53 -0700
User-Agent: KMail/1.9.6
Cc: Trent Piepho <tpiepho@freescale.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200710291809.29936.david-b@pacbell.net> <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp> <20080404100933.077bee33@hyperion.delvare>
In-Reply-To: <20080404100933.077bee33@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804041953.54020.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008, Jean Delvare wrote:
> > +static ssize_t gpio_direction_store(struct device *dev,
> > +             struct device_attribute *attr, const char *buf, size_t size)
> > +{
> > +     const struct gpio_desc *gdesc = dev_get_drvdata(dev);
> > +     int d, n = gdesc - gpio_desc;
> > +
> > +     if (size >= 3 && !strncmp(buf, "out", 3)) {
> > +             d = 1;
> > +     } else if (size >= 2 && !strncmp(buf, "in", 2)) {
> > +             d = 0;
> 
> As far as I know, the string you receive from sysfs is guaranteed to be
> NUL-terminated, so the size checks are not needed.
> 
> > +     } else {
> > +             d = simple_strtoul(buf, NULL, 0);
> 
> This exposes to user-space the so far internal-only decision to encode
> output as 1 and input as 0. I don't see much benefit in doing this, in
> particular when you don't check for errors so for example an input of
> "Out" would result in value 0 i.e. input mode. I'd rather support only
> "in" and "out" as valid values and return -EINVAL otherwise.

So, after trimming trailing whitespace:

	if (strcmp(buf, "out") == 0)
		gpio_direction_output(...)
	else if (strcmp(buf, "in") == 0)
		gpio_direction_input(...)

Yes, that'd be a lot better.

> 
> > +     }
> > +
> > +     if (d)
> > +             gpio_direction_output(n, 0);
> > +     else
> > +             gpio_direction_input(n);
> > +
> > +     return size;
> > +}


