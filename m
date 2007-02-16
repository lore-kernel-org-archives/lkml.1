Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXBPG6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXBPG6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXBPG6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:58:03 -0500
Received: from gw.goop.org ([64.81.55.164]:39206 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXBPG6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:58:01 -0500
Message-ID: <45D555F9.7010203@goop.org>
Date: Thu, 15 Feb 2007 22:58:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 18/21] Xen-paravirt: Add Xen grant table support
References: <20070216022449.739760547@goop.org>	<20070216022531.904462260@goop.org> <20070215225229.6b63d050.akpm@linux-foundation.org>
In-Reply-To: <20070215225229.6b63d050.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 18:25:07 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> +int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
>> +				int readonly)
>> +{
>> +	int ref;
>> +
>> +	if (unlikely((ref = get_free_entry()) == -1))
>> +		return -ENOSPC;
>> +
>> +	shared[ref].frame = frame;
>> +	shared[ref].domid = domid;
>> +	wmb();
>> +	shared[ref].flags = GTF_permit_access | (readonly ? GTF_readonly : 0);
>> +
>> +	return ref;
>> +}
>> +EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
>>     
>
> We have lots of open-coded mysteriously unexplained barriers in here.
>
> I assume they're not smp_wmb() because this could be a !SMP guest talking
> to an SMP host?
>   

Yeah.  The grant tables refer to pages which are shared with other
domains, so they could be running on other cpus even if this domain is
UP.  There's a lockless protocol going on here, but I'll need to look it
up and sprinkle some comments.

    J
