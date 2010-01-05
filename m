Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457Ab0AELsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0AELsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232Ab0AELsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36316 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab0AELsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:01 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [0/12] SYSFS: Sysfs attribute improvements
Date: Tue,  5 Jan 2010 12:47:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysdev_class attributes and class attributes do not pass
their own attribute to the low level store/show functions. This means
that itiss not possible to use shared functions for common data,
but each data item had to have its own function. Typically this
lead to ugly and big custom macro cascades in drivers, generating
the store/show functions for each attribute. This leads to 
large code and is ugly.

When the attributes are passed to the callbacks -- like they are for plain
attributes and sysdev attributes -- it's possible to "derive"
own attribute objects that carry some data, use that data and then call into 
shared store/show code.

This patchkit fixes up these callback interfaces to allow to do this. This
involves two tree sweeps for sysdev_class_attributes and class_attributes,
changing them all to accept the new attribute argument.

I tried to convert all users, but was only able to compile test on x86.

All users were converted in a single patch to avoid unbisectable
sections. I didn't put all the individual driver maintainers in cc,
they probably wouldn't need to care.

Also I added some utility functions to easier deal with arrays
of attributes. A lot of users define multiple attributes and had
to open code array handling for this. Add new sysfs interfaces
to handle the arrays directly. sysdev classes now can just
directly carry their own attributes, similar to normal classes.

Then the CPU and the NODE driver in drivers/base serve as a poster
child for the new facilities and shrink their code dramatically
by using the new facilities.

In addition I added a new string attribute type derived 
from class attributes. This allows various drivers who use
class attributes to export static version strings to just
use a single macro, no custom callbacks.

I didn't convert all drivers over to the new facilities, this
can be done gradually.

-Andi
