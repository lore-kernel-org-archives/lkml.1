Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbYKSW0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbYKSW0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYKSW0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:26:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:36227 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYKSW0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:26:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:to:cc:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding:from;
        b=MooCOriCgSCyrattt58z9ckMVwp0E0BBYhrDW/x37z42bXugChmYOPrKrrIHWEOsac
         A8iBrPmussLYjc2S/wIYANvDVR4/82c89DEaalInZGoUVAanR1jkmsy5ZedoUhA8QDEW
         uxXBYD84JTZF7hsuySOXAAt51t2VZYXZDliv8=
Subject: Re: debugctl msr
To: eranian@gmail.com
Cc: Markus Metzger <markus.t.metzger@googlemail.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 23:26:10 +0100
Message-Id: <1227133570.6104.10.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
From: Markus Metzger <markus.t.metzger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 20:20 +0100, stephane eranian wrote:

> Yes, I have narrowed this down to the following lines:
>         current->mm->total_vm  -= context->pages[qual];
>         current->mm->locked_vm -= context->pages[qual];
> 
> I think this is again related to the problem of which thread call
> ds_release(). In my test
> case, this is the monitored thread as it exits. By the time it gets
> there current->mm is NULL.

Yes, this is again the ptrace-ness of the approach. The entire code
assumes that there is one tracer task that controls another traced task.

You're right, though, that I should only do the memory accounting
if the buffer had been allocated by ds.c.
That's a plain bug. Perfmon2 is the first user that uses its own
buffers.


> > The point I was trying to make is that buffer overflows should not be
> > handled on higher levels (i.e. users of ds.c). That's why I am so
> > reluctant to expose the interrupt threshold in the ds.c interface.
> >
> But the threshold is a characteristic of the buffer, not the interrupt handler.
> Depending on the tool, it may be interesting to set the threshold earlier than
> at the end of the buffer.

Good point.

Would you want to change the threshold or would it be OK if this became
another parameter to ds_request()?

regards,
markus.

