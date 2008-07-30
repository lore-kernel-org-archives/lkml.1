Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYG3VSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYG3VSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYG3VSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:18:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52034 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751739AbYG3VSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:18:12 -0400
Date: Wed, 30 Jul 2008 17:18:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Robert Hancock <hancockr@shaw.ca>, <usb-storage@lists.one-eyed-alien.net>,
       Tomas Styblo <tripie@cpan.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [usb-storage] [PATCH] JMicron JM20337 USB-SATA data corruption
 bugfix - device 152d:2338
In-Reply-To: <20080730200033.GD7578@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.44L0.0807301707350.2322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Matthew Dharm wrote:

> The code path to supress the reporting of an error when auto-sense shows no
> ASC/ASCQ was added for a reason.  That reason has likely been lost to time,
> but I worry about devices that are out there that rely on the current
> behavior to function properly....

In this case we shouldn't have to worry about that code path.  It 
applies to situations where there actually is no error.  In fact, if 
you follow the logic flow you'll see that the supression code gets 
invoked only for CB-like transports, i.e., unsolicited auto-sense.

But in this situation there really _is_ an error: We get an underflow.  
The existing logic checks for underflow only when the device reports 
Okay status; my patch changes the logic so that it also checks for 
underflow when the device reports Check Condition status with no sense 
data.

The idea is that the higher SCSI layers don't know what to do with
Check Condition plus no-sense -- so they treat the transfer as a
success.  But that's definitely the wrong thing to do when there was an
underflow; in that situation we want to report the underflow so that
the midlayer will retry the command.

Alan Stern

