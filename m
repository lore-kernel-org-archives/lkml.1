Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYLJOrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYLJOrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYLJOq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:46:57 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:43932 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYLJOq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:46:56 -0500
Message-ID: <fa686aa40812100646t14eab32duca8cbaa761ab5037@mail.gmail.com>
Date: Wed, 10 Dec 2008 07:46:54 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Dave Hylands" <dhylands@gmail.com>
Subject: Re: How to handle device drivers depending on another device.
Cc: linux-embedded@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <c32efac40812092209v52c3b425i9aede2f096a13bfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa686aa40812092145h72c29ea8o7b55ab6bc0ce52ff@mail.gmail.com>
	 <c32efac40812092209v52c3b425i9aede2f096a13bfa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 11:09 PM, Dave Hylands <dhylands@gmail.com> wrote:
> Hi Grant,
>
>> Problem: There are no guarantees that the MDIO bus controller will be
>> probed before the Ethernet device.
>
> I believe that what you're supposed to do is to have "bus" controllers
> initilize themselves using subsys_initcall rather than module_init. If
> you look in include/linux/init.h you can see the various initcall
> definitions. module_init is at the same level as device_initcall. All
> of the initcalls at one "level" are completed before moving onto the
> next level.

Even so the problem still exists.  There is 1 bus and 3 devices
involved.  The 'bus' infrastructure is the MDIO bus (drivers/net/phy),
and it does indeed use subsys_initcall().  But then there is the
Ethernet device, the MDIO controller device, and the PHY device.  Both
the Ethernet device and the MDIO controller device are probed via the
of_platform bus.  The PHY device is attached to the MDIO controller.

So, while the MDIO bus infrastructure is guaranteed to be initialized
first; there is no guarantee that the MDIO bus controller will be
probed before the Ethernet device.  Secondly, even if the MDIO
controller is probed before the Ethernet device, there is no guarantee
that the PHY device will get registered onto the MDIO bus before the
Ethernet device is probed.  There remains the uncertainty of which of
the two devices will get registered first and the Ethernet driver
needs a mechanism to defer initialization until the PHY device is
ready.

> Of course, if you're using loadable modules, then the dependencies
> should take care of things for you.

For the bus infrastructure, yes, but not for the bus instances.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
