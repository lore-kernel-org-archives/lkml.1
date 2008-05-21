Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbYEUWij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbYEUWij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbYEUWiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:38:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760740AbYEUWiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:38:19 -0400
Date: Wed, 21 May 2008 15:37:56 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "P. Christeas" <p_christ@hol.gr>
Cc: Oliver Neukum <oliver@neukum.org>, lkml <linux-kernel@vger.kernel.org>,
       zaitcev@redhat.com, linux-usb@vger.kernel.org, twaugh@redhat.com
Subject: Re: Patch: usblp quirk for zebra printers
Message-Id: <20080521153756.cc701b14.zaitcev@redhat.com>
In-Reply-To: <200805212057.52050.p_christ@hol.gr>
References: <200805212057.52050.p_christ@hol.gr>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.13.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 20:57:49 +0300, "P. Christeas" <p_christ@hol.gr> wrote:

> I guess such a quirk may be a little odd, but it has been a blocking point in 
> my system not being able to support more than one printer.

> @@ -1330,6 +1332,23 @@ static int usblp_cache_device_id_string(struct usblp *usblp)
.....
> +		strcpy(&usblp->device_id_string[length],"SN:");
> +		length+=3;
> +		strcat(&usblp->device_id_string[length],usblp->dev->serial);
> +		length += strlen(usblp->dev->serial);
> +		usblp->device_id_string[length++]= ';';
> +
> +		*((__be16 *)usblp->device_id_string) = cpu_to_be16(length);

I see...

> Please comment. (and cc. me)

Personally, I don't like this. In kernel, we typically try not to
fake things in lower levels in order to fool upper levels. There are
always knock-off effects. Sometimes we have to do it, but in my
experience CUPS folks always were for doing the right thing.

Let's ask them if extracting the S/N from sysfs is too onerous.
I'm cc-ing this to Tim Waugh.

BTW, Please try to tinker with the following udev ruleset:
BUS="usb", KERNEL="lp[0-9]*", SYSFS{serial}=="XXXXXXX", SYMLINK+="mylp0"
BUS="usb", KERNEL="lp[0-9]*", SYSFS{serial}=="YYYYYYY", SYMLINK+="mylp1"
Encoding your serial numbers into udev rules is not pleasant, but
the above should provide a stop-gap solution without patching kernels.

-- Pete
