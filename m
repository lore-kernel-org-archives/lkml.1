Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKNVKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKNVKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYKNVKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:10:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:62611 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYKNVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=jGS7MYGgwGLkWB+f1+Yy8QiyiHuJZLY71wH0ocPRvy4o1OLjy5w99xgsuCvDIj8dKI
         D089YzP9lMbMbYFPR8cZj1f+savOqXjm5se1eAILbjGSbWpgJ5KpJFFyyZASbDNg11sS
         3KdRXTQNjD7+KNfkAuVA0caKBOx/SBRAQ4vKU=
Message-ID: <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
Date: Fri, 14 Nov 2008 22:10:35 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Markus Metzger" <markus.t.metzger@googlemail.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402AB350E@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811060249g62666885nbaa559c1777217a0@mail.gmail.com>
	 <1226236327.6104.4.camel@raistlin>
	 <7c86c4470811111411k754887a8ic9b63163928157a6@mail.gmail.com>
	 <491A812D.9010208@gmail.com>
	 <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,


I am trying another approach for connecting perfmon to ds.c. I have
added new callbacks
to perfmon to allow me to invoke ds_request_pebs, once I know the
target thread or CPU.
That seems to work, however I ran into a spinlock problem is ds_request():

static int ds_request(struct task_struct *task, void *base, size_t size,
                      ds_ovfl_callback_t ovfl, enum ds_qualifier qual)
{
        struct ds_context *context;
        unsigned long buffer, adj;
        const unsigned long alignment = (1 << 3);
        int error = 0;

        if (!ds_cfg.sizeof_ds)
                return -EOPNOTSUPP;

        /* we require some space to do alignment adjustments below */
        if (size < (alignment + ds_cfg.sizeof_rec[qual]))
                return -EINVAL;

        /* buffer overflow notification is not yet implemented */
        if (ovfl)
                return -EOPNOTSUPP;


        spin_lock(&ds_lock);

>>        if (!check_tracer(task))
>>                return -EPERM;

You need to spin_unlock() before returning here!
