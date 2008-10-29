Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYJ2Tkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYJ2Tkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYJ2TkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:40:17 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:51251 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYJ2TkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:40:16 -0400
Subject: Re: 2.6.28-rc2 / hso driver oops
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20081029164006.GH3162@earth.li>
References: <20081029164006.GH3162@earth.li>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Wed, 29 Oct 2008 19:40:11 +0000
Message-Id: <1225309212.3068.44.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 16:40 +0000, Jonathan McDowell wrote:
> Hi.
> 
> Tried out 2.6.28-rc2 today on my EEE 901 and my Option Icon 225 and got
> the following oops:
> 
> hso: drivers/net/usb/hso.c: 1.2 Option Wireless
> usbcore: registered new interface driver hso
> usb 2-2: new full speed USB device using uhci_hcd and address 3
> usb 2-2: configuration #1 chosen from 1 choice
> hso0: Disabled Privacy Extensions
> BUG: unable to handle kernel NULL pointer dereference at 000000d0
> IP: [<c03589b9>] dev_driver_string+0x1/0x2a

Something passed a null device pointer to dev_printk().

[...]
> [<f81b8265>] ? hso_create_net_device+0x305/0x32d [hso]
[...]

I think that hso_create_rfkill() is the culprit here (and has been
inlined into hso_create_net_device()).  It's using hso_dev->dev as the
first argument to dev_err() and it doesn't look like that field is
initialised except by kzalloc.  At a guess, it should be using
&hso_dev->usb->dev.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

