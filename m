Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYHNMD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYHNMD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYHNMDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:03:18 -0400
Received: from web82103.mail.mud.yahoo.com ([209.191.84.216]:25909 "HELO
	web82103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753889AbYHNMDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:03:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=mmSE36kQjuADETwEMsBxvr/hRdkJONQaaoOtPnmsKo3IPfPceDymjT2f9K8Z2nLFAWP8SBorK4eXLf54kFHzSMc47O+mIDuQsb8n+Umn8NAlpkYCNWWkvXLUZiIF5seN0stPUZcYJ22Qy7HAnSkXdcZRJ2e1du/UylZaRoI/FIs=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Thu, 14 Aug 2008 05:03:16 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- revert for 2.6.26-rc1 failed
To: Yinghai Lu <yhlu.kernel@gmail.com>, Bill Fink <billfink@mindspring.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <998851.29384.qm@web82103.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > I'm not sure Yinghai's revert patch is completely equivalent to
> > a revert of the original problematic commit, by a side-by-side
> > comparison of the original commit with his recent revert patch,
> > but then I don't really know that code at all.
> >
> > In the original code there was a section (in e820_reserve_resources()):
> >
> > #ifdef CONFIG_KEXEC
> >                   if (crashk_res.start != crashk_res.end)
> >                           request_resource(res, &crashk_res);
> > #endif
> >
> > If you don't have CONFIG_KEXEC defined in your .config, which is
> > probably the case, then you would never request a crashk_res resource.
> > But in the code after the original commit, it unconditionally calls
> > (in reserve_crashkernel()):
> >
> >           crashk_res.start = crash_base;
> >           crashk_res.end   = crash_base + crash_size - 1;
> >           insert_resource(&iomem_resource, &crashk_res);
> >
> > And after Yinghai's revert patch it still does (in reserve_crashkernel()):
> >
> >        crashk_res.start = crash_base;
> >        crashk_res.end   = crash_base + crash_size - 1;
> >        crashk_res_ptr = &crashk_res;
> >
> > and (in setup_arch()):
> >
> >        num_res = 3;
> >        if (crashk_res_ptr) {
> >                res_kernel[num_res] = crashk_res_ptr;
> >                num_res++;
> >        }
> >        e820_reserve_resources(res_kernel, num_res);
> >
> > then (in e820_reserve_resources()):
> >
> >                        for (j = 0; j < nr_res_k; j++) {
> >                                if (!res_kernel[j])
> >                                        continue;
> >                                request_resource(res, res_kernel[j]);
> >                        }
> >
> > which for j == 3 is:
> >
> >        request_resource(res, &crashk_res);
> >
> > Now it would appear that the new:
> >
> >        insert_resource(&iomem_resource, &crashk_res);
> >
> > or new:
> >
> >        request_resource(res, &crashk_res);
> >
> > should be noops.  But if for any reason crash_size is not zero,
> > then there could be a difference.  I have no idea if this is at all
> > significant, but I thought I'd point it out just in case.
> 
> why oops ?

I think he meant no-op's.


> if not valid crash kernel size etc is input, crashk_res_ptr will be null
> 
> >        if (crashk_res_ptr) {
> >                res_kernel[num_res] = crashk_res_ptr;
> >                num_res++;
> >        }
> 
> it that is not appended to res_kernel...

So your patch code protects against problem that Bill is mentioning
without using "#ifdef CONFIG_KEXEC", right Yinghai?

For the record:  my configs, including the kernel I built with Yinghai's
revert patch, have CONFIG_KEXEC not set.


Some experiments I did last night may render these questions moot, though.
My problem is very specific to the hardware on two of my machines, and it
has something to do with setting up the system resources that 
insert_resource() touches.


Dave W.
