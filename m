Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbXLUWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbXLUWVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXLUWVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:21:12 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:5110 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXLUWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:21:11 -0500
X-IronPort-AV: E=Sophos;i="4.24,196,1196668800"; 
   d="scan'208";a="14031074"
To: David Dillow <dillowda@ornl.gov>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] list corruption on ib_srp load in v2.6.24-rc5
X-Message-Flag: Warning: May contain useful information
References: <1198273973.9979.34.camel@lap75545.ornl.gov>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Dec 2007 14:21:09 -0800
In-Reply-To: <1198273973.9979.34.camel@lap75545.ornl.gov> (David Dillow's message of "Fri, 21 Dec 2007 16:52:53 -0500")
Message-ID: <adabq8jy9ii.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Dec 2007 22:21:09.0825 (UTC) FILETIME=[C9AC5B10:01C8441F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm getting the following oops when doing the following commands:
 > 
 > modprobe ib_srp
 > <add targets(s) to ib_srp using sysfs>
 > rmmod ib_srp
 > modprobe ib_srp
 > <OOPS>
 > 
 > I'm going to try and track down how the list is getting corrupted; it
 > looks like attribute_container_list in
 > drivers/base/attribute_container.c is the one getting corrupted.
 > 
 > Before I get too far into this, has anyone seen this one before? I
 > looked at 'git diff v2.6.24-rc4..' and didn't see any changes that would
 > stand out as fixing it.

I haven't seen this, but I actually haven't done much srp testing with
post-2.6.23 kernels.  From a quick skim through the code, I would
guess that one of the calls to transport_container_unregister() in
srp_release_transport() (which is called one module unload) is
failing and leaving something bogus on the attribute_container_list.

This could because the underlying call to attribute_container_unregister()
fails because the k_list is not empty.  I don't know if this is some
sort of leak in the ib_srp driver, or something broken elsewhere...

 - R.
