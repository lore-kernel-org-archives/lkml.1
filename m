Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXKELpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXKELpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXKELpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:45:30 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:41977 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXKELp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:45:28 -0500
Message-Id: <20071105113742.233391000@vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 Nov 2007 12:37:42 +0100
From: swen@vnet.ibm.com
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: [patch 0/6] zfcp: updates, fixing a variety of oddities
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
patch 1/6: Remove unnecessary eh_bus_reset_handler callsback
           The callback function used by zfcp always returns success,
           which is an indication for the SCSI midlayer to stop error
           handling. Remove the bus_reset callback, since the same
           function will be called via the host_reset callback.

patch 2/6: Use also port and adapter to identify unit in messages
           Add the appropriate messages.

patch 3/6: Specify waiting times in ERP in seconds
           It is not necessary to use jiffies or milliseconds to specify
           waiting times that last a couple of seconds.

patch 4/6: Remove SCSI devices when removing adapter
           The common I/O layer can call remove a handler to inform zfcp
           that a device disappeared. The handler zfcp_ccw_remove then
           removes all unit, port and the adapter data structures. Removing
           the units requires that the SCSI devices are removed first.


patch 5/6: Fix deadlock when adding invalid LUN
           When adding an invalid LUN, there is a deadlock between the add
           via scsi_scan_target and the slave_destroy handler: The handler
           waits for the scan to complete, but for an invalid unit,
           scsi_scan_target directly calls the slave_destroy handler.
           Fix the deadlock by removing the wait in the slave_destroy
           handler, it was not necessary anyway.

patch 6/6: Reduce flood on HBA trace
           Remove tracing for request with a "qualifier" field set in the
           response.  The protocol status qualifier now contains measurement
           data for "good" commands, so this check would trace every response
           by default.
           The fix is to simply remove the "qual" tracing: The responses with an
           interesting status are also traced as "ferr" or "perr" and all
           responses can be traced as "norm" with a higher trace level.
