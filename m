Return-Path: <linux-kernel-owner+w=401wt.eu-S965191AbXCBJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965191AbXCBJiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965347AbXCBJiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:38:14 -0500
Received: from atlantis.8hz.com ([212.129.237.78]:52897 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965191AbXCBJiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:38:13 -0500
Date: Fri, 2 Mar 2007 09:38:11 +0000
From: Sean Young <sean@mess.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>
Subject: Re: [BUG 2.6.21-rc2] divide error: 0000
Message-ID: <20070302093811.GA38995@atlantis.8hz.com>
References: <20070301231241.GA32630@atlantis.8hz.com> <20070302061149.GF943@1wt.eu> <1172827157.24738.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172827157.24738.29.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 10:19:17AM +0100, Thomas Gleixner wrote:
> On Fri, 2007-03-02 at 07:11 +0100, Willy Tarreau wrote:
> > > Call Trace:
> > >  [<c0127d49>] posix_cpu_clock_get+0x47/0xdc
> > >  [<c0125bf3>] sys_clock_gettime+0x80/0x82
> > >  [<c0103bfc>] syscall_call+0x7/0xb
> > >  [<c02f0000>] svc_ioctl+0xc2/0x261
> > >  =======================
> > > Code: 0b eb fe 57 56 53 89 cb 89 d1 8b 74 24 10 83 e0 03 83 f8 02 74 0c 89 f2 89 c8 5b 5e 5f e9 ee 3f ff ff bf 00 ca 9a 3b 89 d0 89 da <f7> f7 89 56 04 89 06 5b 5e 5f c3 55 57 56 53 89 c7 89 d6 89 cb
> > > EIP: [<c0126a07>] sample_to_timespec+0x28/0x33 SS:ESP 0068:d4a56f74
> > > 
> > > The instruction is:
> > > 
> > > 	div %edi
> > > 
> > > And edi is 1e9 (0x3b9aca00). I don't understand why this results in an 
> > > divide error. 
> > 
> > It does this because 'div' does an unsigned divide of edx:eax by edi.
> > Here, edx=fffffffa and eax is 63b5a669. Clearly, such a number cannot
> > be divided by 1e9 to return a 32 bits value.
> > 
> > Given the values we see here, I suspect the code should have used an
> > integer divide (idiv). This means that something in the code implies
> > that the result is unsigned while it should be signed.
> 
> The question is why do we have this negative value in the dividend. I
> suspect this is related to
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117210430112543&w=2
> 
> Sean, can you please retest with that patch applied, which hit mainline
> after 2.6.21-rc2

Yup, this fixes it. And clock_gettime(CLOCK_THREAD_CPUTIME_ID) returns
nice high resolution times. :)

Thanks
Sean
