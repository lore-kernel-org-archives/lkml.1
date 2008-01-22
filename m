Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYAVGYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYAVGYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYAVGYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:24:21 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:27163 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751241AbYAVGYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:24:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zuLwJZy9Zr9VGc1oHdz2E31TE5ps6eunXZQ/Nmq9AuELCIwK6/6IS52wUs7TVPzNTH0lyfAEIEmbZu5FV9FOMCjiT20vo/jQPGC3KrXFMzWXjJdCoyPpU9Sli48R/ry0p4liQaGDaHi39LBjSKRwVKWguanNJAbaFkhAG4df1mc=  ;
X-YMail-OSG: YCXnUNUVM1kOWdXio_gVhS_btH_uRMVnF45dbANKKB8i.YhGzTgTLg5jF1EOC1YXQe6qTzhlKQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 1/6] driver-core : add class iteration api
Date: Mon, 21 Jan 2008 22:24:17 -0800
User-Agent: KMail/1.9.6
Cc: Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net,
       jarkao2@gmail.com
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com> <20080122055434.GB3066@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080122055434.GB3066@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801212224.18149.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008, Dave Young wrote:
>  
> +/**
> + *	class_for_each_device - device iterator
> + *	@class:	the class we're iterating
> + *	@data: data for the callback
> + *	@fn: function to be called for each device
> + *
> + *	Iterate over @class's list of devices, and call @fn for each,
> + *	passing it @data.
> + *
> + *	We check the return of @fn each time. If it returns anything
> + *	other than 0, we break out and return that value.

I have a suggestion for better documentation, which
applies to all these utilities:


> + */
> +int class_for_each_device(struct class *class, void *data,
> +			   int (*fn)(struct device *, void *))
> +{
> +	struct device *dev;
> +	int error = 0;
> +
> +	if (!class)
> +		return -EINVAL;
> +	down(&class->sem);
> +	list_for_each_entry(dev, &class->devices, node) {
> +		dev = get_device(dev);
> +		if (dev) {
> +			error = fn(dev, data);

This is called with class->sem held.  So fn() has a
constraint to not re-acquire that ... else it'd be
self-deadlocking.  I'd like to see docs at least
mention that; calls to add or remove class members
would be verboten, for example, which isn't an issue
with most other driver model iterators.


> +			put_device(dev);
> +		} else
> +			error = -ENODEV;
> +		if (error)
> +			break;
> +	}
> +	up(&class->sem);
> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(class_for_each_device);
