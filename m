Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbXJOLUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbXJOLUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762340AbXJOLUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:20:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559AbXJOLUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:20:10 -0400
From: Neil Brown <neilb@suse.de>
To: Rob Landley <rob@landley.net>
Date: Mon, 15 Oct 2007 21:19:58 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18195.19678.500863.613193@notabene.brown>
Cc: Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
In-Reply-To: message from Rob Landley on Monday October 15
References: <200710112011.22000.rob@landley.net>
	<200710141845.44750.rob@landley.net>
	<20071015014503.GF9715@thunk.org>
	<200710150304.00901.rob@landley.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday October 15, rob@landley.net wrote:
> 
> This is my objection.  Even when enumerating multiple devices of the same type 
> is tricky, enumerating multiple devices of _different_ types should not be.  
> There's a great big type indicator that is being _deliberately_ ignored, and 
> large classes of devices (millions of laptops) where you know there's only 
> going to be _one_ instance of a given type.

My perspective is different.

The range of addressing option for "all disk devices" is far too rich
to be able to assign a stable device number every device: there are
multiple, multi-dimensional addressing scheme, and some devices might
not even have a stable address at all (e.g. USB?).
So the reality of dealing with disk devices is that you cannot provide
a stable single-number naming scheme for all devices on all machines.

Therefore it is best to not have stable single-number naming schemes
for any devices on any machines.  Why?  Because it ensure there will
not be any second class citizens.

If some devices that are even reasonably common (e.g. IDE drives) are
stable, then some application developers or system integrators will
work under the assumption of stability and whatever they build will
break when you try it on different hardware.  This happened during the
early days of SCSI support - code assumed the stability of
major/minor numbers and so did not work properly with SCSI which
cannot provide that stability in general.

Having a totally uniform approach makes development and testing a lot
easier - there are fewer special cases.

I would prefer that 'total uniformity' went even further than
/dev/sd?? to /dev/disk??.  i.e. Anything that is or behaves
substantially like a disk drive should be "/dev/diskXX", where numbers
are assigned sequentially on discovery. (I wonder why we need
/dev/scdX to be separate from /dev/sdX).

Note that stable names a still a very real option.  udev provides
several.  /dev/disk-by-path/XXX will be stable for lots of "screwed
in" devices.  /dev/disk-by-id will be stable for devices the report a
unique id. etc.

The different between IDE, SATA, SCSI and even USB is peripheral for
the large majority of uses, and I think maintaining the distinction in
the major/minor number or in the "primary" /dev name is - for the
above reasons - more of a cost that a value.

NeilBrown
