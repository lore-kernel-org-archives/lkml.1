Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZEERjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZEERjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZEERjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:39:32 -0400
Received: from gate.in-addr.de ([212.8.193.158]:54568 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908AbZEERjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:39:31 -0400
Date: Tue, 5 May 2009 19:38:54 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Philipp Reisner <philipp.reisner@linbit.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, david@lang.hm,
       Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-ID: <20090505173854.GC14192@suse.de>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <200905051021.33461.philipp.reisner@linbit.com> <e2e108260905050803m4d474702o5ddc741b29325f54@mail.gmail.com> <200905051757.17100.philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905051757.17100.philipp.reisner@linbit.com>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-05-05T17:57:15, Philipp Reisner <philipp.reisner@linbit.com> wrote:

> Up to now we do not offer barrier support for the layers above us.
> That will follow sooner or later.
> 
> Here is an example, why it is not completely trivial:
> 
>   Imagine DRBD on top of a dm-linear on both nodes. When you start,
>   both dm-linear mappings sit on top of something that supports 
>   barriers itself. -- Then the user replaces the backing device
>   below the dm-linear on the secondary node with something that
>   does not support barriers.

The same problem exists essentially for md raid1 as well, and I'd not
consider it objectionable if you took a brutal approach:

>   When we get a write request with the BIO_RW_BARRIER flag set
>   in from the FS, we submit this locally, ship it over to the
>   peer and submit it there. Unfortunately it fails now with
>   ENOTSUP on the peer. 
> 
>   We can not ship that error back to the upper layer, because
>   our mirror is already inconsistent.

Disconnect the secondary with a loud error as to why (incompatible
change of the device below). (Re-)negotiate barrier capability at
connect time; then, resync.


Regards,
    Lars

-- 
SuSE Labs, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

