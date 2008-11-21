Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYKUIWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYKUIWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYKUIWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:22:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:37644 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYKUIWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:22:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,639,1220252400"; 
   d="scan'208";a="80055669"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Nov 2008 08:22:30 +0000
Subject: RE: debugctl msr
Thread-Topic: debugctl msr
Thread-Index: AclLVaqOWIxe9lCGSUGllhdp2bHS5wAWxgNw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
In-Reply-To: <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Donnerstag, 20. November 2008 22:19
>To: Markus Metzger

>- in ds_put_context(), you need to mark task->thread.ds_ctx = NULL or
>this_system_context = NULL when you are
>  done, otherwise a subsequent session on the same task or CPU will
>think there is already a context allocated but
>  the pointer will be stale.

This should happen in:
    *(context->this) = NULL;

Did you see a context without owners?


>- in ptrace.c:ptrace_disable(), you systematically invoke ds_release()
>without checking if TIF_BTS_TRACE_TS
>  is set. That causes extraneous calls to ds_release() which messes up
>the reference counting if PEBS is in use.

That TIF only triggers the recording of scheduling timestamps.

That ds_release_bts() call should:
- get the context
- fail the ownership validation in ds_validate()
- put the context

If ds_validate() is disabled, it would put the context twice.


I am currently working on a patch to replace the validation
mechanism by using a handle returned from ds_request().

I also added the interrupt threshold to the parameters of ds_request().
It will be fix for one tracing session, if that's OK with you.


thanks and regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

