Return-Path: <linux-kernel-owner+w=401wt.eu-S934608AbYBTUnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608AbYBTUnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbYBTUm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:42:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:11031 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934027AbYBTUmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:42:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="300314343"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 12:41:30 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802202114.43007.rjw@sisk.pl> <alpine.LFD.1.00.0802201224380.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802201224380.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201241.30952.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 12:29 pm Linus Torvalds wrote:
> On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:
> > I think we should export the target sleep state somehow.
>
> Yeah. By *not* using "->suspend()" for freezing or hibernate.
>
> Please, Rafael - just make the f*cking suspend-to-disk use other routines
> already. 99% of all hardware needs to do exactly *nothing* on
> suspend-to-disk, and the ones that really do need things tend to need to
> not do a whole lot.

In talking with Rafael on IRC about this, I think we're agreed that we need 
separate entry points.  Even with a kexec based hibernate, we'll probably 
want ->hibernate callbacks so we don't end up shutting down the device.

The current callback system looks like this (according to Rafael and the last 
time I looked):
  ->suspend(PMSG_FREEZE)
  ->resume()
  ->suspend(PMSG_SUSPEND)
  *enter S3 or power off*
  ->resume()
The fact that we get suspend/resume called once before suspend again in the 
hibernate case is somewhat obnoxious, but it's even worse that we don't know 
what we're about to enter after ->suspend(PMSG_SUSPEND).  So in the short 
term it would be nice to at least get the target state exported.

And in the long term we could have:
  ->suspend()
  *enter S3*
  ->resume()
or:
  ->hibernate()
  *kexec to another kernel to save image*
  *power off*
  ->return_from_hibernate() (or somesuch)

Jesse
