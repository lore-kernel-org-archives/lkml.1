Return-Path: <linux-kernel-owner+w=401wt.eu-S1161480AbXDWTUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161480AbXDWTUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161482AbXDWTUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:20:21 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:1730 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161480AbXDWTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:20:19 -0400
X-IronPort-AV: i="4.14,443,1170662400"; 
   d="scan'208"; a="480790662:sNHT46763398"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
Subject: Re: [PATCH] eHCA: Add "Modify Port" verb
X-Message-Flag: Warning: May contain useful information
References: <200704231823.48723.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 23 Apr 2007 12:20:14 -0700
In-Reply-To: <200704231823.48723.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 23 Apr 2007 18:23:48 +0200")
Message-ID: <ada3b2q7v9t.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2007 19:20:14.0487 (UTC) FILETIME=[6B6BBA70:01C785DC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > +	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
 > +		ehca_err(&shca->ib_device, "Can't query port properties");
 > +		ret = -EINVAL;
 > +		goto modify_port1;
 > +	}
 > +
 > +	cap = (rblock->capability_mask | props->set_port_cap_mask)
 > +		& ~props->clr_port_cap_mask;
 > +
 > +	hret = hipz_h_modify_port(shca->ipz_hca_handle, port,
 > +				  cap, props->init_type, port_modify_mask);

Is this thread-safe?  What if two different bits are set at the same
time from two different threads?  It seems that both calls could get
the same result from hipz_h_query_port(), and then the second call to
hipz_h_modify_port() would overwrite the first call.

You could look at the implementation in mthca to see the locking I
used there.

 - R.
