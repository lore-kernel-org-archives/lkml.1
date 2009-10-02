Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZJBJLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZJBJLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZJBJLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:11:54 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:56319 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263AbZJBJLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:11:53 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Fri, 2 Oct 2009 11:11:52 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>, Mel Gorman <mel@csn.ul.ie>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.k2B.ZNTxKB@chimera>
In-Reply-To: <COE24pZSBH.A.k2B.ZNTxKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910021111.55749.elendil@planet.nl>
X-OriginalArrivalTime: 02 Oct 2009 09:11:55.0960 (UTC) FILETIME=[637D3B80:01CA4340]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 October 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
> Subject	: order 2 page allocation failures in iwlagn
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2009-09-06 7:40 (26 days old)
> References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
> Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>

I'm not sure about this.

The error messages from failed allocations should now be a lot less as a 
result of this commit:
commit f82a924cc88a5541df1d4b9d38a0968cd077a051
Author: Reinette Chatre <reinette.chatre@intel.com>
Date:   Thu Sep 17 10:43:56 2009 -0700
    iwlwifi: reduce noise when skb allocation fails

That commit is in mainline, and I'm not sure if it is important enough for 
a stable update (AFAICT it's not listed for 2.6.31.2).

That commit is mostly cosmetic, but possibly the real regression is not in 
iwlagn but in the way memory is freed/defragmented. That aspect was also 
reported by Bartlomiej (#14016) and was extensively discussed (without a 
clear conclusion) here: http://lkml.org/lkml/2009/8/26/140.

My own feeling is that Bartlomiej is correct and that something has changed 
since .29 and that on average we do have less higher order areas available 
after the system has been in use for some time, but I can't substantiate 
that. I do know that before .30 I had never seen the SKB allocation 
errors.

Main problem is that it's hard to deliberately and reproducibly get the 
system in a state where the errors occur.

I certainly do feel that the kernel should try to make sure higher order 
allocations remain possible during system use. They are not only needed 
shortly after boot: drivers can be loaded/unloaded at any time. OTOH Mel 
probably does have a point that really high order GFP_ATOMIC allocations 
by drivers make no sense [1].

Anyway, I have no problems with this BR being closed.

Cheers,
FJP

[1] <20090921133704.GO12726@csn.ul.ie>
