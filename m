Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYG2RoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYG2RoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759741AbYG2Rm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:42:58 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53980 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760202AbYG2Rm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:42:56 -0400
Subject: Subtle but oops causing problem with class_device->device
	conversion
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 12:42:28 -0500
Message-Id: <1217353348.6103.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's taken me a while to track this down.  Basically there's an oops in
scsi_transport_spi that's directly caused by this.

What happened is that you made all class devices become real devices and
be parented to devices they were formerly allied to through the class
device dev pointer.  This means that effectively you expanded the child
list of every device to include not only its real children but also its
class devices.

This breaks in device_for_each_child *if* the routine in the iterator
doesn't perform checks on the devices it gets back (scsi_transport_spi
was assuming that every device it got was embedded in a struct
scsi_device because they're the only logical children of a scsi_target).

I can fix the SCSI breakage, but the whole tree will need auditing to
check that nothing else is using this assumption.

James


