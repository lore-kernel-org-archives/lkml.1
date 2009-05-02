Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZEBOBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZEBOBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZEBOBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:01:19 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51278 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179AbZEBOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:01:18 -0400
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
	synchronization, v5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
In-Reply-To: <20090502022551.GA15600@cuplxvomd02.corp.sa.net>
References: <20090502022551.GA15600@cuplxvomd02.corp.sa.net>
Content-Type: text/plain
Date: Sat, 02 May 2009 09:01:16 -0500
Message-Id: <1241272876.3639.27.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 19:25 -0700, David VomLehn wrote:
> +Init Device Discovery Synchronization
> +=====================================
> +Init devices are those devices that must be used or configured before
> +starting up the /bin/init process.  They may be explicitly specified as
> +kernel command line parameters, such as console=ttyUSB0,115200, or
> +implicitly specified, such as ip=dhcp.
> +
> +Earlier versions of the Linux kernel used a single-threaded approach to
> +boot initialization. This took a number of seconds, which meant that
> +devices were generally set up before being used or configured. Modern
> +kernels use a multithreaded approach, which requires synchronization between
> +code that probes and initializes init devices, and code that uses and
> +configures them.  Support of fine-grained boot concurrency requires
> +distinguishing between types of init devices, so that devices can be used as
> +soon as they are initialized.
> +
> +There are several types of init devices:
> +-	consoles
> +-	network devices
> +-	block devices

OK, so in your scheme, I get why console devices: they need to be
present early before we start dumping console output otherwise it can
get lost.

However, I don't see the need for either network or block.

For network, the only early discovery use is net root (which can be done
fully asynchronously) or net console (which I think can be supplied a
raft of information and isn't usually expected to be up by early boot
because of the TCP stack dependence) neither of which is a compelling
use case.

Block, likewise, is a udev type discovery:  We can specify the root by
some type of ID and we can wait until that is found, rather than have an
elaborate system to check when discovery is finished, which is the only
benefit this code seems to provide.

What I'm getting at is that I don't see the benefit of this in the light
of Arjan's async boot system, which can also tell us when all discovery
is complete ... what added benefit am I missing here?

James


