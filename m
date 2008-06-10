Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYFJQTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYFJQTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYFJQSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:18:53 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11814 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYFJQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:18:53 -0400
X-IronPort-AV: E=Sophos;i="4.27,618,1204531200"; 
   d="scan'208";a="111320211"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
Subject: Re: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
References: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
	<adatzg15ol2.fsf@cisco.com>
	<200806101701.47090.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 10 Jun 2008 09:18:50 -0700
In-Reply-To: <200806101701.47090.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 10 Jun 2008 17:01:45 +0200")
Message-ID: <adaabht5klx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jun 2008 16:18:51.0263 (UTC) FILETIME=[AB8808F0:01C8CB15]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > So just to be clear: this is a workaround for a hardware/firmware bug?

 > Yes it is.

OK, so paulus et al... does it seem like a good approach to call H_EOI
from driver code (given that this driver makes tons of other hcalls)?

How critical is this?  Since you said "corner case testing" I suspect we
can defer this to 2.6.27 and maybe get it into -stable later?

Also, out of curiousity:

 > +u64 hipz_h_eoi(int irq)
 > +{
 > +	int value;
 > +	unsigned long xirr;
 > +
 > +	iosync();

what is the iosync() required for here?

 > +	value = (0xff << 24) | irq;
 > +	xirr = value & 0xffffffff;

given that irq and value are ints, is there any possible way value could
have bits outside of the low 32 set?  If you're worried about sign
extension isn't it simpler to just make value unsigned?

 > +	return plpar_hcall_norets(H_EOI, xirr);
 > +}

ie why not:

u64 hipz_h_eoi(int irq)
{
	unsigned xirr;

	iosync();
	xirr = (0xff << 24) | irq;
	return plpar_hcall_norets(H_EOI, xirr);
}
