Return-Path: <linux-kernel-owner+w=401wt.eu-S1422716AbXCIAqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbXCIAqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423013AbXCIAqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:46:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:47194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422716AbXCIAqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:46:49 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Fri, 9 Mar 2007 01:45:53 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703081101230.4086-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703081101230.4086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703090145.53895.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. März 2007 17:02 schrieb Alan Stern:
> On Thu, 8 Mar 2007, Oliver Neukum wrote:
> 
> > Hi,
> > 
> > after a lightning bolt from high above I've been looking into refcounting
> > the data structures drivers use to provide the data used to refill sysfs
> > buffers. I've come to the following conclusion.
> > 
> > 1. struct sysfs_buffer must have a struct kref * and probably a destructor
> > pointer
> > 2. drivers must be able to pass these pointers through an extended
> > device_create_file()
> > 3. Drivers must use refcounting if they want to use attributes
> > 4. read/write/poll must do refcounting
> > 
> > I am not sure where to store the pointers. struct sysfs_dirent() looks
> > like the obvious choice. Comments?
> 
> Can you explain the reasoning that led to these conclusions?  And what 
> exactly was your lightning bolt?

The old race between disconnect and IO to attribute via sysfs again.
If I cannot disassociate the drivers from the buffers in the buffers, drivers
must not deallocate the data necessary to answer sysfs callbacks while
a buffer exists. Reading from a buffer must up a refcount in the driver's
data structures. The question becomes how to get a pointer to the buffer.
And it cannot live in the dentry as the dentry can go away while files
are still open. This leaves the inode or the buffer.

	Regards
		Oliver
