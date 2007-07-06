Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbXGFUDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbXGFUDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761590AbXGFUCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:02:53 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55517 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760277AbXGFUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:02:52 -0400
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 15:02:49 -0500
Message-Id: <1183752169.3448.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 14:06 -0700, Kristen Carlson Accardi wrote:
> Since gendisk will now become part of struct scsi_device, we don't need
> to store this value in any private data structs where they already store
> scsi_device.  This series cleans up a few drivers which did this.

Actually, as Al pointed out, we do have lifetime rules issues with doing
this.  The problem is that gendisk itself always has a shorter lifetime
than scsi_device (not much shorter, usually, but if you execute a legal
ULD unbind manoeuvre you'll end up with a dangling gendisk pointer).

The other problem with taking gendisk out of the ULD structure and
putting it into the scsi_device is that for the sg driver, we have two
of them (one for the attached ULD and one for the sg driver).

The fundamental issue seems to be that the gendisk is the holder of all
the other info (queue, ULD etc) not vice versa ... and this patch is
trying to reverse that relationship.

James


