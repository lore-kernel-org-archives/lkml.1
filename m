Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZFTOxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZFTOxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZFTOxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:53:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39526 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbZFTOxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:53:11 -0400
Subject: Re: generic_make_request fucntion for scsi_disk
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ravish Tayal <ravish.tayal@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <e42309110906200741x28595685jf56cd505d01cc795@mail.gmail.com>
References: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
	 <1245507640.4255.6.camel@mulgrave.site>
	 <e42309110906200741x28595685jf56cd505d01cc795@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 09:53:09 -0500
Message-Id: <1245509589.4255.15.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't drop the cc list ... part of the point of this is to create
an archive record for people with similar questions to find.

On Sat, 2009-06-20 at 20:11 +0530, Ravish Tayal wrote:
> Thanks James. 
>  
> For simple case when I echo few lines to usb mounted disk (fat file
> system).
>  
> mkdir /var/disk1
> mount /dev/sda /var/disk1
> echo "TESTing " >/var/disk1/test.txt
>  
> in this case will it be echo commands context it will be queue the
> commands to scsiglue.c or in between scsi layer would hold the
> commands.

That echo will end up in the page cache as a dirty page.
 
> I have noticed on usb analyser the write scsi commands happens for max
> sector size (64K) ... does in this case scsi command would be happen 
> for few bytes ?

Block commands all have to happen at a granularity of the device block
size (512b usually).  The elevators try to build up to larger sizes.

> or in other words is pdflush invokation indirectly control the WRITE
> scsi command length if file is of few MB or scsi layer itself does
> ot ?

The elevators control final request size depending on what inputs they
have and what parameters they were given.  In all cases, the request
will be a multiple of the filesystem block size (which will be the same
or bigger than the device block size).

> I still not able to find where sd register its request queue to file
> system.

It doesn't.  The Filesystem registers with block via sys_mount and SCSI
with block in scsi_lib.c:scsi_alloc_queue().

James


