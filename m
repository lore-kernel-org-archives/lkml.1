Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbXGCAps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbXGCAps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbXGCApl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:45:41 -0400
Received: from mail.ccur.com ([66.10.65.12]:9059 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbXGCApk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:45:40 -0400
X-Greylist: delayed 821 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2007 20:45:40 EDT
Subject: Re: idr_get_new_above() limitation?
From: Jim Houston <jim.houston@ccur.com>
Reply-To: jim.houston@ccur.com
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       raisch@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200707021919.27251.hnguyen@linux.vnet.ibm.com>
References: <200707021919.27251.hnguyen@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: Concurrent Computer
Date: Mon, 02 Jul 2007 20:31:40 -0400
Message-Id: <1183422700.3130.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2007 00:31:59.0227 (UTC) FILETIME=[913B0CB0:01C7BD09]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-02 at 19:19 +0200, Hoang-Nam Nguyen wrote:

> i=3fffffff token=3fffffff t=000000003fffffff
> i=40000000 token=40000000 t=0000000000000000
> Invalid object 0000000000000000. Expected 40000000
> 
> That means token 0x40000000 seems to be the "upper boundary" of idr_find().
> However the behaviour is not consistent in that it was returned by
> idr_get_new_above().

Hi Nam,

Yes this is a bug.  Thanks for the great test module.

The problem is in idr_get_new_above_int() in the loop which
adds new layers to the top of the radix tree.  It is failing
the "layers < (MAX_LEVEL - 1)" test.  It doesn't allocate the
new layer but still calls sub_alloc() which relies on having
the new layer properly constructed.  I believe that it is
allocating the slot which corresponds to id = 0.

I believe this is an off by one error in calculating the
MAX_LEVEL value.  I will do a more careful review and post 
a fix in the next day or so.  I have been in Ottawa for OLS.
I'm flying home tomorrow.

Jim Houston - Concurrent Computer Corp.

