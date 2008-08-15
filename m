Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYHOHR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYHOHR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 03:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYHOHRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 03:17:45 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:35211
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbYHOHRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 03:17:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=YoUOs6Ll+WxaKxf6dCP3vBCTQ4KshA1mNdYNQ4R4f01PmAuCuChcRAHcFySkAQ+M;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Fri, 15 Aug 2008 03:17:36 -0400
From: Bill Fink <billfink@mindspring.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "David Witbrodt" <dawitbro@sbcglobal.net>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- revert for
 2.6.26-rc1 failed
Message-Id: <20080815031736.2f48ab7a.billfink@mindspring.com>
In-Reply-To: <86802c440808140336k3558dfbew308ac7d7bdb23c@mail.gmail.com>
References: <737832.54450.qm@web82101.mail.mud.yahoo.com>
	<20080814060433.684c4fe5.billfink@mindspring.com>
	<86802c440808140336k3558dfbew308ac7d7bdb23c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d380f7f47a431b41368f6bec8c0f8a28a350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Yinghai Lu wrote:

> On Thu, Aug 14, 2008 at 3:04 AM, Bill Fink <billfink@mindspring.com> wrote:
> > Hi David,
> >
> > On Wed, 13 Aug 2008, David Witbrodt wrote:
> >
> >> [Yinghai, please note that I did not request a patch to revert the
> >> problem commit.  I was merely experimenting -- on my own time, so
> >> you folks would not have to bother -- to see if I could make it
> >> work.  I should have made that more clear!  Having said that, I am
> >> glad to test changes of any kind on my machine:  reverts, code for
> >> debugging or info, experiments, etc.]
> >
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
> if not valid crash kernel size etc is input, crashk_res_ptr will be null
> 
> >        if (crashk_res_ptr) {
> >                res_kernel[num_res] = crashk_res_ptr;
> >                num_res++;
> >        }
> 
> it that is not appended to res_kernel...

You're right.  Looking just at the diffs, I didn't realize that all
of reserve_crashkernel() is inside "#ifdef CONFIG_KEXEC" and thus
crashk_res_ptr is probably null in David's kernel.  Unless of course,
in the unlikey event that the memory location for crashk_res_ptr was
being corrupted somehow.

						-Bill
